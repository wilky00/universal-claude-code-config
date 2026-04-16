# Python Standards

## Package Management
- Use `uv` for all package management — never pip directly
- Dependencies declared in `pyproject.toml`
- Lock file (`uv.lock`) must be committed

## Type Hints
- Type hints required on all function signatures (parameters and return types)
- Use `from __future__ import annotations` for forward references
- Prefer `X | None` over `Optional[X]`

## Testing
- Use `pytest` for all tests
- Tests live in `tests/` mirroring the source structure
- Use fixtures, not setUp/tearDown
- Aim for 100% coverage on new code

## Linting & Formatting
- Use `ruff` for both linting and formatting — no flake8, black, or isort
- Run `ruff check` and `ruff format` before committing

## Web Framework
- Use FastAPI for all API work
- Route handlers must be async
- Request/response bodies use Pydantic models — never raw dicts

## File & Path Handling
- Use `pathlib.Path` — never `os.path`

## Async
- Use `asyncio` and `async/await` throughout — no threading for I/O-bound work
- Use `asyncio.gather` for concurrent tasks

## Data Validation
- Use Pydantic v2 models for all structured data
- Validate at system boundaries (API input, external responses)
- Never pass raw dicts between internal layers

## Logging
- Use `structlog` for structured logging in new projects
- Include request or job context for traceability
- Never log secrets, tokens, passwords, or PII
- Log startup configuration shape, not secret values

## Docstrings
- Use Google-style docstrings for all public functions, classes, and modules
- Docstrings must describe what the function does, its parameters, return value, and any exceptions raised
- Keep docstrings concise — explain intent, not obvious mechanics

## Python Version
- Target Python 3.11+ minimum unless the project has a specific constraint
- Use modern syntax and stdlib features available at the target version
