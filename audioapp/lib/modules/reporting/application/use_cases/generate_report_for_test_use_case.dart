import '../../../../core/application/use_case.dart';
import '../../../ai_review/domain/repositories/ai_review_repository.dart';
import '../../../ai_review/domain/entities/ai_recommendation_record.dart';
import '../../../clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../../clinician_testing/domain/services/test_pairing_service.dart';
import '../../domain/entities/report_document.dart';
import '../../domain/repositories/report_generation_repository.dart';

class GenerateReportForTestParams {
  final ClinicianTestRecord test;
  final ClinicianPatientRecord patient;
  final List<ClinicianTestRecord> patientTests;

  const GenerateReportForTestParams({
    required this.test,
    required this.patient,
    required this.patientTests,
  });
}

class GenerateReportForTestUseCase
    implements UseCase<ReportDocument, GenerateReportForTestParams> {
  const GenerateReportForTestUseCase({
    required ReportGenerationRepository reportRepository,
    required AiReviewRepository aiReviewRepository,
    required TestPairingService pairingService,
  }) : _reportRepository = reportRepository,
       _aiReviewRepository = aiReviewRepository,
       _pairingService = pairingService;

  final ReportGenerationRepository _reportRepository;
  final AiReviewRepository _aiReviewRepository;
  final TestPairingService _pairingService;

  @override
  Future<ReportDocument> call(GenerateReportForTestParams params) async {
    final pair = _pairingService.resolvePair(params.test, params.patientTests);
    if (pair != null) {
      final aiRec = await _aiReviewRepository.getForTest(pair.anchorTestId);
      final aiHistory = aiRec != null
          ? <AiRecommendationRecord>[aiRec]
          : const <AiRecommendationRecord>[];
      final bytes = await _reportRepository.generateCombinedReport(
        patient: params.patient,
        ac: pair.ac,
        bc: pair.bc,
        ai: aiRec,
        aiHistory: aiHistory,
      );

      return ReportDocument(
        bytes: bytes,
        fileName: 'Combined_Report_${params.patient.name}.pdf',
      );
    }

    final bytes = await _reportRepository.generateTestReport(
      params.test,
      params.patient,
    );
    return ReportDocument(
      bytes: bytes,
      fileName: 'Report_${params.patient.name}.pdf',
    );
  }
}
