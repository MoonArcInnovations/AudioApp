import '../../../../core/application/use_case.dart';
import '../../domain/services/patient_screening_tone_player.dart';

class StopScreeningToneUseCase implements UseCase<void, NoParams> {
  const StopScreeningToneUseCase(this._tonePlayer);

  final PatientScreeningTonePlayer _tonePlayer;

  @override
  Future<void> call(NoParams params) {
    return _tonePlayer.stopTone();
  }
}
