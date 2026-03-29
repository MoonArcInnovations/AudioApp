import '../../../../core/application/use_case.dart';
import '../../domain/services/calibration_tone_player.dart';

class StopCalibrationToneUseCase implements UseCase<void, NoParams> {
  StopCalibrationToneUseCase(this._tonePlayer);

  final CalibrationTonePlayer _tonePlayer;

  @override
  Future<void> call(NoParams params) {
    return _tonePlayer.stopTone();
  }
}
