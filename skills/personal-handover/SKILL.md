---
name: personal-handover
description: Update HANDOVER.md and PROGRESS.md from recent git activity across repositories. USE WHEN the user asks for a "handover", "session wrap-up", "progress update", "what did I do today", OR a cross-repo status summary.
version: 1.0.0
---

# Personal Handover

Use this at session boundaries for multi-repo work.

## Workflow

1. Gather recent git activity across the workspace.
2. Capture active branches and dirty repos.
3. Update `PROGRESS.md` with completed work and next steps.
4. Update `HANDOVER.md` only when cross-session context matters.

## Gather Activity

```bash
REPOS_DIR="${REPOS_DIR:-$PWD}"

for d in "$REPOS_DIR"/*/; do
  [ -d "$d/.git" ] || continue
  repo=$(basename "$d")
  commits=$(cd "$d" && git log --oneline --since="24 hours ago" 2>/dev/null | head -5)
  branch=$(cd "$d" && git branch --show-current 2>/dev/null)
  status=$(cd "$d" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ -n "$commits" ] && printf "\n## %s\n%s\n" "$repo" "$commits"
  printf "%s: %s (%s uncommitted)\n" "$repo" "$branch" "$status"
done
```

## Keep

- what changed
- files or repos touched
- blockers
- next steps

## Not this skill

- Not for scaffolding repo documentation; that is [`repo-docs-audit`](./repo-docs-audit/SKILL.md).
- Not for searching code across repos; that is [`parallel-explore`](./parallel-explore/SKILL.md).
- Not for addressing review feedback or watching PRs; those are [`address-feedback`](./address-feedback/SKILL.md) and [`watch-pr`](./watch-pr/SKILL.md).
