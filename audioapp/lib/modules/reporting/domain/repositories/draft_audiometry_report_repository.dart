import '../../../../shared/widgets/audiogram_chart.dart';

class DraftAudiometryReportData {
  const DraftAudiometryReportData({
    required this.patientName,
    required this.patientDob,
    required this.patientId,
    required this.audiologistName,
    required this.testDate,
    required this.rightEarResults,
    required this.leftEarResults,
    this.notes,
    this.recommendations,
  });

  final String patientName;
  final String patientDob;
  final String patientId;
  final String audiologistName;
  final DateTime testDate;
  final List<AudiogramPoint> rightEarResults;
  final List<AudiogramPoint> leftEarResults;
  final String? notes;
  final String? recommendations;
}

abstract interface class DraftAudiometryReportRepository {
  Future<void> previewDraft(DraftAudiometryReportData data);
}
