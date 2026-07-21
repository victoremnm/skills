---
name: repo-docs-audit
description: Audit repository documentation, identify missing operational docs, and scaffold core files. USE WHEN the user says "audit repo docs", "what docs are missing", "scaffold onboarding docs", OR a repository needs better onboarding, maintenance docs, or session-tracking files.
version: 1.0.0
---

# Repo Docs Audit

Use this to check whether a repo has the minimum useful documentation.

## Core Files

- `README.md`
- `CLAUDE.md`
- `PROGRESS.md`
- `HANDOVER.md`

## Workflow

1. Scan the target repo or workspace for the core files.
2. Report what is missing.
3. Scaffold only the docs the repo actually needs.

## Heuristics

- All repos should have `README.md`.
- Active repos benefit from `CLAUDE.md` and `PROGRESS.md`.
- Multi-session work benefits from `HANDOVER.md`.
- Stable repos usually do not need session-tracking docs.

## Not this skill

- Not for writing session handover content from git activity; that is [`personal-handover`](./personal-handover/SKILL.md).
- Not for security scanning; that is [`security-scrub`](./security-scrub/SKILL.md).
- Not for code-quality or review feedback; that is [`address-feedback`](./address-feedback/SKILL.md).
