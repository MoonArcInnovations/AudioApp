import 'package:flutter/material.dart';

import '../../../../shared/widgets/audiogram_chart.dart';

class ClinicianTestRecord {
  const ClinicianTestRecord({
    required this.id,
    required this.patientId,
    required this.audiologistId,
    required this.testDate,
    required this.rightEarResults,
    required this.leftEarResults,
    required this.rightPta,
    required this.leftPta,
    required this.rightClassification,
    required this.leftClassification,
    this.testType,
    this.screeningId,
    this.headphoneModel,
    this.ambientNoiseDb,
    this.notes,
    this.recommendations,
    this.isComplete = true,
    this.synced = false,
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
  final String? notes;
  final String? recommendations;
  final bool isComplete;
  final bool synced;

  Color get overallStatusColor {
    final maxPta = rightPta > leftPta ? rightPta : leftPta;
    return AudiogramClassification.getClassificationColor(maxPta);
  }

  String get overallClassification {
    final maxPta = rightPta > leftPta ? rightPta : leftPta;
    return AudiogramClassification.getClassification(maxPta);
  }

  ClinicianTestRecord copyWith({
    String? id,
    String? patientId,
    String? audiologistId,
    DateTime? testDate,
    String? testType,
    String? screeningId,
    String? headphoneModel,
    double? ambientNoiseDb,
    List<AudiogramPoint>? rightEarResults,
    List<AudiogramPoint>? leftEarResults,
    double? rightPta,
    double? leftPta,
    String? rightClassification,
    String? leftClassification,
    String? notes,
    String? recommendations,
    bool? isComplete,
    bool? synced,
  }) {
    return ClinicianTestRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      audiologistId: audiologistId ?? this.audiologistId,
      testDate: testDate ?? this.testDate,
      testType: testType ?? this.testType,
      screeningId: screeningId ?? this.screeningId,
      headphoneModel: headphoneModel ?? this.headphoneModel,
      ambientNoiseDb: ambientNoiseDb ?? this.ambientNoiseDb,
      rightEarResults: rightEarResults ?? this.rightEarResults,
      leftEarResults: leftEarResults ?? this.leftEarResults,
      rightPta: rightPta ?? this.rightPta,
      leftPta: leftPta ?? this.leftPta,
      rightClassification: rightClassification ?? this.rightClassification,
      leftClassification: leftClassification ?? this.leftClassification,
      notes: notes ?? this.notes,
      recommendations: recommendations ?? this.recommendations,
      isComplete: isComplete ?? this.isComplete,
      synced: synced ?? this.synced,
    );
  }
}
