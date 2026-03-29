# Implementation Plan: Unified AudioApp with Screening + Diagnostics

**Date:** January 15, 2026  
**Goal:** Extend AudioApp to support three user roles (Patient, Audiologist, System Admin) with both hearing screening and diagnostic audiometry features, targeting generic headphones with clinical validation.

---

## User Review Required

> [!IMPORTANT]
> **Regulatory Pathway Decision**
> Combining screening and diagnostics in one app with generic headphones requires careful regulatory positioning:
> - **Screening Mode**: Can claim "hearing check" (lower regulatory burden)
> - **Diagnostic Mode**: Must maintain "for professional use only" claims
> - **Generic Headphones**: Requires extensive calibration database and validation

> [!WARNING]
> **Generic Headphone Calibration Challenge**
> Without controlled hardware, achieving clinical-grade accuracy (±5 dB) is difficult. The validation protocol must include:
> 1. Building calibration profiles for popular headphone models
> 2. Comparing against proven audiometers in controlled settings
> 3. Documenting limitations in non-calibrated headphone scenarios

---

## Current State

- **Architecture**: Flutter/Dart with Riverpod state management
- **Features**: Audiologist testing screens, patient home, basic admin folder structure
- **Database**: SQLite with patients, tests, calibration profiles
- **Testing**: `AudiometryTestingScreen` with manual tone presentation, ThresholdDetermination

---

## Proposed Changes

### Component 1: Authentication & Role Management

> [!NOTE]
> Extends existing `features/auth` module

---

#### [MODIFY] [user_model.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/data/models/user_model.dart)

Add role-based user model with three roles:

```dart
enum UserRole { patient, audiologist, systemAdmin }

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isVerified;  // For audiologist verification
  final String? licenseNumber;  // For audiologists
  final DateTime createdAt;
  // ...
}
```

---

#### [NEW] [role_based_router.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/core/router/role_based_router.dart)

Route users to appropriate home screens based on role:
- Patient → Patient Home (screening + results)
- Audiologist → Audiologist Dashboard (testing + patients)
- System Admin → Admin Dashboard (user management + analytics)

---

### Component 2: Patient Self-Screening Module

> [!NOTE]
> New feature in `features/patient/`

---

#### [NEW] [screening_test_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/patient/presentation/screens/screening_test_screen.dart)

Self-administered hearing screening with:
- Environment check (ambient noise detection)
- Simplified 5-minute test (4 frequencies: 500, 1000, 2000, 4000 Hz)
- Large, accessible response button
- Clear pass/fail result
- Recommendation to consult professional if needed

---

#### [NEW] [screening_result_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/patient/presentation/screens/screening_result_screen.dart)

Patient-friendly result display:
- Visual hearing status indicator
- Plain language explanation
- Education about hearing health
- Referral pathway to audiologist

---

#### [NEW] [screening_service.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/services/screening/screening_service.dart)

```dart
class ScreeningService {
  static const screeningFrequencies = [500, 1000, 2000, 4000];
  static const passThreshold = 25; // dB HL
  
  Future<ScreeningResult> conductScreening();
  Future<bool> checkEnvironment();
  ScreeningOutcome evaluateResult(List<ThresholdResult> results);
}
```

---

### Component 3: System Admin Module

> [!NOTE]
> Extends existing `features/admin/`

---

#### [NEW] [admin_dashboard_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/admin/presentation/screens/admin_dashboard_screen.dart)

Admin capabilities:
- User management (view, approve, suspend users)
- Audiologist verification workflow
- Analytics dashboard (tests conducted, user growth)
- Calibration profile management
- System settings

---

#### [NEW] [user_management_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/admin/presentation/screens/user_management_screen.dart)

- List all users with role filters
- Approve/reject audiologist registrations
- View user activity logs
- Suspend/reactivate accounts

---

#### [NEW] [calibration_management_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/admin/presentation/screens/calibration_management_screen.dart)

- View/edit calibration profiles
- Add new headphone profiles
- Export calibration data for validation
- Track calibration validation dates

---

#### [NEW] [analytics_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/admin/presentation/screens/analytics_screen.dart)

- Total users by role
- Tests conducted (screening vs diagnostic)
- Headphone usage distribution
- Geographic distribution (if applicable)

---

### Component 4: Generic Headphone Calibration System

> [!IMPORTANT]
> Critical for achieving clinical accuracy with consumer headphones

---

#### [MODIFY] [calibration_constants.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/core/constants/calibration_constants.dart)

Expand calibration database for popular generic headphones:

```dart
class HeadphoneCalibration {
  final String model;
  final String brand;
  final Map<int, double> retsplValues;  // Frequency -> dB SPL
  final bool isValidated;
  final DateTime validationDate;
}

// Initial headphone profiles to validate:
// - Apple AirPods Pro 2
// - Apple AirPods (3rd gen)
// - Apple EarPods
// - Samsung Galaxy Buds Pro
// - Sony WH-1000XM4/5
// - Generic wired earbuds (baseline)
```

---

#### [NEW] [headphone_detection_service.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/services/audio/headphone_detection_service.dart)

- Detect connected headphone type
- Match to calibration profile if available
- Warn user if using uncalibrated headphones
- Provide calibration guidance

---

### Component 5: Enhanced Ambient Noise Monitoring

---

#### [MODIFY] [audio_service.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/services/audio/audio_service.dart)

Add continuous noise monitoring:
- Real-time dB SPL measurement
- Frequency-specific noise analysis
- Auto-pause test if noise exceeds ANSI S3.1 limits
- Recording of noise levels in test metadata

---

### Component 6: Clinical Validation Framework

---

#### [NEW] [validation_test_screen.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/features/admin/presentation/screens/validation_test_screen.dart)

Admin tool for clinical validation:
- Side-by-side comparison mode
- Input reference audiometer results
- Calculate deviation statistics
- Generate validation reports

---

#### [NEW] [validation_report.dart](file:///Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp/lib/data/models/validation_report.dart)

```dart
class ValidationReport {
  final String headphoneModel;
  final String referenceAudiometer;
  final int participantCount;
  final Map<int, DeviationStats> frequencyDeviations;
  final double overallAccuracy;
  final bool meetsStandard;  // ±5 dB at 95% confidence
}
```

---

### Component 7: Database Schema Updates

---

#### [MODIFY] Database Schema

Add tables for new functionality:

```sql
-- Users table (extends existing)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL, -- 'patient', 'audiologist', 'system_admin'
  is_verified INTEGER DEFAULT 0,
  license_number TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- Screening results (separate from diagnostic tests)
CREATE TABLE screening_results (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  test_date TEXT NOT NULL,
  headphone_model TEXT,
  ambient_noise_db REAL,
  pass_fail TEXT NOT NULL, -- 'pass', 'refer', 'incomplete'
  frequencies_tested TEXT, -- JSON array
  thresholds TEXT, -- JSON object {frequency: db}
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Headphone calibration profiles
CREATE TABLE headphone_profiles (
  id TEXT PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  calibration_data TEXT NOT NULL, -- JSON {freq: retspl}
  is_validated INTEGER DEFAULT 0,
  validation_date TEXT,
  validation_accuracy REAL,
  created_at TEXT NOT NULL
);

-- Validation logs
CREATE TABLE validation_logs (
  id TEXT PRIMARY KEY,
  headphone_id TEXT NOT NULL,
  audiologist_id TEXT NOT NULL,
  reference_audiometer TEXT NOT NULL,
  participant_count INTEGER NOT NULL,
  deviation_data TEXT NOT NULL, -- JSON
  overall_accuracy REAL,
  meets_standard INTEGER,
  created_at TEXT NOT NULL,
  FOREIGN KEY (headphone_id) REFERENCES headphone_profiles(id)
);

-- Audit log
CREATE TABLE audit_log (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id TEXT,
  details TEXT,
  created_at TEXT NOT NULL
);
```

---

## Implementation Phases

### Phase 1: Core Architecture (Weeks 1-2)
- [ ] User role system and authentication updates
- [ ] Role-based routing
- [ ] Database schema migration
- [ ] Basic admin dashboard shell

### Phase 2: Patient Screening (Weeks 3-4)
- [ ] Screening test interface
- [ ] Environment check system
- [ ] Pass/fail result screens
- [ ] Patient home screen updates

### Phase 3: Admin Features (Weeks 5-6)
- [ ] User management screens
- [ ] Audiologist verification workflow
- [ ] Calibration profile management
- [ ] Basic analytics dashboard

### Phase 4: Calibration & Validation (Weeks 7-8)
- [ ] Headphone detection service
- [ ] Calibration profile database
- [ ] Validation test mode
- [ ] Deviation reporting

### Phase 5: Clinical Validation (Weeks 9-12)
- [ ] Partner with audiologists for testing
- [ ] Run validation against reference audiometers
- [ ] Build validated headphone profile database
- [ ] Document accuracy statistics

---

## Verification Plan

### Automated Tests

**Existing Tests:**
- `test/widget_test.dart` - Basic widget tests

**New Tests to Add:**

1. **Unit Tests** (`test/unit/`)
   - `screening_service_test.dart` - Test pass/fail logic
   - `calibration_service_test.dart` - Test headphone profile matching
   - `role_router_test.dart` - Test role-based navigation

2. **Integration Tests** (`test/integration/`)
   - `auth_flow_test.dart` - Test login flows for each role
   - `screening_flow_test.dart` - End-to-end screening test

**Run Tests:**
```bash
cd /Users/shishirkafle/Desktop/Moonarc/AudioApp/audioapp
flutter test
```

### Manual Verification

> [!NOTE]
> These require a physical device and actual testing.

1. **Role-Based Access**
   - Log in as Patient → Verify can only access patient screens
   - Log in as Audiologist → Verify can access testing screens
   - Log in as Admin → Verify can access admin dashboard

2. **Screening Mode**
   - Complete a 5-minute screening test
   - Verify pass/fail result is appropriately shown
   - Verify results are saved to screening_results table

3. **Headphone Detection**
   - Connect different headphones
   - Verify app detects and selects appropriate calibration profile

4. **Noise Monitoring**
   - Test in quiet environment → Should proceed
   - Test in noisy environment → Should warn/pause

### Clinical Validation Protocol

> [!IMPORTANT]
> This requires partnering with audiologists and access to reference audiometers.

1. **Participant Recruitment**
   - Minimum 20 participants per headphone model
   - Range of hearing abilities (normal to moderate loss)

2. **Test Protocol**
   - Test subject with reference audiometer in sound booth
   - Test same subject with AudioApp + target headphones
   - Record both results for comparison

3. **Success Criteria**
   - 95% of thresholds within ±5 dB of reference
   - Mean deviation < 3 dB across all frequencies
   - No systematic bias (over/under estimation)

---

## Questions for User

1. **Firebase vs Local DB**: Current app uses Firebase. Should user management be Firebase-based or local SQLite?

2. **Audiologist Verification**: Who verifies audiologists - manual admin approval or automated license check?

3. **Initial Headphone List**: Which headphone models should we prioritize for calibration?

4. **Beta Testing Partners**: Do you have audiologists lined up for the clinical validation phase?
