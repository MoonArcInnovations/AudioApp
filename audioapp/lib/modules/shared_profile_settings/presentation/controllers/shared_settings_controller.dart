import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/sync/data_sync_service.dart';
import '../../application/use_cases/get_shared_settings_use_case.dart';
import '../../application/use_cases/save_shared_settings_use_case.dart';
import '../../application/use_cases/set_demo_data_enabled_use_case.dart';
import '../../domain/entities/shared_settings.dart';

class SharedSettingsController
    extends StateNotifier<AsyncValue<SharedSettings>> {
  SharedSettingsController({
    required Ref ref,
    required GetSharedSettingsUseCase getSharedSettingsUseCase,
    required SaveSharedSettingsUseCase saveSharedSettingsUseCase,
    required SetDemoDataEnabledUseCase setDemoDataEnabledUseCase,
  }) : _ref = ref,
       _getSharedSettingsUseCase = getSharedSettingsUseCase,
       _saveSharedSettingsUseCase = saveSharedSettingsUseCase,
       _setDemoDataEnabledUseCase = setDemoDataEnabledUseCase,
       super(const AsyncValue.loading()) {
    _load();
  }

  final Ref _ref;
  final GetSharedSettingsUseCase _getSharedSettingsUseCase;
  final SaveSharedSettingsUseCase _saveSharedSettingsUseCase;
  final SetDemoDataEnabledUseCase _setDemoDataEnabledUseCase;

  Future<void> refresh() => _load();

  Future<void> setThemeMode(ThemeModePreference mode) {
    return _update((settings) => settings.copyWith(themeMode: mode));
  }

  Future<void> setDefaultHeadphone(String headphone) {
    return _update(
      (settings) => settings.copyWith(defaultHeadphone: headphone),
    );
  }

  Future<void> setToneDuration(int durationMs) {
    return _update((settings) => settings.copyWith(toneDurationMs: durationMs));
  }

  Future<void> toggleNotification(String key) {
    return _update((settings) {
      final notifications = settings.notifications;
      switch (key) {
        case 'testReminders':
          return settings.copyWith(
            notifications: notifications.copyWith(
              testReminders: !notifications.testReminders,
            ),
          );
        case 'patientUpdates':
          return settings.copyWith(
            notifications: notifications.copyWith(
              patientUpdates: !notifications.patientUpdates,
            ),
          );
        case 'syncNotifications':
          return settings.copyWith(
            notifications: notifications.copyWith(
              syncNotifications: !notifications.syncNotifications,
            ),
          );
        case 'soundEnabled':
          return settings.copyWith(
            notifications: notifications.copyWith(
              soundEnabled: !notifications.soundEnabled,
            ),
          );
        default:
          return settings;
      }
    });
  }

  Future<void> setDemoDataEnabled(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final next = current.copyWith(demoDataEnabled: enabled);
    state = AsyncValue.data(next);
    try {
      await _setDemoDataEnabledUseCase(enabled);
      await _saveSharedSettingsUseCase(next);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      state = AsyncValue.data(current);
    }
  }

  Future<void> syncNow() {
    return _ref.read(syncStateProvider.notifier).sync();
  }

  Future<void> _load() async {
    try {
      final settings = await _getSharedSettingsUseCase();
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _update(
    SharedSettings Function(SharedSettings settings) transform,
  ) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final next = transform(current);
    state = AsyncValue.data(next);
    try {
      await _saveSharedSettingsUseCase(next);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      state = AsyncValue.data(current);
    }
  }
}
