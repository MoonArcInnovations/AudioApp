import '../../../../core/application/use_case.dart';
import '../../domain/entities/ai_recommendation_record.dart';
import '../../domain/repositories/ai_review_repository.dart';

class GetAiRecommendationForTestUseCase
    implements UseCase<AiRecommendationRecord?, String> {
  const GetAiRecommendationForTestUseCase(this._repository);

  final AiReviewRepository _repository;

  @override
  Future<AiRecommendationRecord?> call(String params) {
    return _repository.getForTest(params);
  }
}
