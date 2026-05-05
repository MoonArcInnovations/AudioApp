# AudioApp UX Implementation Plan (All Roles)

## Objective
Create a clinically professional, low-error, fast workflow UX across Patient, Audiologist, and Admin roles with predictable navigation, clear primary actions, and accessible layouts on common Android phone sizes.

## Standards Baseline
- Material 3 navigation patterns and app bars: keep one primary navigation model per level; use top app bar back affordance for pushed screens.
- Android adaptive layout guidance: avoid rigid fixed-height stacks that fail on smaller viewports.
- Human Interface Guidelines (Apple): consistent hierarchy, clear primary actions, and predictable back behavior.
- WCAG 2.2 AA: target readable text, color contrast, and touch target reliability.
- Nielsen usability heuristics: visibility of system status, consistency, error prevention, user control and freedom.

## Current UX Gaps (Codebase)
- Inconsistent navigation semantics (`go` used for drill-down routes), removing back affordance in clinical flows.
- Fixed-height sections in critical test screens, causing overflow on smaller displays.
- Action density too high in one row for audiometry and bone-conduction controls.
- Mixed information hierarchy in role home tabs (headers, quick actions, and lists competing for attention).
- Error/empty/loading states not standardized across screens.

## UX Architecture (Role-Based)
### Patient
- Primary jobs: start AC screening, complete test, review latest status and history.
- Navigation model: tabbed home + push for test flow.
- Screen priorities:
  1. Start screening CTA as top primary action.
  2. Latest result summary card with explicit recommendation text.
  3. History list with quick filter (date/result).
- Interaction constraints:
  1. Single primary action per step.
  2. Fixed bottom action bar only where required.

### Audiologist
- Primary jobs: review AC reports, run AC/BC tests, compare outcomes, export reports.
- Navigation model: tabbed home (`Dashboard`, `Patients`, `Tests`, `More`) + push for workflows.
- Screen priorities:
  1. Tests tab: AC reports, BC imports, test history list.
  2. Test execution screens: status strip, chart, frequency, intensity, actions.
  3. Patient detail: latest outcomes, AI decision history, export controls.
- Interaction constraints:
  1. Prevent cramped control rows; split high-density controls across two rows.
  2. Ensure back navigation is always present on test/calibration/import detail screens.

### Admin
- Primary jobs: user management, audiologist verification, audit and governance.
- Navigation model: tabbed admin home + push into management pages.
- Screen priorities:
  1. Pending verification queue.
  2. User lifecycle actions with explicit state chips.
  3. Audit summary with filters.
- Interaction constraints:
  1. Destructive actions require confirmation.
  2. Keep management screens list-first and filter-first.

## Design System Rules (Implementation)
- Surfaces: light-only, warm clinical palette, strong text contrast.
- Typography: modern clean with role-consistent type scale.
- Spacing: 8px grid; minimum 16px screen horizontal padding.
- Components:
  1. Primary button full-width in action zones.
  2. Secondary/tertiary actions as outlined/text buttons.
  3. Cards for summaries; lists for records.
- States:
  1. Standardized loading skeleton or centered progress.
  2. Empty states with one clear CTA.
  3. Error states with retry action.

## Concrete Delivery Plan
### Phase 1: Navigation and Overflow Stability
- Convert drill-down `go` routes to `push` where back behavior is required.
- Remove rigid layout patterns in test/test-history screens.
- Apply bottom safe-area padding in action-heavy screens.
- Add overflow regression checklist for small-height devices.

### Phase 2: Role Home IA Cleanup
- Rebalance home tabs for each role around top user tasks.
- Reduce competing headers/actions.
- Standardize card/list rhythm and section spacing.

### Phase 3: Clinical Workflow Optimization
- Audiologist AC/BC test screens:
  1. Keep status row fixed at top.
  2. Make content scroll-safe.
  3. Keep primary action row reachable without clipping.
- Patient screening flow:
  1. One decision per step.
  2. Explicit progress and back affordance.

### Phase 4: Governance, Quality, and Accessibility
- Admin review flows with clear pending/verified/suspended states.
- Contrast and touch-target audit.
- Add snapshot/golden checks for critical screens.

## Acceptance Criteria
- No `RenderFlex overflow` on target devices (including compact Android displays).
- All drill-down screens show predictable back behavior.
- Primary action is visually obvious and never clipped.
- Empty/error/loading states are consistent across all 3 roles.
- Core role tasks complete in <= 3 taps from role home.

## Source References
- Material Design 3 navigation: https://m3.material.io/components/navigation-bar/overview
- Android navigation best practices: https://developer.android.com/develop/ui/views/components/appbar/back-action
- Android adaptive layouts: https://developer.android.com/develop/ui/views/layout/responsive-adaptive-design-with-views
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines
- WCAG 2.2 overview: https://www.w3.org/WAI/standards-guidelines/wcag/
- Nielsen usability heuristics: https://www.nngroup.com/articles/ten-usability-heuristics/
