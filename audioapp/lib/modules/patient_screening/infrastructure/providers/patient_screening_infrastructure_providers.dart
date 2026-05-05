import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../../../services/app_initialization_service.dart';
import '../../../../services/audio/audio_service.dart';
import '../../domain/repositories/patient_screening_repository.dart';
import '../../domain/services/patient_screening_tone_player.dart';
import '../../domain/services/screening_result_analyzer.dart';
import '../audio/audio_service_patient_screening_tone_player.dart';
import '../repositories/local_patient_screening_repository.dart';

final screeningAnalyzerProvider = Provider<ScreeningResultAnalyzer>((ref) {
  return const ScreeningResultAnalyzer();
});

final screeningDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

final patientScreeningTonePlayerProvider = Provider<PatientScreeningTonePlayer>(
  (ref) {
    final player = AudioServicePatientScreeningTonePlayer(AudioService());
    player.initialize();
    ref.onDispose(() {
      player.dispose();
    });
    return player;
  },
);

final patientScreeningRepositoryProvider = Provider<PatientScreeningRepository>(
  (ref) {
    return LocalPatientScreeningRepository(
      database: ref.watch(screeningDatabaseProvider),
      analyzer: ref.watch(screeningAnalyzerProvider),
    );
  },
);
