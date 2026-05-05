import '../../../../services/pdf/pdf_report_service.dart';
import '../../domain/repositories/draft_audiometry_report_repository.dart';

class PdfDraftAudiometryReportRepository
    implements DraftAudiometryReportRepository {
  const PdfDraftAudiometryReportRepository(this._pdfReportService);

  final PdfReportService _pdfReportService;

  @override
  Future<void> previewDraft(DraftAudiometryReportData data) {
    return _pdfReportService.previewReport(
      patientName: data.patientName,
      patientDob: data.patientDob,
      patientId: data.patientId,
      audiologistName: data.audiologistName,
      testDate: data.testDate,
      rightEarResults: data.rightEarResults,
      leftEarResults: data.leftEarResults,
      notes: data.notes,
      recommendations: data.recommendations,
    );
  }
}
