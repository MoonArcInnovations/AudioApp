import '../../../../shared/widgets/audiogram_chart.dart';

class PtaCalculator {
  const PtaCalculator();

  double calculate(
    List<AudiogramPoint> results, {
    List<int> frequencies = const [500, 1000, 2000, 4000],
  }) {
    final ptaValues = <int>[];

    for (final frequency in frequencies) {
      final point = results
          .where((value) => value.frequency == frequency && !value.noResponse)
          .firstOrNull;
      if (point != null) {
        ptaValues.add(point.thresholdDb);
      }
    }

    if (ptaValues.isEmpty) {
      return 0;
    }

    return ptaValues.reduce((a, b) => a + b) / ptaValues.length;
  }
}
