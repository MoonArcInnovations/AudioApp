# AudioApp Production Setup Guide

## Overview

This guide covers everything needed to deploy AudioApp to production:
- Firebase project setup
- iOS App Store configuration
- Android Play Store configuration
- Calibration requirements
- Security considerations

---

## 1. Firebase Project Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add project**
3. Enter project name: `audioapp-production`
4. Enable Google Analytics (optional)
5. Click **Create project**

### Step 2: Enable Authentication

1. Navigate to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. (Optional) Enable **Google Sign-In**
4. Configure **Authorized domains**

### Step 3: Setup Firestore

1. Navigate to **Firestore Database** → **Create database**
2. Select **Production mode**
3. Choose a location (closest to users)
4. Apply security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Patients collection
    match /patients/{patientId} {
      allow read, write: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['audiologist', 'superAdmin'];
    }
    
    // Tests collection
    match /tests/{testId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'audiologist';
    }
  }
}
```

### Step 4: Add App Platforms

#### iOS
1. Click **Add app** → iOS
2. Bundle ID: `com.yourcompany.audioapp`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/`

#### Android
1. Click **Add app** → Android
2. Package name: `com.yourcompany.audioapp`
3. Download `google-services.json`
4. Place in `android/app/`

#### Web
1. Click **Add app** → Web
2. Register app
3. Copy config to `lib/firebase_options.dart`

### Step 5: Run FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

---

## 2. iOS App Store Setup

### App Store Connect

1. Create App ID in Apple Developer Portal
2. Bundle ID: `com.yourcompany.audioapp`
3. Enable capabilities:
   - Background Audio
   - Sign in with Apple (if used)

### Required Assets

| Asset | Size | Purpose |
|-------|------|---------|
| App Icon | 1024x1024 | App Store |
| Screenshots | Various | Store listing |
| Privacy Policy URL | - | Required |

### Privacy Declarations

Declare these in App Store Connect:

- **Microphone**: Ambient noise monitoring
- **Bluetooth**: External headphone connection
- **Health (optional)**: If storing hearing data in HealthKit

### Run on iOS Device

```bash
flutter build ios --release
open ios/Runner.xcworkspace
# Archive and upload from Xcode
```

---

## 3. Android Play Store Setup

### Play Console

1. Create app in [Play Console](https://play.google.com/console)
2. Package name: `com.yourcompany.audioapp`
3. Complete app content declarations

### Signing Key

```bash
# Generate release key
keytool -genkey -v -keystore ~/audioapp-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias audioapp

# Configure in android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=audioapp
storeFile=/path/to/audioapp-release-key.jks
```

### Build APK/AAB

```bash
# App Bundle (recommended)
flutter build appbundle --release

# APK
flutter build apk --release --split-per-abi
```

---

## 4. Audio Calibration Requirements

### For Clinical Use

> ⚠️ **Important**: Clinical audiometry requires calibrated equipment and professional oversight.

1. **Use Calibrated Headphones**
   - TDH-39/49/50 supra-aural
   - HDA 300 circum-aural
   - ER-3A insert earphones

2. **Annual Calibration**
   - Must be performed by certified technician
   - Documented calibration certificate required

3. **Sound Booth Requirements**
   - Ambient noise levels per ANSI S3.1
   - See `CalibrationConstants.maxAmbientNoiseSupraAural`

### For Screening Use

Consumer headphones can be used for screening with caveats:
- Less accurate
- Approximate correction profiles available
- Not suitable for diagnosis

---

## 5. Security Checklist

### Data Protection

- [ ] Enable Firestore security rules
- [ ] Enable Firebase App Check
- [ ] Encrypt sensitive data at rest
- [ ] Use HTTPS for all communications

### HIPAA Compliance (US)

- [ ] BAA signed with Google Cloud
- [ ] Audit logging enabled
- [ ] Data retention policies configured
- [ ] Access controls implemented

### GDPR Compliance (EU)

- [ ] Privacy policy updated
- [ ] Consent mechanism implemented
- [ ] Data export capability
- [ ] Right to deletion implemented

---

## 6. App Configuration

### Environment Variables

Create `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const bool isProduction = true;
  static const String apiBaseUrl = 'https://api.yourapp.com';
  static const String supportEmail = 'support@yourapp.com';
  static const String privacyPolicyUrl = 'https://yourapp.com/privacy';
  static const String termsUrl = 'https://yourapp.com/terms';
}
```

### Build Flavors

```bash
# Development
flutter run --flavor development

# Production
flutter run --flavor production --release
```

---

## 7. Testing Checklist

### Pre-Launch Testing

- [ ] Login/Register flow
- [ ] Patient CRUD operations
- [ ] Audiometry test flow
- [ ] PDF generation
- [ ] Audio playback on all devices
- [ ] Offline functionality
- [ ] Data sync

### Device Testing

| Platform | Devices to Test |
|----------|-----------------|
| iOS | iPhone 12+, iPad |
| Android | Pixel, Samsung Galaxy |

---

## 8. Launch Commands

```bash
# iOS
flutter build ios --release
# Then use Xcode to archive and upload

# Android (App Bundle for Play Store)
flutter build appbundle --release

# Web (if applicable)
flutter build web --release
```

---

## 9. Post-Launch Monitoring

### Firebase Crashlytics

```dart
// Already included - just enable in Firebase Console
```

### Analytics Events

Key events to track:
- `test_started`
- `test_completed`
- `report_generated`
- `patient_added`

---

## Support

For issues:
1. Check [Flutter docs](https://flutter.dev/docs)
2. Check [Firebase docs](https://firebase.google.com/docs)
3. Contact developer support
