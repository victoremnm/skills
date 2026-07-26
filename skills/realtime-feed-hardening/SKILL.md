---
name: realtime-feed-hardening
description: Harden browser realtime feeds, polling fallbacks, SSE streams, and live timelines against missing credentials, races, duplicate events, stale snapshots, and closed-stream writes. USE WHEN adding or debugging Trigger realtime, WebSocket, SSE, polling, live event feeds, or streaming UI updates.
---

# Realtime Feed Hardening

Design the feed as a snapshot plus an update channel. Realtime is an optimization; the user-facing feed must remain correct and understandable when credentials, subscriptions, or connections fail.

## Required behavior

- Preserve the server-rendered or initial client snapshot until a successful refresh replaces it. A failed refresh must not clear the feed.
- Use a stable event identity (`event_id`, source-qualified key, or equivalent) and deduplicate after every merge. Do not use array position or display text as identity.
- Guard overlapping refreshes with an abort controller and request generation. Ignore late responses from superseded requests.
- Treat missing realtime credentials as an explicit polling state, not as “live.” Treat subscription errors as a separate visible degraded state. Poll only while the document is visible, and always clear timers/listeners on cleanup.
- Own stream closure in one place. Make close/cancel idempotent, stop producers before closing, and guard every `enqueue`/write against a closed stream. Abort readers and unsubscribe listeners during unmount.
- Keep filters and refreshes server-backed when the product promises a new query. Do not silently filter an old snapshot and call it current.

## Tests to add

Cover the no-token path, subscription-error path, initial snapshot retention after refresh failure, duplicate event merging, out-of-order responses, unmount cleanup, visibility changes, and a second write after close. Assert the visible status text as well as the resulting rows.

## Human smoke test

Open the live route with realtime credentials, confirm the status says live, and wait for one new event. Repeat with credentials removed or the realtime endpoint blocked: confirm the status says polling/degraded, the existing rows remain, and a refresh eventually replaces them. Open and close any detail drawer while an update arrives.

