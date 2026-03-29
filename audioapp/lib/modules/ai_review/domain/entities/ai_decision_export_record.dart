class AiDecisionExportRecord {
  const AiDecisionExportRecord({
    required this.testId,
    required this.patientId,
    required this.testDateIso,
    required this.suggestionType,
    required this.confidence,
    required this.decision,
    this.decisionAtIso,
  });

  final String testId;
  final String patientId;
  final String testDateIso;
  final String suggestionType;
  final double confidence;
  final String decision;
  final String? decisionAtIso;
}
