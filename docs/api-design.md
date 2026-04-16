# API Design Standards

## General Principles
- Design APIs around clear business resources and actions.
- Prefer consistency, predictability, and explicit contracts over clever endpoint design.
- Optimize for long-term maintainability and consumer clarity, not short-term convenience.
- Every API should be understandable without reading server implementation code.

## Contract First
- Define or update the API contract before or alongside implementation.
- Prefer OpenAPI for HTTP API documentation and contract sharing.
- Keep request and response schemas explicit.
- Treat the API contract as a product interface, not an afterthought.

## Resource Modeling
- Prefer resource-oriented URLs built around nouns, not verbs.
- Use plural resource names consistently, such as:
  - `/users`
  - `/orders`
  - `/devices`
- Avoid RPC-style endpoint sprawl unless the operation is truly action-oriented and not naturally resource-based.
- For action-heavy cases, prefer explicit subresources or action endpoints such as:
  - `POST /quotes/{quoteId}/submit`
  - `POST /files/{fileId}/archive`

## URL Design
- Keep URLs stable, readable, and predictable.
- Use path parameters for resource identity.
- Use query parameters for filtering, sorting, searching, pagination, and optional view controls.
- Do not encode business actions in query strings.
- Keep nesting shallow. Avoid deeply nested URLs unless the hierarchy is essential.

## HTTP Methods
- Use HTTP methods according to their intended semantics.
- Prefer:
  - `GET` for retrieval
  - `POST` for creation or action execution
  - `PUT` for full replacement when appropriate
  - `PATCH` for partial updates
  - `DELETE` for deletion
- Do not use `GET` for operations with side effects.
- Do not overload one endpoint with multiple unrelated behaviors.

## Status Codes
- Use status codes intentionally and consistently.
- Common patterns:
  - `200 OK` for successful reads and updates with a response body
  - `201 Created` for successful creation
  - `202 Accepted` for async or deferred processing
  - `204 No Content` for successful operations with no response body
  - `400 Bad Request` for malformed input
  - `401 Unauthorized` for missing or invalid authentication
  - `403 Forbidden` for authenticated but not allowed
  - `404 Not Found` when the resource does not exist
  - `409 Conflict` for state conflicts or uniqueness violations
  - `422 Unprocessable Content` for semantically invalid input when the payload is well-formed
  - `429 Too Many Requests` for rate limiting
  - `500 Internal Server Error` for unexpected server failures
- Do not return `200` for every outcome.
- Do not hide failures inside success payloads.

## Headers and Content Negotiation
- Always set `Content-Type` on responses. Prefer `application/json` unless the API has a reason to support other media types.
- Validate `Content-Type` on incoming requests that carry a body.
- Use `Accept` headers when the API supports multiple response formats, and return `406 Not Acceptable` if the requested format is unsupported.
- Use standard headers for cross-cutting concerns (authorization, correlation IDs, caching) rather than inventing custom payload fields.

## Request Design
- Keep request bodies explicit and narrowly scoped.
- Validate all external input at the boundary.
- Reject malformed or unknown fields when the contract should be strict.
- Do not accept large flexible payloads when a clear schema is possible.
- Use idempotency keys for retry-prone create operations when duplicate execution would be harmful.

## Response Design
- Return predictable, documented response shapes.
- Keep field names stable and semantically clear.
- Avoid mixing transport metadata and business data in inconsistent ways.
- Include identifiers and important state fields that clients need immediately after mutation.
- Prefer explicit booleans, enums, and typed fields over ambiguous free-form strings.

## Schema Design
- Define request and response schemas explicitly.
- Prefer JSON Schema-compatible modeling for validation and documentation.
- Mark required fields intentionally.
- Control extra properties deliberately rather than allowing schema drift by default.
- Reuse shared schema components for common objects, pagination wrappers, and error formats.
- Prefer enums or constrained unions when values come from a known set.

## Field Naming
- Use consistent casing across the API, typically `camelCase` for JSON fields if that is the standard.
- Keep names descriptive and stable.
- Avoid abbreviations unless they are already standard in the domain.
- Do not rename equivalent concepts across endpoints.

## Pagination, Filtering, and Sorting
- Paginate large collections consistently.
- Use a standard pattern for pagination parameters and response metadata across the API.
- Keep filtering and sorting syntax simple and documented.
- Do not return unbounded lists for endpoints that may grow significantly.
- Cursor-based pagination is preferred when data changes frequently or stable pagination matters.

## Search Endpoints
- Keep search behavior explicit.
- Use query parameters for lightweight filtering and search.
- Use a dedicated search endpoint only when search behavior becomes complex enough to deserve its own contract.
- Document ranking, partial matching, and case-sensitivity behavior where it affects usability.

## Error Handling
- Use a consistent machine-readable error format across the API.
- Prefer Problem Details style error responses or a clearly standardized internal equivalent.
- Error responses should include:
  - a stable error type or code
  - a human-readable message
  - actionable detail when appropriate
  - field-level validation details when relevant
  - trace or correlation metadata when safe and useful
- Do not leak stack traces, SQL details, or internal implementation data to clients.

## Validation Errors
- Validation errors should identify the affected field or path when possible.
- Return enough detail for clients to correct the request quickly.
- Keep validation error structure consistent across endpoints.
- Do not force consumers to parse free-form strings to understand input issues.

## Rate Limiting
- Apply rate limits to public and high-traffic endpoints.
- Return `429 Too Many Requests` with a `Retry-After` header when limits are exceeded.
- Document rate limit policies so consumers can plan around them.
- Consider per-client, per-endpoint, or tiered rate limiting depending on the use case.

## Caching
- Use `Cache-Control` headers to communicate cacheability for read-heavy endpoints.
- Support `ETag` and `If-None-Match` for conditional requests when practical.
- Return `304 Not Modified` when the resource has not changed and the client sent a valid conditional header.
- Do not cache responses that include user-specific or sensitive data without appropriate controls.

## Bulk Operations
- Provide bulk endpoints when clients frequently need to create, update, or retrieve multiple resources in a single call.
- Define clear limits on batch size and document them.
- Return per-item results so clients can identify which items succeeded and which failed.
- Prefer partial success with detailed results over all-or-nothing behavior when that matches the use case.

## Idempotency and Retries
- Design retry-sensitive operations carefully.
- Prefer idempotent behavior where practical.
- For operations that may be retried by clients, gateways, or queues, define how duplicates are handled.
- Document idempotency expectations clearly.

## Async and Long-Running Operations
- Use async patterns when work may outlive the request lifecycle.
- Prefer `202 Accepted` with a documented follow-up status resource or job resource for long-running tasks.
- Expose clear status values for in-progress, succeeded, failed, and canceled states.
- Do not leave clients guessing whether work completed.

## Versioning
- Version APIs deliberately and sparingly.
- Prefer backward-compatible evolution where possible.
- If versioning is required, use a clear and consistent strategy across the platform.
- Avoid unnecessary breaking changes.
- Deprecate fields and endpoints with a migration path and clear timeline when possible.

## Backward Compatibility
- Adding optional fields is usually safer than changing or removing existing fields.
- Do not silently repurpose existing fields.
- Do not change response shapes incompatibly without versioning or an explicit migration plan.
- Preserve existing semantics whenever possible.

## Security and Access Control
- Separate authentication failures from authorization failures.
- Never trust client-supplied identity or privilege claims without verification.
- Validate and authorize every sensitive operation.
- Do not expose internal-only fields in public responses.
- Minimize data returned to only what the client needs.

## Observability
- Include request identifiers or correlation identifiers where useful.
- Log requests and failures safely without exposing secrets or sensitive payloads.
- Make rate limiting, timeout behavior, and retry behavior observable.
- Keep error codes stable enough to support monitoring and support workflows.

## Documentation
- Every endpoint should document:
  - purpose
  - request schema
  - response schema
  - error responses
  - auth requirements
  - pagination or filtering behavior if relevant
- Keep examples realistic and aligned with the actual contract.
- Update docs when behavior changes.

## Testing Expectations
- Add contract tests for important endpoints.
- Add validation tests for malformed, missing, extra, and boundary-case inputs.
- Add authorization tests for protected operations.
- Add regression tests for previously broken API behavior.
- Test both happy path and failure path behavior.

## Anti-Patterns to Avoid
- Verb-based endpoint sprawl
- Returning `200 OK` for errors
- Inconsistent error formats
- Unvalidated request bodies
- Response shapes that change by endpoint without reason
- Hidden breaking changes
- Unbounded collection endpoints
- Free-form status strings where enums are better
- Silent acceptance of unknown fields when strict schemas are intended
- Leaking internal implementation details in error payloads