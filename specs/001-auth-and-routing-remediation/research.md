# Research: Auth and Routing Remediation

## Decision 1: Keep Firebase Auth as the source of authentication and Firestore user documents as the source of role/verification state

**Rationale**: The project already uses Firebase-backed auth and a modular auth boundary. Keeping authentication in Firebase Auth while storing role and verification state in Firestore matches the current architecture and avoids introducing a second identity source.

**Alternatives considered**:
- Store role and verification state only in local storage: rejected because it cannot support secure admin approval or cross-device session restore.
- Move identity to a custom backend immediately: rejected because it adds migration complexity before the current auth/routing findings are fixed.

## Decision 2: Enforce route access in `GoRouter` using both auth state and role/verification state

**Rationale**: Route protection is currently the highest-risk gap. Centralizing access decisions in the router provides consistent protection for direct route entry and in-app navigation.

**Alternatives considered**:
- Guard screens individually: rejected because it duplicates logic and is easier to bypass or drift.
- Hide navigation only: rejected because it does not protect deep links or manual route entry.

## Decision 3: Treat pending audiologists as authenticated but restricted users

**Rationale**: A pending audiologist should have a valid account and session, but must not reach clinician workflows before approval. A dedicated holding screen makes this state explicit and supports later admin approval without account recreation.

**Alternatives considered**:
- Block audiologist account creation until admin pre-approval: rejected because the existing product already models post-registration verification.
- Route pending audiologists to login with a generic error: rejected because it is confusing and hides the real governance state.

## Decision 4: Surface bootstrap and auth configuration failures in the app shell

**Rationale**: Silent initialization failure makes QA and user diagnosis unnecessarily hard. A visible startup failure state in the shell makes configuration issues actionable.

**Alternatives considered**:
- Log-only startup errors: rejected because the current findings show this is insufficient.
- Surface failures only during auth actions: rejected because Firebase/bootstrap problems can exist before any user interaction.

## Decision 5: Provide password reset through the auth module and Firebase reset email

**Rationale**: Password recovery belongs to the auth boundary and should use the same backend as sign-in. This keeps screens thin and preserves a single auth source.

**Alternatives considered**:
- Keep forgot-password as a placeholder CTA: rejected because it leaves a production auth gap.
- Implement reset only in UI without repository/use-case support: rejected because it breaks the modular architecture.
