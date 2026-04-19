# universal-claude-code-config

> Fork of [**kristianhansen/universal-claude-code-config**](https://github.com/kristianhansen/universal-claude-code-config) by [Kristian Hansen](https://github.com/kristianhansen), licensed under MIT. The original copyright is preserved in [LICENSE](LICENSE); this fork adds personal customizations on top of that work. Full credits are in [Acknowledgments](#acknowledgments).

<img width="372" height="98" alt="Screenshot 2026-03-31 at 12 21 35 PM" src="https://github.com/user-attachments/assets/fea547ab-dc31-4fa5-bd06-d924c0837325" />

[![ShellCheck](https://github.com/wilky00/universal-claude-code-config/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/wilky00/universal-claude-code-config/actions/workflows/shellcheck.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/wilky00/universal-claude-code-config)](https://github.com/wilky00/universal-claude-code-config/releases/latest)

A global [Claude Code](https://claude.ai/code) configuration that installs into `~/.claude/` and applies sensible engineering defaults across every project you work on.

Covers: code standards, security, testing, accessibility, git, Docker, AI/LLM work, and workflow conventions — plus slash commands and a global researcher sub-agent that auto-discovers context, runs audits, and handles codebase research economically across every session.

---

## Install

### curl (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Wilky00/universal-claude-code-config/main/install.sh | bash
```

### Manual

Clone the repo and copy files yourself:

```bash
git clone https://github.com/wilky00/universal-claude-code-config.git
cd universal-claude-code-config

mkdir -p ~/.claude/docs ~/.claude/commands ~/.claude/agents
cp CLAUDE.md ~/.claude/CLAUDE.md
cp docs/* ~/.claude/docs/
cp commands/* ~/.claude/commands/
cp agents/* ~/.claude/agents/
```

---

## Upgrade

### curl

```bash
curl -fsSL https://raw.githubusercontent.com/Wilky00/universal-claude-code-config/main/upgrade.sh | bash
```

The upgrade script checks your installed version against the latest release, shows the release notes, and asks before overwriting anything. Your existing `CLAUDE.md` is backed up to `~/.claude/backups/` automatically.

---

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/Wilky00/universal-claude-code-config/main/uninstall.sh | bash
```

Your original files are backed up to `~/.claude/backups/` before any install or uninstall runs.

---

## After installing

1. Open `~/.claude/CLAUDE.md`
2. Add your name in the **Identity & Communication** section
3. Uncomment and fill in your stack under **Technology Standards**

---

## What it configures

Every section of `CLAUDE.md` is intentional. Here's what each one does and why it matters:

| Section | What it does |
|---|---|
| **Identity & Communication** | Sets your name and establishes Claude as a senior engineer on your team — not a chatbot. You get direct answers, not hedged ones. |
| **Session Startup** | At the start of every session, Claude reads your project's `CLAUDE.md`, checks for context folders, and summarizes what it knows before touching anything. No more re-explaining your project every time. |
| **Commits** | Strips AI attribution from commit messages so your git history stays clean and professional. |
| **Security** | Claude scans for secrets, PII, and credentials before every push. Enforces parameterized queries, input validation, and safe logging — automatically, on every project. |
| **Code Standards** | Keeps Claude in its lane: no unsolicited refactors, no clever rewrites, no renaming things "improved" or "new". Changes are surgical and scoped to what you asked for. |
| **Testing** | Enforces TDD — tests are written alongside code, not as an afterthought. Claude never skips coverage or ignores failing output. |
| **General Coding Behavior** | Prevents scope creep. No speculative abstractions, no extra error handling, no helper utilities built for one use. Code stays simple. |
| **Workflow** | Claude discusses a plan before implementing anything non-trivial, works in small testable increments, and flags problems rather than silently fixing them in ways you didn't ask for. |
| **Technology Standards** | Links to your stack-specific doc files (`python.md`, `aws.md`, etc.) so conventions are consistent whether you're in a FastAPI backend or a React frontend. |
| **Docker & Infrastructure** | Pins base image versions, prefers `COPY` over `ADD`, and documents exposed ports — the basics that get skipped under pressure. |
| **AI/LLM Work** | Structures every prompt with a system role, user turn, and output format. Enforces JSON outputs for tool-use flows so agent pipelines stay predictable. |
| **Accessibility** | Treats accessibility as a bug, not a backlog item. Claude runs audits after every UI change — Lighthouse for web, label checks for mobile, contrast for CLI — and blocks shipping critical issues. |
| **Explanations** | When you ask "why", you get the engineering rationale — trade-offs, risks, constraints — not a textbook definition. |
| **Scope Guard** | If a task touches more than 3 files, Claude stops and confirms before proceeding. Prevents well-intentioned changes from becoming sprawling diffs. |
| **Style** | No emojis, no trailing summaries, no padding. Responses are short, direct, and lead with the answer. |

---

## What's included

```
~/.claude/
├── CLAUDE.md                    # Global instructions, auto-loaded every session
├── docs/
│   ├── python.md                # uv, pytest, ruff, FastAPI, Pydantic conventions
│   ├── aws.md                   # EC2/Docker, IAM, secrets, region conventions
│   ├── git.md                   # Branch naming, commit style, PR format
│   └── (...)                    # Full stack coverage — see docs/ for all files
├── commands/
│   ├── project-memory.md        # /project-memory — maintains decisions, issues, progress logs
│   ├── accessibility.md         # /accessibility — runs audits for web, mobile, CLI, API
│   ├── generate-tests.md        # /generate-tests — generates test suite for current file or module
│   ├── phase-start.md           # /phase-start — Opus plan mode kickoff for a new build phase
│   └── phase-done.md            # /phase-done — phase gate check: tests, security, project notes
└── agents/
    └── researcher.md            # Global read-only research sub-agent (runs on Haiku)
```

### Slash commands

| Command | What it does |
|---|---|
| `/project-memory` | Creates or reads `project_notes/` in the current project — tracks decisions, known issues, and progress across sessions |
| `/accessibility` | Detects project type and runs the appropriate accessibility audit (Lighthouse for web, label checks for mobile, contrast for CLI, etc.) |
| `/generate-tests` | Generates a test suite for the current file or module, following the project's testing conventions |
| `/phase-start <phase-file>` | Switches to Opus in plan mode, delegates orientation to the researcher agent, and produces an implementation plan for the given phase — waits for approval before writing any code |
| `/phase-done <phase-number>` | Runs the full phase close-out gate: unit + integration tests, phase gate checklist, security baseline, accessibility (if applicable), then updates all `project_notes/` files and reports COMPLETE or BLOCKED |

### Sub-agents

| Agent | Model | What it does |
|---|---|---|
| `researcher` | Haiku | Read-only codebase and documentation research. Handles all "find where X is", "does Y exist", and "what does the code currently look like" tasks without bloating the main context window. Costs a fraction of running the same searches in the main Sonnet session. |

Sub-agents are defined in `agents/` and are available globally across every project. A project can override a global agent by placing its own definition in `.claude/agents/` in the project root — the project-level definition takes precedence.

---

## Customizing

The `docs/` files are referenced from `CLAUDE.md` under **Technology Standards**. You can:

- Edit them to match your stack
- Add new ones (e.g. `~/.claude/docs/react.md`, `~/.claude/docs/postgres.md`)
- Remove references to ones you don't use

For project-specific rules, add a `CLAUDE.md` to your project root — Claude Code merges it with the global one.

For project-specific agents, add a `.claude/agents/` directory to your project root. Any agent defined there overrides the global version of the same name for that project only.

---

## Phase workflow (for phased build projects)

If your project uses a phased development plan, these two commands give you a consistent start/close ritual for every phase:

**Starting a phase:**
```
/phase-start dev_plan/01_phase1_infrastructure_auth.md
```
Claude switches to Opus, enters plan mode, delegates all orientation reading to the researcher agent (Haiku), and returns a structured implementation plan. Nothing gets written until you explicitly approve.

**Closing a phase:**
```
/phase-done 1
```
Claude runs the full gate check — tests, phase-specific test gates, security baseline, accessibility — then updates `project_notes/progress.md`, `known-issues.md`, and `decisions.md`. Reports COMPLETE or BLOCKED with any action items before the next phase starts.

For this to work, your project needs:
- `project_notes/decisions.md`, `progress.md`, and `known-issues.md`
- A CLAUDE.md that references your testing and security docs
- A phase file for each phase (e.g. `dev_plan/01_phase1.md`)

The `/project-memory` command sets up the `project_notes/` structure automatically.

---

## Contributing

PRs welcome. Keep rules general enough to apply across teams — project-specific conventions belong in the project's own `CLAUDE.md`.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for community standards.

---

## Acknowledgments

This repository is a fork of [**kristianhansen/universal-claude-code-config**](https://github.com/kristianhansen/universal-claude-code-config), created and maintained by [Kristian Hansen](https://github.com/kristianhansen). The original project defined the structure, `CLAUDE.md` rule set, stack-specific docs, install/uninstall scripts, and CI — all of which this fork builds on.

This fork adds personal customizations and conventions on top of that work. For the canonical upstream project and any issues unrelated to this fork's specific changes, please use the [original repository](https://github.com/kristianhansen/universal-claude-code-config).

### License and copyright

Per the MIT License, the original copyright notice is preserved in [LICENSE](LICENSE):

> Copyright (c) 2026 Kristian Hansen

If you redistribute or further fork this repo, please keep that notice intact and credit the original author.
