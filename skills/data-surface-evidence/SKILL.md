---
name: data-surface-evidence
description: Investigate data-backed product results with reproducible query, API, freshness, and human verification evidence. USE WHEN a dashboard, report, API, export, or drilldown shows zero rows, stale or surprising values, missing details, slow results, or an error that might be hidden by a fallback.
---

# Data Surface Evidence

Use this skill when a data product looks wrong. Distinguish a valid zero from an empty result, query failure, stale data, schema drift, or rendering error before changing code.

## Investigation sequence

1. Trace the surface from UI or caller to API, query function, source/derived objects, and writer. Record the exact query, time window, fallback, cache, and sampling behavior.
2. Run the API or CLI request independently. Capture status, payload shape, row count, query timing, freshness metadata, and error text. A screenshot alone is not data evidence.
3. Compare source and derived results over the same window:

   ```sql
   SELECT count(*) AS rows, min(timestamp_column) AS oldest,
          max(timestamp_column) AS newest
   FROM source_table
   WHERE timestamp_column >= CURRENT_TIMESTAMP - INTERVAL '24 hours';

   SELECT count(*) AS rows, max(bucket_column) AS newest
   FROM derived_table
   WHERE bucket_column >= CURRENT_TIMESTAMP - INTERVAL '24 hours';
   ```

   Adapt syntax, timezone, partition boundaries, and aggregate-state merge functions to the database. Never compare incompatible raw rows and aggregate states as if they were the same type.
4. Inspect live schema and dependencies when freshness diverges. Verify that the derived object observes the table or event source receiving writes.
5. Classify the result explicitly: `OK`, `VALID_EMPTY`, `UNAVAILABLE`, `STALE`, or `SCHEMA_MISMATCH`. Preserve that state through the API and UI. Do not turn query errors or stale data into numeric zeroes.
6. Provide a human verification checklist: exact URL or command, one interaction, exact query/API request, expected relationship between results, and failure criteria.

## Review standard

Every implementation should leave behind a rerunnable query or API proof, a test for the error/empty/stale branch, visible freshness or availability state when data cannot be trusted, and a statement of whether the result is live, cached, sampled, or derived.

When a fallback is intentional, name it and expose it in telemetry or the UI. Graceful degradation must not masquerade as authoritative data.
