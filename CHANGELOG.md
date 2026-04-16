# Changelog

All notable changes to this project will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-03-31

### Added

- `CLAUDE.md` — global Claude Code instructions covering identity, communication, code standards, testing, security, workflow, Docker, AI/LLM work, accessibility, and scope guard
- `docs/python.md` — conventions for uv, pytest, ruff, FastAPI, Pydantic, pathlib, asyncio
- `docs/aws.md` — EC2/Docker, IAM least-privilege, secrets management, region conventions
- `docs/git.md` — branch naming, commit style, PR format, no AI attribution
- `docs/ai-patterns.md` — prompt structure, Ollama/local model conventions, agent tool patterns
- `commands/project-memory.md` — `/project-memory` slash command for per-project decision logs, known issues, and progress tracking
- `commands/accessibility.md` — `/accessibility` slash command with audits for web, mobile, CLI, API, and email surfaces
- `install.sh` — curl-installable setup script with automatic backup of existing config
- `uninstall.sh` — clean removal with optional backup restore
- `SECURITY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `LICENSE` (MIT)
- GitHub issue templates, PR template, and ShellCheck CI workflow

[1.0.0]: https://github.com/wilky00/universal-claude-code-config/releases/tag/v1.0.0
