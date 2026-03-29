import '../../../../core/application/use_case.dart';
import '../../domain/repositories/admin_audit_repository.dart';
import '../../domain/repositories/admin_user_repository.dart';

class VerifyAdminUserParams {
  const VerifyAdminUserParams({required this.userId});

  final String userId;
}

class VerifyAdminUserUseCase implements UseCase<void, VerifyAdminUserParams> {
  const VerifyAdminUserUseCase({
    required AdminUserRepository userRepository,
    required AdminAuditRepository auditRepository,
  }) : _userRepository = userRepository,
       _auditRepository = auditRepository;

  final AdminUserRepository _userRepository;
  final AdminAuditRepository _auditRepository;

  @override
  Future<void> call(VerifyAdminUserParams params) async {
    final user = await _userRepository.getUserById(params.userId);
    if (user == null) {
      throw StateError('User not found: ${params.userId}');
    }
    final updated = user.copyWith(isVerified: true, verifiedAt: DateTime.now());
    await _userRepository.updateUser(updated);
    await _auditRepository.logAudiologistVerified(user.id, user.email);
  }
}
