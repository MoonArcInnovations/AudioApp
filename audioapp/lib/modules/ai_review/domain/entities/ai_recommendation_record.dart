import 'dart:convert';

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

  Map<String, dynamic> get payload {
    try {
      final decoded = jsonDecode(featuresJson);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return const {};
    }
    return const {};
  }

  List<String> get rationale => _stringList(payload['rationale']);

  List<String> get warnings => _stringList(payload['warnings']);

  Map<String, dynamic> get severity {
    final value = payload['severity'];
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const {};
  }

  List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
