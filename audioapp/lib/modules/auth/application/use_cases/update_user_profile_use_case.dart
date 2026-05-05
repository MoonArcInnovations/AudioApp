import '../../../../core/application/use_case.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class UpdateUserProfileParams {
  const UpdateUserProfileParams({
    required this.user,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
  });

  final AppUser user;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;
}

class UpdateUserProfileUseCase
    implements UseCase<AppUser, UpdateUserProfileParams> {
  const UpdateUserProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser> call(UpdateUserProfileParams params) {
    return _repository.updateProfile(
      user: params.user,
      name: params.name,
      phoneNumber: params.phoneNumber,
      avatarUrl: params.avatarUrl,
    );
  }
}
