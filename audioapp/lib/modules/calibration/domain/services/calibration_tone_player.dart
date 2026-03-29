import '../../../../core/constants/app_constants.dart';

abstract interface class CalibrationTonePlayer {
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
