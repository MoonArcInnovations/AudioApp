import '../../../../core/application/use_case.dart';
import '../../domain/repositories/ai_review_repository.dart';

class UpdateAiDecisionParams {
  final String testId;
  final bool accepted;
  final String decisionBy;
  final String? notes;

  const UpdateAiDecisionParams({
    required this.testId,
    required this.accepted,
    required this.decisionBy,
    this.notes,
  });
}

class UpdateAiDecisionUseCase implements UseCase<void, UpdateAiDecisionParams> {
  const UpdateAiDecisionUseCase(this._repository);

  final AiReviewRepository _repository;

  @override
  Future<void> call(UpdateAiDecisionParams params) {
    return _repository.updateDecision(
      testId: params.testId,
      accepted: params.accepted,
      decisionBy: params.decisionBy,
      notes: params.notes,
    );
  }
}
