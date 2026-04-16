# Contributing

Thanks for taking the time to contribute.

## What belongs here

This repo is for **general engineering conventions** that apply across teams and projects. Good contributions:

- Rules that would benefit any engineer, regardless of stack
- New `docs/` files for widely-used technologies (e.g. `postgres.md`, `react.md`)
- Improvements to the install script
- Bug fixes

**Not a good fit:** company-specific rules, personal preferences, or anything that only applies to one project. Those belong in a project-level `CLAUDE.md`.

## How to contribute

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-change`
3. Make your changes
4. Test the install script locally: `bash install.sh`
5. Open a pull request with a clear description of what changed and why

## Guidelines

- Keep rules in `CLAUDE.md` concise and actionable — one clear instruction per bullet
- New `docs/` files should follow the structure of existing ones
- If editing `install.sh`, run [ShellCheck](https://www.shellcheck.net/) before submitting
- No AI attribution in commit messages

## Reporting bugs

Open an issue using the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md).

## Suggesting new rules or docs

Open an issue using the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) before implementing, so we can discuss fit before you invest time writing it.
