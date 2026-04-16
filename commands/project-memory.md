# /project-memory

Maintain the `project_notes/` directory for the current project.

## Steps

1. Check if `project_notes/` exists in the current working directory.
   - If not, create it and initialize the three files below with empty templates.

2. Read all three files if they exist:
   - `project_notes/decisions.md` — architectural and design decisions with rationale
   - `project_notes/known-issues.md` — bugs, edge cases, and known limitations
   - `project_notes/progress.md` — recent work completed and what's next

3. Summarize what you found: key decisions made, open issues, and current progress state.

4. Ask if anything needs to be updated or added before continuing work.

## File templates (use when creating from scratch)

### decisions.md
```
# Decisions

## [Decision title] — YYYY-MM-DD
**What:** 
**Why:** 
**Alternatives considered:** 
```

### known-issues.md
```
# Known Issues

## [Issue title]
**Status:** open | in-progress | resolved
**Description:** 
**Workaround:** 
```

### progress.md
```
# Progress Log

## YYYY-MM-DD
**Completed:**
**In progress:**
**Next:**
```
