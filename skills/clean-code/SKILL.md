---
name: clean-code
description: Review or improve Python, JavaScript, and TypeScript code for readability, cohesion, testability, and maintainability. USE WHEN reviewing a refactor, diagnosing code smell, improving code structure, or asking for clean-code guidance; do not trigger for formatter-only or lint-configuration work.
---

# Clean Code

Use these principles as review heuristics, not rigid laws. Improve the code's
clarity and changeability while preserving behavior and the repository's existing
conventions. Do not introduce abstractions, renames, or style churn without a
clear maintenance or correctness benefit.

## Shared review

- Prefer names that reveal intent, use consistent vocabulary, and make constants
  searchable. Avoid unexplained abbreviations, mental mapping, and redundant
  context.
- Keep functions focused on one responsibility, at one level of abstraction.
  Prefer explicit names, small parameter lists, and separate code paths over
  boolean flags that hide multiple behaviors.
- Make side effects visible and localized. Avoid hidden global mutation, shared
  mutable state, and duplicated sources of truth.
- Keep modules and classes cohesive. Apply SOLID and DRY when they reduce
  coupling or duplication; do not create speculative interfaces or inheritance.
- Design for tests: make boundaries explicit, inject meaningful dependencies,
  and preserve useful state when an operation fails.
- Treat comments as explanations of intent, constraints, or non-obvious tradeoffs.
  Prefer code that makes routine behavior clear.

## Language routing

Identify the language from the files, manifests, and surrounding conventions,
then read only the relevant reference:

- Python: [references/python.md](references/python.md)
- JavaScript or TypeScript: [references/javascript.md](references/javascript.md)

For mixed repositories, read both. For a language-agnostic design discussion,
use the shared review guidance and load a reference only when examples or
language semantics matter.

## Review output

Separate correctness risks, maintainability concerns, and optional preferences.
For each finding, point to the code, explain the reader or change cost, and give
the smallest useful improvement. When proposing a refactor, state behavior that
must remain unchanged and recommend focused tests.

This skill synthesizes the principles in [clean-code-python](https://github.com/zedr/clean-code-python)
and [clean-code-javascript](https://github.com/ryanmcdermott/clean-code-javascript),
both MIT-licensed references.
