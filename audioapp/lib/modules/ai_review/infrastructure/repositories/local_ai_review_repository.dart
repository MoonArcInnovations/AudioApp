import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart'
    show AiRecommendation, AiRecommendationsCompanion, AppDatabase;
import '../../../../services/ai/ai_inference_service.dart';
import '../../../../services/security/audit_service.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../domain/entities/ai_recommendation_record.dart';
import '../../domain/repositories/ai_review_repository.dart';

class LocalAiReviewRepository implements AiReviewRepository {
  LocalAiReviewRepository(this._database);

  final AppDatabase _database;
  final AiInferenceService _ai = AiInferenceService();

  AiRecommendationRecord _toRecord(AiRecommendation recommendation) {
    return AiRecommendationRecord(
      id: recommendation.id,
      testId: recommendation.testId,
      modelVersion: recommendation.modelVersion,
      suggestionType: recommendation.suggestionType,
      confidence: recommendation.confidence,
      featuresJson: recommendation.featuresJson,
      createdAt: recommendation.createdAt,
      accepted: recommendation.accepted,
      decisionBy: recommendation.decisionBy,
      decisionAt: recommendation.decisionAt,
      decisionNotes: recommendation.decisionNotes,
    );
  }

  @override
  Future<List<AiRecommendationRecord>> getAll() async {
    final recommendations = await _database
        .select(_database.aiRecommendations)
        .get();
    return recommendations.map(_toRecord).toList();
  }

  @override
  Future<AiRecommendationRecord?> getForTest(String testId) async {
    final result = await (_database.select(
      _database.aiRecommendations,
    )..where((value) => value.testId.equals(testId))).getSingleOrNull();
    return result == null ? null : _toRecord(result);
  }

  @override
  Future<AiRecommendationRecord> getOrCreateForTest({
    required String testId,
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) async {
    final existing = await getForTest(testId);
    if (existing != null) {
      return existing;
    }

    final inference = _ai.analyze(ac: ac, bc: bc);
    final suggestionType = inference['type']?.toString() ?? 'unknown';
    final confidence = (inference['confidence'] as num?)?.toDouble() ?? 0.0;
    final modelVersion = inference['modelVersion']?.toString() ?? 'rules-0.2';
    final featuresJson = jsonEncode({
      'features': inference['features'] ?? {},
      'severity': inference['severity'] ?? {},
      'rationale': inference['rationale'] ?? const <String>[],
      'warnings': inference['warnings'] ?? const <String>[],
      'notes': inference['notes'],
    });
    final id = 'ai_${DateTime.now().millisecondsSinceEpoch}';

    final companion = AiRecommendationsCompanion.insert(
      id: id,
      testId: testId,
      modelVersion: modelVersion,
      suggestionType: suggestionType,
      confidence: confidence,
      featuresJson: featuresJson,
      createdAt: DateTime.now(),
      accepted: const Value.absent(),
      decisionBy: const Value.absent(),
      decisionAt: const Value.absent(),
      decisionNotes: const Value.absent(),
    );

    await _database.into(_database.aiRecommendations).insert(companion);
    return (await getForTest(testId))!;
  }

  @override
  Future<void> updateDecision({
    required String testId,
    required bool accepted,
    required String decisionBy,
    String? notes,
  }) async {
    await (_database.update(
      _database.aiRecommendations,
    )..where((value) => value.testId.equals(testId))).write(
      AiRecommendationsCompanion(
        accepted: Value(accepted),
        decisionBy: Value(decisionBy),
        decisionAt: Value(DateTime.now()),
        decisionNotes: Value(notes),
      ),
    );

    await auditService.logAiDecision(
      testId: testId,
      accepted: accepted,
      notes: notes,
    );
  }
}
