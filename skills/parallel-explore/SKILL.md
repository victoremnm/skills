---
name: parallel-explore
description: Search across multiple repositories or investigate several hypotheses in parallel. USE WHEN the user asks "where is X", "why is Y broken", "find all places Z happens", "search across repos", OR wants fast context gathering across repos or hypotheses.
version: 1.0.0
---

# Parallel Explore

Use parallel exploration when the task is search-heavy and the answer may live in several places.

## Workflow

1. Decide the search shape: cross-repo, multi-hypothesis, or end-to-end trace.
2. Spawn one bounded explorer per repo or hypothesis.
3. Keep prompts narrow: what to find, where to look, how deep to go.
4. Synthesize only the findings that change the next decision.

## Good Fits

- "where is auth handled?"
- "why is this slow?"
- "trace data flow from A to B"
- "find all places X happens"

## Depth Levels

- `quick`: first plausible answer
- `medium`: follow imports and obvious callers
- `thorough`: exhaustive search and cross-check

## Rules

- Do not duplicate the same search locally and in spawned work.
- Prefer one explorer per repo or per hypothesis.
- Stop once you have enough signal to choose the next step.

## Not this skill

- Not for implementing fixes; hand findings to [`agent-chain`](../agent-chain/SKILL.md) or [`multi-agent-pr-review`](../multi-agent-pr-review/SKILL.md) for execution.
- Not a staged workflow; if the task needs explore → plan → implement, use [`agent-chain`](../agent-chain/SKILL.md) and use this skill inside its explore phase.
- Not for running long commands; that is [`background-runner`](../background-runner/SKILL.md).
