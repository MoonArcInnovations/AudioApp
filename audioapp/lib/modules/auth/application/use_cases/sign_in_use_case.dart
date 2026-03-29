import '../../../../core/application/use_case.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCase<AppUser, SignInParams> {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  @override
  Future<AppUser> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}
