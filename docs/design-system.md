# Design System Standards

## General Principles
- Build UI from reusable patterns, not one-off screen-specific styling.
- Prefer consistency over novelty.
- Reuse existing components, tokens, and layout patterns before creating new ones.
- Every new UI element should feel like it belongs to the same product family.

## Theme and Token Requirements
- All colors, spacing, typography, radius, shadows, and sizing should come from design tokens or semantic variables.
- Do not hardcode raw hex values, spacing values, or font sizes directly in components unless there is a strong reason.
- All components must support both light mode and dark mode by default when theming exists.
- Use semantic tokens such as:
  - `background`
  - `foreground`
  - `card`
  - `card-foreground`
  - `popover`
  - `popover-foreground`
  - `muted`
  - `muted-foreground`
  - `border`
  - `input`
  - `ring`
  - `primary`
  - `primary-foreground`
  - `secondary`
  - `secondary-foreground`
  - `accent`
  - `accent-foreground`
  - `destructive`
  - `destructive-foreground`
  - `success`
  - `warning`
- Components should never define their own ad hoc theme logic when shared tokens already exist.

## Dark Mode
- Dark mode should be designed intentionally, not created by inverting colors.
- Dark mode is required to feel like an intentional design, not a secondary skin.
- Ensure both themes preserve hierarchy, readability, contrast, and clear affordances.
- Surfaces should use layered contrast carefully to preserve depth without becoming muddy.
- Text should remain comfortable to read without appearing harsh or overly dim.
- Interactive elements must still feel clickable, focused, and distinct from surrounding surfaces.
- Components should inherit theme values consistently across hover, focus, active, disabled, and error states.
- Charts, badges, alerts, and status colors must also be reviewed in dark mode, not just main surfaces and text.

## Accessibility Across Themes
- Maintain sufficient contrast in both light and dark mode.
- Focus indicators must remain clearly visible in both themes.
- Do not rely on glow, low-contrast borders, or subtle shadows alone to separate elements in dark mode.
- Error, warning, success, and informational states must remain distinct without depending on color alone.

## Theme Preferences
- Respect system theme preference when appropriate.
- If the application includes theme switching, make it easy to find and persist the user's choice.
- Avoid theme flicker during page load or hydration.
- Theme selection should not break layout, branding, or component behavior.

## Shared Component Quality Bar
- Shared UI components should be built so theme support, accessibility states, and spacing consistency come by default, not by one-off screen customization.
- A screen should inherit the design system through component usage instead of re-solving visual rules locally.
- Shared components should expose intentional, limited variants instead of encouraging custom styling at the point of use.
- If repeated per-screen overrides are needed, improve the shared component rather than duplicating custom behavior.

## Color Usage
- Color should communicate hierarchy, interactivity, and state.
- Do not use color for decoration alone when it creates noise.
- Use accent colors sparingly and intentionally.
- Destructive, warning, success, and info colors must be consistent across all components.
- Never rely on color alone to convey meaning.

## Spacing Scale
- Use a consistent spacing scale throughout the UI.
- Prefer a 4-point or 8-point spacing system.
- Typical spacing tokens may include:
  - `space-1` = 4px
  - `space-2` = 8px
  - `space-3` = 12px
  - `space-4` = 16px
  - `space-5` = 20px
  - `space-6` = 24px
  - `space-8` = 32px
  - `space-10` = 40px
  - `space-12` = 48px
- Keep spacing relationships consistent between:
  - label and input
  - section heading and content
  - card header and body
  - table toolbar and table
- Use spacing to create hierarchy before adding borders or background fills.

## Layout Standards
- Use consistent container widths and page gutters.
- Align elements to a clear layout grid.
- Prefer predictable section structure:
  - page header
  - summary or actions
  - main content
  - secondary content if needed
- Avoid crowded layouts with weak alignment.
- Prefer whitespace and grouping over heavy borders everywhere.

## Typography Scale
- Use a defined typography scale instead of arbitrary font sizes.
- Suggested semantic text styles:
  - `display`
  - `h1`
  - `h2`
  - `h3`
  - `title`
  - `body`
  - `body-small`
  - `label`
  - `caption`
- Headings should clearly communicate hierarchy.
- Body text should prioritize readability over stylistic effect.
- Labels should remain legible and consistent across forms and controls.
- Use font weight intentionally. Do not rely on excessive bolding to create hierarchy.
- Limit the number of text styles used on one screen.

## Radius, Borders, and Shadows
- Use a small, consistent radius scale.
- Use borders and shadows intentionally, not simultaneously by default.
- Surfaces should be distinguishable without excessive decoration.
- In dark mode, rely on contrast and layering carefully instead of heavy shadow alone.
- Use stronger elevation only for overlays such as dialogs, popovers, and floating panels.

## Iconography
- Use a consistent icon set and visual weight.
- Icons should support comprehension, not replace labels unnecessarily.
- Avoid ambiguous icon-only actions unless the meaning is widely understood.
- Match icon size and alignment consistently across buttons, lists, and navigation.

## Component Consistency
- Similar components should behave and appear similarly across the product.
- Shared components should expose a small, predictable API.
- Avoid creating multiple variants that differ only slightly without a clear need.
- Standardize states across components:
  - default
  - hover
  - focus
  - active
  - disabled
  - loading
  - error
  - success where relevant

## Buttons
- Use a consistent button hierarchy:
  - primary
  - secondary
  - tertiary or ghost
  - destructive
- There should usually be one clear primary action per region.
- Avoid multiple competing primary buttons in the same view.
- Button labels should clearly describe the outcome.

## Inputs and Form Controls
- Inputs, selects, textareas, checkboxes, radios, and switches should share consistent styling and spacing.
- Labels should be persistent and clearly associated with controls.
- Help text and error text should appear in predictable locations.
- Required and optional patterns should be consistent across forms.
- Validation and disabled states should look consistent across all controls.

## Cards
- Use cards to group related content, actions, or summaries.
- Cards are appropriate when content needs clear containment or when repeating items benefit from consistent structure.
- Do not use cards when a simple list or table would be clearer.
- Cards should have a predictable internal structure such as:
  - header
  - optional metadata
  - body
  - optional actions
- Avoid deeply nested cards.

## Tables
- Use tables for dense, structured data where users need comparison or scanning across rows and columns.
- Prefer tables over cards when column alignment matters.
- Include clear column labels.
- Row actions should stay close to the row they affect.
- Large datasets should support filtering, sorting, and search when needed.
- Avoid squeezing too many low-value columns into one table.

## Tabs
- Use tabs for closely related peer views within the same context.
- Tabs should not hide critical information users need before acting.
- Keep the number of tabs manageable.
- Tab labels should be short and specific.
- Do not use tabs when a step-by-step flow, filter, or segmented control would be clearer.

## Drawers and Side Panels
- Use drawers for contextual detail, editing, or supporting workflows that should not fully interrupt the main page.
- Drawers work well for:
  - item detail review
  - lightweight editing
  - secondary actions
- Do not use drawers for highly complex, multi-step workflows when a full page would be clearer.
- Preserve context between the main surface and the drawer.

## Modals and Dialogs
- Use modals for focused tasks, confirmations, or short flows that require temporary interruption.
- Use them sparingly.
- Good modal use cases:
  - destructive confirmation
  - short form
  - focused decision
  - small contextual task
- Avoid large, scroll-heavy, multi-purpose modals.
- If the task is complex, use a dedicated page or drawer instead.
- Modal actions should be clear, limited, and appropriately prioritized.

## Popovers, Tooltips, and Menus
- Use popovers for lightweight contextual controls or information.
- Use tooltips only for supplemental clarification, not critical instructions.
- Menus should contain related actions, not mixed categories of behavior.
- Keep action naming consistent across menus and page-level buttons.

## Navigation Patterns
- Reuse navigation structures consistently across the app.
- Global navigation, local navigation, and in-page navigation should be visually distinct.
- Keep navigation labels user-centered and task-oriented.
- Avoid changing navigation behavior from screen to screen without a strong reason.

## Empty, Loading, and Error States
- Every reusable component pattern should define:
  - loading state
  - empty state
  - error state
  - disabled state if relevant
- These states should be designed, not treated as afterthoughts.
- Empty states should help users understand what to do next.
- Error states should explain what happened and how to recover.

## Responsive Behavior
- Components should adapt intentionally across breakpoints.
- Do not simply shrink desktop patterns onto mobile screens.
- Tables may need responsive alternatives, such as:
  - horizontal scroll
  - condensed columns
  - stacked views
- Drawers, modals, and navigation should remain usable on smaller screens.

## Motion and Feedback
- Use motion to support understanding, not decoration.
- Keep transitions subtle and fast.
- Motion should reinforce:
  - state change
  - hierarchy
  - continuity
- Avoid excessive animation that delays interaction or distracts from the task.

## Accessibility Requirements
- Shared components must be keyboard accessible.
- Focus states must be visible and consistent.
- Interactive target sizes must remain usable across device sizes.
- Components must use semantic roles and labels appropriately.
- Accessibility must hold across both light mode and dark mode.

## Component Selection Guidance
- Use a card when grouping related content in a flexible, scannable format.
- Use a table when structured comparison across rows and columns matters.
- Use tabs when switching between related peer sections in the same context.
- Use a drawer when the user should keep page context while viewing or editing something secondary.
- Use a modal only when the task deserves focused interruption.
- Use a full page when the content or workflow is too complex for a modal or drawer.

## Anti-Patterns to Avoid
- One-off component styling that breaks system consistency
- Hardcoded colors, font sizes, or spacing in component files
- Too many button variants with unclear purpose
- Cards used where tables should be used
- Tabs used to hide critical workflow steps
- Large complex workflows forced into modals
- Inconsistent form control states
- Decorative motion that adds no clarity
- Light mode support without dark mode support when theming is feasible