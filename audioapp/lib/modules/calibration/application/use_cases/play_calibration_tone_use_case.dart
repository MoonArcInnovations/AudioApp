import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/services/calibration_tone_player.dart';

class PlayCalibrationToneParams {
  const PlayCalibrationToneParams({
    required this.frequency,
    required this.intensityDbHl,
    required this.ear,
    required this.durationMs,
  });

  final int frequency;
  final int intensityDbHl;
  final Ear ear;
  final int durationMs;
}

class PlayCalibrationToneUseCase
    implements UseCase<void, PlayCalibrationToneParams> {
  PlayCalibrationToneUseCase(this._tonePlayer);

  final CalibrationTonePlayer _tonePlayer;

  @override
  Future<void> call(PlayCalibrationToneParams params) {
    return _tonePlayer.playTone(
      frequency: params.frequency,
      intensityDbHl: params.intensityDbHl,
      ear: params.ear,
      durationMs: params.durationMs,
    );
  }
}
