# Feature Specification (Detailed)

## Patient (AC Screening)
- Consent and eligibility check
- Headphone selection and verification
- Ambient noise check with pass/fail gating
- AC threshold testing with response capture
- AC result storage and report generation
- AC report delivery to audiologist

## Audiologist (BC + Review)
- AC report inbox with triage
- BC test workflow with hardware integration
- Calibration validation for BC transducer
- Combined AC/BC audiogram view
- Clinical notes and recommendations

## AI Assist
- Combined AC/BC feature extraction
- AI classification and severity output
- Confidence score and reasoning summary
- Clinician accept/override with reason
- Audit log of AI output and clinician action

## Reporting
- AC-only screening report
- Combined AC/BC diagnostic report
- Versioned reports with immutable snapshots
- Secure sharing and export

## Data and Sync
- Offline-first storage (Drift)
- Background sync to Firestore
- Conflict resolution rules
- De-identification for ML training exports

## Security and Compliance
- Encryption at rest and in transit
- Role-based access control
- Session timeout and audit logs
- Consent records per patient and test

## Performance
- Audio generation latency <50ms
- Fast audiogram rendering
- Efficient background sync
