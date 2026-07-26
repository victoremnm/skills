---
name: realtime-feed-hardening
description: Harden realtime subscriptions, polling fallbacks, SSE, WebSockets, and live feeds against missing credentials, races, duplicate events, stale snapshots, and writes after closure. USE WHEN adding or debugging any live-update client or server stream.
---

# Realtime Feed Hardening

Design a live feed as an initial snapshot plus an update channel. Realtime is an optimization; the user-facing feed must remain correct and understandable when credentials, subscriptions, or connections fail.

## Required behavior

- Preserve the initial snapshot until a successful refresh replaces it. A failed refresh must not clear useful data.
- Use a stable source identity and deduplicate after every merge. Never use array position or display text as identity.
- Guard overlapping refreshes with cancellation and request generation. Ignore late responses from superseded requests.
- Treat missing credentials as an explicit polling/degraded state, not as “live.” Poll only while the surface is active/visible, and clear timers, listeners, and subscriptions on cleanup.
- Own stream closure in one place. Make close/cancel idempotent, stop producers before closing, and guard every enqueue/write against a closed stream.
- Keep promised filters and refreshes server-backed. Do not silently filter an old snapshot and call it current.

## Tests to add

Cover missing credentials, subscription errors, initial-snapshot retention after refresh failure, duplicate merging, out-of-order responses, cancellation, cleanup, visibility changes, and a second write after close. Assert the visible status as well as the resulting records.

## Human smoke test

Open the live surface with realtime enabled and confirm its status and one update. Repeat with credentials removed or the endpoint blocked: confirm the degraded/polling status, retained records, and eventual refresh. Trigger navigation, close any detail panel, and change filters while an update is arriving.

