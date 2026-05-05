import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/audiogram_chart.dart';
import '../entities/clinician_test_record.dart';
import 'pta_calculator.dart';

class TestResultFactory {
  TestResultFactory({required PtaCalculator ptaCalculator, Uuid? uuid})
    : _ptaCalculator = ptaCalculator,
      _uuid = uuid ?? const Uuid();

  final PtaCalculator _ptaCalculator;
  final Uuid _uuid;

  ClinicianTestRecord create({
    required String patientId,
    required String audiologistId,
    required DateTime testDate,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? testType,
    String? screeningId,
    String? headphoneModel,
    double? ambientNoiseDb,
    String? notes,
    String? recommendations,
  }) {
    final rightPta = _ptaCalculator.calculate(rightEarResults);
    final leftPta = _ptaCalculator.calculate(leftEarResults);

    return ClinicianTestRecord(
      id: _uuid.v4(),
      patientId: patientId,
      audiologistId: audiologistId,
      testDate: testDate,
      testType: testType,
      screeningId: screeningId,
      headphoneModel: headphoneModel,
      ambientNoiseDb: ambientNoiseDb,
      rightEarResults: rightEarResults,
      leftEarResults: leftEarResults,
      rightPta: rightPta,
      leftPta: leftPta,
      rightClassification: AudiogramClassification.getClassification(rightPta),
      leftClassification: AudiogramClassification.getClassification(leftPta),
      notes: notes,
      recommendations: recommendations,
      isComplete: true,
      synced: false,
    );
  }
}
