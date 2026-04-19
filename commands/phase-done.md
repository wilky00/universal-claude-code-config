Run the phase close-out gate check for Phase $ARGUMENTS.

Do not mark a phase complete until every step below passes.

## 1. Test Suite

Run the full unit test suite and report results. Show pass/fail counts and any failures in full.

Run the integration tests against the test database or test environment. Show results.

If any tests fail, stop here and fix them before continuing.

## 2. Phase Gate Check

Read any testing strategy doc referenced in CLAUDE.md or the phase file. Confirm every test gate defined for Phase $ARGUMENTS is satisfied. List each gate and its status (pass / fail / not applicable).

## 3. Security & Accessibility

Read any security baseline doc referenced in CLAUDE.md. Confirm all controls required for Phase $ARGUMENTS are in place.

If Phase $ARGUMENTS includes any frontend work: confirm axe-core scans pass and Lighthouse accessibility score is ≥ 90 on all affected pages.

## 4. Project Notes — Update Now

Update project_notes/progress.md:
- Mark Phase $ARGUMENTS as complete with today's date
- Note anything that was descoped or deferred

Update project_notes/known-issues.md:
- Add any bugs, edge cases, or TODOs that surfaced during Phase $ARGUMENTS but were not fixed
- Include file path and line number where relevant

Update project_notes/decisions.md:
- Add an ADR for any architectural decision made during Phase $ARGUMENTS not already recorded

## 5. Final Report

Report back with:
- Phase $ARGUMENTS status: COMPLETE or BLOCKED (and why)
- Test results summary
- Any action items required before the next phase starts (DNS records, third-party registrations, manual deploys, etc.)
