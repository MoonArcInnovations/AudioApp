# FDA Compliance Guide

**Document Type:** Regulatory Documentation  
**Last Updated:** January 15, 2026  
**Status:** Planning Phase

---

## 1. Classification Analysis

### 1.1 Product Description

AudioApp is a mobile application providing:
- **Hearing screening** for patients (self-administered)
- **Diagnostic audiometry** for audiologists (professional use)
- **Results management** and reporting

### 1.2 FDA Classification

| Feature | Intended Use | Risk Level | Classification |
|---------|-------------|------------|----------------|
| Patient Screening | General wellness, early detection | Low | Class I / Enforcement Discretion |
| Audiologist Diagnostics | Clinical hearing assessment | Moderate | Class II (510(k) or De Novo) |
| Hearing Aid Software | Sound amplification | Moderate | Class II (OTC Hearing Aid) |

---

## 2. Regulatory Pathway Options

### Option A: General Wellness / Screening Only

**Criteria for Enforcement Discretion:**
- Low risk to users
- Not intended to diagnose or treat
- General wellness claims only

**Claims Allowed:**
- ✅ "Check your hearing health"
- ✅ "Track changes in hearing over time"
- ✅ "Identify when to see a professional"
- ❌ "Diagnose hearing loss"
- ❌ "Clinical-grade accuracy"

**Regulatory Burden:** Minimal

---

### Option B: Class II Medical Device (510(k))

**When Required:**
- Making diagnostic claims
- Targeting healthcare professionals
- Claiming clinical accuracy

**Predicate Devices:**
- Audiometers under 21 CFR 874.1050
- Apple AirPods Pro 2 Hearing Aid (De Novo DEN230029)

**Submission Requirements:**
| Requirement | Description |
|-------------|-------------|
| Device Description | Complete technical specifications |
| Substantial Equivalence | Comparison to predicate devices |
| Performance Testing | Accuracy, reliability data |
| Labeling | Intended use, warnings, instructions |
| Software Documentation | IEC 62304 compliance |
| Cybersecurity | SBOM, threat analysis |

---

### Option C: De Novo Classification

**When Appropriate:**
- Novel device with no predicate
- Low-to-moderate risk
- New technology approach

**Apple's Precedent (2024):**
- First OTC hearing aid SOFTWARE device
- Received De Novo authorization
- Established new regulatory pathway

---

## 3. Software as Medical Device (SaMD)

### 3.1 IEC 62304 Software Lifecycle

| Phase | Activities | Documentation |
|-------|------------|---------------|
| Development Planning | Define requirements, risk management | SDP, SRS |
| Requirements Analysis | Functional, performance specs | SRS |
| Architecture Design | System, software architecture | SAD |
| Detailed Design | Module specifications | SDD |
| Implementation | Coding, unit testing | Source code, unit tests |
| Integration | Component integration | Integration test results |
| Verification | System testing | Test protocols, reports |
| Validation | Clinical validation | Clinical study data |
| Release | Deployment, labeling | Release notes, IFU |

### 3.2 Software Safety Classification

Per IEC 62304:

| Class | Risk | AudioApp Features |
|-------|------|-------------------|
| Class A | No injury possible | Patient education content |
| Class B | Non-serious injury possible | Screening results display |
| Class C | Death/serious injury possible | Diagnostic audiometry (if misdiagnosis delays treatment) |

**Recommendation:** Treat diagnostic features as Class B or C software.

---

## 4. Quality System Requirements

### 4.1 21 CFR Part 820

| Requirement | Implementation |
|-------------|----------------|
| Design Controls | Requirements traceability, verification, validation |
| Document Controls | Version-controlled documentation |
| Purchasing Controls | Vendor qualification (cloud providers, SDKs) |
| Production/Process Controls | Build automation, testing pipelines |
| CAPA | Bug tracking, corrective actions |
| Complaint Handling | User feedback system |
| Internal Audits | Annual QMS audits |

### 4.2 Risk Management (ISO 14971)

**Key Risk Areas:**

| Hazard | Harm | Mitigation |
|--------|------|------------|
| Inaccurate thresholds | Delayed treatment | Calibration validation, warnings |
| Excessive sound levels | Hearing damage | Output limiting, volume caps |
| Privacy breach | PHI exposure | Encryption, access controls |
| Misinterpretation | Inappropriate action | Clear disclaimers, professional guidance |

---

## 5. Labeling Requirements

### 5.1 Required Labels

**App Store Description:**
> "AudioApp is designed for use by licensed audiologists and hearing healthcare professionals. The screening feature is for informational purposes only and is not intended to diagnose any medical condition. Results should be interpreted by a qualified professional."

**In-App Disclaimers:**

**Screening Mode:**
> "This hearing check is for general wellness purposes only. It is not a medical diagnosis. If you have concerns about your hearing, please consult a licensed audiologist or ENT physician."

**Diagnostic Mode:**
> "This app is intended for use by licensed audiologists and hearing healthcare professionals only. Proper calibration and ambient noise control are required for accurate results. This app is not a replacement for testing in a sound-treated environment."

### 5.2 Instructions for Use (IFU)

Required sections:
1. Intended Use
2. Indications for Use
3. Contraindications
4. Warnings and Precautions
5. Setup and Calibration
6. Operating Instructions
7. Troubleshooting
8. Technical Specifications
9. Symbols Glossary
10. Manufacturer Information

---

## 6. Cybersecurity Requirements

### 6.1 Pre-market Submission

| Element | Documentation |
|---------|---------------|
| Threat Model | STRIDE analysis |
| Security Architecture | Data flow diagrams |
| SBOM | Software Bill of Materials |
| Vulnerability Testing | Penetration test results |
| Update Mechanism | Patch management plan |
| Authentication | User access controls |

### 6.2 Post-market Requirements

- Coordinated vulnerability disclosure
- Security patch deployment plan
- Breach notification procedures
- Regular security updates

---

## 7. Clinical Evidence Requirements

### 7.1 Analytical Studies

| Study Type | Purpose | Status |
|------------|---------|--------|
| Calibration Accuracy | Verify output levels match specifications | 🔴 Planned |
| Threshold Repeatability | Test-retest reliability | 🔴 Planned |
| Headphone Comparison | Validate across supported models | 🔴 Planned |
| Noise Impact | Effect of ambient noise on results | 🔴 Planned |

### 7.2 Clinical Validation

| Parameter | Target | Method |
|-----------|--------|--------|
| Accuracy | ≤5 dB deviation from reference | Compare to booth audiometry |
| Sensitivity | ≥90% for hearing loss detection | Against clinical diagnosis |
| Specificity | ≥80% for normal hearing | Against clinical diagnosis |
| Inter-rater reliability | ICC ≥0.90 | Multiple audiologist testing |

---

## 8. Recommended Timeline

| Phase | Duration | Activities |
|-------|----------|------------|
| Pre-Submission | 2-3 months | Prepare Q-Sub, meet with FDA |
| Analytical Testing | 2-3 months | Complete bench testing |
| Clinical Validation | 3-4 months | Conduct validation studies |
| Submission Prep | 2-3 months | Compile 510(k) or De Novo |
| FDA Review | 3-12 months | Respond to questions |
| **Total** | **12-24 months** | |

---

## 9. Next Steps

1. **Decide regulatory pathway** (screening only vs. full device)
2. **Engage regulatory consultant** familiar with mobile audiometry
3. **Request pre-submission meeting** with FDA (Q-Sub)
4. **Begin quality system documentation**
5. **Plan clinical validation studies**

---

## 10. Resources

- [FDA Guidance: Policy for Device Software Functions](https://www.fda.gov/medical-devices/digital-health-center-excellence)
- [FDA De Novo Database](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpmn/denovo.cfm)
- [IEC 62304:2006+AMD1:2015](https://www.iso.org/standard/38421.html)
- [ISO 14971:2019](https://www.iso.org/standard/72704.html)
