import '../../../../core/application/use_case.dart';
import '../../domain/repositories/admin_audit_repository.dart';
import '../../domain/repositories/admin_user_repository.dart';

class DeleteAdminUserUseCase implements UseCase<void, String> {
  const DeleteAdminUserUseCase({
    required AdminUserRepository userRepository,
    required AdminAuditRepository auditRepository,
  }) : _userRepository = userRepository,
       _auditRepository = auditRepository;

  final AdminUserRepository _userRepository;
  final AdminAuditRepository _auditRepository;

  @override
  Future<void> call(String params) async {
    final user = await _userRepository.getUserById(params);
    if (user == null) {
      throw StateError('User not found: $params');
    }
    await _userRepository.deleteUser(user.id);
    await _auditRepository.logUserDeleted(user.id, user.email);
  }
}
