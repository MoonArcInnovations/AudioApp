# Feature Specification: Auth and Routing Remediation

**Feature Branch**: `[001-auth-and-routing-remediation]`  
**Created**: 2026-03-29  
**Status**: Draft  
**Input**: User description: "Implement the initial findings remediation so auth, routing, verification, and startup behavior match project requirements and are usable through Spec Kit."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Safe Auth Entry and Session Restore (Priority: P1)

As a user, I need login, registration, session restore, and startup behavior to work predictably so I can enter the correct role-specific workspace without ambiguous auth failures.

**Why this priority**: Authentication and startup are the entry gate to every other workflow. If they are unreliable or misleading, the rest of the product cannot be validated safely.

**Independent Test**: Can be tested by launching the app, signing in or registering, restarting the app, and verifying that startup and session behavior is explicit and deterministic.

**Acceptance Scenarios**:

1. **Given** Firebase is correctly configured and a valid patient account exists, **When** the user signs in, **Then** the app authenticates successfully and routes to the patient home screen.
2. **Given** Firebase is not configured or initialization fails, **When** the app starts or the user attempts auth, **Then** the app surfaces a clear configuration/auth availability error instead of failing silently.
3. **Given** a valid authenticated session exists, **When** the app restarts, **Then** the session is restored and the user lands in the correct role-appropriate home or holding screen.

---

### User Story 2 - Enforced Role-Based Access Control in Navigation (Priority: P1)

As a patient, audiologist, or admin, I need route access restricted to my authorized surfaces so that the app enforces role boundaries instead of only checking whether I am logged in.

**Why this priority**: This is a direct security and product-integrity requirement. It protects privileged clinician/admin surfaces from unauthorized users.

**Independent Test**: Can be fully tested by attempting direct route access and in-app navigation as each role and confirming redirection to the correct home or safe destination.

**Acceptance Scenarios**:

1. **Given** a patient is authenticated, **When** they attempt to access an audiologist or admin route, **Then** the app redirects them to the patient home screen.
2. **Given** an audiologist is authenticated, **When** they attempt to access an admin-only route, **Then** the app redirects them to the audiologist home screen.
3. **Given** an unauthenticated user, **When** they attempt to access any protected route, **Then** the app redirects them to login.

---

### User Story 3 - Audiologist Verification Gate (Priority: P1)

As a newly registered audiologist, I need a pending verification state so that clinician access is granted only after administrative approval.

**Why this priority**: The product already includes admin verification concepts; direct clinician access on registration creates a governance and access-control gap.

**Independent Test**: Can be tested independently by registering an audiologist, verifying pending-state routing, then changing verification state and confirming clinician access is granted.

**Acceptance Scenarios**:

1. **Given** a new audiologist registers, **When** account creation completes, **Then** the user is routed to a pending approval screen instead of clinician home.
2. **Given** an audiologist remains pending, **When** they attempt clinician routes, **Then** access is blocked and the app redirects to the pending approval screen.
3. **Given** an admin verifies an audiologist account, **When** the audiologist next restores session or signs in, **Then** the clinician home becomes accessible.

---

### User Story 4 - Functional Password Recovery and Honest Auth UX (Priority: P2)

As a user, I need working password reset and non-misleading login messaging so that I can recover access and understand the actual auth behavior.

**Why this priority**: Recovery is essential for production auth flows, and stale demo messaging undermines QA confidence and user trust.

**Independent Test**: Can be tested by opening password reset from login, validating email input, submitting a reset request, and confirming the login UI no longer presents fake/demo credentials in normal mode.

**Acceptance Scenarios**:

1. **Given** a user on the login screen, **When** they choose forgot password and enter a valid email, **Then** the app submits a password reset request and shows success feedback.
2. **Given** a user enters an invalid reset email, **When** they submit the reset request, **Then** the app shows validation or service error feedback.
3. **Given** the app is running in normal QA/production auth mode, **When** the login screen is displayed, **Then** stale demo login hints are not shown.

## Edge Cases

- What happens when Firebase initializes partially but Firestore user profile lookup fails after successful auth?
- How does the app handle a user document with an unknown or missing role?
- What happens when a pending audiologist is verified while their local session is still active?
- How does the system respond when password reset is requested for an email with no matching account?
- How does the router behave for shared screens like profile and settings when role data is temporarily unavailable during session restore?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST authenticate users using Firebase Auth backed by real, non-placeholder Firebase project configuration in the target QA environment.
- **FR-002**: The system MUST persist and read a Firestore user document containing role and verification state for authenticated users.
- **FR-003**: The system MUST restrict route access by both authentication state and user role.
- **FR-004**: The system MUST block patient access to audiologist and admin-only routes.
- **FR-005**: The system MUST block audiologist access to admin-only routes.
- **FR-006**: The system MUST route newly registered patient users directly to patient home after successful registration.
- **FR-007**: The system MUST route newly registered audiologist users to a pending verification holding state until verification is granted.
- **FR-008**: The system MUST block pending audiologists from clinician workflows.
- **FR-009**: The system MUST provide a forgot-password flow from the login screen using Firebase password reset.
- **FR-010**: The system MUST surface startup/auth configuration failures clearly to the user instead of only logging them.
- **FR-011**: The system MUST restore the correct post-login destination on app restart based on role and verification state.
- **FR-012**: The normal login screen MUST NOT advertise obsolete demo credentials once Firebase-backed auth is the active path.

### Key Entities *(include if feature involves data)*

- **Authenticated User**: The signed-in application user, including `id`, `email`, `name`, `role`, `createdAt`, and profile metadata.
- **Verification State**: The clinician approval status associated with an audiologist account, such as `pending`, `verified`, or other explicit governance states.
- **Protected Route**: A route classified by required access level: public, shared-authenticated, patient-only, audiologist-only, or admin-only.
- **Bootstrap Status**: Startup state that captures Firebase readiness, local services readiness, and actionable initialization errors.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of automated navigation guard tests pass for unauthenticated, patient, audiologist, and admin route access scenarios.
- **SC-002**: 100% of automated auth-state tests pass for sign-in, registration, sign-out, and session restore behavior.
- **SC-003**: A newly registered audiologist is unable to access clinician routes prior to verification in all tested route-entry paths.
- **SC-004**: QA testers can distinguish invalid credentials from Firebase configuration failure within one visible screen interaction, without needing to inspect logs.
- **SC-005**: Password reset can be completed from the login flow with valid feedback for both success and failure states.

## Assumptions

- Real Firebase credentials for the QA environment will be supplied outside this spec or during implementation.
- The existing Admin module remains the authority for approving audiologists.
- The app will continue using Flutter, Riverpod, GoRouter, Firebase Auth, Firestore, and Drift as the current architecture baseline.
- Shared routes like profile and settings remain authenticated routes accessible across roles unless later re-scoped.
