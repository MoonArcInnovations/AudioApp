import '../entities/headphone_profile.dart';

abstract interface class CalibrationRepository {
  double getRetspl(int frequency, HeadphoneProfileType profileType);

  double getCorrection(int frequency, HeadphoneProfileType profileType);

  double getOutputSpl({
    required int frequency,
    required int desiredDbHl,
    required HeadphoneProfileType profileType,
  });

  int getCalibratedThreshold({
    required int frequency,
    required double rawDbSpl,
    required HeadphoneProfileType profileType,
  });

  HeadphoneProfileDetails getProfileDetails(HeadphoneProfileType profileType);

  List<HeadphoneProfileDetails> getAllProfiles();

  List<HeadphoneProfileDetails> getProfilesByUse(ApprovedUse use);

  Future<void> saveCalibrationCorrection({
    required int frequency,
    required double correction,
    required String calibratedBy,
    String? headphoneProfileId,
    String? notes,
  });

  Future<Map<int, double>> getSavedCalibrations();

  Future<double> getSavedCorrection(int frequency);
}
