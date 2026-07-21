# Multi-Repo Coordination Templates

Templates for coordinating AI agent sessions across multiple repositories.

## Overview

These templates create a standardized structure for Claude Code (or similar AI assistants) to maintain context across:
- Multiple repositories in a parent directory
- Multiple work sessions
- Multiple agents/instances

## The Three Files

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `CLAUDE.md` | Agent instructions and session protocol | Rarely (setup only) |
| `HANDOVER.md` | Cross-session context, active work, reflections | Every session |
| `PROGRESS.md` | Detailed session history and project status | Every session |

## Quick Start

1. Copy templates to your parent directory:
   ```bash
   cp CLAUDE.md.template /path/to/workspace/CLAUDE.md
   cp HANDOVER.md.template /path/to/workspace/HANDOVER.md
   cp PROGRESS.md.template /path/to/workspace/PROGRESS.md
   ```

2. Customize the repository table in `CLAUDE.md`

3. Add to your global CLAUDE.md (if desired):
   ```markdown
   ## Session Protocol
   - Read HANDOVER.md on session start
   - Update PROGRESS.md on session end
   ```

## File Structure

```
/path/to/workspace/         # Parent directory
├── CLAUDE.md               # Agent instructions
├── HANDOVER.md             # Cross-session handover
├── PROGRESS.md             # Session history
├── project-a/              # Individual repo
├── project-b/              # Individual repo
└── project-c/              # Individual repo
```

## Key Patterns

### Session Protocol

**On Start:**
1. Read `HANDOVER.md` for context from previous sessions
2. Read `PROGRESS.md` for current project status
3. Identify relevant repos

**On End:**
1. Update `PROGRESS.md` with completed work
2. Update `HANDOVER.md` if cross-repo context needed
3. Note any reflections or insights

### Reflections Section

The `HANDOVER.md` includes a "Reflections to Stew On" section for:
- Patterns worth extracting into shared utilities
- Energy/focus observations
- Open questions not urgent to answer

This transforms handover from pure task-tracking to learning capture.

### Introspection Log

The `PROGRESS.md` includes an introspection template for tracking:
- Energy levels
- Mood/state
- What clicked vs what felt hard
- Insights worth keeping

## Customization Options

### Work-Focused
- Emphasize: PRs, branches, blockers, cross-repo dependencies
- De-emphasize: Reflections, energy tracking

### Personal/Learning-Focused
- Emphasize: Learning progress, reflections, energy tracking
- De-emphasize: PR coordination

### Hybrid
- Keep all sections
- Use what's relevant per session

## Integration with /handover Skill

Create a Claude Code skill that automates:
1. Gathering git activity across repos
2. Generating session entry
3. Appending to PROGRESS.md
4. Prompting for reflections

See: the handover skill in your shared skills repo or adjacent project repo.

## License

MIT - Use freely, attribution appreciated.
