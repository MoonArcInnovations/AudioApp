class AiRecommendationRecord {
  const AiRecommendationRecord({
    required this.id,
    required this.testId,
    required this.modelVersion,
    required this.suggestionType,
    required this.confidence,
    required this.featuresJson,
    required this.createdAt,
    this.accepted,
    this.decisionBy,
    this.decisionAt,
    this.decisionNotes,
  });

  final String id;
  final String testId;
  final String modelVersion;
  final String suggestionType;
  final double confidence;
  final String featuresJson;
  final DateTime createdAt;
  final bool? accepted;
  final String? decisionBy;
  final DateTime? decisionAt;
  final String? decisionNotes;
}
