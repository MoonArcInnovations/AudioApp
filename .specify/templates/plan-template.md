# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [Android/iOS mobile first; include web only if truly relevant]  
**Project Type**: [Flutter modular monolith mobile app]  
**Performance Goals**: [startup, navigation, and workflow responsiveness relevant to the feature]  
**Constraints**: [offline-first behavior, RBAC, PHI handling, auditability, clinical credibility, analyzer cleanliness]  
**Scale/Scope**: [roles, surfaces, modules, or workflows touched]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Clinical Safety First: Explain how this feature avoids unsafe screening, testing, calibration, reporting, or AI behavior.
- Security, Privacy, and RBAC Are Non-Negotiable: Explain auth, authorization, PHI, audit, and visible-failure impact.
- Modular Monolith With Explicit Boundaries: Confirm presentation/application/domain/infrastructure boundaries remain intact.
- Offline-First, Sync-Safe Behavior: Explain local-first and sync behavior impact, or explicitly state why none exists.
- Testable Changes With Executable Specs: List automated tests and manual QA that will prove the feature.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
audioapp/
├── lib/
│   ├── app/
│   ├── core/
│   ├── modules/
│   ├── features/
│   ├── services/
│   └── main.dart
├── test/
└── android/ ios/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
