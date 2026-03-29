import '../../../../services/security/audit_service.dart';
import '../../domain/repositories/report_audit_repository.dart';

class AuditReportRepository implements ReportAuditRepository {
  const AuditReportRepository();

  @override
  Future<void> logTestResultView(String testId) {
    return auditService.logTestResultView(testId);
  }

  @override
  Future<void> logReportExport({
    required String resourceType,
    required String resourceId,
    required String exportFormat,
  }) {
    return auditService.logReportExport(
      resourceType: resourceType,
      resourceId: resourceId,
      exportFormat: exportFormat,
    );
  }
}
