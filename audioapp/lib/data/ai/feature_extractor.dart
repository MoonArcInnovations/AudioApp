import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';

class FeatureExtractor {
  Map<String, dynamic> extract({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    final acRight = _toMap(ac.rightEarResults);
    final acLeft = _toMap(ac.leftEarResults);
    final bcRight = _toMap(bc.rightEarResults);
    final bcLeft = _toMap(bc.leftEarResults);

    final rightGap = _computeGap(acRight, bcRight);
    final leftGap = _computeGap(acLeft, bcLeft);

    return {
      'acRight': acRight,
      'acLeft': acLeft,
      'bcRight': bcRight,
      'bcLeft': bcLeft,
      'airBoneGapRight': rightGap,
      'airBoneGapLeft': leftGap,
      'airBoneGapMaxDb': _maxGap(rightGap, leftGap),
      'rightPta': ac.rightPta,
      'leftPta': ac.leftPta,
      'testDate': ac.testDate.toIso8601String(),
    };
  }

  Map<int, int> _toMap(List<AudiogramPoint> points) {
    return {for (final p in points) p.frequency: p.thresholdDb};
  }

  Map<int, int> _computeGap(Map<int, int> ac, Map<int, int> bc) {
    final result = <int, int>{};
    for (final freq in ac.keys) {
      if (bc.containsKey(freq)) {
        result[freq] = ac[freq]! - bc[freq]!;
      }
    }
    return result;
  }

  int _maxGap(Map<int, int> right, Map<int, int> left) {
    final values = [...right.values, ...left.values];
    if (values.isEmpty) return 0;
    values.sort();
    return values.last;
  }
}
