/// App-wide constants for the AudioApp
class AppConstants {
  // App Info
  static const String appName = 'AudioApp';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Audiometry Mobile Application';
  
  // API Endpoints (for future backend integration)
  static const String apiBaseUrl = 'https://api.audioapp.com/v1';
  
  // Audiometry Constants
  static const List<int> standardFrequencies = [250, 500, 1000, 2000, 3000, 4000, 6000, 8000];
  static const List<int> extendedFrequencies = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 12000, 16000];
  
  // Intensity Range
  static const int minIntensity = -10;  // dB HL
  static const int maxIntensity = 100;  // dB HL
  static const int intensityStep = 5;   // dB steps
  
  // Tone Settings
  static const int defaultToneDurationMs = 1500;   // 1.5 seconds
  static const int defaultInterStimulusMs = 2500;  // 2.5 seconds
  static const int sampleRate = 44100;             // 44.1 kHz
  
  // Maximum Permissible Ambient Noise Levels (ANSI S3.1-1999) in dB SPL
  static const Map<int, double> maxAmbientNoiseLevels = {
    250: 40.0,
    500: 40.0,
    1000: 40.0,
    2000: 47.0,
    4000: 57.0,
    8000: 62.0,
  };
  
  // RETSPL Values (Reference Equivalent Threshold Sound Pressure Level)
  // For Supra-aural headphones
  static const Map<int, double> retsplValues = {
    125: 45.5,
    250: 27.0,
    500: 13.5,
    1000: 7.5,
    2000: 9.0,
    3000: 11.5,
    4000: 12.0,
    6000: 16.0,
    8000: 15.5,
  };
  
  // Hearing Loss Classification (based on PTA)
  static const Map<String, List<int>> hearingLossRanges = {
    'Normal': [0, 25],
    'Mild': [26, 40],
    'Moderate': [41, 55],
    'Moderately Severe': [56, 70],
    'Severe': [71, 90],
    'Profound': [91, 120],
  };
  
  // Session & Security
  static const int sessionTimeoutMinutes = 15;
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 30;
  
  // UI Constants
  static const double minTouchTargetSize = 44.0;  // iOS guidelines
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Test Configuration
  static const List<int> testSequence = [1000, 2000, 3000, 4000, 6000, 8000, 1000, 500, 250];
  static const int reliabilityCheckFrequency = 1000;  // Hz
  static const int minimumResponsesForThreshold = 2;  // out of 3
  
  // Report Settings
  static const String reportDateFormat = 'MMMM d, yyyy';
  static const String reportTimeFormat = 'h:mm a';
  static const String reportDateTimeFormat = 'MMMM d, yyyy \'at\' h:mm a';
}

/// User role enum
enum UserRole {
  patient('Patient'),
  audiologist('Audiologist'),
  superAdmin('Super Admin');

  const UserRole(this.displayName);
  final String displayName;
}

/// Ear enum for audiometry
enum Ear {
  left('Left'),
  right('Right');

  const Ear(this.displayName);
  final String displayName;
}

/// Conduction type for audiometry
enum ConductionType {
  air('Air'),
  bone('Bone');

  const ConductionType(this.displayName);
  final String displayName;
}

/// Test mode enum
enum TestMode {
  manual('Manual'),
  semiAutomated('Semi-Automated'),
  bekesy('Békésy');

  const TestMode(this.displayName);
  final String displayName;
}

/// Hearing loss type classification
enum HearingLossType {
  conductive('Conductive'),
  sensorineural('Sensorineural'),
  mixed('Mixed'),
  normal('Normal');

  const HearingLossType(this.displayName);
  final String displayName;
}

/// Response type for audiometry
enum ResponseType {
  responded,
  noResponse,
  uncertain,
}
