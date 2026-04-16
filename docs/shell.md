# Shell Standards

## Shell Choice
- Default to `bash` for scripts unless zsh-specific behavior is required.
- Interactive shell examples may assume `zsh`, but scripts should be portable where practical.

## Script Requirements
- Start scripts with `#!/usr/bin/env bash`
- Use `set -Eeuo pipefail`
- Use functions for non-trivial scripts.
- Add a `trap` for cleanup when temporary files or partial state are involved.

## Safety
- Quote all variable expansions unless there is a specific reason not to.
- Never use `eval` unless absolutely necessary and explicitly justified.
- Check commands with `command -v` before relying on them.
- Validate inputs before acting on files, ports, or paths.

## Style
- Prefer clear multi-line scripts over dense one-liners for anything non-trivial.
- Use `[[ ... ]]` for tests in bash.
- Use lowercase variable names for local variables and uppercase only for exported env vars.
- Print actionable errors to stderr and return non-zero on failure.

## Tooling
- Prefer `shellcheck`-clean scripts.
- Prefer idempotent scripts that can be rerun safely.
- For Docker workflows, always use `docker compose`, never `docker-compose`.