import '../../../../services/security/audit_service.dart';

abstract interface class AiAuditRepository {
  Future<List<AuditLogEntry>> getRecentAiLogs({int limit});
}
