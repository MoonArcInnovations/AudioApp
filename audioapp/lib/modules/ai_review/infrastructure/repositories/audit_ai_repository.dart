import '../../../../services/security/audit_service.dart';
import '../../domain/repositories/ai_audit_repository.dart';

class AuditAiRepository implements AiAuditRepository {
  const AuditAiRepository();

  @override
  Future<List<AuditLogEntry>> getRecentAiLogs({int limit = 200}) async {
    final logs = await auditService.getRecentLogs(limit: limit);
    return logs
        .where((value) => value.resourceType == 'ai_recommendation')
        .toList();
  }
}
