import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai_review/infrastructure/providers/ai_review_infrastructure_providers.dart';
import '../../../clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../clinician_testing/infrastructure/providers/clinician_testing_infrastructure_providers.dart';
import '../../application/use_cases/generate_report_for_test_use_case.dart';
import '../../application/use_cases/log_test_result_view_use_case.dart';
import '../../application/use_cases/preview_draft_audiometry_report_use_case.dart';
import '../../application/use_cases/preview_report_for_test_use_case.dart';
import '../../application/use_cases/share_report_for_test_use_case.dart';
import '../../domain/repositories/report_audit_repository.dart';
import '../../domain/repositories/report_delivery_repository.dart';
import '../../infrastructure/providers/reporting_infrastructure_providers.dart';
import '../../infrastructure/repositories/audit_report_repository.dart';
import '../../infrastructure/repositories/printing_report_delivery_repository.dart';

final reportAuditRepositoryProvider = Provider<ReportAuditRepository>((ref) {
  return const AuditReportRepository();
});

final reportDeliveryRepositoryProvider = Provider<ReportDeliveryRepository>((
  ref,
) {
  return const PrintingReportDeliveryRepository();
});

final generateReportForTestUseCaseProvider =
    Provider<GenerateReportForTestUseCase>((ref) {
      return GenerateReportForTestUseCase(
        reportRepository: ref.watch(reportGenerationRepositoryProvider),
        aiReviewRepository: ref.watch(aiReviewRepositoryProvider),
        pairingService: ref.watch(testPairingServiceProvider),
      );
    });

final logTestResultViewUseCaseProvider = Provider<LogTestResultViewUseCase>((
  ref,
) {
  return LogTestResultViewUseCase(ref.watch(reportAuditRepositoryProvider));
});

final previewReportForTestUseCaseProvider =
    Provider<PreviewReportForTestUseCase>((ref) {
      return PreviewReportForTestUseCase(
        generateReportForTestUseCase: ref.watch(
          generateReportForTestUseCaseProvider,
        ),
        deliveryRepository: ref.watch(reportDeliveryRepositoryProvider),
        auditRepository: ref.watch(reportAuditRepositoryProvider),
      );
    });

final shareReportForTestUseCaseProvider = Provider<ShareReportForTestUseCase>((
  ref,
) {
  return ShareReportForTestUseCase(
    generateReportForTestUseCase: ref.watch(
      generateReportForTestUseCaseProvider,
    ),
    deliveryRepository: ref.watch(reportDeliveryRepositoryProvider),
    auditRepository: ref.watch(reportAuditRepositoryProvider),
  );
});

final previewDraftAudiometryReportUseCaseProvider =
    Provider<PreviewDraftAudiometryReportUseCase>((ref) {
      return PreviewDraftAudiometryReportUseCase(
        ref.watch(draftAudiometryReportRepositoryProvider),
      );
    });

final previewSavedTestReportProvider = Provider<Future<void> Function(String)>((
  ref,
) {
  return (testId) async {
    final test = ref.read(clinicianTestByIdProvider(testId));
    if (test == null) {
      throw Exception('Test not found');
    }
    final patient = ref.read(clinicianPatientProvider(test.patientId));
    if (patient == null) {
      throw Exception('Patient not found');
    }
    final patientTests = ref.read(
      clinicianPatientTestsProvider(test.patientId),
    );
    await ref.read(previewReportForTestUseCaseProvider)(
      GenerateReportForTestParams(
        test: test,
        patient: patient,
        patientTests: patientTests,
      ),
    );
  };
});

final shareSavedTestReportProvider = Provider<Future<void> Function(String)>((
  ref,
) {
  return (testId) async {
    final test = ref.read(clinicianTestByIdProvider(testId));
    if (test == null) {
      throw Exception('Test not found');
    }
    final patient = ref.read(clinicianPatientProvider(test.patientId));
    if (patient == null) {
      throw Exception('Patient not found');
    }
    final patientTests = ref.read(
      clinicianPatientTestsProvider(test.patientId),
    );
    await ref.read(shareReportForTestUseCaseProvider)(
      GenerateReportForTestParams(
        test: test,
        patient: patient,
        patientTests: patientTests,
      ),
    );
  };
});
