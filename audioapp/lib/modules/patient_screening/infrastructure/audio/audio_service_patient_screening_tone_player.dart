import '../../../../core/constants/app_constants.dart';
import '../../../../services/audio/audio_service.dart';
import '../../domain/services/patient_screening_tone_player.dart';

class AudioServicePatientScreeningTonePlayer
    implements PatientScreeningTonePlayer {
  AudioServicePatientScreeningTonePlayer(this._audioService);

  final AudioService _audioService;

  @override
  Future<void> dispose() => _audioService.dispose();

  @override
  Future<void> initialize() => _audioService.initialize();

  @override
  Future<void> playTone({
    required int frequency,
    required int intensityDbHl,
    required Ear ear,
    int durationMs = 1500,
  }) {
    return _audioService.playTone(
      frequency: frequency,
      intensityDbHl: intensityDbHl,
      ear: ear,
      durationMs: durationMs,
    );
  }

  @override
  Future<void> stopTone() => _audioService.stopTone();
}
