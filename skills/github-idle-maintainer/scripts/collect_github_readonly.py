#!/usr/bin/env python3
"""Collect a compact GitHub maintenance snapshot without performing mutations."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone

API = "https://api.github.com"
GRAPHQL = "https://api.github.com/graphql"
HTTP_TIMEOUT = float(os.environ.get("IDLE_HTTP_TIMEOUT", "15"))
MAX_WORKERS = max(1, int(os.environ.get("IDLE_MAX_WORKERS", "8")))


def credential() -> str:
    proc = subprocess.run(
        ["git", "credential", "fill"],
        input="protocol=https\nhost=github.com\n\n",
        text=True,
        capture_output=True,
        env={**os.environ, "GIT_TERMINAL_PROMPT": "0"},
        check=True,
    )
    values = dict(line.split("=", 1) for line in proc.stdout.splitlines() if "=" in line)
    token = values.get("password")
    if not token:
        raise RuntimeError("GitHub credential has no password/token")
    return token


TOKEN = credential()
HEADERS = {
    "Accept": "application/vnd.github+json",
    "Authorization": f"Bearer {TOKEN}",
    "User-Agent": "github-idle-maintainer-readonly/1",
    "X-GitHub-Api-Version": "2022-11-28",
}


def request(url: str, payload: dict | None = None) -> dict | list:
    data = None if payload is None else json.dumps(payload).encode()
    headers = dict(HEADERS)
    if data is not None:
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=data, headers=headers, method="GET" if data is None else "POST")
    with urllib.request.urlopen(req, timeout=HTTP_TIMEOUT) as response:
        return json.load(response)


def request_optional_404(url: str) -> dict | list | None:
    try:
        return request(url)
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return None
        raise


def search(query: str) -> list[dict]:
    items: list[dict] = []
    page = 1
    while True:
        url = f"{API}/search/issues?q={urllib.parse.quote_plus(query)}&per_page=100&page={page}"
        result = request(url)
        batch = result["items"]
        items.extend(batch)
        if len(batch) < 100:
            return items
        page += 1


def get_all(url: str) -> list[dict]:
    items: list[dict] = []
    page = 1
    while True:
        sep = "&" if "?" in url else "?"
        batch = request(f"{url}{sep}per_page=100&page={page}")
        items.extend(batch)
        if len(batch) < 100:
            return items
        page += 1


THREAD_QUERY = """
query($owner:String!, $name:String!, $number:Int!, $cursor:String) {
  repository(owner:$owner, name:$name) {
    pullRequest(number:$number) {
      reviewThreads(first:100, after:$cursor) {
        nodes { isResolved isOutdated }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}
"""


def threads(owner: str, name: str, number: int) -> list[dict]:
    nodes: list[dict] = []
    cursor = None
    while True:
        result = request(
            GRAPHQL,
            {"query": THREAD_QUERY, "variables": {"owner": owner, "name": name, "number": number, "cursor": cursor}},
        )
        if result.get("errors"):
            raise RuntimeError(str(result["errors"]))
        conn = result["data"]["repository"]["pullRequest"]["reviewThreads"]
        nodes.extend(conn["nodes"])
        if not conn["pageInfo"]["hasNextPage"]:
            return nodes
        cursor = conn["pageInfo"]["endCursor"]


def latest_review_states(reviews: list[dict]) -> dict[str, str]:
    latest: dict[str, tuple[str, str]] = {}
    for review in reviews:
        login = (review.get("user") or {}).get("login")
        submitted = review.get("submitted_at") or ""
        state = review.get("state") or ""
        if login and (login not in latest or submitted >= latest[login][0]):
            latest[login] = (submitted, state)
    return {login: value[1] for login, value in latest.items()}


def approval_evidence(repo_path: str, base_ref: str, latest: dict[str, str]) -> dict:
    encoded_ref = urllib.parse.quote(base_ref, safe="")
    try:
        rules = request(f"{API}/repos/{repo_path}/rules/branches/{encoded_ref}")
        classic = request_optional_404(f"{API}/repos/{repo_path}/branches/{encoded_ref}/protection")
    except urllib.error.HTTPError as exc:
        return {
            "policy_known": False,
            "required_count": None,
            "approved_by": sorted(login for login, state in latest.items() if state == "APPROVED"),
            "satisfied": False,
            "error": f"HTTP {exc.code}: approval policy unavailable",
        }

    required = 0
    for rule in rules:
        if rule.get("type") == "pull_request":
            required = max(required, int((rule.get("parameters") or {}).get("required_approving_review_count", 0)))
    if classic:
        required = max(
            required,
            int(((classic.get("required_pull_request_reviews") or {}).get("required_approving_review_count", 0))),
        )
    approvals = sorted(login for login, state in latest.items() if state == "APPROVED")
    return {
        "policy_known": True,
        "required_count": required,
        "approved_by": approvals,
        "satisfied": len(approvals) >= required,
    }


def audit_pr(item: dict) -> dict:
    repo_path = urllib.parse.urlparse(item["repository_url"]).path.split("/repos/", 1)[-1]
    owner, name = repo_path.split("/", 1)
    number = item["number"]
    pr = request(f"{API}/repos/{repo_path}/pulls/{number}")
    sha = pr["head"]["sha"]
    combined = request(f"{API}/repos/{repo_path}/commits/{sha}/status")
    checks = request(f"{API}/repos/{repo_path}/commits/{sha}/check-runs?per_page=100")
    reviews = get_all(f"{API}/repos/{repo_path}/pulls/{number}/reviews")
    thread_nodes = threads(owner, name, number)
    latest = latest_review_states(reviews)
    approval = approval_evidence(repo_path, pr["base"]["ref"], latest)

    status_states = [s.get("state") for s in combined.get("statuses", [])]
    check_states = [
        run.get("conclusion") if run.get("status") == "completed" else run.get("status")
        for run in checks.get("check_runs", [])
    ]
    evidence = status_states + check_states
    ci_green = bool(evidence) and all(state == "success" for state in evidence)
    unresolved = sum(not node["isResolved"] for node in thread_nodes)
    changes_requested = sorted(login for login, state in latest.items() if state == "CHANGES_REQUESTED")
    body = (pr.get("body") or "").lower()
    human_hold = any(marker in body for marker in ("not merging", "human review", "manual review", "manual confidence", "rollout"))

    candidate = (
        pr["user"]["login"] == AUTH_LOGIN
        and not pr["draft"]
        and pr.get("mergeable") is True
        and ci_green
        and unresolved == 0
        and not changes_requested
        and approval["policy_known"]
        and approval["satisfied"]
        and not human_hold
    )
    return {
        "repo": repo_path,
        "number": number,
        "title": pr["title"],
        "url": pr["html_url"],
        "author": pr["user"]["login"],
        "draft": pr["draft"],
        "mergeable": pr.get("mergeable"),
        "head_sha": sha,
        "ci_evidence": evidence,
        "ci_green": ci_green,
        "unresolved_threads": unresolved,
        "changes_requested_by": changes_requested,
        "approval_evidence": approval,
        "human_hold_marker": human_hold,
        "mechanical_candidate": candidate,
    }


def audit_pr_safe(item: dict) -> tuple[dict | None, dict | None]:
    """Audit one PR without allowing a single failed read to stop the sweep."""
    try:
        return audit_pr(item), None
    except Exception as exc:
        return None, {
            "url": item.get("html_url"),
            "error": f"{type(exc).__name__}: {exc}",
        }


def authenticated_login() -> str:
    return request(f"{API}/user")["login"]


orgs = [org.strip() for org in os.environ.get("IDLE_ORGS", "").split(",") if org.strip()]
if not orgs:
    raise SystemExit("IDLE_ORGS must contain at least one organization")
AUTH_LOGIN = authenticated_login()
snapshot = {
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "authenticated_login": AUTH_LOGIN,
    "organizations": {},
    "prs": [],
    "errors": [],
}
pr_items: list[dict] = []
for org in orgs:
    issues = search(f"org:{org} is:issue is:open")
    prs = search(f"org:{org} is:pr is:open")
    ready = search(f"org:{org} is:issue is:open label:ready-for-agent no:assignee")
    snapshot["organizations"][org] = {
        "open_issue_count": len(issues),
        "open_pr_count": len(prs),
        "ready_issues": [{"repo_url": i["repository_url"], "number": i["number"], "title": i["title"], "url": i["html_url"]} for i in ready],
    }
    pr_items.extend(prs)

with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
    for result, error in executor.map(audit_pr_safe, pr_items):
        if result is not None:
            snapshot["prs"].append(result)
        if error is not None:
            snapshot["errors"].append(error)

json.dump(snapshot, sys.stdout, separators=(",", ":"))
sys.stdout.write("\n")
