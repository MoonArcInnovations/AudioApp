# Quickstart: Auth and Routing Remediation

## Goal

Validate that Firebase-backed auth, role routing, audiologist verification, and password reset behave safely on the mobile app.

## Prerequisites

- Real QA Firebase configuration is installed in `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp/lib/firebase_options.dart`
- Matching Android and iOS Firebase platform files are present
- Firebase Auth email/password provider is enabled
- Test users exist for:
  - patient
  - verified audiologist
  - admin
- At least one pending audiologist account exists, or can be created during test

## Automated Verification

From `/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/audioapp`:

```bash
dart analyze lib
flutter test
```

## Manual QA Flow

### 1. Startup and login

1. Launch the app on device.
2. Confirm startup completes without a silent failure.
3. If Firebase is intentionally misconfigured, confirm the app shows an actionable startup or auth error.
4. Sign in as a patient and confirm patient home opens.

### 2. Session restore

1. While still signed in, fully close the app.
2. Reopen the app.
3. Confirm the session restores and returns to the correct role surface.

### 3. Role-based routing

1. As a patient, attempt to reach audiologist/admin surfaces through navigation or direct route entry.
2. Confirm the app redirects safely to patient home.
3. Repeat as an audiologist against admin-only routes.

### 4. Audiologist verification

1. Register a new audiologist account.
2. Confirm registration finishes in a pending approval screen, not clinician home.
3. Attempt clinician routes and confirm they remain blocked.
4. Approve the audiologist from the admin flow.
5. Reopen or refresh the session and confirm clinician home is now accessible.

### 5. Password reset

1. From login, tap forgot password.
2. Submit a valid email and confirm success feedback.
3. Submit an invalid or malformed email and confirm visible validation or service feedback.

## Expected Outcome

- Auth failures are visible and actionable
- Role-based routing cannot be bypassed
- Pending audiologists cannot reach clinician workflows
- Verified audiologists can reach clinician workflows
- Password reset is functional and honest to the real auth system
