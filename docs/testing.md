# Testing Standards

## General Philosophy
- Tests exist to catch regressions and prove behavior — not to hit coverage numbers.
- Write tests before or alongside implementation. TDD is preferred but not religious.
- Every bug fix ships with a regression test that would have caught it.
- Tests are production code. Keep them readable, maintainable, and well-named.
- Never ignore test output, warnings, or logs — they contain diagnostic information that matters.

## Test Pyramid
- Favor a balanced pyramid: many unit tests, fewer integration tests, minimal end-to-end tests.
- Unit tests cover individual functions, modules, and business logic in isolation.
- Integration tests cover boundaries: API endpoints, database queries, external service calls, message consumers.
- End-to-end tests cover critical user journeys through the full stack. Keep these focused and stable.
- If a bug can be caught by a unit test, do not write an integration or e2e test for it.

## What to Test
- Business logic and domain rules — always.
- API endpoints: request validation, response shape, status codes, auth, error handling.
- Database queries and migrations — especially anything beyond simple CRUD.
- Edge cases: empty inputs, null values, boundary conditions, large payloads, concurrent access.
- Authorization and access control — every protected operation needs a test proving unauthorized access is rejected.
- Error paths: malformed input, missing dependencies, timeout, upstream failure.

## What Not to Test
- Framework internals or third-party library behavior.
- Private implementation details that are not part of the public contract.
- Trivial getters, setters, or pass-through wrappers with no logic.
- Generated code unless you have reason to distrust the generator.

## Test Organization
- Keep tests close to the code they cover or in a parallel `tests/` directory that mirrors the source structure.
- Name test files and functions clearly so failures are self-documenting.
- Group related tests logically. Prefer descriptive names over numbered tests.
- Separate unit, integration, and e2e tests so they can be run independently.

## Test Data
- Use factories or builder functions to create test data — not raw object literals scattered across tests.
- Keep test data minimal. Only set fields that matter for the assertion.
- Do not share mutable test state between tests. Each test should set up and tear down its own data.
- Use realistic but synthetic data. Never use real user data, PII, or production credentials in tests.
- Seed databases per test or per test suite, not globally.

## Mocking and Fakes
- Mock external dependencies (APIs, databases, file systems) at integration boundaries — not deep inside business logic.
- Prefer fakes and in-memory implementations over mocks when they improve confidence and readability.
- Mock only what you must. Over-mocking hides real bugs and makes tests brittle.
- Never mock the thing you are testing.
- When mocking HTTP calls, assert on the request shape, not just that a call was made.

## Fixtures and Setup
- Use framework-appropriate fixtures (pytest fixtures, beforeEach/afterEach, etc.).
- Keep fixture scope as narrow as practical. Prefer per-test setup over shared module or session fixtures.
- Clean up after tests: close connections, remove temp files, reset state.
- Avoid complex fixture chains that are hard to trace when a test fails.

## Assertions
- Assert on behavior and outcomes, not implementation steps.
- Keep assertions specific. Prefer `expect(status).toBe(404)` over `expect(status).toBeTruthy()`.
- One logical assertion per test when practical. Multiple related assertions in one test are fine if they test the same behavior.
- Use snapshot testing sparingly and only for stable output shapes. Avoid snapshots for volatile data.

## Async and Timing
- Test async code with proper await patterns — never rely on timing or sleep.
- Use deterministic clocks or time-travel utilities when testing time-dependent behavior.
- Set explicit timeouts on async tests to catch hangs early.
- Test cancellation, timeout, and retry behavior for operations that involve them.

## Database Testing
- Use a real database instance for integration tests — not an in-memory substitute with different behavior.
- Run migrations before the test suite to ensure schema is current.
- Isolate test data per test using transactions that roll back, or per-test database seeding with cleanup.
- Test migration scripts separately: verify they apply cleanly, handle edge cases, and are reversible when required.

## API and Contract Testing
- Test every public API endpoint for expected request/response contracts.
- Validate status codes, response shapes, headers, and error formats.
- Test auth: unauthenticated, unauthorized, and authorized paths for every protected endpoint.
- Test input validation: missing fields, extra fields, wrong types, boundary values.
- For services that depend on external APIs, add contract tests to catch upstream schema drift early.

## Frontend and UI Testing
- Test user-facing behavior, not component internals.
- Prefer React Testing Library-style patterns: render, interact, assert on DOM output.
- Add e2e tests for critical user flows: login, checkout, form submission, navigation.
- Test accessibility: keyboard navigation, ARIA attributes, focus management.
- Add visual regression tests for UI components when layout stability matters.

## CI Integration
- All tests must pass in CI before a branch can merge. No exceptions.
- Tests must run in a clean environment — no dependency on local state, developer machines, or previous test runs.
- Fail the build on test failures, not just on compilation errors.
- Run linting and type checking as part of the CI test pipeline.
- Keep CI test runs fast. Parallelize where possible and separate slow e2e tests into their own stage.

## Coverage
- Aim for high coverage on new code (90%+ for business logic, 80%+ overall).
- Coverage is a safety net, not a goal. Do not write low-value tests just to hit a number.
- Track coverage trends over time. Coverage should not decrease on any PR.
- Exclude generated code, configuration files, and type definitions from coverage metrics when appropriate.

## Performance and Load Testing
- Add performance tests for latency-sensitive endpoints or operations before production launch.
- Define baseline response times and set regression thresholds.
- Run load tests against a staging environment that mirrors production infrastructure.
- Test under realistic concurrency: multiple users, concurrent writes, connection pool exhaustion.
- Do not run load tests against production unless the infrastructure and data are explicitly designed for it.

## Flaky Tests
- Flaky tests are bugs. Investigate and fix them immediately — do not ignore or retry-loop around them.
- Common causes: shared mutable state, timing dependencies, external service calls, non-deterministic ordering.
- If a test cannot be made reliable quickly, quarantine it with a tracking issue. Do not leave it silently skipped.

## Language-Specific Notes
- **Python:** Use `pytest` with fixtures. Use `pytest-cov` for coverage. Use `httpx` or FastAPI `TestClient` for API tests.
- **Node/TypeScript:** Use Vitest or Jest. Use `supertest` for API tests. Prefer `vi.mock` / `jest.mock` at module boundaries.
- **React:** Use React Testing Library. Avoid Enzyme. Use Playwright or Cypress for e2e.
- See `docs/python.md`, `docs/node.md`, `docs/react.md`, and `docs/typescript.md` for stack-specific testing details.

## Anti-Patterns to Avoid
- Tests that pass when the feature is broken
- Tests that break when unrelated code changes
- Shared mutable state between tests
- Mocking everything including the code under test
- Testing implementation details instead of behavior
- Ignoring or disabling failing tests instead of fixing them
- Tests that depend on execution order
- Hardcoded dates, ports, or file paths that break in CI
- Empty catch blocks in test assertions
- Copy-pasting test bodies instead of using parameterized tests or factories
