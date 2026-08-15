# Agent conventions for {{REPOSITORY_NAME}}

## Working rules

- Work on feature branches in isolated worktrees. Do not edit the default
  branch checkout, push to `main`, or self-merge.
- Keep changes small and within the requested scope. Verify the root cause
  before proposing a fix.
- Use a virtual environment for Python tooling whenever possible.
- Keep credentials in the approved secret manager and GitHub Actions secrets.
  Never put them in tracked files, command lines, logs, PR evidence, or agent
  telemetry.
- Apply the upstream `avoid-ai-writing` skill to original prose before it
  ships: write direct claims, name sources, and remove filler.

## Agent work

- Idle/background subagents are suggestions-only. They may inspect and report,
  but may not edit files, create commits or PRs, push, change labels, or reply
  to review threads.
- Log each completed subagent run with `scripts/log-subagent-run.sh`. The log
  stays local and is ignored by Git.
- Every agent commit uses a conventional-commit subject and a `Co-authored-by:`
  trailer with the model identifier.

## Pull requests

- Use `.github/PULL_REQUEST_TEMPLATE.md` exactly. State what was verified,
  what still requires a human, and how optional additions degrade safely.
- Provide current evidence: a preview plus committed screenshot for visual
  changes, or a rendered query/document/build artifact for non-visual work.
- Identify the agent ID, model, type, session, and scope in the PR body.
- Address every automated review thread with a reply and verify that CI is
  green and unresolved threads are zero before asking for human approval.
- An independent reviewer may apply `lgtm`; an implementation agent may not.

## Delivery

- CI runs on pull requests. CD runs after merges to `main` and only deploys
  when the repository administrator configures `DEPLOY_COMMAND`.
- Releases are cut from conventional commits after merges to `main`. Release
  automation creates tags and GitHub releases; it does not write generated
  version files back to protected `main`.
