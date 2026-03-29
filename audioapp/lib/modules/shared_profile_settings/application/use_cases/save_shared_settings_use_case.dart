import '../../domain/entities/shared_settings.dart';
import '../../domain/repositories/shared_settings_repository.dart';

class SaveSharedSettingsUseCase {
  const SaveSharedSettingsUseCase(this._repository);

  final SharedSettingsRepository _repository;

  Future<void> call(SharedSettings settings) {
    return _repository.save(settings);
  }
}
