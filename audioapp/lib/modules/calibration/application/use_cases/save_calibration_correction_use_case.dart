import '../../../../core/application/use_case.dart';
import '../../domain/repositories/calibration_repository.dart';

class SaveCalibrationCorrectionParams {
  const SaveCalibrationCorrectionParams({
    required this.frequency,
    required this.correction,
    required this.calibratedBy,
    this.headphoneProfileId,
    this.notes,
  });

  final int frequency;
  final double correction;
  final String calibratedBy;
  final String? headphoneProfileId;
  final String? notes;
}

class SaveCalibrationCorrectionUseCase
    implements UseCase<void, SaveCalibrationCorrectionParams> {
  SaveCalibrationCorrectionUseCase(this._repository);

  final CalibrationRepository _repository;

  @override
  Future<void> call(SaveCalibrationCorrectionParams params) {
    return _repository.saveCalibrationCorrection(
      frequency: params.frequency,
      correction: params.correction,
      calibratedBy: params.calibratedBy,
      headphoneProfileId: params.headphoneProfileId,
      notes: params.notes,
    );
  }
}
