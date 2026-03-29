import '../entities/patient_screening_record.dart';

abstract interface class PatientScreeningRepository {
  Future<PatientScreeningRecord> saveScreeningResult({
    required String userId,
    required Map<String, int> rightEarThresholds,
    required Map<String, int> leftEarThresholds,
    required String headphoneModel,
    required double ambientNoiseDb,
  });

  Future<List<PatientScreeningRecord>> getScreeningHistory(String userId);

  Future<PatientScreeningRecord?> getScreeningById(String id);

  Future<List<PatientScreeningRecord>> getAllScreeningResults();

  Future<PatientScreeningRecord?> getLatestScreening(String userId);
}
