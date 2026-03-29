import '../../../../core/application/use_case.dart';
import '../../../../services/security/audit_service.dart';
import '../../domain/repositories/ai_audit_repository.dart';

class GetAiAuditLogsUseCase implements UseCase<List<AuditLogEntry>, int> {
  const GetAiAuditLogsUseCase(this._repository);

  final AiAuditRepository _repository;

  @override
  Future<List<AuditLogEntry>> call(int params) {
    return _repository.getRecentAiLogs(limit: params);
  }
}
