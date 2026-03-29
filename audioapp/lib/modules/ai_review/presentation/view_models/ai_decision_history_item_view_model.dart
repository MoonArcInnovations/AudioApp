class AiDecisionHistoryItemViewModel {
  const AiDecisionHistoryItemViewModel({
    required this.testId,
    required this.patientId,
    required this.testDate,
    required this.suggestionType,
    required this.confidence,
    required this.accepted,
  });

  final String testId;
  final String patientId;
  final DateTime testDate;
  final String suggestionType;
  final double confidence;
  final bool? accepted;

  String get decisionLabel {
    if (accepted == null) {
      return 'Pending';
    }
    return accepted! ? 'Accepted' : 'Overridden';
  }
}
