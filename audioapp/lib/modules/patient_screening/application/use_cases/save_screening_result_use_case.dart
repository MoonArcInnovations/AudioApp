import '../../../../core/application/use_case.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../domain/repositories/patient_screening_repository.dart';

class SaveScreeningResultParams {
  final String userId;
  final Map<String, int> rightEarThresholds;
  final Map<String, int> leftEarThresholds;
  final String headphoneModel;
  final double ambientNoiseDb;

  const SaveScreeningResultParams({
    required this.userId,
    required this.rightEarThresholds,
    required this.leftEarThresholds,
    required this.headphoneModel,
    required this.ambientNoiseDb,
  });
}

class SaveScreeningResultUseCase
    implements UseCase<PatientScreeningRecord, SaveScreeningResultParams> {
  final PatientScreeningRepository _repository;

  const SaveScreeningResultUseCase(this._repository);

  @override
  Future<PatientScreeningRecord> call(SaveScreeningResultParams params) {
    return _repository.saveScreeningResult(
      userId: params.userId,
      rightEarThresholds: params.rightEarThresholds,
      leftEarThresholds: params.leftEarThresholds,
      headphoneModel: params.headphoneModel,
      ambientNoiseDb: params.ambientNoiseDb,
    );
  }
}
