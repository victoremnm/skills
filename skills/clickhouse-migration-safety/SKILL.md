---
name: clickhouse-migration-safety
description: Audit and implement ClickHouse schema changes safely, including Goose migration ordering, materialized-view source correctness, production drift, local OSS smoke tests, and separate backfills. USE WHEN changing ClickHouse DDL, adding or repairing materialized views, investigating schema drift, or planning a migration/backfill rollout.
---

# ClickHouse Migration Safety

Use this skill to make schema changes convergent and independently verifiable. Treat the checked-in migration files, the live catalog, and the writer's actual destination as three separate facts that must agree.

## Workflow

1. **Map the contract before editing.** Find every writer, query, migration, and materialized view for the affected object. Record the physical table, any query-side view, engine, `ORDER BY`, partitioning, TTL, and aggregate-function state types.
2. **Inspect the live catalog.** Run `SHOW CREATE TABLE db.object` and query `system.tables` for `database`, `name`, `engine`, and `create_table_query`. Do not infer the live object from a migration filename. If production differs, document the drift and identify which migration could not converge it.
3. **Keep Goose migrations structural.** Put DDL only in migrations. Never insert or backfill data in Goose, and do not assume `CREATE ... IF NOT EXISTS` changes an existing object. A repair that changes an MV source or target needs an explicit, safe replacement strategy.
4. **Validate MV sources.** An incremental MV must read from the physical table receiving inserts. Do not attach the MV to a query-side view unless the ingestion path demonstrably inserts into that view. Check the source in `create_table_query` and compare it with the writer target.
5. **Separate backfill from migration.** After an MV is created or repaired, run an idempotent operator/script backfill for the missing window. Make the window, deduplication key, writer-pause requirement, and verification query explicit. Incremental MVs do not retroactively process rows that existed before creation.
6. **Test the whole path.** Use a disposable OSS ClickHouse instance to apply any legacy source-schema fixture, run Goose `up` through the current migration, inspect the resulting objects, then exercise the supported `down` path where the project permits it. CI should run the same convergence test, including up/down ordering.

## Evidence gate

Before calling a migration safe, provide:

- the live and checked-in `SHOW CREATE` comparison;
- a source-to-MV dependency check and latest timestamps/row counts on both sides;
- local OSS migration output, including the exact migration that failed if blocked;
- a separate backfill command and before/after count query, if historical data is involved;
- explicit notes for destructive operations, writer pauses, and rollback limits.

## Stop conditions

Stop and report the blocker when the physical writer target is unknown, an MV source differs from the migration, a migration relies on an insert, or a backfill cannot be made idempotent. Do not “fix” drift by silently changing a view or by adding a compensating fallback in the query layer.

