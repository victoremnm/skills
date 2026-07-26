---
name: clickhouse-migration-safety
description: Audit database schema migrations and derived-data changes safely, with concrete ClickHouse gotchas for materialized views, schema drift, local smoke tests, and separate backfills. USE WHEN changing DDL, adding rollups or materialized views, investigating migration drift, or planning a migration/backfill rollout.
---

# Migration Safety

Use this skill to make schema changes convergent and independently verifiable. Treat the repository's migration files, the live catalog, and the writer's actual destination as three separate facts that must agree.

## Workflow

1. **Map the contract before editing.** Find every writer, query, migration, derived object, and rollback path for the affected schema. Record types, keys, indexes, partitioning, retention, and ownership.
2. **Inspect the live catalog.** Use the database's native schema introspection (`SHOW CREATE`, catalog tables, or equivalent). Do not infer the live object from a migration filename. If production differs, document the drift and identify which migration could not converge it.
3. **Keep migrations structural.** Put DDL in migrations and data movement in a separately reviewable, idempotent operation. Never hide a backfill inside a schema migration. Do not assume `CREATE ... IF NOT EXISTS` changes an existing object; an existing object may require an explicit repair or replacement strategy.
4. **Validate derived-object sources.** A derived table, trigger, view, or materialized view must observe the actual table or event stream receiving writes. A query-side view can be a read abstraction without being a valid change-data source.
5. **Separate backfill from rollout.** Define the historical window, deduplication key, writer-pause requirement, batching, retry behavior, and before/after verification query. Do not assume a newly created derived object processes rows that existed before it.
6. **Test the whole path.** Use a disposable local database to apply any legacy fixture, run migrations to the end, inspect the resulting objects, and exercise supported rollback/down paths. CI should run the same ordering and convergence checks.

## ClickHouse gotchas

- Incremental materialized views process insert blocks into their source table; attaching one to a read view does not make it observe inserts into an unrelated underlying table.
- `CREATE MATERIALIZED VIEW IF NOT EXISTS` does not repair an existing view definition. Inspect `create_table_query` and use an explicit repair migration when the source or target is wrong.
- Aggregate-state tables require the matching merge functions when queried; raw counts and aggregate states are not interchangeable.
- A materialized-view creation migration does not backfill historical rows. Run the backfill separately after creation and verify its window.

## Evidence gate

Before calling a migration safe, provide the live-versus-checked-in schema comparison, a source-to-derived dependency check, local migration output, and a separate backfill proof when historical data is involved. Call out destructive operations, writer pauses, rollback limits, and any credential-gated verification.

Stop when the writer target is unknown, a derived source differs from the intended source, a migration relies on an insert, or a backfill cannot be made idempotent.

