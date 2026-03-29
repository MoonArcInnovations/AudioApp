import '../../../../shared/widgets/audiogram_chart.dart';
import '../entities/clinician_test_record.dart';

abstract interface class ClinicianTestRepository {
  Future<List<ClinicianTestRecord>> getAllTestResultsForAudiologist(
    String audiologistId,
  );

  Future<List<ClinicianTestRecord>> getTestsForPatient(String patientId);

  Future<ClinicianTestRecord> saveTestResult({
    required String patientId,
    required String audiologistId,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? testType,
    String? screeningId,
    String? headphoneModel,
    double? ambientNoiseDb,
    String? notes,
    String? recommendations,
  });

  Future<void> updateTestResult(ClinicianTestRecord test);

  Future<void> deleteTestResult(String testId);
}
