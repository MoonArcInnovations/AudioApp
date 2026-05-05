import '../../../../shared/widgets/audiogram_chart.dart';
import '../entities/clinician_test_record.dart';

class TestPairingResult {
  final ClinicianTestRecord ac;
  final ClinicianTestRecord bc;

  const TestPairingResult({required this.ac, required this.bc});

  String get anchorTestId => bc.id;
}

class TestPairingService {
  const TestPairingService();

  static const maxPairAge = Duration(days: 30);

  ClinicianTestRecord? findRelatedTest(
    ClinicianTestRecord current,
    List<ClinicianTestRecord> allTests,
  ) {
    final isBone = current.testType == 'bone';
    final targetTypes = isBone ? {'air', 'screening', null} : {'bone'};
    final related =
        allTests
            .where((value) => value.id != current.id)
            .where((value) => value.patientId == current.patientId)
            .where((value) => targetTypes.contains(value.testType))
            .where((value) => _withinPairWindow(current, value))
            .where((value) => _hasOverlappingFrequencies(current, value))
            .toList()
          ..sort(
            (a, b) =>
                _timeDistance(current, a).compareTo(_timeDistance(current, b)),
          );

    return related.isNotEmpty ? related.first : null;
  }

  TestPairingResult? resolvePair(
    ClinicianTestRecord current,
    List<ClinicianTestRecord> allTests,
  ) {
    final related = findRelatedTest(current, allTests);
    if (related == null) {
      return null;
    }

    final ac = current.testType == 'bone' ? related : current;
    final bc = current.testType == 'bone' ? current : related;

    if (ac.testType == 'bone' || bc.testType != 'bone') {
      return null;
    }

    return TestPairingResult(ac: ac, bc: bc);
  }

  bool _withinPairWindow(ClinicianTestRecord a, ClinicianTestRecord b) {
    return _timeDistance(a, b) <= maxPairAge;
  }

  Duration _timeDistance(ClinicianTestRecord a, ClinicianTestRecord b) {
    final difference = a.testDate.difference(b.testDate);
    return difference.isNegative
        ? Duration(microseconds: -difference.inMicroseconds)
        : difference;
  }

  bool _hasOverlappingFrequencies(
    ClinicianTestRecord current,
    ClinicianTestRecord candidate,
  ) {
    final rightCurrent = _frequencies(current.rightEarResults);
    final leftCurrent = _frequencies(current.leftEarResults);
    final rightCandidate = _frequencies(candidate.rightEarResults);
    final leftCandidate = _frequencies(candidate.leftEarResults);

    final rightOverlap = rightCurrent.intersection(rightCandidate).length;
    final leftOverlap = leftCurrent.intersection(leftCandidate).length;
    return rightOverlap >= 2 || leftOverlap >= 2;
  }

  Set<int> _frequencies(List<AudiogramPoint> points) {
    return {
      for (final point in points)
        if (!point.noResponse) point.frequency,
    };
  }
}
