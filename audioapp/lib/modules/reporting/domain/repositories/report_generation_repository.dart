import '../../../ai_review/domain/entities/ai_recommendation_record.dart';
import '../../../clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';

abstract interface class ReportGenerationRepository {
  Future<List<int>> generateTestReport(
    ClinicianTestRecord test,
    ClinicianPatientRecord patient,
  );

  Future<List<int>> generateCombinedReport({
    required ClinicianPatientRecord patient,
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
    AiRecommendationRecord? ai,
    List<AiRecommendationRecord> aiHistory,
  });
}
