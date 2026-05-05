import '../../../../core/application/use_case.dart';
import '../../domain/repositories/admin_user_repository.dart';

class UpdateAdminUserParams {
  const UpdateAdminUserParams({
    required this.userId,
    required this.name,
    required this.email,
  });

  final String userId;
  final String name;
  final String email;
}

class UpdateAdminUserUseCase implements UseCase<void, UpdateAdminUserParams> {
  const UpdateAdminUserUseCase(this._repository);

  final AdminUserRepository _repository;

  @override
  Future<void> call(UpdateAdminUserParams params) async {
    final user = await _repository.getUserById(params.userId);
    if (user == null) {
      throw StateError('User not found: ${params.userId}');
    }
    return _repository.updateUser(
      user.copyWith(name: params.name, email: params.email),
    );
  }
}
