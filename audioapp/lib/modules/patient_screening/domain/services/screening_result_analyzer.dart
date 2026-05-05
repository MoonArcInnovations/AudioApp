import '../value_objects/screening_outcome.dart';

class ScreeningResultAnalyzer {
  const ScreeningResultAnalyzer();

  ScreeningOutcome analyze({
    required Map<String, int> rightEarThresholds,
    required Map<String, int> leftEarThresholds,
  }) {
    final allThresholds = [
      ...rightEarThresholds.values,
      ...leftEarThresholds.values,
    ];

    if (allThresholds.isEmpty) {
      return ScreeningOutcome.incomplete;
    }

    final maxThreshold = allThresholds.reduce((a, b) => a > b ? a : b);
    final avgThreshold =
        allThresholds.reduce((a, b) => a + b) / allThresholds.length;

    if (maxThreshold > 40 || avgThreshold > 30) {
      return ScreeningOutcome.refer;
    }

    if (maxThreshold > 25 || avgThreshold > 20) {
      return ScreeningOutcome.borderline;
    }

    return ScreeningOutcome.pass;
  }
}
