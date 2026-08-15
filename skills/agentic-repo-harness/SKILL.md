---
name: agentic-repo-harness
description: Establish or audit a reusable AI-agent repository harness with isolated worktrees, reviewable PRs, evidence, bounded feedback handling, portable CI/CD, and release automation. USE WHEN creating an agent-ready repository, a project template, engineering harness, or reusable contribution workflow.
version: 1.0.0
---

# Agentic repository harness

Create a small, enforceable operating system for agent-assisted changes. Keep
application and infrastructure details out of the harness: the same baseline
must fit Node, Python, Go, Rust, and mixed repositories.

## Required baseline

1. **Feature branches and isolated worktrees.** Never let agents edit the
   default-branch checkout. Agents do not self-merge.
2. **Reviewable PRs.** Require user impact, a concrete summary, before/after
   proof, exact verification, a narrow human checklist, graceful degradation,
   and agent attribution. Do not claim local-only evidence is attached.
3. **Bounded review follow-through.** Require replies for every automated
   review thread, then verify zero unresolved threads and green CI. Poll at a
   bounded cadence; idle agents may inspect and suggest, but never mutate.
4. **Secrets discipline.** Keep credentials out of tracked files, command
   lines, generated evidence, and telemetry. CI runs a lightweight tracked-file
   secret scan before stack-specific jobs.
5. **Portable validation.** Detect the project stack and run its narrowest
   standard install, test, and build commands. Keep database migration tests
   and cloud credentials as explicit, opt-in extensions.
6. **Safe delivery.** Deploy only from the default branch after CI. The default
   deployment hook must no-op until a repository administrator configures it.
7. **Release without protected-branch writes.** Use conventional commits and
   release automation that creates tags and GitHub releases after merge, but
   never commits generated release files directly to the protected branch.

## Workflow

1. Start with a clean worktree and inspect existing policies, CI, deployment,
   release configuration, and branch protection.
2. Add the required baseline with small, stack-neutral files. Preserve existing
   project commands; do not replace a working CI system without evidence.
3. For any service-specific integration, add a named opt-in hook and document
   required variables. Do not add fake credentials or placeholder deployments.
4. Run shell, YAML, JSON, and link checks. Run each detected local stack check
   that does not need secrets or external infrastructure.
5. Open a PR that follows the repository template, includes inspectable
   evidence, and states every skipped validation.

## Template

Use [`templates/agentic-repo-harness`](../../templates/agentic-repo-harness/)
for the baseline files. Copy them into a new repository, customize the marked
placeholders, and configure `DEPLOY_COMMAND` as a GitHub Actions repository
variable only after the target platform is known.

## Not this skill

- Not a replacement for service-specific deployment, migration, security, or
  release requirements.
- Not permission to create cloud resources, set secrets, or deploy.
- Not a substitute for `address-feedback` or `watch-pr` when a PR already has
  review threads.
