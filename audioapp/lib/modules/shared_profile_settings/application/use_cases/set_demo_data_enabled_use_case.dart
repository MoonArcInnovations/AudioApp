import '../../domain/repositories/shared_settings_repository.dart';

class SetDemoDataEnabledUseCase {
  const SetDemoDataEnabledUseCase(this._repository);

  final SharedSettingsRepository _repository;

  Future<void> call(bool enabled) {
    return _repository.setDemoDataEnabled(enabled);
  }
}
