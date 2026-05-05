import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';

class FeatureExtractor {
  Map<String, dynamic> extract({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    final acRight = _thresholdMap(ac.rightEarResults);
    final acLeft = _thresholdMap(ac.leftEarResults);
    final bcRight = _thresholdMap(bc.rightEarResults);
    final bcLeft = _thresholdMap(bc.leftEarResults);

    final rightGap = _computeGap(acRight, bcRight);
    final leftGap = _computeGap(acLeft, bcLeft);
    final warnings = _qualityWarnings(
      ac: ac,
      bc: bc,
      rightGap: rightGap,
      leftGap: leftGap,
    );

    return {
      'acRight': acRight,
      'acLeft': acLeft,
      'bcRight': bcRight,
      'bcLeft': bcLeft,
      'acRightNoResponse': _noResponseFrequencies(ac.rightEarResults),
      'acLeftNoResponse': _noResponseFrequencies(ac.leftEarResults),
      'bcRightNoResponse': _noResponseFrequencies(bc.rightEarResults),
      'bcLeftNoResponse': _noResponseFrequencies(bc.leftEarResults),
      'bcRightMasking': _maskingMap(bc.rightEarResults),
      'bcLeftMasking': _maskingMap(bc.leftEarResults),
      'airBoneGapRight': rightGap,
      'airBoneGapLeft': leftGap,
      'airBoneGapMaxDb': _maxGap(rightGap, leftGap),
      'rightPta': ac.rightPta,
      'leftPta': ac.leftPta,
      'boneRightPta': _pta(bc.rightEarResults),
      'boneLeftPta': _pta(bc.leftEarResults),
      'overlapFrequencyCount': rightGap.length + leftGap.length,
      'qualityWarnings': warnings,
      'testDate': ac.testDate.toIso8601String(),
      'boneTestDate': bc.testDate.toIso8601String(),
    };
  }

  Map<int, int> _thresholdMap(List<AudiogramPoint> points) {
    return {
      for (final p in points.where((point) => !point.noResponse))
        p.frequency: p.thresholdDb,
    };
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

  List<int> _noResponseFrequencies(List<AudiogramPoint> points) {
    return points
        .where((point) => point.noResponse)
        .map((point) => point.frequency)
        .toList()
      ..sort();
  }

  Map<int, int> _maskingMap(List<AudiogramPoint> points) {
    return {
      for (final point in points.where((point) => point.masked))
        point.frequency: point.maskingLevel ?? 0,
    };
  }

  double _pta(List<AudiogramPoint> points) {
    const ptaFrequencies = [500, 1000, 2000, 4000];
    final values = points
        .where(
          (point) =>
              ptaFrequencies.contains(point.frequency) && !point.noResponse,
        )
        .map((point) => point.thresholdDb)
        .toList();
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a + b) / values.length;
  }

  List<String> _qualityWarnings({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
    required Map<int, int> rightGap,
    required Map<int, int> leftGap,
  }) {
    final warnings = <String>[];
    if (rightGap.length < 2 && leftGap.length < 2) {
      warnings.add('Limited overlapping AC/BC frequencies for interpretation.');
    }
    if (_noResponseFrequencies(ac.rightEarResults).isNotEmpty ||
        _noResponseFrequencies(ac.leftEarResults).isNotEmpty ||
        _noResponseFrequencies(bc.rightEarResults).isNotEmpty ||
        _noResponseFrequencies(bc.leftEarResults).isNotEmpty) {
      warnings.add(
        'No-response values present; interpretation confidence reduced.',
      );
    }
    final unmaskedBcCount = [
      ...bc.rightEarResults,
      ...bc.leftEarResults,
    ].where((point) => !point.noResponse && !point.masked).length;
    if (unmaskedBcCount > 0) {
      warnings.add('Some BC thresholds have no recorded masking metadata.');
    }
    if (ac.ambientNoiseDb != null && ac.ambientNoiseDb! > 40) {
      warnings.add('AC ambient noise was elevated (${ac.ambientNoiseDb} dB).');
    }
    return warnings;
  }
}
