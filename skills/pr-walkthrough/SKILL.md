---
name: pr-walkthrough
description: Explain a GitHub pull request from verified code, tests, CI evidence, and rendered diagrams. Use when asked to walk through or understand a PR; do not use to address feedback, modify the PR, or watch it to merge.
---

# PR Walkthrough

Create an accurate, read-only explanation of how a pull request works and how well its changed behavior is tested. The deliverable is a learning aid, not a code review: draw the implemented system, surface evidence-backed questions, and never imply that the PR is blocked.

## Boundaries and defaults

- Treat the diff and the checked-out code as the source of truth. A PR body, issue, or comment is a claim to verify, not a specification to repeat.
- Do not edit files on the PR branch, commit, push, approve/request changes, resolve review threads, or change PR metadata.
- Draft the walkthrough in the conversation or scratchpad first. The default publication venue is one plain, top-level PR comment only after the user approves its exact draft.
- Frame a published note as personal learning, not a review. Start with: "I drew these to understand how this fits together. They're for my own understanding, not a review; nothing here blocks anything."
- For feedback-resolution work, use `address-feedback`; for polling a PR to completion, use `watch-pr`. Do not invoke either workflow from this skill.

## 1. Map the implemented change

1. Resolve the repository, PR number, base SHA, head SHA, changed files, commits, PR body, check status, and diff. Record the base and head so all observations remain tied to a revision.
2. Group changed files by their role: schema/migrations, models, services, entry points (endpoints, webhooks, tasks, commands), constants/types, and tests.
3. Follow each new or changed entry point into the code it calls. For every material dependency or prerequisite behavior, verify its implementation at the PR base and head. If the behavior comes from another PR, identify its merge/base dependency rather than assuming it is already present.
4. Compare the PR body with the actual diff. Record material discrepancies separately; do not let them shape the diagrams.

When a conclusion relies on a third-party dependency, inspect the installed version's source and lockfile before making the claim. When it relies on data behavior, inspect the migration, model/query behavior, and any soft-delete or transaction semantics. State uncertainty rather than guessing.

## 2. Build a test map

Use tests as evidence for understanding the change, not merely a pass/fail gate.

- Prefer a disposable worktree at the PR head. Use the repository's documented dependency and test setup, including its test environment file where one is provided. Never copy production secrets into it.
- If an isolated test runner or subagent is available, it may own this noisy phase and return the commands, results, coverage, and failures. It must not change the PR or its branch.
- Identify changed test files plus related tests for changed production modules (for example, the project's `--findRelatedTests` equivalent). Check test infrastructure first, then start required local services only when the repository documents a safe local setup.
- Run the selected tests and, where supported, collect coverage only for changed production modules. Do not claim coverage that was not measured.
- If infrastructure cannot start, record the exact blocker and which tests did not run. Run safe unit tests when possible, then inspect CI logs as fallback. Never silently skip an affected test category.
- Read failed CI job logs, not just check conclusions. Explain the failure in terms of the changed code and fixture/setup, distinguishing a PR failure from unrelated CI breakage.

For each changed module, capture: exercised happy paths, exercised error/edge paths, untested branches, failing tests, and the evidence command or CI job. Keep this map compact enough to use as diagram annotations or a private table.

## 3. Draw the code that changed

Choose diagrams based on the diff:

- Add an ERD for actual schema or relationship changes.
- Add one sequence diagram for each changed entry point.
- Add an error or type hierarchy only when it clarifies behavior.
- Exclude flows that are not implemented by, or necessary to explain, this PR.

Annotate material branches as `✅ tested`, `⚠️ untested`, or `❌ failing`, using the test map. Keep diagrams code-led: identify authentication, validation, lookups, writes, failure paths, and external calls only where the code supports them.

Render every Mermaid diagram with `mmdc` before including it in a proposed publication. If `mmdc` is unavailable or rendering fails, report that and fix diagram syntax before presenting it as ready to post. Do not install global tools or alter project dependencies merely to render diagrams.

## 4. Things I noticed

This section is required whenever there is a material observation. Write observations as non-blocking questions, ordered by likely impact. Each question must include:

- the relevant file and line or symbol;
- the observed code behavior;
- why that behavior may matter; and
- evidence for every external, dependency, migration, or CI claim.

Do not convert an unverified intuition into a finding. Do not ask stylistic questions just to fill the section. If the PR body contradicts the code, say so as a factual documentation discrepancy, not as a request to change it.

## 5. Produce and publish the walkthrough

The normal draft structure is:

1. A short learning/non-blocking framing.
2. Data model diagram, when applicable.
3. One sequence diagram per changed entry point.
4. Error/type diagram, when applicable.
5. A compact test map or test annotations in the diagrams.
6. `### Things I noticed while drawing` with verified questions.
7. A brief evidence note if tests could not be fully run.

Before any GitHub post, show the complete proposed comment to the user and obtain explicit approval. If they decline or prefer privacy, leave it as the draft; optionally create one private Markdown artifact only when asked. Do not post inline review comments, submit a review, or make commits as part of a walkthrough.

## Cleanup

Remove the disposable worktree and only the temporary test artifacts created for this walkthrough after the result is delivered. Preserve user files and an explicitly requested private artifact. Report any setup or cleanup limitation plainly.
