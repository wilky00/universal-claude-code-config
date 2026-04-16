# Node.js Standards

## General
- Use Node.js for backend services, CLIs, automation utilities, and local development tooling where JavaScript or TypeScript is a good fit.
- Prefer TypeScript over plain JavaScript for new Node projects unless the project is intentionally minimal.
- Favor clear, maintainable service structure over framework-heavy abstraction.

## Runtime and Package Management
- Use the project's existing package manager if one is already established.
- For new projects, prefer one package manager and keep it consistent across the repo.
- Commit the lockfile.
- Do not mix package managers within the same project.
- Define engines when version compatibility matters.

## Project Structure
- Keep structure predictable and shallow.
- Prefer clear folders such as:
  - `src/`
  - `tests/`
  - `scripts/`
  - `config/`
- Separate transport, business logic, and integration code when the service is non-trivial.
- Avoid scattering environment access, HTTP clients, and database calls across unrelated files.

## Configuration
- All environment-specific values must come from environment variables or config files that are safe to commit.
- Never hardcode secrets, API keys, tokens, ports, hostnames, or credentials.
- Commit `.env.example`, never real `.env` values.
- Validate environment variables at startup and fail fast on missing required config.

## TypeScript in Node
- Prefer TypeScript for all new Node services.
- Use strict typing.
- Add explicit types for exported functions, service contracts, and external integrations.
- Validate untrusted inputs at boundaries with Zod, Pydantic-equivalent libraries in TS, or similar schema validation.

## Architecture
- Prefer small, composable modules with clear responsibilities.
- Keep framework setup thin and business logic framework-agnostic where practical.
- Avoid service files that mix routing, validation, business logic, and persistence in one place.
- Favor dependency injection through constructor or function parameters when it improves testability and clarity.

## APIs and Services
- Keep request validation explicit.
- Return structured, predictable responses.
- Handle loading, timeout, upstream failure, and malformed input cases intentionally.
- Do not leak internal errors or stack traces to clients.
- Use clear status codes and error objects.

## Async and Concurrency
- Use `async` and `await` over raw promise chains.
- Handle rejected promises explicitly.
- Use concurrency intentionally with `Promise.all` or `Promise.allSettled` based on failure needs.
- Apply timeouts, cancellation, or retries where external calls may hang or fail transiently.

## Error Handling
- Fail loudly and clearly for startup and configuration problems.
- Use structured error handling with useful context.
- Do not swallow errors silently.
- Distinguish between user input errors, integration failures, and programmer bugs.
- Log enough to diagnose issues without exposing secrets.

## Logging and Observability
- Use structured logging where possible.
- Include request or job context for traceability.
- Never log secrets, tokens, passwords, or sensitive payloads.
- Log startup configuration shape, not secret values.
- Add health checks or basic observability for long-running services.

## Security
- Validate all external inputs.
- Sanitize data before using it in shell commands, queries, file operations, or rendered content.
- Apply least privilege for file access, environment access, and container permissions.
- Rate limit or guard endpoints when exposure risk exists.
- Review middleware and dependencies for security impact before adding them.

## File and Process Safety
- Be careful with file deletion, path joins, recursive operations, and spawned child processes.
- Never pass raw user input directly into shell commands.
- Prefer built-in Node APIs before adding extra dependencies for simple tasks.
- Use streams for large files when appropriate instead of loading everything into memory.

## Dependencies
- Keep dependencies minimal and justified.
- Prefer mature, well-maintained libraries.
- Do not add a library for functionality that the platform already provides well.
- Remove unused dependencies promptly.

## Testing
- Add or update tests for new behavior and bug fixes.
- Test business logic separately from transport when practical.
- Prefer integration tests for critical service boundaries.
- Mock only where it preserves confidence rather than hiding real behavior.

## Scripts and Tooling
- Keep package scripts clear and predictable.
- Typical scripts should include:
  - `dev`
  - `build`
  - `test`
  - `lint`
  - `start`
- Do not create overly clever script chains that are hard to debug.
- Prefer straightforward development workflows.

## Background Jobs and Workers
- Make job retry behavior explicit.
- Ensure jobs are idempotent when possible.
- Log job inputs carefully and redact sensitive fields.
- Track failure conditions clearly enough to debug without replaying blind.

## Performance
- Avoid premature optimization.
- Measure before optimizing hotspots.
- Watch for blocking work on the event loop.
- Offload heavy CPU-bound work when necessary instead of forcing it through a request path.

## Containers and Deployment
- Services should start reliably with clear startup logs.
- Fail fast on invalid configuration.
- Expose only required ports.
- Include health checks when the service is intended to run in Docker or orchestration.
- Keep container images and runtime assumptions explicit.

## Anti-Patterns to Avoid
- Accessing environment variables all over the codebase instead of centralizing config
- Massive route files with validation, logic, and persistence mixed together
- Silent catch blocks
- Unbounded retries
- Hardcoded secrets or URLs
- Dependency sprawl
- Ignored promise rejections
- Child process usage with untrusted input