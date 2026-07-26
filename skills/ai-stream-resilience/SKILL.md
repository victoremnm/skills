---
name: ai-stream-resilience
description: Harden AI provider streams against empty prompts, invalid conversation state, quota failures, retry storms, malformed tool events, and writes after stream closure. USE WHEN working on chat, completion, agent, tool-calling, SSE, or ReadableStream output.
---

# AI Stream Resilience

Treat an AI turn as a validated state machine, not a single provider call. Validate state before the provider call, classify failures before retrying, and emit exactly one terminal outcome to the client.

## Before the provider call

- Normalize the conversation and assert that the final message list is non-empty. If a retry or regeneration has no persisted input to operate on, return a typed client/state error instead of calling the provider.
- Keep the previous conversation and rendered answer until the replacement turn succeeds. A failed retry must not replace useful state with an empty state.
- Log safe identifiers and state counts, never credentials, full prompts, or raw provider payloads. Include the operation, turn, and failure class.

## Error policy

- Invalid input, missing conversation state, and malformed tool input are non-retryable client/state errors.
- Quota, billing, and authentication failures are non-retryable provider errors. Show an actionable message and do not spend more attempts retrying them.
- Timeouts, connection resets, and bounded 5xx responses may retry with a small capped backoff. Preserve the original failure class after the final attempt.
- Map failures consistently to the stream protocol. Do not expose raw provider stack traces in the UI.

## Stream ownership

Use one owner for abort, cancellation, and terminal emission. Make close/error handling idempotent; stop upstream producers before closing downstream; and guard delta writes after cancellation. Every structured tool event must follow its protocol's start/available/finish ordering, and each generated message must have a stable start and finish lifecycle.

## Verification

Test empty input, invalid retry/regeneration, quota response, transient retry, structured-event ordering, client cancellation, and a second write after close. Human smoke testing should cover send, retry, provider failure, reconnecting to the same conversation, and preserving the previous answer.

