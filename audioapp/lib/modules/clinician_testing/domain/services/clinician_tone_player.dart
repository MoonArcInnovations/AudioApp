import '../../../../core/constants/app_constants.dart';

abstract interface class ClinicianTonePlayer {
  Future<void> initialize();

  Future<void> playTone({
    required int frequency,
    required int intensityDbHl,
    required Ear ear,
    int durationMs,
  });

  Future<void> stopTone();

  Future<void> dispose();
}
