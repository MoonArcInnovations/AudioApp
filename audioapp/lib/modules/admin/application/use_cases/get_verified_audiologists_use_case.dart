import '../../../../core/application/use_case.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../domain/repositories/admin_user_repository.dart';

class GetVerifiedAudiologistsUseCase
    implements UseCase<List<AdminUserRecord>, NoParams> {
  const GetVerifiedAudiologistsUseCase(this._repository);

  final AdminUserRepository _repository;

  @override
  Future<List<AdminUserRecord>> call(NoParams params) {
    return _repository.getVerifiedAudiologists();
  }
}
