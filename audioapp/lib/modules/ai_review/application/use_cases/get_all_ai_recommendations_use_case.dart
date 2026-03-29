import '../../../../core/application/use_case.dart';
import '../../domain/entities/ai_recommendation_record.dart';
import '../../domain/repositories/ai_review_repository.dart';

class GetAllAiRecommendationsUseCase
    implements UseCase<List<AiRecommendationRecord>, NoParams> {
  const GetAllAiRecommendationsUseCase(this._repository);

  final AiReviewRepository _repository;

  @override
  Future<List<AiRecommendationRecord>> call(NoParams params) {
    return _repository.getAll();
  }
}
