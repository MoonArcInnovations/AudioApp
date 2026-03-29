import '../../domain/entities/headphone_profile.dart';
import '../../domain/repositories/calibration_repository.dart';

class GetRetsplForProfileParams {
  const GetRetsplForProfileParams({
    required this.frequency,
    required this.profileType,
  });

  final int frequency;
  final HeadphoneProfileType profileType;
}

class GetRetsplForProfileUseCase {
  GetRetsplForProfileUseCase(this._repository);

  final CalibrationRepository _repository;

  double call(GetRetsplForProfileParams params) {
    return _repository.getRetspl(params.frequency, params.profileType);
  }
}
