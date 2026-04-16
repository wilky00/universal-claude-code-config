# Database Standards

## Default Stack
- Use PostgreSQL as the default relational database for all new projects.
- PostgreSQL is available as a managed service on both AWS (RDS) and GCP (Cloud SQL), keeping the stack portable across clouds.
- Use Redis for caching, session storage, and lightweight pub/sub. Available as ElastiCache on AWS and Memorystore on GCP.
- Do not introduce a new database engine without a clear justification that PostgreSQL or Redis cannot meet the requirement.

## When to Consider Alternatives
- Document stores (MongoDB, Firestore): only when the data is genuinely unstructured, schema-free, or the access pattern is overwhelmingly document-oriented.
- Time-series databases (TimescaleDB, InfluxDB): only for high-volume metrics, telemetry, or IoT data where time-series-native queries and retention policies matter.
- Search engines (Elasticsearch, OpenSearch): only for full-text search, log aggregation, or complex query workloads that PostgreSQL full-text search cannot handle at scale.
- Any alternative must still meet the same standards for backups, observability, and access control described in this doc.

## Schema Design
- Design schemas around clear domain entities and relationships.
- Prefer explicit foreign keys and constraints. Let the database enforce data integrity.
- Use appropriate data types. Do not store dates as strings, booleans as integers, or structured data as untyped JSON unless there is a specific reason.
- Prefer `timestamptz` over `timestamp` in PostgreSQL. Store all times in UTC.
- Use `uuid` or `bigint` for primary keys depending on the project convention. Pick one and stay consistent.
- Add `created_at` and `updated_at` columns to all tables. Use database-level defaults and triggers where practical.
- Name tables and columns in `snake_case`. Use plural table names (`users`, `orders`) consistently.

## Indexing
- Add indexes for columns used in WHERE clauses, JOIN conditions, and ORDER BY on frequently queried tables.
- Do not add indexes speculatively. Measure query performance first, then add targeted indexes.
- Use partial indexes when queries filter on a predictable subset of rows.
- Use composite indexes when queries frequently filter or sort on multiple columns together.
- Review index usage periodically. Drop unused indexes — they slow down writes for no benefit.
- Add unique indexes to enforce business uniqueness constraints at the database level, not just in application code.

## Migrations
- Use a dedicated migration tool: Alembic for Python, Prisma Migrate or Drizzle Kit for Node/TypeScript.
- Every schema change goes through a migration. No manual DDL in production.
- Migrations must be committed to version control alongside the code that depends on them.
- Write forward migrations that are safe to run against a live database. Avoid long-running locks on large tables.
- Prefer additive changes (add column, add table) over destructive changes (drop column, rename) when possible.
- When destructive changes are necessary, use a multi-step approach: add new → migrate data → remove old.
- Test migrations against a copy of production-like data before deploying. Verify they apply cleanly and are reversible when required.
- Never edit or reorder a migration that has already been applied to any shared environment.

## Connection Management
- Use connection pooling in all environments. Do not open a new connection per request.
- For Python, use SQLAlchemy's built-in pool or `asyncpg` pool. For Node, use the ORM's built-in pooling or `pg-pool`.
- Set pool size, connection timeout, and idle timeout explicitly. Do not rely on defaults.
- Close or return connections properly. Leaked connections exhaust the pool and cause cascading failures.
- For serverless or high-concurrency environments, consider a connection proxy such as PgBouncer, RDS Proxy, or Cloud SQL Auth Proxy.

## Query Patterns
- Use an ORM or query builder for standard CRUD. Use raw SQL only for complex queries, performance-critical paths, or operations the ORM cannot express cleanly.
- Use parameterized queries for all database access. Never string-interpolate user input into SQL.
- Keep queries simple and readable. Prefer multiple clear queries over a single complex query when the performance difference is negligible.
- Avoid N+1 query patterns. Use eager loading, joins, or batch queries for related data.
- Log slow queries. Set a threshold and monitor for regressions.

## ORM and Query Builder Standards
- **Python:** Use SQLAlchemy 2.0+ with the modern `select()` style. Use Alembic for migrations. Define models with mapped classes.
- **Node/TypeScript:** Use Prisma or Drizzle ORM. Prisma for rapid prototyping and schema-first workflows. Drizzle for more SQL-oriented control. Pick one per project and stay consistent.
- Keep ORM models aligned with the database schema. Do not let model definitions and migrations drift apart.
- Validate data with Pydantic (Python) or Zod (TypeScript) at the application boundary. Do not rely on the ORM alone for input validation.

## Transactions
- Use transactions for operations that must be atomic: multi-table writes, balance adjustments, state transitions.
- Keep transactions short. Do not hold a transaction open across network calls, user input waits, or long computations.
- Handle transaction failures explicitly. Retry on serialization conflicts when the operation is idempotent.
- Prefer database-level constraints and unique indexes over application-level race-condition checks where possible.

## Redis Usage
- Use Redis for caching, session storage, rate limiting, and lightweight queuing.
- Set TTLs on all cache keys. Do not let cache entries grow unbounded.
- Use key prefixes by application and purpose to avoid namespace collisions.
- Do not use Redis as a primary data store. Data in Redis should be rebuildable from the source of truth.
- Handle Redis unavailability gracefully. Cache misses should fall through to the database, not crash the application.

## Backups and Recovery
- Enable automated daily backups on all managed database instances.
- Set retention periods appropriate to the application. Minimum 7 days for non-trivial production data.
- Test backup restoration periodically. A backup that has never been restored is not a backup.
- Enable point-in-time recovery (PITR) on production PostgreSQL instances where the managed service supports it.
- Document the recovery procedure for each database so it is not discovered during an incident.

## Security
- Use IAM-based authentication or managed credentials for database access. Never hardcode database passwords in code or config files.
- Restrict network access to the database. Only application services and authorized admin tools should be able to connect.
- Use separate database users for application access and admin operations with appropriate privilege levels.
- Encrypt data at rest and in transit. Managed services handle this by default — verify it is enabled.
- Do not store plaintext passwords, tokens, or PII in the database. Hash passwords with bcrypt or argon2. Encrypt sensitive fields when required.
- Audit access to sensitive tables when compliance or regulatory requirements apply.

## Observability
- Monitor connection pool utilization, query latency, error rates, and replication lag.
- Set alerts for connection pool exhaustion, high query latency, and storage approaching capacity.
- Log slow queries with execution time and query plan when available.
- Track migration status as part of deployment health checks.

## Cost Efficiency
- Right-size managed database instances. Start small and scale up based on observed load, not projected maximums.
- Use read replicas only when read load justifies the cost. Do not provision replicas by default.
- Use reserved instances or committed use discounts for stable production workloads on AWS (RDS Reserved Instances) or GCP (committed use contracts).
- Archive or purge old data when retention policies allow. Large cold datasets drive up storage and backup costs.
- Monitor storage growth and query patterns. An unexplained spike in either usually indicates a problem worth investigating.

## Anti-Patterns to Avoid
- Using the database as a message queue or job scheduler when a proper tool exists
- Storing structured data as untyped JSON blobs when a relational schema is appropriate
- Missing foreign keys or constraints, relying entirely on application code for integrity
- N+1 query patterns in loops
- Running schema changes manually instead of through migrations
- Sharing a single database across unrelated services without clear schema boundaries
- Unbounded queries that return entire tables
- Ignoring connection pool configuration and relying on defaults
- Storing plaintext secrets or PII without encryption or hashing
- Treating Redis as durable storage
