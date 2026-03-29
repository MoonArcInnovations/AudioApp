# Findings Remediation Spec Kit

## Purpose

This spec kit converts the initial navigation/auth QA findings into an implementation-ready remediation plan with:

- required product behavior
- code-level change areas
- test coverage requirements
- manual QA checks
- acceptance criteria

Primary references:

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/techspec.md`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/04-technical/feature-spec.md`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/06-qa/initial_navigation_auth_test_kit.md`

## Findings To Fix

1. Firebase configuration is placeholder-based
2. Route authorization is authentication-only, not role-based
3. Audiologist registration bypasses verification hold
4. Forgot password flow is not implemented
5. Demo login copy is stale and misleading
6. Firebase bootstrap failures are swallowed instead of surfaced clearly

## Implementation Status

Implemented in the current remediation slice:

- structured bootstrap result and visible startup error UI
- role-aware and verification-aware route redirects
- audiologist `verificationState` persisted in Firebase-backed auth profile
- pending approval screen and route
- admin verification sync back to Firebase user access profile
- password reset repository/use-case plumbing and login dialog flow
- automated tests for auth state, route guards, bootstrap UI, reset UI, and reset failure handling

Still pending outside code:

- real QA Firebase options and matching platform files
- manual device regression after environment confirmation

## Target Behavior

### Auth

- Login uses Firebase Auth with real environment configuration
- Register creates Firebase Auth user plus Firestore user profile
- Patient registration grants immediate access to patient surfaces
- Audiologist registration creates a pending account state
- Pending audiologists must not access clinician workflows until approved
- Super admin access must only be available to explicit admin users
- Password reset must be available from login

### Navigation / RBAC

- Unauthenticated users can access only splash, login, and register
- Patient users can access only patient/common routes
- Audiologist users can access only audiologist/common routes
- Admin users can access only admin/common routes
- Unauthorized route access must redirect to the correct home screen or a safe fallback

### Startup / Reliability

- If Firebase is not configured or initialization fails, the app must surface a clear startup/auth configuration error
- Auth-related failures must be diagnosable in QA without reading logs only

## Remediation Workstreams

## 1. Firebase Configuration Hardening

### Goal

Replace placeholder config with real environment-safe configuration and make startup failure visible.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/firebase_options.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/app/bootstrap/app_bootstrap.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/main.dart`

### Required Changes

- Replace placeholder Firebase options with real generated config
- Add explicit bootstrap result state for Firebase init success/failure
- Distinguish:
  - local service init failure
  - Firebase init failure
  - partial init mode if allowed
- Show actionable UI if Firebase auth is unavailable

### Acceptance Criteria

- App startup clearly indicates when Firebase is misconfigured
- Login/register are disabled or error explicitly when Firebase is unavailable
- QA can tell configuration failure from bad credentials
- Status: code implemented, environment verification still pending

### Automated Tests

- bootstrap success state test
- bootstrap Firebase failure state test
- initialization error UI test

## 2. Role-Based Route Authorization

### Goal

Enforce route access by role, not just auth state.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/core/router/app_router.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/test/navigation_spec_test.dart`

### Required Changes

- Add route classification:
  - public routes
  - patient routes
  - audiologist routes
  - admin routes
  - shared authenticated routes
- Add role guard helper:
  - `canAccessRoute(role, location)`
- Update redirect logic to:
  - keep public routes public
  - redirect wrong-role access to role home
  - prevent admin route access by patient/audiologist
  - prevent clinician route access by patient/admin unless explicitly shared

### Acceptance Criteria

- Patient cannot access `/audiologist/*` or `/admin/*`
- Audiologist cannot access `/admin/*`
- Admin cannot access role-only patient/clinician routes unless explicitly intended
- Direct URL navigation and in-app navigation follow the same rules
- Status: implemented with automated route-guard coverage

### Automated Tests

- patient blocked from audiologist routes
- patient blocked from admin routes
- audiologist blocked from admin routes
- admin blocked from clinician-only workflow routes if not permitted
- shared routes remain accessible after login

## 3. Audiologist Verification Gate

### Goal

Align clinician signup with the admin verification model.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/register_screen.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/domain/entities/app_user.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/services/firebase/firebase_auth_service.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/admin/infrastructure/repositories/local_admin_user_repository.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/core/router/app_router.dart`

### Required Changes

- Extend auth user profile with verification status
  - `pending`
  - `verified`
  - `rejected` or `suspended` if needed
- On audiologist registration:
  - create account
  - persist role as `audiologist`
  - persist verification status as `pending`
  - route to a pending approval screen, not clinician dashboard
- Add pending approval screen
- Update router guard to block clinician routes for unverified audiologists
- Ensure admin verification action changes this state

### Acceptance Criteria

- Newly registered audiologist cannot access clinician home until verified
- Verified audiologist can access clinician routes
- Pending audiologist sees a clear waiting state
- Admin verification unblocks access on next app refresh/session restore
- Status: implemented in code; live Firebase/device confirmation still required

### Automated Tests

- register audiologist results in pending state
- pending audiologist redirect test
- verified audiologist access test

## 4. Password Reset Flow

### Goal

Implement a functional recovery flow from login.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/login_screen.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/services/firebase/firebase_auth_service.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/domain/repositories/auth_repository.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/modules/auth/infrastructure/repositories/firebase_auth_repository.dart`

### Required Changes

- Add repository contract for password reset
- Add use case for password reset
- Wire login screen CTA to:
  - open dialog or screen
  - validate email
  - submit reset request
  - show success/error feedback

### Acceptance Criteria

- User can request reset from login screen
- Invalid email is blocked
- Success message is visible after request
- Firebase errors are translated to usable UI feedback
- Status: implemented in code with widget and controller coverage for invalid, success, and failure paths

### Automated Tests

- password reset validation test
- successful reset action test
- Firebase error mapping test
- login screen does not render stale demo messaging

## 5. Login Screen Messaging Cleanup

### Goal

Remove stale demo-era language now that real Firebase auth is the source of truth.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/features/auth/presentation/screens/login_screen.dart`

### Required Changes

- Remove demo login helper block or replace with environment-aware QA guidance
- If a QA mode is needed, gate it behind:
  - explicit debug-only config
  - clear non-production messaging

### Acceptance Criteria

- Production login screen does not advertise fake credentials
- QA users are not misled about authentication behavior
- Status: implemented

### Automated Tests

- login screen does not render demo login helper in normal mode

## Residual Risks and Environment Notes

- `flutter test` passes locally, but the first load phase is still slower than expected on this macOS machine
- `xcrun xcodebuild -version` currently fails because Xcode command-line developer tools are not installed, which likely contributes to the delayed Flutter startup probing
- Real Firebase QA configuration and live device regression are still required before this feature can be closed end to end

## 6. Startup Error Surfacing

### Goal

Make init/auth failures easier to diagnose during QA and production support.

### Files

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/app/bootstrap/app_bootstrap.dart`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/main.dart`

### Required Changes

- Return structured bootstrap result instead of swallowing errors
- Expose:
  - `firebaseReady`
  - `localServicesReady`
  - `errorMessage`
- Render distinct startup failure states

### Acceptance Criteria

- Missing Firebase config produces visible startup/auth warning
- QA can distinguish init failures from navigation bugs
- Status: implemented with bootstrap UI coverage

## Test Matrix

### Automated

- `navigation_spec_test.dart`
  - expand to include role guards
- `auth_controller_test.dart`
  - expand to include pending verification logic
- new password reset tests
- startup/bootstrap tests
- status: analyzer clean, focused Flutter tests passing locally after verbose run

### Manual Device QA

#### Public/Auth

- splash -> login
- register patient -> patient home
- register audiologist -> pending approval screen
- forgot password -> request flow
- wrong credentials -> error

#### Role Access

- patient deep-link to audiologist/admin routes
- audiologist deep-link to admin routes
- pending audiologist deep-link to clinician routes

#### Session Restore

- logged-in patient restart -> patient home
- verified audiologist restart -> clinician home
- pending audiologist restart -> pending approval screen

#### Admin Verification

- approve pending audiologist
- restart app as that user
- verify clinician access opens

## Recommended Delivery Order

1. Firebase config hardening
2. Role-based router guard
3. Audiologist verification gate
4. Password reset flow
5. Login messaging cleanup
6. Startup error surfacing polish
7. Expand automated tests
8. Manual regression on Android phone

## Definition Of Done

- Real Firebase config is in place for the test environment
- Role-based route authorization is enforced
- Audiologist registration is gated by verification
- Password reset works from login
- Startup failures are clearly surfaced
- Demo login messaging is removed or debug-gated
- Automated tests cover public/auth/role guard core flows
- Manual smoke pass on device is complete

Current status:

- code-side remediation is substantially complete
- environment setup and final device smoke pass remain the last gating items

## Immediate Next Implementation Ticket Set

### Ticket 1

Implement role-based route guard in `/audioapp/lib/core/router/app_router.dart`

### Ticket 2

Add verification status to auth user model and Firebase user document

### Ticket 3

Create pending-audiologist holding screen and route behavior

### Ticket 4

Implement password reset end-to-end

### Ticket 5

Replace placeholder Firebase config for the QA environment
