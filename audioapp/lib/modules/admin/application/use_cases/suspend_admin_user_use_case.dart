import '../../../../core/application/use_case.dart';
import '../../domain/repositories/admin_audit_repository.dart';
import '../../domain/repositories/admin_user_repository.dart';

class SuspendAdminUserParams {
  const SuspendAdminUserParams({required this.userId, required this.reason});

  final String userId;
  final String reason;
}

class SuspendAdminUserUseCase implements UseCase<void, SuspendAdminUserParams> {
  const SuspendAdminUserUseCase({
    required AdminUserRepository userRepository,
    required AdminAuditRepository auditRepository,
  }) : _userRepository = userRepository,
       _auditRepository = auditRepository;

  final AdminUserRepository _userRepository;
  final AdminAuditRepository _auditRepository;

  @override
  Future<void> call(SuspendAdminUserParams params) async {
    final user = await _userRepository.getUserById(params.userId);
    if (user == null) {
      throw StateError('User not found: ${params.userId}');
    }
    final updated = user.copyWith(
      isSuspended: true,
      suspensionReason: params.reason,
    );
    await _userRepository.updateUser(updated);
    await _auditRepository.logUserSuspended(user.id, user.email, params.reason);
  }
}
