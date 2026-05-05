import '../../domain/entities/shared_settings.dart';
import '../../domain/repositories/shared_settings_repository.dart';

class GetSharedSettingsUseCase {
  const GetSharedSettingsUseCase(this._repository);

  final SharedSettingsRepository _repository;

  Future<SharedSettings> call() {
    return _repository.load();
  }
}
