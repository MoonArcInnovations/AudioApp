import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../entities/ai_recommendation_record.dart';

abstract interface class AiReviewRepository {
  Future<AiRecommendationRecord?> getForTest(String testId);

  Future<List<AiRecommendationRecord>> getAll();

  Future<AiRecommendationRecord> getOrCreateForTest({
    required String testId,
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  });

  Future<void> updateDecision({
    required String testId,
    required bool accepted,
    required String decisionBy,
    String? notes,
  });
}
