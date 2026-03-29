import '../entities/clinician_test_record.dart';

class TestPairingResult {
  final ClinicianTestRecord ac;
  final ClinicianTestRecord bc;

  const TestPairingResult({required this.ac, required this.bc});

  String get anchorTestId => bc.id;
}

class TestPairingService {
  const TestPairingService();

  ClinicianTestRecord? findRelatedTest(
    ClinicianTestRecord current,
    List<ClinicianTestRecord> allTests,
  ) {
    final isBone = current.testType == 'bone';
    final targetTypes = isBone ? {'air', 'screening', null} : {'bone'};
    final related =
        allTests
            .where((value) => value.id != current.id)
            .where((value) => targetTypes.contains(value.testType))
            .toList()
          ..sort((a, b) => b.testDate.compareTo(a.testDate));

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
}
