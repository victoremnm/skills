---
name: data-surface-evidence
description: Investigate data-backed UI results with reproducible SQL, API, freshness, and human smoke-test evidence. USE WHEN a dashboard shows zero rows, stale or surprising aggregates, missing drilldowns, slow results, or an error that might be hidden by a fallback.
---

# Data Surface Evidence

Use this skill when a user reports that a data product looks wrong. The goal is to distinguish a valid zero from an empty result, a query failure, stale data, schema drift, or a rendering bug before changing code.

## Investigation sequence

1. Trace the surface from route/component to API/query function, table or view, materialized view, and ingestion writer. Record the exact query and fallback behavior.
2. Run the API request independently and capture status, payload shape, row count, query timing, and error text. Do not accept a UI screenshot as proof of the data state.
3. Run source and aggregate checks with the same time window:

   ```sql
   SELECT count() AS rows, min(timestamp_column) AS oldest,
          max(timestamp_column) AS newest
   FROM source_table
   WHERE timestamp_column >= now() - INTERVAL 24 HOUR;

   SELECT count() AS rows, max(bucket_column) AS newest
   FROM aggregate_table
   WHERE bucket_column >= now() - INTERVAL 24 HOUR;
   ```

   For `AggregatingMergeTree` tables, use the appropriate `countMerge`, `uniqMerge`, or other `-Merge` functions. Never compare a raw source count with an aggregate state as if they were the same type.
4. Inspect `SHOW CREATE TABLE` and the live catalog when freshness diverges. Compare the aggregate's newest bucket with the source's newest row and verify that the MV reads from the table receiving writes.
5. Classify the result explicitly: `OK`, `VALID_EMPTY`, `UNAVAILABLE`, `STALE`, or `SCHEMA_MISMATCH`. Preserve that classification through the API and UI. Do not turn query errors or stale aggregates into numeric zeroes.
6. Provide a human verification checklist: the exact URL, one UI interaction, the exact SQL/API command to rerun, the expected relationship between results, and what counts as failure.

## Review standard

Every implementation should leave behind:

- a query or API proof that a reviewer can rerun without reconstructing the investigation;
- a test for the error/empty/stale branch, not only the populated branch;
- visible freshness or availability state when the data cannot be trusted;
- a statement of whether the result is live, cached, sampled, or aggregate-derived.

When a fallback is intentional, name the fallback and expose it in telemetry or the UI. A graceful degradation path must not masquerade as authoritative data.
