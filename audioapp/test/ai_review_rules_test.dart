import 'package:audioapp/core/constants/app_constants.dart';
import 'package:audioapp/modules/clinician_testing/domain/entities/clinician_test_record.dart';
import 'package:audioapp/modules/clinician_testing/domain/services/test_pairing_service.dart';
import 'package:audioapp/services/ai/ai_inference_service.dart';
import 'package:audioapp/shared/widgets/audiogram_chart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiInferenceService rules engine', () {
    test(
      'classifies conductive pattern from normal BC and significant ABG',
      () {
        final ac = _testRecord(
          id: 'ac',
          type: 'air',
          right: const [35, 40, 45, 45],
          left: const [20, 20, 20, 20],
        );
        final bc = _testRecord(
          id: 'bc',
          type: 'bone',
          right: const [10, 15, 20, 20],
          left: const [15, 15, 15, 15],
          masked: true,
        );

        final result = AiInferenceService().analyze(ac: ac, bc: bc);

        expect(result['type'], 'conductive');
        expect(result['modelVersion'], 'rules-0.2');
        expect(result['confidence'], greaterThan(0.70));
        expect(result['rationale'], isNotEmpty);
      },
    );

    test(
      'reduces confidence and warns when no-response values are present',
      () {
        final ac = _testRecord(
          id: 'ac',
          type: 'air',
          right: const [35, 40, 45, 45],
          left: const [20, 20, 20, 20],
          rightNoResponse: const {4000},
        );
        final bc = _testRecord(
          id: 'bc',
          type: 'bone',
          right: const [10, 15, 20, 20],
          left: const [15, 15, 15, 15],
          masked: true,
        );

        final result = AiInferenceService().analyze(ac: ac, bc: bc);

        expect(result['warnings'].toString(), contains('No-response'));
        expect(result['confidence'], lessThan(0.86));
      },
    );
  });

  group('TestPairingService', () {
    test('pairs closest opposite test for same patient within date window', () {
      final current = _testRecord(id: 'bc', type: 'bone');
      final closest = _testRecord(
        id: 'ac-close',
        type: 'air',
        date: current.testDate.subtract(const Duration(days: 1)),
      );
      final stale = _testRecord(
        id: 'ac-stale',
        type: 'air',
        date: current.testDate.subtract(const Duration(days: 45)),
      );
      final otherPatient = _testRecord(
        id: 'ac-other',
        patientId: 'other',
        type: 'air',
        date: current.testDate.subtract(const Duration(hours: 1)),
      );

      final pair = const TestPairingService().resolvePair(current, [
        closest,
        stale,
        otherPatient,
      ]);

      expect(pair?.ac.id, 'ac-close');
      expect(pair?.bc.id, 'bc');
    });
  });
}

ClinicianTestRecord _testRecord({
  required String id,
  String patientId = 'patient-1',
  String type = 'air',
  DateTime? date,
  List<int> right = const [20, 20, 20, 20],
  List<int> left = const [20, 20, 20, 20],
  Set<int> rightNoResponse = const {},
  bool masked = false,
}) {
  final testDate = date ?? DateTime(2026, 1, 10);
  final rightPoints = _points(
    Ear.right,
    right,
    noResponse: rightNoResponse,
    masked: masked,
  );
  final leftPoints = _points(Ear.left, left, masked: masked);
  final rightPta = right.reduce((a, b) => a + b) / right.length;
  final leftPta = left.reduce((a, b) => a + b) / left.length;

  return ClinicianTestRecord(
    id: id,
    patientId: patientId,
    audiologistId: 'audio-1',
    testDate: testDate,
    testType: type,
    rightEarResults: rightPoints,
    leftEarResults: leftPoints,
    rightPta: rightPta,
    leftPta: leftPta,
    rightClassification: 'Normal',
    leftClassification: 'Normal',
  );
}

List<AudiogramPoint> _points(
  Ear ear,
  List<int> thresholds, {
  Set<int> noResponse = const {},
  bool masked = false,
}) {
  const frequencies = [500, 1000, 2000, 4000];
  return [
    for (var i = 0; i < frequencies.length; i++)
      AudiogramPoint(
        frequency: frequencies[i],
        thresholdDb: thresholds[i],
        ear: ear,
        noResponse: noResponse.contains(frequencies[i]),
        masked: masked,
        maskingLevel: masked ? 40 : null,
        maskingEar: masked ? (ear == Ear.right ? Ear.left : Ear.right) : null,
      ),
  ];
}
