import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../../../services/app_initialization_service.dart';
import '../../../../services/audio/audio_service.dart';
import '../../domain/repositories/clinician_bc_import_repository.dart';
import '../../domain/repositories/clinician_patient_repository.dart';
import '../../domain/repositories/clinician_test_repository.dart';
import '../../domain/services/clinician_tone_player.dart';
import '../../domain/services/pta_calculator.dart';
import '../../domain/services/test_pairing_service.dart';
import '../../domain/services/test_result_factory.dart';
import '../audio/audio_service_tone_player.dart';
import '../repositories/local_clinician_bc_import_repository.dart';
import '../repositories/local_clinician_patient_repository.dart';
import '../repositories/local_clinician_test_repository.dart';

final clinicianDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

final clinicianTonePlayerProvider = Provider<ClinicianTonePlayer>((ref) {
  return AudioServiceTonePlayer(AudioService());
});

final ptaCalculatorProvider = Provider<PtaCalculator>((ref) {
  return const PtaCalculator();
});

final clinicianTestResultFactoryProvider = Provider<TestResultFactory>((ref) {
  return TestResultFactory(ptaCalculator: ref.watch(ptaCalculatorProvider));
});

final testPairingServiceProvider = Provider<TestPairingService>((ref) {
  return const TestPairingService();
});

final clinicianPatientRepositoryProvider = Provider<ClinicianPatientRepository>(
  (ref) {
    return LocalClinicianPatientRepository(
      ref.watch(clinicianDatabaseProvider),
    );
  },
);

final clinicianTestRepositoryProvider = Provider<ClinicianTestRepository>((
  ref,
) {
  return LocalClinicianTestRepository(
    database: ref.watch(clinicianDatabaseProvider),
    testResultFactory: ref.watch(clinicianTestResultFactoryProvider),
  );
});

final clinicianBcImportRepositoryProvider =
    Provider<ClinicianBcImportRepository>((ref) {
      return LocalClinicianBcImportRepository(
        database: ref.watch(clinicianDatabaseProvider),
        testResultFactory: ref.watch(clinicianTestResultFactoryProvider),
      );
    });
