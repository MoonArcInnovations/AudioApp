import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUserParams {
  final String email;
  final String password;
  final String name;
  final UserRole role;

  const RegisterUserParams({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}

class RegisterUserUseCase implements UseCase<AppUser, RegisterUserParams> {
  final AuthRepository _repository;

  const RegisterUserUseCase(this._repository);

  @override
  Future<AppUser> call(RegisterUserParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      role: params.role,
    );
  }
}
