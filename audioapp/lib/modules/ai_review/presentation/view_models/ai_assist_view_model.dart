class AiAssistViewModel {
  const AiAssistViewModel({
    required this.anchorTestId,
    required this.suggestionType,
    required this.confidence,
    required this.accepted,
  });

  final String anchorTestId;
  final String suggestionType;
  final double confidence;
  final bool? accepted;
}
