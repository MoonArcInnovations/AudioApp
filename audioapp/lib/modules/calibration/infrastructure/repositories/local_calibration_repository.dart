import '../../../../data/local/app_database.dart';
import '../../domain/entities/headphone_profile.dart';
import '../../domain/repositories/calibration_repository.dart';

class LocalCalibrationRepository implements CalibrationRepository {
  LocalCalibrationRepository(this._database);

  final AppDatabase _database;

  static const Map<int, double> _tdh39Retspl = {
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

  static const Map<int, double> _er3aRetspl = {
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

  static const Map<int, double> _hda300Retspl = {
    125: 30.5,
    250: 18.0,
    500: 11.0,
    1000: 5.5,
    2000: 4.5,
    4000: 9.5,
    8000: 17.5,
    10000: 22.0,
    12500: 28.0,
    16000: 43.5,
  };

  static const Map<int, double> _airpodsProRetspl = {
    250: 32.0,
    500: 16.5,
    1000: 7.5,
    2000: 11.0,
    4000: 16.0,
    8000: 21.5,
  };

  static const Map<int, double> _airpodsProCorrections = {
    250: -5.0,
    500: -3.0,
    1000: 0.0,
    2000: -2.0,
    4000: -4.0,
    8000: -6.0,
  };

  static const Map<int, double> _genericRetspl = {
    250: 40.0,
    500: 22.0,
    1000: 12.0,
    2000: 14.0,
    4000: 20.0,
    8000: 28.0,
  };

  @override
  double getRetspl(int frequency, HeadphoneProfileType profileType) {
    final profile = _getProfile(profileType);
    return profile[frequency] ?? _interpolateRetspl(frequency, profile);
  }

  @override
  double getCorrection(int frequency, HeadphoneProfileType profileType) {
    switch (profileType) {
      case HeadphoneProfileType.airpodsPro2:
        return _airpodsProCorrections[frequency] ?? 0.0;
      default:
        return 0.0;
    }
  }

  @override
  double getOutputSpl({
    required int frequency,
    required int desiredDbHl,
    required HeadphoneProfileType profileType,
  }) {
    return desiredDbHl +
        getRetspl(frequency, profileType) +
        getCorrection(frequency, profileType);
  }

  @override
  int getCalibratedThreshold({
    required int frequency,
    required double rawDbSpl,
    required HeadphoneProfileType profileType,
  }) {
    return (rawDbSpl -
            getRetspl(frequency, profileType) -
            getCorrection(frequency, profileType))
        .round();
  }

  @override
  HeadphoneProfileDetails getProfileDetails(HeadphoneProfileType profileType) {
    switch (profileType) {
      case HeadphoneProfileType.tdh39:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.tdh39,
          name: 'TDH-39/49/50',
          brand: 'Telephonics',
          type: 'Supra-aural',
          accuracy: CalibrationAccuracy.clinical,
          accuracyDb: 3,
          isValidated: true,
          approvedUse: ApprovedUse.diagnostic,
          description: 'Standard clinical audiometry headphones',
        );
      case HeadphoneProfileType.er3a:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.er3a,
          name: 'ER-3A Insert',
          brand: 'Etymotic',
          type: 'Insert Earphones',
          accuracy: CalibrationAccuracy.clinical,
          accuracyDb: 3,
          isValidated: true,
          approvedUse: ApprovedUse.diagnostic,
          description: 'Clinical insert earphones with excellent isolation',
        );
      case HeadphoneProfileType.hda300:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.hda300,
          name: 'HDA 300',
          brand: 'Sennheiser',
          type: 'Circum-aural',
          accuracy: CalibrationAccuracy.clinical,
          accuracyDb: 3,
          isValidated: true,
          approvedUse: ApprovedUse.diagnostic,
          description: 'Extended high-frequency testing headphones',
        );
      case HeadphoneProfileType.airpodsPro2:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.airpodsPro2,
          name: 'AirPods Pro 2',
          brand: 'Apple',
          type: 'True Wireless',
          accuracy: CalibrationAccuracy.validated,
          accuracyDb: 5,
          isValidated: false,
          approvedUse: ApprovedUse.screening,
          description: 'Consumer earbuds with ANC - requires validation',
        );
      case HeadphoneProfileType.galaxyBudsPro:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.galaxyBudsPro,
          name: 'Galaxy Buds Pro',
          brand: 'Samsung',
          type: 'True Wireless',
          accuracy: CalibrationAccuracy.validated,
          accuracyDb: 7,
          isValidated: false,
          approvedUse: ApprovedUse.screening,
          description: 'Consumer earbuds - requires validation',
        );
      case HeadphoneProfileType.airpods3:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.airpods3,
          name: 'AirPods 3rd Gen',
          brand: 'Apple',
          type: 'True Wireless',
          accuracy: CalibrationAccuracy.screening,
          accuracyDb: 10,
          isValidated: false,
          approvedUse: ApprovedUse.screeningOnly,
          description: 'Consumer earbuds - screening only',
        );
      case HeadphoneProfileType.earpods:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.earpods,
          name: 'EarPods',
          brand: 'Apple',
          type: 'Wired',
          accuracy: CalibrationAccuracy.screening,
          accuracyDb: 10,
          isValidated: false,
          approvedUse: ApprovedUse.screeningOnly,
          description: 'Wired earbuds - screening only',
        );
      case HeadphoneProfileType.generic:
        return const HeadphoneProfileDetails(
          profileType: HeadphoneProfileType.generic,
          name: 'Generic Headphones',
          brand: 'Unknown',
          type: 'Unknown',
          accuracy: CalibrationAccuracy.approximate,
          accuracyDb: 15,
          isValidated: false,
          approvedUse: ApprovedUse.screeningWithWarning,
          description: 'Unvalidated headphones - results may be inaccurate',
        );
    }
  }

  @override
  List<HeadphoneProfileDetails> getAllProfiles() {
    return HeadphoneProfileType.values.map(getProfileDetails).toList();
  }

  @override
  List<HeadphoneProfileDetails> getProfilesByUse(ApprovedUse use) {
    return HeadphoneProfileType.values
        .map(getProfileDetails)
        .where((profile) => profile.approvedUse.index <= use.index)
        .toList();
  }

  @override
  Future<void> saveCalibrationCorrection({
    required int frequency,
    required double correction,
    required String calibratedBy,
    String? headphoneProfileId,
    String? notes,
  }) {
    return _database.setCalibration(
      frequency: frequency,
      correction: correction,
      calibratedBy: calibratedBy,
      headphoneProfileId: headphoneProfileId,
      notes: notes,
    );
  }

  @override
  Future<Map<int, double>> getSavedCalibrations() {
    return _database.getAllCalibrations();
  }

  @override
  Future<double> getSavedCorrection(int frequency) {
    return _database.getCalibrationCorrection(frequency);
  }

  Map<int, double> _getProfile(HeadphoneProfileType profileType) {
    switch (profileType) {
      case HeadphoneProfileType.tdh39:
        return _tdh39Retspl;
      case HeadphoneProfileType.er3a:
        return _er3aRetspl;
      case HeadphoneProfileType.hda300:
        return _hda300Retspl;
      case HeadphoneProfileType.airpodsPro2:
        return _airpodsProRetspl;
      case HeadphoneProfileType.galaxyBudsPro:
      case HeadphoneProfileType.airpods3:
      case HeadphoneProfileType.earpods:
      case HeadphoneProfileType.generic:
        return _genericRetspl;
    }
  }

  double _interpolateRetspl(int frequency, Map<int, double> profile) {
    final frequencies = profile.keys.toList()..sort();

    int? lowerFreq;
    int? upperFreq;

    for (final value in frequencies) {
      if (value <= frequency) {
        lowerFreq = value;
      }
      if (value >= frequency && upperFreq == null) {
        upperFreq = value;
      }
    }

    if (lowerFreq == null) {
      return profile[frequencies.first]!;
    }
    if (upperFreq == null) {
      return profile[frequencies.last]!;
    }
    if (lowerFreq == upperFreq) {
      return profile[lowerFreq]!;
    }

    final lowerVal = profile[lowerFreq]!;
    final upperVal = profile[upperFreq]!;
    final ratio = (frequency - lowerFreq) / (upperFreq - lowerFreq);
    return lowerVal + (upperVal - lowerVal) * ratio;
  }
}
