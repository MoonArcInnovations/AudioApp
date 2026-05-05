import '../../../../data/local/app_database.dart';
import '../../../../services/demo/demo_data_service.dart';
import '../../domain/entities/shared_settings.dart';
import '../../domain/repositories/shared_settings_repository.dart';

class LocalSharedSettingsRepository implements SharedSettingsRepository {
  LocalSharedSettingsRepository({
    required AppDatabase database,
    required DemoDataService demoDataService,
  }) : _database = database,
       _demoDataService = demoDataService;

  final AppDatabase _database;
  final DemoDataService _demoDataService;

  static const _themeModeKey = 'ui.theme_mode';
  static const _testRemindersKey = 'notifications.test_reminders';
  static const _patientUpdatesKey = 'notifications.patient_updates';
  static const _syncNotificationsKey = 'notifications.sync_notifications';
  static const _soundEnabledKey = 'notifications.sound_enabled';
  static const _defaultHeadphoneKey = 'audio.default_headphone';
  static const _toneDurationKey = 'audio.tone_duration_ms';

  @override
  Future<SharedSettings> load() async {
    final themeModeValue = await _database.getAppSetting(_themeModeKey);
    final testRemindersValue = await _database.getAppSetting(_testRemindersKey);
    final patientUpdatesValue = await _database.getAppSetting(
      _patientUpdatesKey,
    );
    final syncNotificationsValue = await _database.getAppSetting(
      _syncNotificationsKey,
    );
    final soundEnabledValue = await _database.getAppSetting(_soundEnabledKey);
    final defaultHeadphoneValue = await _database.getAppSetting(
      _defaultHeadphoneKey,
    );
    final toneDurationValue = await _database.getAppSetting(_toneDurationKey);
    final demoDataEnabled = await _demoDataService.isEnabled();

    return SharedSettings(
      themeMode: themeModePreferenceFromStorage(themeModeValue),
      notifications: NotificationSettingsPreference(
        testReminders: _parseBool(testRemindersValue, fallback: true),
        patientUpdates: _parseBool(patientUpdatesValue, fallback: true),
        syncNotifications: _parseBool(syncNotificationsValue, fallback: false),
        soundEnabled: _parseBool(soundEnabledValue, fallback: true),
      ),
      defaultHeadphone: defaultHeadphoneValue ?? 'TDH-39 Supra-aural',
      toneDurationMs: int.tryParse(toneDurationValue ?? '') ?? 1000,
      demoDataEnabled: demoDataEnabled,
    );
  }

  @override
  Future<void> save(SharedSettings settings) async {
    await _database.setAppSetting(
      _themeModeKey,
      settings.themeMode.storageValue,
    );
    await _database.setAppSetting(
      _testRemindersKey,
      settings.notifications.testReminders.toString(),
    );
    await _database.setAppSetting(
      _patientUpdatesKey,
      settings.notifications.patientUpdates.toString(),
    );
    await _database.setAppSetting(
      _syncNotificationsKey,
      settings.notifications.syncNotifications.toString(),
    );
    await _database.setAppSetting(
      _soundEnabledKey,
      settings.notifications.soundEnabled.toString(),
    );
    await _database.setAppSetting(
      _defaultHeadphoneKey,
      settings.defaultHeadphone,
    );
    await _database.setAppSetting(
      _toneDurationKey,
      settings.toneDurationMs.toString(),
    );
  }

  @override
  Future<void> setDemoDataEnabled(bool enabled) async {
    if (enabled) {
      await _demoDataService.seedIfNeeded();
    } else {
      await _demoDataService.setDemoEnabled(false);
    }
  }

  bool _parseBool(String? raw, {required bool fallback}) {
    if (raw == null) {
      return fallback;
    }
    return raw.toLowerCase() == 'true';
  }
}
