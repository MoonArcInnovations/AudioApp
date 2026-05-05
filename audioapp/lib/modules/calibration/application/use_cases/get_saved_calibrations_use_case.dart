import '../../../../core/application/use_case.dart';
import '../../domain/repositories/calibration_repository.dart';

class GetSavedCalibrationsUseCase
    implements UseCase<Map<int, double>, NoParams> {
  GetSavedCalibrationsUseCase(this._repository);

  final CalibrationRepository _repository;

  @override
  Future<Map<int, double>> call(NoParams params) {
    return _repository.getSavedCalibrations();
  }
}
