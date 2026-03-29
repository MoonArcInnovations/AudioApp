import '../../../../core/application/use_case.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../../clinician_testing/domain/services/test_pairing_service.dart';
import '../../domain/entities/ai_recommendation_record.dart';
import '../../domain/repositories/ai_review_repository.dart';

class GetOrCreateAiRecommendationForPairParams {
  final ClinicianTestRecord current;
  final List<ClinicianTestRecord> allTests;

  const GetOrCreateAiRecommendationForPairParams({
    required this.current,
    required this.allTests,
  });
}

class GetOrCreateAiRecommendationForPairUseCase
    implements
        UseCase<
          AiRecommendationRecord?,
          GetOrCreateAiRecommendationForPairParams
        > {
  const GetOrCreateAiRecommendationForPairUseCase({
    required AiReviewRepository repository,
    required TestPairingService pairingService,
  }) : _repository = repository,
       _pairingService = pairingService;

  final AiReviewRepository _repository;
  final TestPairingService _pairingService;

  @override
  Future<AiRecommendationRecord?> call(
    GetOrCreateAiRecommendationForPairParams params,
  ) async {
    final pair = _pairingService.resolvePair(params.current, params.allTests);
    if (pair == null) {
      return null;
    }

    return _repository.getOrCreateForTest(
      testId: pair.anchorTestId,
      ac: pair.ac,
      bc: pair.bc,
    );
  }
}
