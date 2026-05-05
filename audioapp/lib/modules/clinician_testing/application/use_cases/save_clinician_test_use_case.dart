import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../domain/repositories/clinician_test_repository.dart';

class SaveClinicianTestParams {
  final String patientId;
  final String audiologistId;
  final List<AudiogramPoint> rightEarResults;
  final List<AudiogramPoint> leftEarResults;
  final String? testType;
  final String? screeningId;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final String? notes;
  final String? recommendations;

  const SaveClinicianTestParams({
    required this.patientId,
    required this.audiologistId,
    required this.rightEarResults,
    required this.leftEarResults,
    this.testType,
    this.screeningId,
    this.headphoneModel,
    this.ambientNoiseDb,
    this.notes,
    this.recommendations,
  });
}

class SaveClinicianTestUseCase
    implements UseCase<ClinicianTestRecord, SaveClinicianTestParams> {
  const SaveClinicianTestUseCase(this._repository);

  final ClinicianTestRepository _repository;

  @override
  Future<ClinicianTestRecord> call(SaveClinicianTestParams params) {
    return _repository.saveTestResult(
      patientId: params.patientId,
      audiologistId: params.audiologistId,
      rightEarResults: params.rightEarResults,
      leftEarResults: params.leftEarResults,
      testType: params.testType,
      screeningId: params.screeningId,
      headphoneModel: params.headphoneModel,
      ambientNoiseDb: params.ambientNoiseDb,
      notes: params.notes,
      recommendations: params.recommendations,
    );
  }
}
