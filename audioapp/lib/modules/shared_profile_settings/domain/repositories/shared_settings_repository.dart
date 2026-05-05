import '../entities/shared_settings.dart';

abstract class SharedSettingsRepository {
  Future<SharedSettings> load();
  Future<void> save(SharedSettings settings);
  Future<void> setDemoDataEnabled(bool enabled);
}
