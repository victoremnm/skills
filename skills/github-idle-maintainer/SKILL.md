---
name: github-idle-maintainer
description: Audit open issues and pull requests across configured GitHub organizations during idle time, surface human decisions, and safely merge only the authenticated user's own PRs after strict CI and review gates. Use for recurring backlog sweeps, organization-wide PR review, idle automation, or requests to merge clean owned PRs without touching other authors' PRs.
---

# GitHub Idle Maintainer

Run a bounded, repeatable GitHub maintenance pass. Prefer the connected GitHub app; use local `gh` only when the connector lacks required evidence.

## Inputs

Resolve the organizations or repositories, authenticated GitHub login, ready-work label (default `ready-for-agent`), merge method (default `squash`), and per-run issue cap (default one).

Never infer PR ownership from repository ownership, branch names, commit authors, or organization membership. Compare the PR author's exact login with the authenticated login.

## Maintenance pass

1. Fetch every open issue and PR in scope. Paginate until exhausted; report partial coverage if any query is capped or fails.
2. Classify issues as human decision/external coordination, blocked, agent-ready only when unassigned with the configured ready label, or already covered by an open PR.
3. For every PR, fetch fresh metadata, author, draft and mergeable state, head SHA, CI/check status, submitted reviews, requested reviewers, and inline review threads.
4. Surface changes requested, unresolved threads, conflicts, drafts, missing or non-green CI, missing approvals, overlapping PRs, and external rollout decisions.
5. Optionally pick up at most the configured cap of agent-ready issues. Use `$idle-pickup` when subagents are allowed. Produce a draft PR only; never create and merge a fix in the same pass.
6. Evaluate merging with the gate below. Re-fetch all evidence immediately before each merge and reevaluate remaining candidates after every successful merge.

## Strict merge gate

Merge only when every condition is true at the same fresh head SHA:

- `author.login` exactly equals the authenticated login;
- PR is open, not draft, and currently mergeable;
- at least one CI/check exists and every required or observed check is successful;
- no review is currently `CHANGES_REQUESTED`;
- every inline review thread is resolved;
- repository-required approvals are satisfied when that evidence is available;
- no human-only rollout, security, data, or product decision remains;
- expected head SHA is supplied to the merge call.

Treat absent CI as unknown, never green. Never merge another author's PR, including bot PRs. Never enable auto-merge as a substitute. If a prior merge makes another PR conflict, stop and surface it.

## Reporting

Return coverage counts by organization, merges with resulting SHAs, the human-review queue with concrete blockers, agent-ready issues and draft work, skipped PRs grouped by reason, and data/tool failures. Never claim full coverage when pagination, permissions, or check APIs were incomplete.

## Scheduled operation

For unattended runs, use the lowest-cost available model, a one-hour interval, a non-overlapping lock, and an ephemeral session. Scheduling never broadens authority. Use `scripts/run-hourly.sh` as the cron entrypoint and `assets/hourly-prompt.md` as its prompt.
