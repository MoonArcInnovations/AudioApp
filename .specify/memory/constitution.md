<!--
Sync Impact Report
- Version change: template -> 1.0.0
- Modified principles:
  - Added I. Clinical Safety First
  - Added II. Security, Privacy, and RBAC Are Non-Negotiable
  - Added III. Modular Monolith With Explicit Boundaries
  - Added IV. Offline-First, Sync-Safe Behavior
  - Added V. Testable Changes With Executable Specs
- Added sections:
  - Product Constraints
  - Delivery Workflow
  - Governance
- Removed sections:
  - Placeholder-only template guidance
- Templates requiring updates:
  - ✅ /Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/.specify/templates/spec-template.md
  - ✅ /Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/.specify/templates/plan-template.md
  - ✅ /Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/.specify/templates/tasks-template.md
- Follow-up TODOs:
  - Supply real QA Firebase credentials and platform config outside the constitution.
-->
# AudioApp Constitution

## Core Principles

### I. Clinical Safety First
Every feature MUST protect clinical correctness, patient safety, and clear role boundaries before convenience or speed. Screening behavior, diagnostic workflows, audiogram rendering, calibration logic, AI assistance, and report generation MUST remain medically credible and explicitly scoped. The app MUST never imply diagnostic certainty where the product is intended only for screening or assistive interpretation.

### II. Security, Privacy, and RBAC Are Non-Negotiable
Authentication, authorization, audit logging, consent handling, and PHI protection are first-class requirements. Protected routes and actions MUST enforce role-based access control for Patient, Audiologist, and Admin users. Sensitive data MUST only flow through approved infrastructure boundaries, and security-relevant failures MUST be surfaced clearly rather than silently ignored.

### III. Modular Monolith With Explicit Boundaries
The codebase MUST preserve the modular architecture already established: presentation, application/use-cases, domain entities/policies, and infrastructure adapters. New business logic MUST NOT be placed directly in screens. Presentation may depend on view models and use-cases; application may depend on domain contracts; infrastructure owns concrete Firebase, database, audio, printing, and platform integrations.

### IV. Offline-First, Sync-Safe Behavior
User-facing workflows MUST function safely with local persistence first, then synchronize through explicit sync infrastructure. Changes to patient data, test data, and reports MUST preserve consistency between local and cloud representations, including conflict handling and identifier remapping for offline-created records. No feature may regress safe offline operation without an explicit product decision.

### V. Testable Changes With Executable Specs
Every meaningful feature or remediation MUST be represented by a spec, implementation plan, and actionable task list before broad implementation. Automated tests are required for routing, auth, security-sensitive flows, and domain/application logic changes. A change is not complete until the relevant unit/widget/integration tests and a manual QA checklist are updated.

## Product Constraints

- Platform: Flutter mobile app with Android and iOS targets; web may exist for limited validation but mobile is primary.
- Architecture: Modular monolith client with Firebase-backed auth/cloud sync and local Drift/SQLite persistence.
- Primary roles: Patient, Audiologist, Super Admin.
- Domain-critical areas:
  - authentication and session restore
  - role-based navigation and route protection
  - patient screening flows
  - clinician AC/BC testing workflows
  - calibration
  - reporting and AI review
  - audit/compliance
- Regulatory direction:
  - support HIPAA-conscious handling of PHI
  - preserve auditable clinician decisions
  - maintain explicit distinction between screening, assistive AI, and diagnosis

## Delivery Workflow

1. Create or refine the feature spec in `specs/<feature>/spec.md`.
2. Write an implementation plan in `specs/<feature>/plan.md` that references real repository paths.
3. Generate or maintain task breakdown in `specs/<feature>/tasks.md`, grouped by independently testable user stories.
4. Implement in small slices that preserve architectural boundaries.
5. Run automated verification for affected areas.
6. Update manual QA guidance and acceptance evidence for risky flows.

Required quality gates for any feature touching auth, routing, PHI, reports, AI, or sync:

- explicit acceptance scenarios
- automated regression coverage
- manual QA steps on device when UI/mobile behavior is affected
- analyzer clean for touched scope

## Governance

This constitution supersedes ad hoc implementation shortcuts. When a proposed change conflicts with these principles, the spec and plan MUST document the exception, risk, and migration path. Architectural convenience does not override safety, RBAC, or auditability requirements. Amendments require updating this constitution, the affected spec artifacts, and any corresponding QA guidance.

**Version**: 1.0.0 | **Ratified**: 2026-03-29 | **Last Amended**: 2026-03-29
