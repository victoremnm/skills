---
name: ai-stream-resilience
description: Harden AI SDK streaming chat against empty prompts, invalid regeneration state, quota failures, retry storms, and writes after stream closure. USE WHEN working on `streamText`, chat sessions, regenerate/retry flows, provider errors, SSE/ReadableStream output, or AI quota handling.
---

# AI Stream Resilience

Treat an AI turn as a validated state machine, not a single provider call. Validate conversation state before calling the model, classify provider failures before retrying, and emit exactly one terminal outcome to the client.

## Before the provider call

- Normalize the conversation and assert that messages are non-empty after filtering. If a regenerate request has no persisted message to regenerate, return a typed client-visible error instead of calling `streamText`.
- Keep the session's prior messages and rendered answer until the replacement turn succeeds. A failed retry must not replace a useful conversation with an empty state.
- Log safe identifiers and state counts, never tokens, full prompts, or credentials. Include the operation, turn, failure class, and whether the request was a regenerate.

## Error policy

- Invalid prompt, missing conversation state, and malformed tool input are non-retryable client/state errors.
- Quota, billing, and authentication failures are non-retryable provider errors. Show an actionable message and do not spend three more attempts retrying them.
- Timeouts, connection resets, and bounded 5xx responses may retry with a small capped backoff. Preserve the original error class after the final attempt.
- Map errors consistently to the stream protocol. Do not expose raw provider stack traces in the UI.

## Stream ownership

Use one owner for abort, cancellation, and terminal emission. Make close/error handling idempotent; stop upstream producers before closing the downstream stream; and guard `enqueue`/delta writes after cancellation. Every tool-input delta must follow its tool-input-start event, and every generated message must have a stable start and finish lifecycle.

## Verification

Test an empty conversation, invalid regenerate, quota response, transient retry, tool delta ordering, client cancellation, and a second write after close. Human smoke testing should cover send, regenerate, retry, provider failure, and reopening the same session without losing the prior answer.

