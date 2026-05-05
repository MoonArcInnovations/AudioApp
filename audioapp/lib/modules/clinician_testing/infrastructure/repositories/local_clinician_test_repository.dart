import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../domain/repositories/clinician_test_repository.dart';
import '../../domain/services/test_result_factory.dart';

class LocalClinicianTestRepository implements ClinicianTestRepository {
  const LocalClinicianTestRepository({
    required AppDatabase database,
    required TestResultFactory testResultFactory,
  }) : _database = database,
       _testResultFactory = testResultFactory;

  final AppDatabase _database;
  final TestResultFactory _testResultFactory;

  @override
  Future<List<ClinicianTestRecord>> getAllTestResultsForAudiologist(
    String audiologistId,
  ) async {
    return _database.getAllClinicianTestsForAudiologist(audiologistId);
  }

  @override
  Future<List<ClinicianTestRecord>> getTestsForPatient(String patientId) async {
    return _database.getClinicianTestsForPatient(patientId);
  }

  @override
  Future<void> deleteTestResult(String testId) {
    return _database.deleteTestResult(testId);
  }

  @override
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
  }) async {
    final result = _testResultFactory.create(
      patientId: patientId,
      audiologistId: audiologistId,
      testDate: DateTime.now(),
      rightEarResults: rightEarResults,
      leftEarResults: leftEarResults,
      testType: testType ?? 'air',
      screeningId: screeningId,
      headphoneModel: headphoneModel,
      ambientNoiseDb: ambientNoiseDb,
      notes: notes,
      recommendations: recommendations,
    );

    await _database.upsertClinicianTestResult(result, synced: false);
    return result;
  }

  @override
  Future<void> updateTestResult(ClinicianTestRecord test) {
    return _database.upsertClinicianTestResult(test, synced: false);
  }
}
