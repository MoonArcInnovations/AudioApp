import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/sync/data_sync_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../application/use_cases/get_shared_settings_use_case.dart';
import '../../application/use_cases/save_shared_settings_use_case.dart';
import '../../application/use_cases/set_demo_data_enabled_use_case.dart';
import '../../domain/entities/shared_settings.dart';
import '../../infrastructure/providers/shared_profile_settings_infrastructure_providers.dart';
import '../controllers/shared_settings_controller.dart';
import '../view_models/shared_settings_view_model.dart';

final getSharedSettingsUseCaseProvider = Provider<GetSharedSettingsUseCase>((
  ref,
) {
  return GetSharedSettingsUseCase(ref.watch(sharedSettingsRepositoryProvider));
});

final saveSharedSettingsUseCaseProvider = Provider<SaveSharedSettingsUseCase>((
  ref,
) {
  return SaveSharedSettingsUseCase(ref.watch(sharedSettingsRepositoryProvider));
});

final setDemoDataEnabledUseCaseProvider = Provider<SetDemoDataEnabledUseCase>((
  ref,
) {
  return SetDemoDataEnabledUseCase(ref.watch(sharedSettingsRepositoryProvider));
});

final sharedSettingsControllerProvider =
    StateNotifierProvider<SharedSettingsController, AsyncValue<SharedSettings>>(
      (ref) {
        return SharedSettingsController(
          ref: ref,
          getSharedSettingsUseCase: ref.watch(getSharedSettingsUseCaseProvider),
          saveSharedSettingsUseCase: ref.watch(
            saveSharedSettingsUseCaseProvider,
          ),
          setDemoDataEnabledUseCase: ref.watch(
            setDemoDataEnabledUseCaseProvider,
          ),
        );
      },
    );

final sharedSettingsViewModelProvider =
    Provider<AsyncValue<SharedSettingsViewModel>>((ref) {
      final settingsState = ref.watch(sharedSettingsControllerProvider);
      final syncState = ref.watch(syncStateProvider);
      final authState = ref.watch(authStateProvider);

      return settingsState.whenData(
        (settings) => SharedSettingsViewModel(
          settings: settings,
          syncState: syncState,
          currentUserRole: authState.userRole,
        ),
      );
    });

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(sharedSettingsControllerProvider);
  final preference =
      settings.valueOrNull?.themeMode ?? ThemeModePreference.light;
  switch (preference) {
    case ThemeModePreference.light:
      return ThemeMode.light;
    case ThemeModePreference.dark:
      return ThemeMode.dark;
    case ThemeModePreference.system:
      return ThemeMode.system;
  }
});
