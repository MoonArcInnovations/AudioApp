import '../../../../core/application/use_case.dart';
import '../../domain/repositories/report_audit_repository.dart';
import '../../domain/repositories/report_delivery_repository.dart';
import 'generate_report_for_test_use_case.dart';

class ShareReportForTestUseCase
    implements UseCase<void, GenerateReportForTestParams> {
  const ShareReportForTestUseCase({
    required GenerateReportForTestUseCase generateReportForTestUseCase,
    required ReportDeliveryRepository deliveryRepository,
    required ReportAuditRepository auditRepository,
  }) : _generateReportForTestUseCase = generateReportForTestUseCase,
       _deliveryRepository = deliveryRepository,
       _auditRepository = auditRepository;

  final GenerateReportForTestUseCase _generateReportForTestUseCase;
  final ReportDeliveryRepository _deliveryRepository;
  final ReportAuditRepository _auditRepository;

  @override
  Future<void> call(GenerateReportForTestParams params) async {
    final report = await _generateReportForTestUseCase(params);
    await _deliveryRepository.shareReport(report);
    await _auditRepository.logReportExport(
      resourceType: 'test_result',
      resourceId: params.test.id,
      exportFormat: 'pdf_share',
    );
  }
}
