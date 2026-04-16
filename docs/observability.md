# Observability Standards

## General Principles
- Observability is not optional for production services. Every deployed application must be observable enough to diagnose problems without SSH-ing into a running container.
- Instrument early. Adding observability after an incident is too late to catch the incident.
- Prefer a small number of well-understood tools over a sprawl of overlapping dashboards.
- Keep observability costs proportional to the value of the service. Not every app needs enterprise APM.

## Structured Logging
- Use structured JSON logging in all production services. Never rely on unstructured print statements or string-formatted log lines.
- **Python:** Use `structlog`. See `docs/python.md` for details.
- **Node/TypeScript:** Use `pino` or the logging facility built into the framework. Avoid `console.log` in production code paths.
- Include consistent context fields in every log entry:
  - `timestamp` (ISO 8601, UTC)
  - `level` (debug, info, warn, error)
  - `service` (application name)
  - `request_id` or `correlation_id` when handling a request or job
  - `environment` (dev, staging, production)
- Add contextual fields relevant to the operation: user ID (if non-sensitive), endpoint, job name, duration.
- Never log secrets, tokens, passwords, full credit card numbers, or PII. See `docs/security.md`.
- Log at the right level:
  - `debug` — verbose detail useful during development, off in production by default.
  - `info` — normal operations: startup, shutdown, request handled, job completed.
  - `warn` — recoverable issues: deprecated usage, retry succeeded, approaching limits.
  - `error` — failures requiring attention: unhandled exceptions, upstream failures, data integrity issues.
- Do not log at `error` for expected conditions like 404s or validation failures.

## Log Aggregation
- Ship logs to a centralized platform. Do not rely on local container logs as the primary source.
- Preferred options by cloud:
  - **AWS:** CloudWatch Logs, or ship to a third-party aggregator.
  - **GCP:** Cloud Logging (built-in for Cloud Run and GKE).
  - **Self-hosted / homelab:** Loki + Grafana, or a lightweight log collector.
- Set retention periods appropriate to the service. Production logs should be retained for at least 30 days. Debug-level logs can have shorter retention.
- Ensure logs are searchable by request ID, service name, error type, and time range.

## Metrics
- Collect application-level metrics for every production service. At minimum:
  - Request rate (requests per second by endpoint)
  - Error rate (4xx and 5xx by endpoint)
  - Latency (p50, p95, p99 by endpoint)
  - Active connections or concurrent requests
- Collect infrastructure-level metrics:
  - CPU and memory utilization
  - Disk usage and I/O
  - Network throughput
  - Container restart count
- Collect dependency metrics:
  - Database connection pool utilization and query latency (see `docs/database.md`)
  - Redis hit/miss ratio and latency
  - External API call latency and error rate
- Preferred options:
  - **AWS:** CloudWatch Metrics, or Prometheus + Grafana.
  - **GCP:** Cloud Monitoring, or Prometheus + Grafana.
  - **Self-hosted:** Prometheus + Grafana.
- Use consistent metric naming conventions across services.

## Alerting
- Set alerts for conditions that require human attention. Do not alert on noise.
- Critical alerts (page-worthy):
  - Service is down or health check is failing
  - Error rate exceeds threshold (e.g., 5xx > 5% of traffic for 5 minutes)
  - Database connection pool exhausted
  - Disk usage above 90%
  - Certificate expiring within 14 days
- Warning alerts (review next business day):
  - Latency p95 elevated above baseline
  - Error rate elevated but below critical threshold
  - Memory or CPU consistently above 80%
  - Background job failure rate increasing
- Alert fatigue is a real problem. If an alert fires regularly and is always ignored, fix the underlying issue or remove the alert.
- Route alerts to the right channel: critical to pager/phone, warnings to a team channel.

## Health Checks
- Every production service must expose a health check endpoint (typically `GET /health` or `GET /healthz`).
- Health checks should verify the service can reach its critical dependencies (database, Redis, required upstream services).
- Return `200` when healthy, `503` when unhealthy, with a JSON body indicating component status.
- Keep health check logic lightweight. Do not run expensive queries or external calls on every probe.
- Use health checks for:
  - Container orchestration (Docker healthcheck, Kubernetes liveness/readiness probes)
  - Load balancer target health
  - Uptime monitoring

## Distributed Tracing
- Add tracing for services that make multiple downstream calls or participate in multi-service workflows.
- Propagate trace and span IDs across service boundaries using standard headers (`traceparent` / W3C Trace Context).
- Preferred options:
  - OpenTelemetry for instrumentation (vendor-neutral, works with most backends).
  - **AWS:** X-Ray or export to a third-party backend.
  - **GCP:** Cloud Trace or export to a third-party backend.
- Tracing is most valuable for debugging latency and understanding call chains. Not every service needs it on day one — add it when the architecture involves multiple communicating services.

## Uptime Monitoring
- Monitor critical endpoints externally — from outside the infrastructure, not just from within.
- Check core user-facing URLs and API health endpoints.
- Alert immediately when external checks fail for more than 2 consecutive intervals.
- Preferred options: UptimeRobot, Better Stack, Checkly, or cloud-native equivalents.

## Error Tracking
- Use an error tracking service for production applications that serve users. Sentry is the preferred default.
- Capture unhandled exceptions, promise rejections, and framework-level errors automatically.
- Include context with errors: request details, user ID (if non-sensitive), environment, release version.
- Group and deduplicate errors to avoid alert floods from a single root cause.
- Triage new errors promptly. Do not let the error backlog grow unchecked.

## Dashboards
- Create a service dashboard for every production application. At minimum it should show:
  - Request rate and error rate over time
  - Latency percentiles over time
  - Resource utilization (CPU, memory)
  - Dependency health (database, cache, external APIs)
- Keep dashboards simple and focused. One dashboard per service, not one dashboard for everything.
- Include a link to the dashboard in the service README or runbook.

## Incident Response
- Define a lightweight incident process before the first production deploy:
  - How to identify an incident (alerts, user reports, monitoring)
  - Who to contact and how (on-call rotation, team channel)
  - Where to find logs, metrics, and dashboards
  - How to roll back a deploy
- Write a brief postmortem for any incident that impacts users. Focus on what happened, why, and what will prevent recurrence.
- Do not blame individuals. Focus on system improvements.

## Cost Awareness
- Observability tooling can become expensive at scale. Monitor ingestion volume and retention costs.
- Use sampling for high-volume traces and debug logs rather than capturing everything.
- Set log level to `info` in production by default. Enable `debug` only when actively investigating.
- Review observability spend quarterly and drop tools or reduce retention where the cost exceeds the value.

## Anti-Patterns to Avoid
- Logging only to stdout with no aggregation or search capability
- Alerting on every error instead of meaningful thresholds
- Dashboards that no one looks at or that show stale data
- Health checks that return 200 even when the service is broken
- Logging PII, tokens, or secrets
- Relying on SSH and `tail -f` as the primary debugging workflow
- Adding observability only after the first production incident
- Over-instrumenting low-value services while ignoring critical ones
