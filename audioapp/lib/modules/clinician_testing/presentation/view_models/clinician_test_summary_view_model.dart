import 'package:flutter/material.dart';

import '../../../../shared/widgets/audiogram_chart.dart';

class ClinicianTestSummaryViewModel {
  const ClinicianTestSummaryViewModel({
    required this.id,
    required this.patientId,
    required this.audiologistId,
    required this.testDate,
    required this.testType,
    required this.screeningId,
    required this.headphoneModel,
    required this.ambientNoiseDb,
    required this.rightEarResults,
    required this.leftEarResults,
    required this.rightPta,
    required this.leftPta,
    required this.rightClassification,
    required this.leftClassification,
    required this.overallClassification,
    required this.overallStatusColor,
    required this.notes,
    required this.recommendations,
  });

  final String id;
  final String patientId;
  final String audiologistId;
  final DateTime testDate;
  final String? testType;
  final String? screeningId;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final List<AudiogramPoint> rightEarResults;
  final List<AudiogramPoint> leftEarResults;
  final double rightPta;
  final double leftPta;
  final String rightClassification;
  final String leftClassification;
  final String overallClassification;
  final Color overallStatusColor;
  final String? notes;
  final String? recommendations;
}
