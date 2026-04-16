# /accessibility

Run an accessibility audit on the current project and report findings.

## Detect project type and run the appropriate audit

### Web (React, Vite, Next.js, static HTML)
1. Check if `@axe-core/cli` or `lighthouse` is available; if not, flag it as missing and suggest installing.
2. If Lighthouse is available: `npx lighthouse <local_url> --only-categories=accessibility --output=json --quiet`
3. Parse the score and list all failing audits by severity (critical → serious → moderate → minor).
4. If axe is available as a dev dependency, check that it is wired into the test suite.

### React Native / Mobile
1. Check that `react-native-accessibility` or equivalent is in use.
2. Verify that interactive elements have `accessibilityLabel`, `accessibilityRole`, and `accessibilityHint` where appropriate.
3. Check for missing labels on touchable elements.

### CLI / Terminal tools
1. Verify color is not the only means of conveying information.
2. Check for `--no-color` / `NO_COLOR` support.
3. Verify all output is screen-reader compatible (no control characters in plain output).

### APIs / Backend services
1. Verify error messages are human-readable and not just error codes.
2. Check that any generated HTML (emails, reports) meets WCAG 2.1 AA.

## Report format
- Overall score (if available): X/100
- Critical issues (must fix before ship): list
- Serious issues (fix soon): list
- Moderate/minor issues (backlog): list
- Recommendation: pass / fix before merge / fix before launch
