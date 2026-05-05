import '../../../../core/application/use_case.dart';
import '../../domain/repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.signOut();
  }
}
