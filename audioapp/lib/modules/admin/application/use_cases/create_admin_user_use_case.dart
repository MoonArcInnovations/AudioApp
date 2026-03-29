import '../../../../core/application/use_case.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../domain/repositories/admin_audit_repository.dart';
import '../../domain/repositories/admin_user_repository.dart';

class CreateAdminUserParams {
  const CreateAdminUserParams({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;
}

class CreateAdminUserUseCase
    implements UseCase<AdminUserRecord, CreateAdminUserParams> {
  const CreateAdminUserUseCase({
    required AdminUserRepository userRepository,
    required AdminAuditRepository auditRepository,
  }) : _userRepository = userRepository,
       _auditRepository = auditRepository;

  final AdminUserRepository _userRepository;
  final AdminAuditRepository _auditRepository;

  @override
  Future<AdminUserRecord> call(CreateAdminUserParams params) async {
    final user = AdminUserRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: params.email,
      name: params.name,
      role: params.role,
      createdAt: DateTime.now(),
    );
    await _userRepository.createUser(user);
    await _auditRepository.logUserCreated(user.id, user.email);
    return user;
  }
}
