import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/use_cases/get_all_screenings_use_case.dart';
import '../../application/use_cases/get_latest_screening_use_case.dart';
import '../../application/use_cases/play_screening_tone_use_case.dart';
import '../../application/use_cases/get_screening_by_id_use_case.dart';
import '../../application/use_cases/get_screening_history_use_case.dart';
import '../../application/use_cases/save_screening_result_use_case.dart';
import '../../application/use_cases/stop_screening_tone_use_case.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../infrastructure/providers/patient_screening_infrastructure_providers.dart';
import '../controllers/screening_test_controller.dart';
import '../view_models/screening_summary_view_model.dart';

final saveScreeningResultUseCaseProvider = Provider<SaveScreeningResultUseCase>(
  (ref) {
    return SaveScreeningResultUseCase(
      ref.watch(patientScreeningRepositoryProvider),
    );
  },
);

final playScreeningToneUseCaseProvider = Provider<PlayScreeningToneUseCase>((
  ref,
) {
  return PlayScreeningToneUseCase(
    ref.watch(patientScreeningTonePlayerProvider),
  );
});

final stopScreeningToneUseCaseProvider = Provider<StopScreeningToneUseCase>((
  ref,
) {
  return StopScreeningToneUseCase(
    ref.watch(patientScreeningTonePlayerProvider),
  );
});

final getScreeningHistoryUseCaseProvider = Provider<GetScreeningHistoryUseCase>(
  (ref) {
    return GetScreeningHistoryUseCase(
      ref.watch(patientScreeningRepositoryProvider),
    );
  },
);

final getLatestScreeningUseCaseProvider = Provider<GetLatestScreeningUseCase>((
  ref,
) {
  return GetLatestScreeningUseCase(
    ref.watch(patientScreeningRepositoryProvider),
  );
});

final getScreeningByIdUseCaseProvider = Provider<GetScreeningByIdUseCase>((
  ref,
) {
  return GetScreeningByIdUseCase(ref.watch(patientScreeningRepositoryProvider));
});

final getAllScreeningsUseCaseProvider = Provider<GetAllScreeningsUseCase>((
  ref,
) {
  return GetAllScreeningsUseCase(ref.watch(patientScreeningRepositoryProvider));
});

final _screeningHistoryProvider =
    FutureProvider.family<List<PatientScreeningRecord>, String>((ref, userId) {
      return ref.watch(getScreeningHistoryUseCaseProvider)(userId);
    });

final _latestScreeningProvider =
    FutureProvider.family<PatientScreeningRecord?, String>((ref, userId) {
      return ref.watch(getLatestScreeningUseCaseProvider)(userId);
    });

final _screeningByIdProvider =
    FutureProvider.family<PatientScreeningRecord?, String>((ref, id) {
      return ref.watch(getScreeningByIdUseCaseProvider)(id);
    });

ScreeningSummaryViewModel _toScreeningSummaryViewModel(
  PatientScreeningRecord model,
) {
  return ScreeningSummaryViewModel(
    id: model.id,
    result: model.result,
    testDate: model.testDate,
    thresholds: model.thresholds,
    headphoneModel: model.headphoneModel,
    ambientNoiseDb: model.ambientNoiseDb,
  );
}

final screeningHistorySummaryProvider =
    FutureProvider.family<List<ScreeningSummaryViewModel>, String>((
      ref,
      userId,
    ) {
      return ref
          .watch(_screeningHistoryProvider(userId).future)
          .then(
            (results) => results.map(_toScreeningSummaryViewModel).toList(),
          );
    });

final latestScreeningSummaryProvider =
    FutureProvider.family<ScreeningSummaryViewModel?, String>((ref, userId) {
      return ref
          .watch(_latestScreeningProvider(userId).future)
          .then(
            (result) =>
                result == null ? null : _toScreeningSummaryViewModel(result),
          );
    });

final screeningByIdSummaryProvider =
    FutureProvider.family<ScreeningSummaryViewModel?, String>((ref, id) {
      return ref
          .watch(_screeningByIdProvider(id).future)
          .then(
            (result) =>
                result == null ? null : _toScreeningSummaryViewModel(result),
          );
    });

final screeningTestControllerProvider = StateNotifierProvider.autoDispose
    .family<
      ScreeningTestController,
      ScreeningTestState,
      ScreeningSessionConfig
    >((ref, config) {
      return ScreeningTestController(
        playScreeningToneUseCase: ref.watch(playScreeningToneUseCaseProvider),
        stopScreeningToneUseCase: ref.watch(stopScreeningToneUseCaseProvider),
      );
    });
