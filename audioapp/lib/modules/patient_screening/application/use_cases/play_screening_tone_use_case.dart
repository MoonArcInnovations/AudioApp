import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/services/patient_screening_tone_player.dart';

class PlayScreeningToneParams {
  const PlayScreeningToneParams({
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

class PlayScreeningToneUseCase
    implements UseCase<void, PlayScreeningToneParams> {
  const PlayScreeningToneUseCase(this._tonePlayer);

  final PatientScreeningTonePlayer _tonePlayer;

  @override
  Future<void> call(PlayScreeningToneParams params) {
    return _tonePlayer.playTone(
      frequency: params.frequency,
      intensityDbHl: params.intensityDbHl,
      ear: params.ear,
      durationMs: params.durationMs,
    );
  }
}
