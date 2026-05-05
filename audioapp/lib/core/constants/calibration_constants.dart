/// Audiometry Calibration Constants
/// Based on ISO 389 and ANSI S3.6 standards for audiometric equipment
library;

class CalibrationConstants {
  CalibrationConstants._();

  // ===================================================================
  // RETSPL (Reference Equivalent Threshold Sound Pressure Level)
  // Values in dB SPL for 0 dB HL at each frequency
  // ===================================================================

  /// TDH-39/49/50 Supra-aural headphones (most common clinical headphones)
  static const Map<int, double> retsplTDH39 = {
    125: 45.5,
    250: 27.0,
    500: 13.5,
    750: 9.0,
    1000: 7.5,
    1500: 7.5,
    2000: 9.0,
    3000: 11.5,
    4000: 12.0,
    6000: 16.0,
    8000: 15.5,
  };

  /// HDA 300 Circum-aural headphones (extended high frequency)
  static const Map<int, double> retsplHDA300 = {
    125: 30.5,
    250: 18.0,
    500: 11.0,
    750: 6.0,
    1000: 5.5,
    1500: 5.5,
    2000: 4.5,
    3000: 2.5,
    4000: 9.5,
    6000: 17.0,
    8000: 17.5,
    10000: 22.0,
    12500: 28.0,
    16000: 43.5,
  };

  /// ER-3A Insert earphones (less ambient noise influence)
  static const Map<int, double> retsplER3A = {
    125: 26.0,
    250: 14.0,
    500: 5.5,
    750: 2.0,
    1000: 0.0,
    1500: 2.0,
    2000: 3.0,
    3000: 3.5,
    4000: 5.5,
    6000: 2.0,
    8000: 0.0,
  };

  /// Radioear B-71 Bone conductor (mastoid placement)
  static const Map<int, double> retflB71Mastoid = {
    250: 67.0,
    500: 58.0,
    750: 48.5,
    1000: 42.5,
    1500: 36.5,
    2000: 31.0,
    3000: 30.0,
    4000: 35.5,
  };

  /// Radioear B-71 Bone conductor (forehead placement)
  static const Map<int, double> retflB71Forehead = {
    250: 79.0,
    500: 72.0,
    750: 61.5,
    1000: 51.0,
    1500: 47.5,
    2000: 42.5,
    3000: 42.0,
    4000: 43.5,
  };

  // ===================================================================
  // Maximum Audiometer Output Levels (dB HL)
  // ===================================================================

  static const Map<int, int> maxOutputAirConduction = {
    125: 100,
    250: 110,
    500: 120,
    750: 120,
    1000: 120,
    1500: 120,
    2000: 120,
    3000: 120,
    4000: 120,
    6000: 115,
    8000: 100,
  };

  static const Map<int, int> maxOutputBoneConduction = {
    250: 45,
    500: 65,
    750: 70,
    1000: 70,
    1500: 70,
    2000: 70,
    3000: 70,
    4000: 70,
  };

  // ===================================================================
  // Interaural Attenuation (dB) - for masking calculations
  // ===================================================================

  /// Air conduction (supra-aural headphones)
  static const Map<int, int> interauralAttenuationAC = {
    250: 40,
    500: 40,
    1000: 40,
    2000: 45,
    4000: 50,
    8000: 50,
  };

  /// Air conduction (insert earphones - better isolation)
  static const Map<int, int> interauralAttenuationInsert = {
    250: 55,
    500: 60,
    1000: 65,
    2000: 70,
    4000: 70,
    8000: 70,
  };

  /// Bone conduction (very low - hence masking often needed)
  static const int interauralAttenuationBC = 0; // Worst case assumption

  // ===================================================================
  // Maximum Permissible Ambient Noise Levels (dB SPL)
  // For testing down to 0 dB HL per ANSI S3.1-1999
  // ===================================================================

  /// Using supra-aural headphones
  static const Map<int, double> maxAmbientNoiseSupraAural = {
    125: 34.5,
    250: 22.5,
    500: 14.5,
    750: 12.0,
    1000: 14.0,
    1500: 20.5,
    2000: 28.0,
    3000: 34.5,
    4000: 37.0,
    6000: 45.0,
    8000: 50.5,
  };

  /// Using insert earphones (more attenuation = higher allowed ambient)
  static const Map<int, double> maxAmbientNoiseInsert = {
    125: 67.5,
    250: 49.5,
    500: 33.5,
    750: 27.0,
    1000: 26.0,
    1500: 27.0,
    2000: 34.0,
    3000: 37.0,
    4000: 37.0,
    6000: 45.0,
    8000: 50.5,
  };

  // ===================================================================
  // Common Headphone Calibration Profiles
  // Corrections to apply for common consumer headphones (APPROXIMATE)
  // These require device-specific calibration for clinical use
  // ===================================================================

  /// Apple AirPods Pro (approximate)
  static const Map<int, double> correctionAirPodsPro = {
    250: -5.0,
    500: -3.0,
    1000: 0.0,
    2000: -2.0,
    4000: -4.0,
    8000: -6.0,
  };

  /// Sony WH-1000XM4 (approximate)
  static const Map<int, double> correctionSonyXM4 = {
    250: -3.0,
    500: -2.0,
    1000: 0.0,
    2000: -1.0,
    4000: -3.0,
    8000: -5.0,
  };

  /// Generic over-ear headphones (baseline)
  static const Map<int, double> correctionGenericOverEar = {
    250: -8.0,
    500: -5.0,
    1000: 0.0,
    2000: -3.0,
    4000: -5.0,
    8000: -8.0,
  };

  // ===================================================================
  // Hearing Loss Classification (dB HL PTA)
  // Based on WHO and ASHA guidelines
  // ===================================================================

  static const Map<String, (int, int)> hearingLossClassification = {
    'Normal': (-10, 25),
    'Mild': (26, 40),
    'Moderate': (41, 55),
    'Moderately Severe': (56, 70),
    'Severe': (71, 90),
    'Profound': (91, 120),
  };

  /// Get classification for PTA value
  static String getClassification(double pta) {
    for (final entry in hearingLossClassification.entries) {
      if (pta >= entry.value.$1 && pta <= entry.value.$2) {
        return entry.key;
      }
    }
    return 'Unknown';
  }

  // ===================================================================
  // Masking Noise Specifications
  // ===================================================================

  /// Narrowband noise bandwidth (Hz) for masking
  static const Map<int, (int, int)> narrowBandNoiseWidth = {
    250: (180, 360),
    500: (360, 720),
    1000: (720, 1440),
    2000: (1440, 2880),
    4000: (2880, 5760),
    8000: (5760, 11520),
  };

  /// Effective masking levels
  static const int effectiveMaskingOffset =
      5; // dB to add for effective masking

  // ===================================================================
  // Test Tone Specifications
  // ===================================================================

  static const int defaultToneDurationMs = 1000;
  static const int warbleToneDurationMs = 1000;
  static const int warbleModulationHz = 5; // 5% frequency modulation at 5 Hz
  static const int pulsedToneOnMs = 200;
  static const int pulsedToneOffMs = 200;
  static const int minimumRiseTimeMs = 20; // Avoid transients
  static const int minimumFallTimeMs = 20;
}
