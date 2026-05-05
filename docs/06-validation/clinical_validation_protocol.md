# Clinical Validation Protocol

**Document Type:** Validation Documentation  
**Last Updated:** January 15, 2026  
**Status:** Draft - Pending IRB Approval

---

## 1. Study Overview

### 1.1 Objective

Validate that AudioApp produces hearing thresholds within clinically acceptable limits (±5 dB) compared to reference audiometry conducted with calibrated equipment in a sound-treated environment.

### 1.2 Study Design

| Parameter | Value |
|-----------|-------|
| Study Type | Prospective, single-center, comparison study |
| Control | Reference audiometry (TDH-39 in sound booth) |
| Test Device | AudioApp with validated headphones |
| Primary Outcome | Threshold deviation (dB) at each frequency |
| Secondary Outcomes | Sensitivity, specificity, ICC |

---

## 2. Participant Requirements

### 2.1 Inclusion Criteria

- Adults aged 18-80 years
- Able to provide informed consent
- Able to follow test instructions
- Range of hearing abilities (normal to moderate loss)

### 2.2 Exclusion Criteria

- Active ear infection or drainage
- Recent ear surgery (within 6 months)
- Cognitive impairment affecting test compliance
- Unable to tolerate headphones

### 2.3 Sample Size

| Headphone Model | Minimum N | Target N |
|-----------------|-----------|----------|
| Apple AirPods Pro 2 | 20 | 25 |
| Samsung Galaxy Buds Pro | 20 | 25 |
| Apple EarPods (wired) | 20 | 25 |
| **Total** | **60** | **75** |

**Justification:** Based on previous mobile audiometry validation studies, N=20 per headphone model provides 80% power to detect 5 dB differences with α=0.05.

---

## 3. Test Protocol

### 3.1 Reference Audiometry

**Equipment:**
- Calibrated clinical audiometer (GSI AudioStar Pro or equivalent)
- TDH-39/49 supra-aural headphones
- Sound-treated booth meeting ANSI S3.1

**Procedure:**
1. Otoscopy to confirm ear canal patency
2. Pure-tone air conduction at: 250, 500, 1000, 2000, 3000, 4000, 6000, 8000 Hz
3. Modified Hughson-Westlake procedure
4. Both ears tested
5. Duration: ~20 minutes

### 3.2 AudioApp Audiometry

**Equipment:**
- iPhone/Android device with AudioApp installed
- Validated headphones (as specified per group)
- Quiet room (ambient noise <45 dB SPL)

**Procedure:**
1. App calibration verification
2. Ambient noise check
3. Pure-tone air conduction at same frequencies
4. Same threshold determination method
5. Both ears tested
6. Duration: ~15-20 minutes

### 3.3 Test Order

Randomize order of reference vs. app testing to control for:
- Fatigue effects
- Learning effects
- Order bias

---

## 4. Data Collection

### 4.1 Primary Data Points

| Variable | Source | Format |
|----------|--------|--------|
| Participant ID | Registration | Anonymized |
| Age, Gender | Demographics | Numbers/codes |
| Reference thresholds (dB HL) | Audiometer | Per frequency, per ear |
| App thresholds (dB HL) | AudioApp | Per frequency, per ear |
| Ambient noise level | Sound meter | dB SPL |
| Headphone model | Observation | Category |
| Test duration | Timer | Minutes |

### 4.2 Secondary Data Points

- Participant hearing status (normal, mild, moderate)
- Any test interruptions or repeats
- Participant feedback on usability

---

## 5. Statistical Analysis

### 5.1 Primary Analysis

**Threshold Deviation:**
```
Deviation_f = App_threshold_f - Reference_threshold_f
```

Calculate for each frequency (f), each ear, each participant.

**Summary Statistics:**
- Mean deviation per frequency
- Standard deviation
- 95% confidence interval
- Range (min, max)

### 5.2 Acceptance Criteria

| Metric | Target | Rationale |
|--------|--------|-----------|
| Mean deviation | ≤3 dB | Within calibration tolerance |
| 95% of thresholds | Within ±5 dB | Clinical acceptability |
| RMSD | ≤5 dB | Overall accuracy |
| No frequency bias | Consistent across frequencies | Calibration validity |

### 5.3 Secondary Analyses

**Intraclass Correlation Coefficient (ICC):**
- Target: ICC ≥0.90 (excellent agreement)

**Bland-Altman Analysis:**
- Plot difference vs. mean
- Identify systematic bias
- Calculate limits of agreement

**Sensitivity/Specificity:**
For detecting hearing loss (>25 dB HL):
- Target sensitivity: ≥90%
- Target specificity: ≥80%

---

## 6. Quality Control

### 6.1 Equipment Verification

| Check | Frequency | Documentation |
|-------|-----------|---------------|
| Reference audiometer calibration | Annual + before study | Calibration certificate |
| App version verification | Before each session | Screenshot |
| Headphone condition | Before each session | Checklist |
| Sound booth verification | Before study | Ambient noise measurement |

### 6.2 Operator Training

All operators must complete:
- Study protocol training
- AudioApp operation training
- Good Clinical Practice (GCP) refresher

---

## 7. Ethical Considerations

### 7.1 IRB Approval

- Submit protocol to local IRB
- Obtain approval before recruitment
- Report any adverse events

### 7.2 Informed Consent

Participants must understand:
- Study purpose
- Procedures involved
- Risks (minimal - hearing assessment)
- Benefits (free hearing test, contribute to science)
- Data confidentiality

### 7.3 Data Protection

- De-identified data only
- Secure storage (encrypted)
- Limited access
- Retention per IRB requirements

---

## 8. Timeline

| Phase | Duration | Activities |
|-------|----------|------------|
| Preparation | 4 weeks | IRB approval, equipment setup |
| Recruitment | 4 weeks | Enroll 60-75 participants |
| Testing | 6 weeks | Conduct validation tests |
| Analysis | 3 weeks | Statistical analysis |
| Reporting | 2 weeks | Final study report |
| **Total** | **~4 months** | |

---

## 9. Expected Deliverables

1. **Clinical Study Report** - Full documentation of methods, results, conclusions
2. **Summary Statistics** - Per-frequency deviation data
3. **Calibration Profiles** - Updated RETSPL values per headphone
4. **Regulatory Submission Package** - For FDA 510(k) or De Novo

---

## 10. References

1. ANSI S3.6-2018 - Specification for Audiometers
2. ISO 8253-1:2010 - Audiometric test methods
3. FDA Guidance on Clinical Studies for Medical Devices
4. Previous mobile audiometry validation studies (JMIR, IJA)
