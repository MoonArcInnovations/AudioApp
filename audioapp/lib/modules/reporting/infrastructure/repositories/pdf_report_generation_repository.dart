import '../../../../services/pdf/pdf_report_service.dart';
import '../../../ai_review/domain/entities/ai_recommendation_record.dart';
import '../../../clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../domain/repositories/report_generation_repository.dart';

class PdfReportGenerationRepository implements ReportGenerationRepository {
  const PdfReportGenerationRepository(this._pdfReportService);

  final PdfReportService _pdfReportService;

  @override
  Future<List<int>> generateCombinedReport({
    required ClinicianPatientRecord patient,
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
    AiRecommendationRecord? ai,
    List<AiRecommendationRecord> aiHistory = const [],
  }) async {
    return _pdfReportService.generateCombinedReport(
      patient: patient,
      ac: ac,
      bc: bc,
      ai: ai,
      aiHistory: aiHistory,
    );
  }

  @override
  Future<List<int>> generateTestReport(
    ClinicianTestRecord test,
    ClinicianPatientRecord patient,
  ) async {
    return _pdfReportService.generateTestReport(test, patient);
  }
}
