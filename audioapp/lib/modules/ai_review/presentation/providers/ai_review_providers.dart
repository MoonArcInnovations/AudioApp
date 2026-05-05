import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../services/security/audit_service.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../../clinician_testing/infrastructure/providers/clinician_testing_infrastructure_providers.dart';
import '../../../clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../application/use_cases/ai_decision_export_params.dart';
import '../../application/use_cases/get_ai_audit_logs_use_case.dart';
import '../../application/use_cases/get_ai_recommendation_for_test_use_case.dart';
import '../../application/use_cases/get_all_ai_recommendations_use_case.dart';
import '../../application/use_cases/get_or_create_ai_recommendation_for_pair_use_case.dart';
import '../../application/use_cases/share_ai_decision_csv_use_case.dart';
import '../../application/use_cases/share_ai_decision_pdf_use_case.dart';
import '../../application/use_cases/update_ai_decision_use_case.dart';
import '../../domain/entities/ai_recommendation_record.dart';
import '../../infrastructure/providers/ai_review_infrastructure_providers.dart';
import '../view_models/ai_assist_view_model.dart';
import '../view_models/ai_decision_history_item_view_model.dart';

final getAiRecommendationForTestUseCaseProvider =
    Provider<GetAiRecommendationForTestUseCase>((ref) {
      return GetAiRecommendationForTestUseCase(
        ref.watch(aiReviewRepositoryProvider),
      );
    });

final getAllAiRecommendationsUseCaseProvider =
    Provider<GetAllAiRecommendationsUseCase>((ref) {
      return GetAllAiRecommendationsUseCase(
        ref.watch(aiReviewRepositoryProvider),
      );
    });

final getOrCreateAiRecommendationForPairUseCaseProvider =
    Provider<GetOrCreateAiRecommendationForPairUseCase>((ref) {
      return GetOrCreateAiRecommendationForPairUseCase(
        repository: ref.watch(aiReviewRepositoryProvider),
        pairingService: ref.watch(aiReviewPairingServiceProvider),
      );
    });

final updateAiDecisionUseCaseProvider = Provider<UpdateAiDecisionUseCase>((
  ref,
) {
  return UpdateAiDecisionUseCase(ref.watch(aiReviewRepositoryProvider));
});

final getAiAuditLogsUseCaseProvider = Provider<GetAiAuditLogsUseCase>((ref) {
  return GetAiAuditLogsUseCase(ref.watch(aiAuditRepositoryProvider));
});

final shareAiDecisionCsvUseCaseProvider = Provider<ShareAiDecisionCsvUseCase>((
  ref,
) {
  return ShareAiDecisionCsvUseCase(
    aiReviewRepository: ref.watch(aiReviewRepositoryProvider),
    clinicianTestRepository: ref.watch(clinicianTestRepositoryProvider),
    aiExportRepository: ref.watch(aiExportRepositoryProvider),
    aiExportDeliveryRepository: ref.watch(aiExportDeliveryRepositoryProvider),
    aiExportAuditRepository: ref.watch(aiExportAuditRepositoryProvider),
  );
});

final shareAiDecisionPdfUseCaseProvider = Provider<ShareAiDecisionPdfUseCase>((
  ref,
) {
  return ShareAiDecisionPdfUseCase(
    aiReviewRepository: ref.watch(aiReviewRepositoryProvider),
    clinicianTestRepository: ref.watch(clinicianTestRepositoryProvider),
    aiExportRepository: ref.watch(aiExportRepositoryProvider),
    aiExportDeliveryRepository: ref.watch(aiExportDeliveryRepositoryProvider),
    aiExportAuditRepository: ref.watch(aiExportAuditRepositoryProvider),
  );
});

final aiRecommendationByTestProvider =
    FutureProvider.family<AiRecommendationRecord?, String>((ref, testId) {
      return ref.watch(getAiRecommendationForTestUseCaseProvider)(testId);
    });

final allAiRecommendationsProvider =
    FutureProvider<List<AiRecommendationRecord>>((ref) {
      return ref.watch(getAllAiRecommendationsUseCaseProvider)(
        const NoParams(),
      );
    });

final aiDecisionHistoryItemsProvider =
    FutureProvider<List<AiDecisionHistoryItemViewModel>>((ref) async {
      final recommendations = await ref.watch(
        allAiRecommendationsProvider.future,
      );
      final tests = ref.watch(clinicianTestResultsProvider);
      final testsById = {for (final test in tests) test.id: test};

      return recommendations
          .map((recommendation) {
            final test = testsById[recommendation.testId];
            if (test == null) {
              return null;
            }
            return AiDecisionHistoryItemViewModel(
              testId: recommendation.testId,
              patientId: test.patientId,
              testDate: test.testDate,
              suggestionType: recommendation.suggestionType,
              confidence: recommendation.confidence,
              accepted: recommendation.accepted,
            );
          })
          .whereType<AiDecisionHistoryItemViewModel>()
          .toList();
    });

class AiDecisionHistoryItemsForTestsRequest {
  const AiDecisionHistoryItemsForTestsRequest({required this.testIds});

  final List<String> testIds;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AiDecisionHistoryItemsForTestsRequest ||
        other.testIds.length != testIds.length) {
      return false;
    }
    for (var i = 0; i < testIds.length; i++) {
      if (other.testIds[i] != testIds[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(testIds);
}

final aiDecisionHistoryItemsForTestsProvider =
    FutureProvider.family<
      List<AiDecisionHistoryItemViewModel>,
      AiDecisionHistoryItemsForTestsRequest
    >((ref, request) async {
      if (request.testIds.isEmpty) {
        return const [];
      }
      final items = await ref.watch(aiDecisionHistoryItemsProvider.future);
      final testIds = request.testIds.toSet();
      return items.where((item) => testIds.contains(item.testId)).toList();
    });

final aiAssistForTestProvider = FutureProvider.family
    .autoDispose<AiAssistViewModel?, String>((ref, testId) async {
      final tests = ref.watch(clinicianTestResultsProvider);
      final current = tests.where((value) => value.id == testId).firstOrNull;
      if (current == null) {
        return null;
      }

      final recommendation =
          await ref.watch(getOrCreateAiRecommendationForPairUseCaseProvider)(
            GetOrCreateAiRecommendationForPairParams(
              current: current,
              allTests: tests,
            ),
          );
      if (recommendation == null) {
        return null;
      }

      final pair = ref
          .watch(aiReviewPairingServiceProvider)
          .resolvePair(current, tests);
      if (pair == null) {
        return null;
      }

      return AiAssistViewModel(
        anchorTestId: pair.anchorTestId,
        suggestionType: recommendation.suggestionType,
        confidence: recommendation.confidence,
        accepted: recommendation.accepted,
        rationale: recommendation.rationale,
        warnings: recommendation.warnings,
      );
    });

final aiAuditLogsProvider = FutureProvider<List<AuditLogEntry>>((ref) {
  return ref.watch(getAiAuditLogsUseCaseProvider)(200);
});

class AiRecommendationForPairRequest {
  const AiRecommendationForPairRequest({
    required this.current,
    required this.allTests,
  });

  final ClinicianTestRecord current;
  final List<ClinicianTestRecord> allTests;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AiRecommendationForPairRequest ||
        current.id != other.current.id ||
        allTests.length != other.allTests.length) {
      return false;
    }

    for (var i = 0; i < allTests.length; i++) {
      if (allTests[i].id != other.allTests[i].id) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hash(
    current.id,
    Object.hashAll(allTests.map((value) => value.id)),
  );
}

class AiRecommendationsForTestsRequest {
  const AiRecommendationsForTestsRequest({required this.testIds});

  final List<String> testIds;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AiRecommendationsForTestsRequest ||
        testIds.length != other.testIds.length) {
      return false;
    }

    for (var i = 0; i < testIds.length; i++) {
      if (testIds[i] != other.testIds[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(testIds);
}

final aiRecommendationForPairProvider = FutureProvider.family
    .autoDispose<AiRecommendationRecord?, AiRecommendationForPairRequest>((
      ref,
      request,
    ) {
      return ref.watch(getOrCreateAiRecommendationForPairUseCaseProvider)(
        GetOrCreateAiRecommendationForPairParams(
          current: request.current,
          allTests: request.allTests,
        ),
      );
    });

final aiRecommendationsForTestsProvider =
    FutureProvider.family<
      List<AiRecommendationRecord>,
      AiRecommendationsForTestsRequest
    >((ref, request) async {
      if (request.testIds.isEmpty) {
        return const [];
      }

      final allRecommendations = await ref.watch(
        getAllAiRecommendationsUseCaseProvider,
      )(const NoParams());
      final testIds = request.testIds.toSet();
      return allRecommendations
          .where((recommendation) => testIds.contains(recommendation.testId))
          .toList();
    });

final aiAuditLogsByLimitProvider =
    FutureProvider.family<List<AuditLogEntry>, int>((ref, limit) {
      return ref.watch(getAiAuditLogsUseCaseProvider)(limit);
    });

final sharePatientAiDecisionCsvProvider =
    Provider.family<Future<int> Function(AiDecisionExportParams), Object?>((
      ref,
      _,
    ) {
      return (params) {
        return ref.read(shareAiDecisionCsvUseCaseProvider)(params);
      };
    });

final sharePatientAiDecisionPdfProvider =
    Provider.family<Future<int> Function(AiDecisionExportParams), Object?>((
      ref,
      _,
    ) {
      return (params) {
        return ref.read(shareAiDecisionPdfUseCaseProvider)(params);
      };
    });
