# TypeScript Standards

## General
- Use TypeScript for all new JavaScript code unless the project explicitly requires plain JavaScript.
- Prefer strict typing over `any`.
- Treat TypeScript errors as real issues to fix, not warnings to bypass.

## tsconfig Expectations
- Enable strict mode.
- Prefer modern module and target settings aligned with the repo build system.
- Do not weaken compiler settings just to get code compiling unless explicitly approved.

## Types
- Prefer explicit domain types and interfaces for important business objects.
- Use `type` for unions, mapped types, and utility composition.
- Use `interface` for extendable object contracts when that improves readability.
- Avoid `any`. Use `unknown` when a value truly is unknown and narrow it safely.
- Prefer discriminated unions over loose optional-property branching.

## Functions
- Add explicit parameter and return types for exported functions.
- Keep functions small and single-purpose.
- Prefer pure functions where practical.
- Do not hide side effects in helper utilities.

## Null and Undefined
- Handle `null` and `undefined` deliberately.
- Do not silence nullability with non-null assertions unless there is a strong reason.
- Narrow values safely before use.

## Data Boundaries
- Validate external data at boundaries.
- Do not trust API responses, form payloads, local storage values, or environment variables without parsing or validation.
- Prefer Zod or equivalent schema validation when runtime validation is needed.

## Enums and Constants
- Prefer union string literals or const objects over enums unless the repo already uses enums heavily.
- Centralize reusable constants instead of scattering string literals across the codebase.

## Imports and Structure
- Use clear, stable import paths.
- Avoid circular dependencies.
- Keep shared utility types in predictable locations.
- Do not create deep abstraction layers unless they solve a real maintenance problem.

## Async Code
- Use `async` and `await` over raw promise chains.
- Handle errors explicitly.
- Do not ignore rejected promises.
- For concurrent work, use `Promise.all` or `Promise.allSettled` intentionally based on failure behavior.

## Error Handling
- Throw errors with useful context.
- Do not swallow errors silently.
- Prefer typed result patterns or clear exception handling for important workflows.

## Style
- Prefer readable code over advanced type gymnastics.
- Use descriptive names.
- Avoid overly clever generic utilities unless they materially reduce duplication and remain understandable.

## Testing
- Add or update tests for new behavior and bug fixes.
- Test business logic separately from UI where possible.
- Prefer testing observable behavior over implementation details.