import '../../../../core/application/use_case.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../domain/repositories/admin_user_repository.dart';

class GetAllAdminUsersUseCase
    implements UseCase<List<AdminUserRecord>, NoParams> {
  const GetAllAdminUsersUseCase(this._repository);

  final AdminUserRepository _repository;

  @override
  Future<List<AdminUserRecord>> call(NoParams params) {
    return _repository.getAllUsers();
  }
}
