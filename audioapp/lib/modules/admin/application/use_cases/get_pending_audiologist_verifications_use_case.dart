import '../../../../core/application/use_case.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../domain/repositories/admin_user_repository.dart';

class GetPendingAudiologistVerificationsUseCase
    implements UseCase<List<AdminUserRecord>, NoParams> {
  const GetPendingAudiologistVerificationsUseCase(this._repository);

  final AdminUserRepository _repository;

  @override
  Future<List<AdminUserRecord>> call(NoParams params) {
    return _repository.getPendingAudiologistVerifications();
  }
}
