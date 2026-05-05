import '../../../../core/application/use_case.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<AppUser?, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser?> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
