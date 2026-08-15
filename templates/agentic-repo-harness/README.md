# Agentic repository harness

This directory is the source for a GitHub template repository. It gives a new
project a small, stack-neutral baseline for AI-assisted delivery.

Copy the files into a fresh repository, then replace `{{REPOSITORY_NAME}}` and
the other marked values before the first PR. Install the workflow skills from
this repository with `npx skills@latest add victoremnm/skills`; use
`avoid-ai-writing` before publishing prose in docs, commits, PRs, and releases.

## What it includes

- `AGENTS.md` for isolated worktrees, secrets, agent attribution, evidence,
  bounded review handling, and a human merge gate.
- `.github/PULL_REQUEST_TEMPLATE.md` that separates proof from work a human
  still needs to perform.
- CI jobs for hygiene plus Node, Python, Go, and Rust when their project files
  exist. The language scripts use standard tools and can be narrowed per repo.
- CD that runs only after `main` changes. It is deliberately a no-op until a
  repository administrator sets the `DEPLOY_COMMAND` Actions variable.
- Conventional-commit releases that create a GitHub tag and release without
  committing generated version files to protected `main`.

## Before enabling deployment

Set a repository Actions variable named `DEPLOY_COMMAND` to the verified deploy
command for the project. Put credentials in GitHub Actions secrets, never in
the variable or repository. The command runs only after a merge to `main`.

For database migrations, create a separate deployment step that validates in a
disposable service first, then uses only the secrets it needs in production.
