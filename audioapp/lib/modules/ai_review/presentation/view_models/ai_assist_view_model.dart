class AiAssistViewModel {
  const AiAssistViewModel({
    required this.anchorTestId,
    required this.suggestionType,
    required this.confidence,
    required this.accepted,
    this.rationale = const [],
    this.warnings = const [],
  });

  final String anchorTestId;
  final String suggestionType;
  final double confidence;
  final bool? accepted;
  final List<String> rationale;
  final List<String> warnings;
}
