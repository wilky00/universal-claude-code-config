Switch to Opus and use plan mode before writing anything.

The phase to plan is: $ARGUMENTS

First, use the researcher agent (if defined) or read these files yourself to orient:
- CLAUDE.md (project root) — tech stack, engineering rules, repo structure
- project_notes/decisions.md — ADR log
- project_notes/progress.md — what's done and in flight
- project_notes/known-issues.md — open bugs and blockers
- Any overview or architecture doc referenced in CLAUDE.md
- The phase file for $ARGUMENTS
- Any testing strategy doc referenced in CLAUDE.md or the phase file
- Any security baseline doc referenced in CLAUDE.md or the phase file

Once oriented, present an implementation plan covering:
- What will be built and in what order
- Which files will be created or modified (flag if this exceeds 3 files and confirm approach)
- Where and how tests will be written (unit + integration)
- Any security or compliance items that apply to this phase
- Any ambiguities or decisions needed before starting

Wait for explicit approval before writing any code.
