import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart';
import '../../../../services/app_initialization_service.dart';
import '../../../../services/audio/audio_service.dart';
import '../../domain/repositories/calibration_repository.dart';
import '../../domain/services/calibration_tone_player.dart';
import '../audio/audio_service_calibration_tone_player.dart';
import '../repositories/local_calibration_repository.dart';

final calibrationDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

final calibrationRepositoryProvider = Provider<CalibrationRepository>((ref) {
  return LocalCalibrationRepository(ref.watch(calibrationDatabaseProvider));
});

final calibrationTonePlayerProvider = Provider<CalibrationTonePlayer>((ref) {
  final player = AudioServiceCalibrationTonePlayer(AudioService());
  player.initialize();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});
