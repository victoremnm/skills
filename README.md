# Agent Workflow Skills

[![skills.sh](https://skills.sh/b/victoremnm/skills)](https://skills.sh/victoremnm/skills)

Portable workflow skills for AI coding assistants. This repo focuses on repo-agnostic engineering workflows rather than company-specific or domain knowledge — small, composable skills you can drop into any project and adapt.

## Install

Pick whichever fits how you like to work.

### 1. skills.sh (copy in, hack on them)

Copies the skills into your project so you can edit and make them your own. Works with Claude Code, Codex, and other Agent-Skills-compatible harnesses.

```bash
npx skills@latest add victoremnm/skills
```

### 2. Claude Code plugin (managed, always-current)

Installs the whole set as a read-only bundle that updates when this repo ships a new version — subscribe rather than fork.

```
/plugin marketplace add victoremnm/skills
/plugin install skills@victoremnm
```

Or from your shell:

```bash
claude plugin marketplace add victoremnm/skills
claude plugin install skills@victoremnm
```

### 3. Manual / dev (symlink from a clone)

For hacking on the skills locally — symlinks auto-update on `git pull`. Requires [`just`](https://github.com/casey/just).

```bash
git clone https://github.com/victoremnm/skills.git
cd skills
just install                          # symlink all skills into ~/.claude/skills
just install skill=agent-chain        # one skill
just install-codex                    # symlink into ~/.agents/skills (Codex)
just uninstall                        # remove all
just list                             # list available skills
```

## Use in your assistant

Skills trigger automatically based on their descriptions. Examples:

```
> handover session        # triggers personal-handover
> audit repo docs         # triggers repo-docs-audit
> address feedback        # triggers address-feedback
```

## Included Skills

| Skill | Purpose |
|-------|---------|
| [`address-feedback`](skills/address-feedback/SKILL.md) | resolve automated PR review feedback (CodeRabbit, Copilot, Codex, Claude, Vercel Toolbar) to zero open threads |
| [`agent-chain`](skills/agent-chain/SKILL.md) | staged explore → plan → implement workflows |
| [`background-runner`](skills/background-runner/SKILL.md) | long-running checks without blocking |
| [`ai-stream-resilience`](skills/ai-stream-resilience/SKILL.md) | harden AI provider streams, retries, quotas, and closure |
| [`clickhouse-migration-safety`](skills/clickhouse-migration-safety/SKILL.md) | validate schema migrations, derived data, drift, and backfills |
| [`data-surface-evidence`](skills/data-surface-evidence/SKILL.md) | prove data-backed product results with query and API evidence |
| [`idle-pickup`](skills/idle-pickup/SKILL.md) | use idle time — cheap subagents pick up ready issues and review open PRs, gated to draft PRs |
| [`multi-agent-pr-review`](skills/multi-agent-pr-review/SKILL.md) | fan-out orchestration — decompose into issues, execute with subagents, review with a stronger model, merge behind a hard gate; delegates per-PR loops to `watch-pr` and comment triage to `address-feedback` |
| [`parallel-explore`](skills/parallel-explore/SKILL.md) | bounded parallel codebase search |
| [`personal-handover`](skills/personal-handover/SKILL.md) | session wrap-up across repos |
| [`repo-docs-audit`](skills/repo-docs-audit/SKILL.md) | find missing docs and scaffolding |
| [`realtime-feed-hardening`](skills/realtime-feed-hardening/SKILL.md) | harden live feeds, subscriptions, and polling fallbacks |
| [`security-scrub`](skills/security-scrub/SKILL.md) | fast pre-push security scan |
| [`watch-pr`](skills/watch-pr/SKILL.md) | autonomously poll a PR for reviewer feedback and drive every thread to resolved |

## Templates

| Template | Description |
|----------|-------------|
| [`templates/multi-repo-coordination/`](templates/multi-repo-coordination/) | `CLAUDE.md`, `HANDOVER.md`, `PROGRESS.md` templates for multi-repo AI agent coordination |

Copy a template and customize the `{{PLACEHOLDERS}}`:

```bash
cd templates/multi-repo-coordination
cp CLAUDE.md.template /path/to/workspace/CLAUDE.md
cp HANDOVER.md.template /path/to/workspace/HANDOVER.md
cp PROGRESS.md.template /path/to/workspace/PROGRESS.md
```

## Skill Format

```
skills/
└── <skill-name>/
    └── SKILL.md        # + optional helper scripts / reference files
```

Keep each `SKILL.md` short. Move deterministic logic into scripts only when it materially helps.

## Scope

This repo keeps only broadly reusable workflow skills:

- investigation and staged execution
- data correctness, migration safety, and reproducible verification
- realtime and AI stream resilience
- background verification
- repo documentation hygiene
- session handoff
- lightweight security scanning
- PR-feedback resolution and autonomous PR watching
- idle-time backlog work via cheap subagents

Private or company-specific skills live elsewhere.

## License

[MIT](LICENSE)
