# Step-by-Step Implementation Plan

## Phase 1: Data Wiring and AC Flow
1. Replace in-memory `PatientRepository` with Drift-backed repository.
2. Persist AC screening results in `screeningResults` and `testResults` tables.
3. Attach AC results to patient record and sync to Firestore.
4. Generate AC PDF report and deliver to audiologist queue.
5. Add consent + data sharing confirmation in patient flow.

## Phase 2: BC Flow and Hardware Integration
1. Select BC transducer and audiometer interface (USB/Bluetooth, vendor SDK).
2. Build platform channel integration for BC tone output.
3. Add calibration steps and validate output accuracy.
4. Store BC results linked to AC test.
5. Update reports to include AC + BC in one view.

## Phase 3: Combined Analysis
1. Compute air-bone gap per frequency.
2. Determine hearing loss type (conductive, sensorineural, mixed).
3. Add combined audiogram overlays and summary metrics.
4. Add UI for audiologist to verify combined results.

## Phase 4: AI Assist
1. Define ML task (classification + severity + confidence).
2. Extract features and build dataset schema.
3. Train baseline model and measure accuracy.
4. Build inference pipeline (on-device or server-side).
5. Add AI suggestion UI and clinician approval workflow.

## Phase 5: Compliance and Scale
1. Harden role-based access control.
2. Audit logs for all PHI access and AI actions.
3. Add model monitoring and version management.
4. Stress testing for sync and large datasets.

