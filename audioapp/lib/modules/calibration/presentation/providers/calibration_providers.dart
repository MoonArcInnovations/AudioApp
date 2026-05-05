import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../application/use_cases/get_retspl_for_profile_use_case.dart';
import '../../application/use_cases/get_saved_calibrations_use_case.dart';
import '../../application/use_cases/play_calibration_tone_use_case.dart';
import '../../application/use_cases/save_calibration_correction_use_case.dart';
import '../../application/use_cases/stop_calibration_tone_use_case.dart';
import '../../domain/entities/headphone_profile.dart';
import '../../infrastructure/providers/calibration_infrastructure_providers.dart';
import '../controllers/headphone_calibration_controller.dart';
import '../controllers/manual_calibration_controller.dart';

final getSavedCalibrationsUseCaseProvider =
    Provider<GetSavedCalibrationsUseCase>((ref) {
      return GetSavedCalibrationsUseCase(
        ref.watch(calibrationRepositoryProvider),
      );
    });

final saveCalibrationCorrectionUseCaseProvider =
    Provider<SaveCalibrationCorrectionUseCase>((ref) {
      return SaveCalibrationCorrectionUseCase(
        ref.watch(calibrationRepositoryProvider),
      );
    });

final playCalibrationToneUseCaseProvider = Provider<PlayCalibrationToneUseCase>(
  (ref) {
    return PlayCalibrationToneUseCase(ref.watch(calibrationTonePlayerProvider));
  },
);

final stopCalibrationToneUseCaseProvider = Provider<StopCalibrationToneUseCase>(
  (ref) {
    return StopCalibrationToneUseCase(ref.watch(calibrationTonePlayerProvider));
  },
);

final getRetsplForProfileUseCaseProvider = Provider<GetRetsplForProfileUseCase>(
  (ref) {
    return GetRetsplForProfileUseCase(ref.watch(calibrationRepositoryProvider));
  },
);

final headphoneProfilesProvider = Provider<List<HeadphoneProfileDetails>>((
  ref,
) {
  return ref.watch(calibrationRepositoryProvider).getAllProfiles();
});

final savedCalibrationsProvider = FutureProvider<Map<int, double>>((ref) async {
  return ref.watch(getSavedCalibrationsUseCaseProvider)(const NoParams());
});

final retsplTableProvider =
    Provider.family<Map<int, double>, HeadphoneProfileType>((ref, profileType) {
      const frequencies = [250, 500, 1000, 2000, 4000, 8000];
      final getRetspl = ref.watch(getRetsplForProfileUseCaseProvider);
      return {
        for (final frequency in frequencies)
          frequency: getRetspl(
            GetRetsplForProfileParams(
              frequency: frequency,
              profileType: profileType,
            ),
          ),
      };
    });

final manualCalibrationControllerProvider =
    StateNotifierProvider<ManualCalibrationController, ManualCalibrationState>((
      ref,
    ) {
      return ManualCalibrationController(
        getSavedCalibrationsUseCase: ref.watch(
          getSavedCalibrationsUseCaseProvider,
        ),
        saveCalibrationCorrectionUseCase: ref.watch(
          saveCalibrationCorrectionUseCaseProvider,
        ),
        playCalibrationToneUseCase: ref.watch(
          playCalibrationToneUseCaseProvider,
        ),
        readCalibratorId: () =>
            ref.read(authStateProvider).user?.id ?? 'system',
        refreshSavedCalibrations: () {
          ref.invalidate(savedCalibrationsProvider);
        },
      );
    });

final headphoneCalibrationControllerProvider =
    StateNotifierProvider<
      HeadphoneCalibrationController,
      HeadphoneCalibrationState
    >((ref) {
      return HeadphoneCalibrationController(
        playCalibrationToneUseCase: ref.watch(
          playCalibrationToneUseCaseProvider,
        ),
        stopCalibrationToneUseCase: ref.watch(
          stopCalibrationToneUseCaseProvider,
        ),
      );
    });
