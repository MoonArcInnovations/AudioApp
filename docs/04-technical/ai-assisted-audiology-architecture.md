# AI-Assisted Audiology Architecture

## Purpose
Define the end-to-end architecture for AC (home) and BC (clinic) testing, combined analysis, and AI-assisted interpretation with clinician review.

## High-Level Flow
1. Patient performs AC screening at home with headphones.
2. AC data is saved locally and synced to cloud.
3. Audiologist reviews AC report in the app.
4. Audiologist performs BC test with clinic hardware.
5. AC + BC are combined to derive air-bone gaps and classifications.
6. Combined audiogram and features are fed to AI model.
7. AI provides suggestions; clinician approves or overrides.
8. Final report is generated and shared.

## Core Components
### Client (Flutter)
- AC testing UI (patient)
- BC testing UI (audiologist)
- Audiogram rendering (AC + BC + air-bone gap overlays)
- AI suggestion display and clinician decision capture
- Offline-first persistence (Drift)

### Backend (Optional or Required for Sync/AI)
- Secure storage of AC/BC tests
- AI inference service (server-side) or model distribution (on-device)
- Audit logs and clinician actions
- Report storage and sharing

## Data Model Extensions
Extend TestResult (or add TestSession + TestResult tables):
- testType: `air` | `bone`
- transducer: e.g. `TDH-39`, `B-71`, `B-81`
- calibrationProfileId
- ambientNoiseDb
- deviceInfo
- operatorId
- locationType: `home` | `clinic`
- linkedTestId: links AC to BC
- aiSuggestion: classification + severity + confidence
- clinicianDecision: accepted/rejected + reason

## AI Feature Extraction
- AC thresholds by frequency (per ear)
- BC thresholds by frequency (per ear)
- Air-bone gaps by frequency
- PTA, slope, and configuration descriptors
- Reliability markers (no-response flags, retest count)

## Clinician Review Loop
- AI output always marked as `assistive`.
- Clinician must accept or override.
- Store clinician decision and timestamp.
- Feed corrections back for model retraining.

## Non-Functional Requirements
- Latency: audio generation <50 ms
- Local data safety: encrypted at rest
- Offline-first with background sync
- Full audit trail for PHI access

