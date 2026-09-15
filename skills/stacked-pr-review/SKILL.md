---
name: stacked-pr-review
description: >-
  Review a stack of dependent pull requests, each based on the preceding
  branch. Use when a change spans multiple chained PRs and each needs a
  focused, independent review plus a stack-level integration assessment.
---

# Reviewing stacked pull requests

Use this workflow for a review that spans a chain of dependent PRs. The goal is
to isolate each PR's effect while also checking that the combined stack behaves
as intended.

## Establish the stack

- Identify every PR, its head branch, base branch, and merge target. A PR in a
  stack should be evaluated against its immediate base, not against the default
  branch.
- Call out stacks with different ultimate bases (for example, one targets a
  release branch and another targets the default branch). Treat the intended
  merge target as an explicit integration question.
- Keep a short stack map in the review so readers can see dependency order and
  which PR owns each behavior.

## Review safely in parallel

For a multi-PR review, assign one reviewer per PR when parallel review is
available. Reviewers must be read-only and must not check out shared branches:

- Use the hosting provider's per-PR diff and metadata commands (for GitHub,
  `gh pr diff <number>` and `gh pr view <number> --json body,baseRefName,headRefName`).
- Inspect an exact version of a file with `git show origin/<head-branch>:<path>`.
- Do not use `git checkout`, `git switch`, rebases, or worktrees that could
  interfere with another reviewer in the shared workspace.

Each reviewer should distinguish facts visible in the diff from assumptions
about lower PRs, external systems, or deployment configuration.

## Per-PR review deliverable

Start each PR's report with a Mermaid salient map: a compact diagram of the
changed path from trigger through state transitions, external integrations, and
persistence. Use it as a navigation aid, not as an exhaustive architecture
diagram.

Then include:

1. A 3–5 item TL;DR of the load-bearing claims made by the change.
2. A verdict for each claim: verified, contradicted, or unverified, with file
   and line evidence where available.
3. Blocking findings first, ordered by severity; explain the concrete bad
   outcome and the smallest correction that would prevent it.
4. A separate checkbox list for non-blocking nits, questions, and missing
   coverage. Do not present a preference as a correctness blocker.

Use the review system's native Mermaid fence support when posting the result.
If it does not render Mermaid, provide a short text flow instead.

## Correctness checklist

Apply the checks relevant to the changed system to each PR and again across the
composed stack:

- **Contract preservation:** Interfaces, schemas, APIs, and consumer behavior
  remain compatible or have a deliberate migration path.
- **State and concurrency:** State transitions are valid, terminal states are
  protected, and retries or concurrent requests cannot duplicate work.
- **Failure handling:** Timeouts, partial failures, and out-of-order events
  have defined behavior and leave the system recoverable.
- **Data integrity:** Validation, ownership boundaries, ordering, and precision
  rules protect persisted data from corruption or unintended disclosure.
- **Observability:** Logs, errors, metrics, and correlation identifiers make
  the changed path diagnosable without exposing sensitive data.
- **Boundary behavior:** Validate external responses, asynchronous events,
  malformed input, and changes from adjacent services or manual tools.

## Local verification

Do not rely on a suspicious-looking diff alone. Trace the changed call path,
schema constraints, and relevant tests; compare the PR against its own base.
For a cross-PR finding, name every PR needed to reproduce the issue and say
whether it is introduced here or inherited.

Start with the repository's documented runtime version and package manager;
install dependencies if the clone is incomplete. Run focused tests sequentially
when they share a database or other mutable service. Use a per-branch reset
only in an isolated workspace; otherwise continue using read-only object-store
inspection.

When local tooling, operating-system compatibility, native dependencies, or
unavailable services prevent execution, record the exact command, failure
category, and strongest available alternative evidence. Use narrowly scoped,
untracked test configuration only when it does not alter the behavior under
test, and remove it when finished. Do not claim a test passed, or that a
behavior is safe, without evidence.

## Synthesize the stack review

After the per-PR reports, provide one stack-level conclusion:

- Dependency and merge order.
- Invariants verified across PR boundaries.
- Blocking issues grouped by the PR that should fix them.
- Integration risks that cannot be attributed to a single PR.
- Tests run, tests not run, and any environmental limitation.

Keep the assessment specific to the repository's architecture and documented
behavior. This skill supplies a review method; it does not substitute generic
assumptions for project requirements.

## Posting review comments

Draft review text in a file and use the platform's file-based comment option
when available to avoid shell-escaping errors. Before posting external comments,
confirm the exact text with the developer unless they have already explicitly
authorized posting. Include actual local test results and limitations; do not
repeat claimed test counts as though they were independently verified.
