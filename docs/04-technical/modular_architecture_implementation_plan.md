# Modular Architecture Implementation Plan

## Objective

Migrate `AudioApp` from a screen-centric Flutter app into a modular, domain-first architecture that is:

- Scalable
- Maintainable
- Secure
- Offline-first
- Safe to migrate incrementally without a rewrite

The target state is a modular monolith on the client with strict boundaries:

- `app`: bootstrap, dependency wiring, router, shell
- `modules/*`: bounded contexts with `presentation`, `application`, `domain`, `infrastructure`
- `platform`: external systems and adapters
- `core`: shared primitives only

## Current State Summary

The current codebase already has useful separation by role and service type, but key workflow logic is still spread across:

- screens
- state notifiers
- repositories
- service classes

This makes the app harder to scale as the product grows in:

- patient screening
- clinician testing
- AC/BC linkage
- AI review lifecycle
- calibration profiles
- reporting
- audit and compliance

## Migration Principles

1. No rewrite.
2. Keep current UI behavior stable during migration.
3. Extract workflows before moving files.
4. Move business rules into domain/application layers.
5. Hide infrastructure behind interfaces.
6. Centralize security and audit policy.
7. Migrate one vertical slice at a time.

## Target Module Layout

```text
lib/
  app/
    bootstrap/
    dependencies/
    shell/

  core/
    application/
    constants/
    domain/
    presentation/
    theme/

  modules/
    auth/
      application/
      domain/
      infrastructure/
      presentation/
    patient_screening/
      application/
      domain/
      infrastructure/
      presentation/
    clinician_testing/
      application/
      domain/
      infrastructure/
      presentation/
    reporting/
      application/
      domain/
      infrastructure/
      presentation/
    admin/
      application/
      domain/
      infrastructure/
      presentation/
    shared_profile_settings/
      application/
      domain/
      infrastructure/
      presentation/

  platform/
    audio/
    database/
    firebase/
    security/
    storage/
```

## Workstreams

### 1. App Shell

Scope:

- startup bootstrap
- router
- dependency composition
- session state
- feature flags

Tasks:

- extract startup logic from `main.dart`
- centralize bootstrapping into `lib/app/bootstrap`
- keep `GoRouter` as the entry router, but make it depend on module state instead of feature-local implementation details

Deliverable:

- stable application bootstrap layer used by all modules

### 2. Auth Module

Scope:

- sign in
- registration
- sign out
- role-based routing state

Tasks:

- create `domain` entity for authenticated user
- create `AuthRepository` contract
- move auth workflow into use-cases
- replace legacy `auth_provider.dart` implementation with compatibility export over the new module controller

Deliverable:

- auth screens keep working while auth logic is migrated behind module boundaries

### 3. Patient Screening Module

Scope:

- screening onboarding and save flow
- result classification
- history and latest result reads

Tasks:

- create `PatientScreeningRepository` contract
- extract screening outcome analysis into a domain service
- move history/latest/save access into use-cases
- convert current `data/repositories/screening_repository.dart` into a compatibility facade backed by the new module

Deliverable:

- patient screening persistence and classification moved out of the legacy repository implementation

### 4. Clinician Testing Module

Scope:

- patient list workflows
- AC testing
- BC testing
- calibration
- BC import

Tasks:

- extract test session orchestration from screens
- create test session use-cases
- separate pure domain logic from UI state
- define infrastructure adapters for audio and imports

Deliverable:

- testing screens become thinner, with application-layer orchestration

### 5. Reporting Module

Scope:

- report generation
- export/share
- immutable snapshots

Tasks:

- define report generation contract
- move report composition and export orchestration into use-cases
- prepare async boundary for long-running jobs

Deliverable:

- reporting isolated from screens and reusable across modules

### 6. AI Review Module

Scope:

- AI recommendations
- accept/override workflow
- decision history

Tasks:

- define AI recommendation lifecycle rules
- isolate clinician review actions into use-cases
- make audit logging automatic on review decisions

Deliverable:

- AI stays assistive and auditable by design

### 7. Admin Module

Scope:

- user management
- verification
- analytics/governance

Tasks:

- isolate admin actions and permissions
- formalize approval and audit flows
- keep admin screens as thin presentation surfaces

Deliverable:

- clear governance boundary with role-aware policy enforcement

### 8. Security and Compliance

Scope:

- encryption
- session policy
- audit policy
- authorization

Tasks:

- centralize security adapters
- centralize authorization checks
- emit audit events for PHI access and sensitive actions
- avoid business rules in screens

Deliverable:

- security becomes a first-class architecture concern instead of scattered implementation detail

## Migration Phases

### Phase 1: Foundation

Goals:

- add app bootstrap layer
- add application use-case abstraction
- migrate auth into new module
- migrate patient screening repository into new module

Success criteria:

- app still launches
- auth flow still works
- patient screening history/latest/save still work
- legacy screens continue to compile against compatibility APIs

### Phase 2: Clinician Vertical Slice

Goals:

- extract patient list and test session orchestration
- move AC/BC save logic into use-cases
- wrap audio service behind interfaces

Success criteria:

- clinician testing screens use application-layer orchestration
- no new test workflow logic is added directly to screens

### Phase 3: Reporting + AI

Goals:

- move report generation and AI decision workflow behind modules
- prepare async job boundaries

Success criteria:

- test detail/report flow no longer coordinates multiple services directly from UI

### Phase 4: Admin + Security Hardening

Goals:

- isolate admin workflows
- centralize authorization and audit policy
- tighten session and PHI access handling

Success criteria:

- admin actions are centrally governed and auditable

## Compatibility Strategy

The migration should preserve current imports for as long as possible.

Examples:

- legacy `features/auth/presentation/providers/auth_provider.dart` becomes a compatibility export over the new auth module
- legacy `data/repositories/screening_repository.dart` becomes a compatibility facade backed by new patient screening use-cases

This minimizes churn and keeps UI migration incremental.

## Testing Strategy

### Domain Tests

- hearing classification rules
- screening outcome analysis
- AC/BC linkage
- report policy rules

### Application Tests

- sign in/register/sign out
- save screening result
- screening history retrieval
- verify audiologist
- AI accept/override

### UI / Widget Tests

- login
- register
- patient home
- screening results
- clinician testing shell

### Security Tests

- PHI access audit emission
- protected action authorization
- session timeout policy

## Risks

### Risk: mixed old/new state management

Mitigation:

- use compatibility facades during migration
- migrate by vertical slice

### Risk: routing regressions

Mitigation:

- keep router stable while replacing underlying providers

### Risk: duplicate business rules

Mitigation:

- extract domain services early
- route all new logic through use-cases

### Risk: security behavior drift

Mitigation:

- centralize audit and authorization before deeper backend integration

## Definition of Done

The architecture migration is considered complete when:

- screens are thin presentation layers
- workflows live in application use-cases
- domain rules are isolated from UI and infrastructure
- infrastructure is behind interfaces
- security and audit are centralized
- modules are organized by domain capability rather than role-centric UI grouping

## Immediate Implementation Scope

The first implementation slice in this repository will do the following:

1. Add `app/bootstrap` foundation.
2. Add shared `use_case` abstraction.
3. Implement modular `auth` domain/application/infrastructure/presentation layers.
4. Replace legacy auth provider with a compatibility export.
5. Implement modular `patient_screening` domain/application/infrastructure layers.
6. Convert the legacy screening repository into a compatibility facade.
7. Keep current routes and screens stable.
