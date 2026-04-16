# GCP Standards

## Compute
- Prefer Cloud Run for containerized web services and APIs. It handles scaling, TLS, and request routing with minimal infrastructure management.
- Use GKE only when the application requires persistent connections, background workers, stateful workloads, or capabilities that Cloud Run cannot support.
- Use Compute Engine (GCE) only for workloads that need full VM control, such as custom networking, GPU access, or legacy software that cannot be containerized.
- Always run applications in containers. Do not install app dependencies directly on VMs.

## IAM
- Follow least-privilege. Grant only the permissions each service account actually needs.
- No wildcard permissions in IAM bindings unless unavoidable and documented.
- Use dedicated service accounts per application or workload. Do not use the default compute service account for production services.
- Prefer Workload Identity for GKE pods and service account impersonation over exporting JSON key files.
- Never create or download long-lived service account keys unless there is no alternative. Prefer short-lived tokens and federated identity.

## Secrets and Configuration
- Use Secret Manager for all production secrets: API keys, database credentials, tokens, certificates.
- Inject secrets via environment variables or mounted volumes at runtime. Never bake secrets into container images or config files.
- Use `.env` files locally only. Never commit real secrets, even to private repos.
- Grant Secret Manager access through IAM — scope it to specific secrets and specific service accounts.

## Regions and Networking
- Never hardcode region or zone strings in code. Read from environment variables, metadata server, or deployment configuration.
- Prefer `us-central1` as the default region unless latency, compliance, or cost requires a different choice. Stay consistent across services in the same project.
- Use VPC and private networking for service-to-service communication. Do not expose internal services to the public internet.
- Use Cloud NAT for outbound internet access from private resources when needed.
- Prefer Serverless VPC Access connectors for Cloud Run services that need to reach private resources.

## Cloud Run Specifics
- Set minimum instances to 0 for dev/staging and to 1+ for production services that need low cold-start latency.
- Set maximum instances based on expected load and downstream capacity (database connections, API rate limits).
- Set explicit memory and CPU limits. Do not rely on defaults.
- Set request timeout appropriate to the service. Default is 300s — lower it for fast APIs.
- Use Cloud Run service-to-service authentication (IAM invoker role) for internal services. Do not leave internal services publicly accessible.
- Use revision-based traffic splitting for gradual rollouts when the deployment strategy requires it.

## Cloud SQL (PostgreSQL)
- Use Cloud SQL with PostgreSQL as the default managed database. See `docs/database.md` for schema, migration, and query standards.
- Enable automated backups and point-in-time recovery on production instances.
- Use private IP connectivity. Do not expose Cloud SQL to the public internet unless there is a specific need with appropriate auth controls.
- Use Cloud SQL Auth Proxy for secure, IAM-authenticated connections from application services, local development, and CI.
- Right-size instances. Start with the smallest tier that handles the load and scale up based on observed metrics.

## Storage
- Use Cloud Storage (GCS) for object storage: file uploads, static assets, backups, data exports.
- Set lifecycle policies to transition or delete objects that are no longer needed.
- Use signed URLs for time-limited access to private objects. Do not make buckets publicly accessible unless the use case explicitly requires it.
- Use uniform bucket-level access. Avoid legacy ACL-based access control on new buckets.

## Memorystore (Redis)
- Use Memorystore for Redis when caching, session storage, or rate limiting is needed. See `docs/database.md` for Redis usage patterns.
- Connect via private networking. Memorystore instances are not publicly accessible by design.
- Set maxmemory policies appropriate to the use case (`allkeys-lru` for general caching).
- Monitor memory utilization and connection count. Alert before hitting capacity.

## Pub/Sub and Async Workflows
- Use Cloud Pub/Sub for asynchronous messaging and event-driven workflows.
- Use Cloud Tasks for reliable, delayed, or rate-controlled HTTP task execution.
- Define dead-letter topics for messages that fail processing after retries.
- Make message handlers idempotent. Pub/Sub guarantees at-least-once delivery, not exactly-once.
- Set acknowledgment deadlines appropriate to the processing time of the handler.

## Artifact Registry
- Use Artifact Registry for container images. Do not use the deprecated Container Registry.
- Store images in the same region as the compute resources that pull them.
- Set cleanup policies to delete old image versions and control storage costs.
- Scan images for vulnerabilities when Artifact Analysis is available.

## Monitoring and Logging
- Use Cloud Monitoring for infrastructure metrics and alerting. See `docs/observability.md` for application-level observability standards.
- Use Cloud Logging for centralized log aggregation. Structured JSON logs from Cloud Run and GKE are indexed automatically.
- Create log-based metrics for application-specific conditions that matter (error patterns, business events).
- Set up alerting policies for critical conditions: service health, error rate spikes, resource exhaustion.
- Use Cloud Trace for distributed tracing when services communicate across boundaries.

## Resource Organization
- Label all GCP resources with at minimum: `project`, `environment`, `team`.
- Use separate GCP projects for production and non-production environments when the scale justifies it.
- Use budgets and billing alerts to catch unexpected cost increases early.
- Review IAM bindings and service account usage periodically. Remove unused accounts and overly broad permissions.

## Cost Efficiency
- Prefer Cloud Run over GKE for stateless HTTP workloads. Cloud Run scales to zero and charges only for request processing time.
- Use committed use discounts for stable Cloud SQL and GCE workloads.
- Use Spot VMs for fault-tolerant batch workloads or non-critical background jobs on GCE or GKE.
- Right-size everything. Review CPU and memory utilization monthly and adjust instance sizes accordingly.
- Set Cloud Storage lifecycle policies and Artifact Registry cleanup policies to avoid unbounded storage growth.

## Anti-Patterns to Avoid
- Using the default compute service account for production workloads
- Downloading and distributing service account key files
- Hardcoding project IDs, regions, or zones in application code
- Exposing Cloud SQL or internal services to the public internet without justification
- Running on GKE when Cloud Run would suffice
- Ignoring IAM least-privilege because "it works with Owner role"
- Skipping budgets and billing alerts on new projects
- Leaving unused resources (idle VMs, orphaned disks, old images) running indefinitely
