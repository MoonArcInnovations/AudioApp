# Data Model: Auth and Routing Remediation

## AuthenticatedUser

**Purpose**: Represents the signed-in app user used by routing, session restore, and shared authenticated screens.

**Fields**:
- `id`: stable user identifier
- `email`: sign-in email
- `name`: display name
- `role`: one of `patient`, `audiologist`, `admin`
- `phoneNumber`: optional profile field
- `verificationState`: one of `not_required`, `pending`, `verified`, `rejected`
- `createdAt`: account creation timestamp

**Validation rules**:
- `email` must be non-empty and valid for auth actions
- `role` must be one of the supported role values
- `verificationState` must be explicit for audiologists

## VerificationState

**Purpose**: Governs whether an audiologist can access clinician workflows.

**States**:
- `not_required`: patient/admin or any role that does not require approval
- `pending`: registration complete but clinician access blocked
- `verified`: clinician access allowed
- `rejected`: account exists but clinician access remains blocked

**Transitions**:
- `pending -> verified` by admin approval
- `pending -> rejected` by admin rejection
- `verified -> rejected` or `verified -> pending` only through explicit governance action if later needed

## ProtectedRoute

**Purpose**: Defines access requirements for a route.

**Fields**:
- `path`
- `accessLevel`: `public`, `authenticated`, `patientOnly`, `audiologistOnly`, `adminOnly`
- `pendingAudiologistAllowed`: boolean

**Validation rules**:
- Every non-public route must define its access level explicitly
- Shared authenticated routes must not implicitly grant privileged clinician/admin access

## BootstrapStatus

**Purpose**: Represents startup readiness and actionable failure state.

**Fields**:
- `state`: `ready`, `loading`, `failed`
- `message`: user-facing startup error summary
- `technicalHint`: optional QA-facing detail

**Validation rules**:
- `failed` must include a visible message
- `ready` must only be emitted after required startup services are initialized

## PasswordResetRequest

**Purpose**: Encapsulates a password reset action from the login flow.

**Fields**:
- `email`

**Validation rules**:
- `email` must be syntactically valid before submit
