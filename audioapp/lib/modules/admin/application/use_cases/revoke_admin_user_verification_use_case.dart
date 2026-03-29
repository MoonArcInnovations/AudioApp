import '../../../../core/application/use_case.dart';
import '../../domain/repositories/admin_user_repository.dart';

class RevokeAdminUserVerificationUseCase implements UseCase<void, String> {
  const RevokeAdminUserVerificationUseCase(this._repository);

  final AdminUserRepository _repository;

  @override
  Future<void> call(String params) async {
    final user = await _repository.getUserById(params);
    if (user == null) {
      throw StateError('User not found: $params');
    }
    return _repository.updateUser(
      user.copyWith(isVerified: false, verifiedAt: null, verifiedBy: null),
    );
  }
}
