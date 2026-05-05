class ScreeningSummaryViewModel {
  const ScreeningSummaryViewModel({
    required this.id,
    required this.result,
    required this.testDate,
    required this.thresholds,
    required this.headphoneModel,
    required this.ambientNoiseDb,
  });

  final String id;
  final String result;
  final DateTime testDate;
  final Map<String, int> thresholds;
  final String? headphoneModel;
  final double? ambientNoiseDb;

  double averageThresholdForEar(String prefix) {
    final values = thresholds.entries
        .where((entry) => entry.key.startsWith(prefix))
        .map((entry) => entry.value)
        .toList();
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((left, right) => left + right) / values.length;
  }

  double get averageThreshold {
    final values = thresholds.values.toList();
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((left, right) => left + right) / values.length;
  }
}
