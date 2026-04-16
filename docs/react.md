# React Standards

## General
- Use functional components.
- Use hooks instead of class components.
- Keep components focused and easy to reason about.
- Prefer composition over deeply nested prop drilling or overly abstract wrappers.

## Component Design
- Keep presentational concerns separate from data-fetching and side-effect-heavy logic when practical.
- Break large components into smaller ones when responsibilities become mixed.
- Do not create tiny components for the sake of fragmentation.
- Prefer explicit props over implicit behavior.

## State Management
- Keep state as local as possible.
- Do not lift state higher than necessary.
- Use context sparingly for truly shared concerns.
- Prefer simple built-in React state before introducing heavier state libraries.

## Effects
- Use `useEffect` only for real side effects.
- Do not use effects for logic that can be derived during render.
- Keep effect dependencies correct.
- Avoid effect chains that create hard-to-follow behavior.

## Derived State
- Prefer deriving values from props or existing state instead of duplicating state.
- Use `useMemo` only when there is a real performance or referential reason.
- Do not prematurely optimize.

## Forms
- Prefer controlled inputs unless the form library or use case clearly benefits from uncontrolled patterns.
- Validate user input clearly and close to the form boundary.
- Show useful validation and error states in the UI.

## Data Fetching
- Keep loading, error, empty, and success states explicit.
- Do not leave components in ambiguous UI states.
- Cancel, ignore, or guard stale async responses when needed.
- Prefer the existing repo pattern for data fetching instead of introducing a new one.

## Props
- Keep props small and intentional.
- Avoid passing large unstructured objects when only a few fields are needed.
- Prefer explicit callback names like `onSave`, `onCancel`, and `onSelect`.

## Performance
- Optimize only when there is a real rendering issue.
- Use `React.memo`, `useMemo`, and `useCallback` intentionally, not by default.
- Prefer clear code first, then optimize hotspots.

## Accessibility
- Use semantic HTML first.
- Ensure buttons are buttons, links are links, and labels are associated with inputs.
- Include keyboard accessibility for interactive UI.
- Preserve focus behavior and visible focus states.
- Provide accessible names for controls and meaningful alt text where appropriate.

## Styling
- Follow the existing project styling approach.
- Do not introduce a new styling library into an established codebase without a clear reason.
- Prefer predictable, maintainable styling over one-off inline styling.
- Keep spacing, typography, and layout patterns consistent.

## Error and Empty States
- Every user-facing async workflow should account for:
  - loading state
  - error state
  - empty state
  - success state
- Error messages should be useful and calm, not technical unless the user is technical.

## Testing
- Test behavior from the user perspective.
- Prefer React Testing Library-style patterns when the repo uses them.
- Avoid testing implementation details like hook internals unless necessary.
- Add regression tests for UI bugs.

## File Organization
- Keep component files and related tests close together when that matches the repo style.
- Keep hooks, utilities, and component logic in predictable locations.
- Avoid massive component files with mixed rendering, fetching, parsing, and business logic.