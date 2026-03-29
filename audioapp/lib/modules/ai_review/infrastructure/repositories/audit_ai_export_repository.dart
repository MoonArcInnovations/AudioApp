import '../../../../services/security/audit_service.dart';
import '../../domain/repositories/ai_export_audit_repository.dart';

class AuditAiExportRepository implements AiExportAuditRepository {
  const AuditAiExportRepository();

  @override
  Future<void> logAiExport({
    required String resourceId,
    required String exportFormat,
  }) {
    return auditService.logReportExport(
      resourceType: 'ai_recommendation',
      resourceId: resourceId,
      exportFormat: exportFormat,
    );
  }
}
