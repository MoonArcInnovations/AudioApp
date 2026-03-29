# Tasks: Auth and Routing Remediation

**Input**: Design documents from `/specs/001-auth-and-routing-remediation/`
**Prerequisites**: plan.md, spec.md

**Tests**: Routing, auth-state, and widget tests are required for this feature because it affects security-sensitive entry flows.

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Create feature working branch `001-auth-and-routing-remediation`
- [ ] T002 Review and replace placeholder QA Firebase configuration in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/firebase_options.dart`
- [ ] T003 [P] Confirm Android/iOS QA environment has matching Firebase platform files and auth providers enabled

---

## Phase 2: Foundational (Blocking Prerequisites)

- [x] T004 Implement explicit bootstrap result/error state in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/app/bootstrap/app_bootstrap.dart`
- [x] T005 Update `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/main.dart` to render actionable startup/auth configuration failure UI
- [x] T006 [P] Extend audiologist verification state mapping in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/domain/entities/app_user.dart` and `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/services/firebase/firebase_auth_service.dart`
- [x] T007 [P] Add password reset repository and use-case support in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/`

**Checkpoint**: Foundation ready for user-story work

---

## Phase 3: User Story 1 - Safe Auth Entry and Session Restore (Priority: P1) 🎯 MVP

**Goal**: Login, registration, startup, and session restore behave deterministically and surface configuration/auth failures clearly.

**Independent Test**: Launch the app, perform patient sign-in/register, restart the app, and verify startup or auth errors are visible and the session restores correctly.

### Tests for User Story 1

- [x] T008 [P] [US1] Add bootstrap/auth-state tests covering startup success and startup failure in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/widget_test.dart`
- [x] T009 [P] [US1] Extend `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/auth_controller_test.dart` with session restore and startup-state expectations

### Implementation for User Story 1

- [x] T010 [US1] Wire startup/auth configuration errors into visible UI in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/main.dart`
- [x] T011 [US1] Ensure session restore in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/presentation/controllers/auth_controller.dart` respects verification state and startup readiness
- [x] T012 [US1] Remove silent Firebase-init-only failure behavior from `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/app/bootstrap/app_bootstrap.dart`

---

## Phase 4: User Story 2 - Enforced Role-Based Access Control in Navigation (Priority: P1)

**Goal**: Route access is enforced by role and auth state.

**Independent Test**: Attempt direct navigation to patient, audiologist, and admin routes as each role and verify redirection behavior.

### Tests for User Story 2

- [x] T013 [P] [US2] Expand `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/navigation_spec_test.dart` with patient, audiologist, admin, and unauthenticated route guard cases

### Implementation for User Story 2

- [x] T014 [US2] Add route classification and access helpers in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/core/router/app_router.dart`
- [x] T015 [US2] Enforce wrong-role redirects in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/core/router/app_router.dart`
- [x] T016 [US2] Add shared authenticated route handling for profile/settings while blocking role-only surfaces

---

## Phase 5: User Story 3 - Audiologist Verification Gate (Priority: P1)

**Goal**: New audiologists remain pending until admin verification grants clinician access.

**Independent Test**: Register an audiologist, verify pending state, block clinician routes, then approve and confirm access.

### Tests for User Story 3

- [x] T017 [P] [US3] Extend `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/auth_controller_test.dart` with pending vs verified audiologist auth-state scenarios
- [x] T018 [P] [US3] Extend `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/navigation_spec_test.dart` with pending-audiologist redirect cases

### Implementation for User Story 3

- [x] T019 [US3] Persist verification state for audiologist users in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/services/firebase/firebase_auth_service.dart`
- [x] T020 [US3] Update registration logic in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/register_screen.dart` so audiologists enter pending state
- [x] T021 [US3] Add a pending approval screen and routing in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/shared_profile_settings/presentation/screens/` or `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/`
- [x] T022 [US3] Update admin verification persistence and action flow in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/admin/` and `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/services/firebase/firebase_auth_service.dart`

---

## Phase 6: User Story 4 - Functional Password Recovery and Honest Auth UX (Priority: P2)

**Goal**: Password reset works and login messaging accurately reflects the live auth system.

**Independent Test**: Trigger reset flow from login, validate form behavior, verify success/error feedback, and confirm stale demo hints are gone.

### Tests for User Story 4

- [x] T023 [P] [US4] Add password reset action tests in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/auth_controller_test.dart` or a dedicated auth UI test
- [x] T024 [P] [US4] Update `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/widget_test.dart` or add a dedicated login widget test for reset CTA and non-demo messaging

### Implementation for User Story 4

- [x] T025 [US4] Add password reset repository/use-case plumbing in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/`
- [x] T026 [US4] Implement forgot-password dialog or screen in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/login_screen.dart`
- [x] T027 [US4] Remove or debug-gate stale demo login helper content in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/login_screen.dart`

---

## Phase 7: Polish & Cross-Cutting Concerns

- [x] T028 [P] Update `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/06-qa/initial_navigation_auth_test_kit.md` with post-fix validation steps
- [x] T029 [P] Update `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/06-qa/findings_remediation_spec_kit.md` with implemented behavior and residual risks
- [x] T030 Run `dart analyze audioapp/lib`
- [x] T031 Run `flutter test`
- [ ] T032 Perform manual device regression on the connected Android phone for auth, role navigation, and approval gating

## Dependencies & Execution Order

### Phase Dependencies

- Setup must complete first
- Foundational work blocks all user stories
- User Stories 1, 2, and 3 should be completed before broader product QA because they protect auth and role boundaries
- User Story 4 can proceed after foundational auth plumbing is in place

### Parallel Opportunities

- T003 can run in parallel with T002
- T006 and T007 can run in parallel
- T008 and T009 can run in parallel
- T013, T017, and T018 can run in parallel once route/auth contracts are defined
- T028 and T029 can run in parallel after implementation stabilizes

## Implementation Strategy

### MVP First

1. Replace QA Firebase config
2. Surface startup failure clearly
3. Enforce route RBAC
4. Gate audiologist access by verification state
5. Run automated tests and manual login/navigation smoke pass

### Incremental Delivery

1. Safe startup and login behavior
2. Secure role-based routing
3. Audiologist pending approval workflow
4. Password recovery and auth UX cleanup
