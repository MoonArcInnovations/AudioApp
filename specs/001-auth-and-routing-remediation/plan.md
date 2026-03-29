# Implementation Plan: Auth and Routing Remediation

**Branch**: `[001-auth-and-routing-remediation]` | **Date**: 2026-03-29 | **Spec**: [/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/specs/001-auth-and-routing-remediation/spec.md](/Users/shishirkafle/Desktop-iCloud-Extract/Moonarc/AudioApp/specs/001-auth-and-routing-remediation/spec.md)
**Input**: Feature specification from `/specs/001-auth-and-routing-remediation/spec.md`

## Summary

Harden the app’s entry path so that Firebase-backed authentication, role-based route protection, audiologist verification, password reset, and startup failure surfacing behave consistently with AudioApp’s clinical, security, and governance requirements.

## Technical Context

**Language/Version**: Dart 3.10 / Flutter stable  
**Primary Dependencies**: Flutter, flutter_riverpod, go_router, firebase_core, firebase_auth, cloud_firestore  
**Storage**: Firebase Auth + Firestore for auth/user profile state, Drift/SQLite for local services  
**Testing**: flutter_test  
**Target Platform**: Android and iOS mobile (Android phone QA first)  
**Project Type**: Mobile app  
**Performance Goals**: App launch under 3 seconds; route guards and auth redirects must feel immediate  
**Constraints**: Offline-first local services remain intact; RBAC cannot be bypassed by direct route entry; startup/auth errors must be visible  
**Scale/Scope**: Multi-role client app with Patient, Audiologist, and Admin surfaces

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Clinical Safety First: Pass, because role access and clinician verification directly affect safe use boundaries.
- Security, Privacy, and RBAC Are Non-Negotiable: Pass only if route guards and verification state are enforced in router and auth profile logic.
- Modular Monolith With Explicit Boundaries: Pass if routing logic stays in router/application helpers and Firebase wiring remains behind module/service boundaries.
- Offline-First, Sync-Safe Behavior: Pass, provided auth and verification changes do not regress local service startup.
- Testable Changes With Executable Specs: Pass, with required automated routing/auth tests and manual QA on device.

## Project Structure

### Documentation (this feature)

```text
specs/001-auth-and-routing-remediation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── spec.md
└── tasks.md
```

### Source Code (repository root)

```text
audioapp/
├── lib/
│   ├── app/bootstrap/
│   │   └── app_bootstrap.dart
│   ├── core/router/
│   │   └── app_router.dart
│   ├── features/auth/presentation/screens/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── modules/auth/
│   │   ├── application/use_cases/
│   │   ├── domain/entities/
│   │   ├── domain/repositories/
│   │   ├── infrastructure/repositories/
│   │   └── presentation/controllers/
│   ├── services/firebase/
│   │   └── firebase_auth_service.dart
│   ├── firebase_options.dart
│   └── main.dart
└── test/
    ├── auth_controller_test.dart
    ├── navigation_spec_test.dart
    └── widget_test.dart
```

**Structure Decision**: This feature remains inside the existing modular monolith. Routing changes stay in `core/router`, auth/profile state changes stay in `modules/auth` and `services/firebase`, and UI changes stay in auth screens or dedicated holding/error screens.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Firebase init surfaced in app shell | Startup/auth failure must be visible before user interaction | Pure logging hides failures and blocks clear QA diagnosis |
| Verification state added to auth profile | Audiologist access must be gated before clinician workflows | Route-only checks without persisted verification state cannot support admin approval lifecycle |
