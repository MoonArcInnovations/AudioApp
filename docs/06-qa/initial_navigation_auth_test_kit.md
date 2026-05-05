# Initial Navigation and Auth Test Kit

## Scope

This kit covers the first-pass smoke test areas for:

- App bootstrap and launch
- Authentication wiring
- Role-based entry routing
- Login and registration flows
- Manual navigation checks across Patient, Audiologist, and Admin surfaces

Primary spec sources:

- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/techspec.md`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/04-technical/feature-spec.md`
- `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/docs/04-technical/architecture.md`

## Automated Coverage Added

- `audioapp/test/navigation_spec_test.dart`
  - splash route is allowed
  - unauthenticated users are redirected to login for protected routes
  - login/register remain reachable when unauthenticated
  - authenticated users are redirected away from auth pages to their role home
  - patient users are blocked from audiologist routes
  - verified audiologists are blocked from admin routes
  - pending audiologists are redirected to pending approval
  - shared authenticated routes remain reachable

- `audioapp/test/auth_controller_test.dart`
  - session restore behavior
  - sign-in state transition
  - register state transition
  - audiologist registration creates pending approval state
  - sign-out state reset
  - restore failure is surfaced
  - password reset action succeeds through the auth controller
  - password reset failure is surfaced through the auth controller

- `audioapp/test/widget_test.dart`
  - startup failure UI is rendered when bootstrap fails
  - router content is rendered when bootstrap succeeds
  - login screen primary content is present
  - login screen no longer renders demo login copy
  - forgot-password dialog validates invalid email
  - forgot-password dialog submits reset requests successfully
  - forgot-password dialog surfaces reset request failures

## Manual Phone Test Checklist

### 1. Launch and bootstrap

- Launch the app from the installed Android package
- Confirm splash screen appears
- Confirm app transitions to login without crash

### 2. Login flow

- Try empty email/password
  - Expected: validation errors
- Try invalid email format
  - Expected: email validation message
- Try valid credentials for an existing account
  - Expected: sign-in succeeds and routes to role home
- Try wrong password
  - Expected: error message is shown

### 3. Registration flow

- Open register from login
- Verify role picker is available
- Register as patient
  - Expected: account creation and patient home routing
- Register as audiologist
  - Expected: account creation and pending approval routing
- Try mismatched passwords
  - Expected: validation error

### 4. Role navigation smoke checks

- Patient
  - Home opens
  - History opens
  - Profile opens
- Audiologist
  - Dashboard opens
  - Patients list opens
  - Testing workspace opens
  - Calibration opens
- Admin
  - Dashboard opens
  - Users opens
  - Verification opens

### 5. Deep-link / route protection checks

Try to navigate directly to routes for another role after logging in:

- Patient user tries `/audiologist`
- Patient user tries `/admin`
- Audiologist user tries `/admin`

Expected by spec and security intent:

- Access should be blocked or redirected

Current implementation risk:

- Authenticated users are checked only for login state, not role authorization

### 6. Firebase-backed auth checks

- Confirm login/register uses Firebase Auth
- Confirm user document is created in Firestore `users`
- Confirm Firestore `role` field matches selected role
- Confirm Firestore `verificationState` is `pending` for new audiologists
- Confirm app restores session after restart

## Current Status After Remediation Slice

Resolved in code:

- role-based route authorization is enforced for patient, audiologist, admin, and shared authenticated routes
- audiologist signup is routed to a pending approval state
- forgot-password flow is wired through the auth module and login UI
- stale demo login messaging is removed
- bootstrap failures are surfaced with actionable startup UI

Still open:

- real QA Firebase credentials and platform config must still be supplied in the environment
- full device regression should still be completed after the environment is confirmed

## Recommended Next QA Pass

1. Supply real QA Firebase config and verify startup on device
2. Confirm patient, verified audiologist, and admin login against live Firebase
3. Verify pending audiologist flow end to end, including admin approval
4. Run the full automated suite after the local Flutter test harness is confirmed in this environment

## Local Flutter Test Diagnosis

- `flutter test` now passes locally
- The runner spends a noticeable amount of time in the initial `loading` phase before test execution begins
- On this machine, `xcrun xcodebuild -version` fails because `xcodebuild` is not installed, which contributes to slower Flutter toolchain startup on macOS
- This is currently a local environment performance issue, not an active failing test issue
