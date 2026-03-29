# System Architecture

**Last Updated:** January 15, 2026

---

## 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AudioApp                                  │
├─────────────────────────────────────────────────────────────────┤
│                    Presentation Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Patient    │  │ Audiologist  │  │    Admin     │          │
│  │   Screens    │  │   Screens    │  │   Screens    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
├─────────────────────────────────────────────────────────────────┤
│                    Application Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    State     │  │   Services   │  │  Providers   │          │
│  │  Management  │  │              │  │  (Riverpod)  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
├─────────────────────────────────────────────────────────────────┤
│                      Domain Layer                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Entities   │  │ Repositories │  │  Use Cases   │          │
│  │              │  │ (Interfaces) │  │              │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
├─────────────────────────────────────────────────────────────────┤
│                       Data Layer                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    Local     │  │   Firebase   │  │    Audio     │          │
│  │   Database   │  │   Services   │  │    Engine    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
├─────────────────────────────────────────────────────────────────┤
│                    Platform Layer                                │
│  ┌──────────────────────────┐  ┌──────────────────────────┐    │
│  │         iOS              │  │        Android           │    │
│  │    AVAudioEngine         │  │      AudioTrack          │    │
│  └──────────────────────────┘  └──────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Framework** | Flutter 3.x | Cross-platform UI |
| **Language** | Dart 3.x | Application logic |
| **State Management** | Riverpod | Reactive state |
| **Local Database** | SQLite + SQLCipher | Encrypted local storage |
| **Authentication** | Firebase Auth | User authentication |
| **Cloud Database** | Firebase Firestore | Cloud sync (optional) |
| **Audio (iOS)** | AVAudioEngine | Low-latency audio |
| **Audio (Android)** | AudioTrack | Low-latency audio |

---

## 3. Module Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── calibration_constants.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       └── app_theme.dart
│
├── data/
│   ├── models/
│   │   ├── patient.dart
│   │   ├── test_result.dart
│   │   └── user_model.dart
│   ├── repositories/
│   │   ├── patient_repository.dart
│   │   └── test_repository.dart
│   └── datasources/
│       ├── local_database.dart
│       └── firebase_datasource.dart
│
├── features/
│   ├── admin/
│   │   └── presentation/screens/
│   ├── audiologist/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/screens/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── patient/
│       └── presentation/screens/
│
├── services/
│   ├── audio/
│   │   ├── audio_service.dart
│   │   └── headphone_detection_service.dart
│   └── firebase/
│       └── firebase_auth_service.dart
│
└── shared/
    ├── screens/
    │   └── settings_screen.dart
    └── widgets/
        └── audiogram_chart.dart
```

---

## 4. Data Flow

### 4.1 Authentication Flow

```
User → Login Screen → Firebase Auth → Role Check → Route to Home
                                          │
                                          ├── Patient → Patient Home
                                          ├── Audiologist → Audiologist Home
                                          └── Admin → Admin Dashboard
```

### 4.2 Test Flow (Audiologist)

```
Select Patient → Configure Test → Audio Service → Play Tones
                                        │
                                        ↓
                                 Record Response
                                        │
                                        ↓
                               Calculate Threshold
                                        │
                                        ↓
                              Save to Database → Generate Report
```

### 4.3 Screening Flow (Patient)

```
Patient → Start Screening → Environment Check → Pass?
                                                  │
                                                  ├── No → Warning
                                                  │
                                                  ↓ Yes
                                            Play Tones
                                                  │
                                                  ↓
                                          Record Response
                                                  │
                                                  ↓
                                        Calculate Result
                                                  │
                                      ┌───────────┴───────────┐
                                      ↓                       ↓
                                    Pass                    Refer
                                      │                       │
                                      ↓                       ↓
                              "Hearing OK"         "Consult Professional"
```

---

## 5. Audio Engine

### 5.1 Tone Generation

```dart
class AudioService {
  // Pure sine wave generation
  void generateTone(int frequency, int durationMs) {
    // Sample rate: 44100 Hz
    // Bit depth: 16-bit
    // Phase: Continuous
    // Envelope: Rise/fall time 20ms (avoid clicks)
  }
  
  // Apply calibration
  double getCalibratedAmplitude(int frequency, int dbHl, HeadphoneProfile profile) {
    final retspl = profile.retspl[frequency]!;
    final correction = profile.corrections[frequency] ?? 0;
    final dbSpl = dbHl + retspl - correction;
    return dbSplToAmplitude(dbSpl);
  }
}
```

### 5.2 Platform Channels

```
Flutter ──────── Platform Channel ──────── Native Audio
   │                    │                       │
   │     playTone()     │                       │
   │ ─────────────────► │ ─────────────────►   │
   │                    │    AVAudioEngine      │
   │     onComplete()   │    (iOS)              │
   │ ◄───────────────── │ ◄───────────────────  │
   │                    │                       │
```

---

## 6. Database Schema

### 6.1 SQLite Tables

```sql
-- Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL,  -- 'patient', 'audiologist', 'admin'
  license_number TEXT,
  is_verified INTEGER DEFAULT 0,
  created_at TEXT NOT NULL
);

-- Patients (managed by audiologists)
CREATE TABLE patients (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  date_of_birth TEXT NOT NULL,
  gender TEXT,
  medical_record_number TEXT,
  notes TEXT,
  audiologist_id TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (audiologist_id) REFERENCES users(id)
);

-- Test Results
CREATE TABLE test_results (
  id TEXT PRIMARY KEY,
  patient_id TEXT NOT NULL,
  audiologist_id TEXT NOT NULL,
  test_date TEXT NOT NULL,
  test_type TEXT NOT NULL,  -- 'air', 'bone', 'screening'
  headphone_model TEXT,
  ambient_noise_db REAL,
  thresholds TEXT NOT NULL,  -- JSON
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- Headphone Profiles
CREATE TABLE headphone_profiles (
  id TEXT PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  retspl TEXT NOT NULL,  -- JSON
  corrections TEXT,  -- JSON
  is_validated INTEGER DEFAULT 0,
  validation_date TEXT
);
```

---

## 7. Security Architecture

### 7.1 Data Protection

| Layer | Protection |
|-------|------------|
| At Rest | AES-256 encryption (SQLCipher) |
| In Transit | TLS 1.3 |
| Authentication | Firebase Auth + MFA |
| Authorization | Role-based access control |
| Sessions | 15-minute timeout |

### 7.2 Access Control Matrix

| Resource | Patient | Audiologist | Admin |
|----------|---------|-------------|-------|
| Own test results | Read | - | - |
| Other patients | - | Read/Write | Read |
| Test administration | - | Create | - |
| User management | - | - | Full |
| Calibration profiles | - | Read | Full |

---

## 8. Deployment

### 8.1 Build Pipeline

```
Code Push → GitHub Actions → Build → Test → Deploy
                               │       │       │
                               ↓       ↓       ↓
                           Flutter  Unit/   App Store
                            Build   Widget   Connect
                                    Tests   (TestFlight)
```

### 8.2 Environments

| Environment | Purpose | Database |
|-------------|---------|----------|
| Development | Local testing | SQLite (unencrypted) |
| Staging | QA testing | Firebase (test project) |
| Production | Live app | Firebase (production) |
