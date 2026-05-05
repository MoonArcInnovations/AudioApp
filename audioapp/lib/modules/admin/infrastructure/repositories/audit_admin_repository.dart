import '../../../../services/security/audit_service.dart';
import '../../domain/repositories/admin_audit_repository.dart';

class AuditAdminRepository implements AdminAuditRepository {
  const AuditAdminRepository();

  @override
  Future<void> logAudiologistVerified(String userId, String email) {
    return auditService.logAudiologistVerified(userId, email);
  }

  @override
  Future<void> logUserCreated(String userId, String email) {
    return auditService.logUserCreated(userId, email);
  }

  @override
  Future<void> logUserDeleted(String userId, String email) {
    return auditService.logUserDeleted(userId, email);
  }

  @override
  Future<void> logUserSuspended(String userId, String email, String reason) {
    return auditService.logUserSuspended(userId, email, reason);
  }
}
