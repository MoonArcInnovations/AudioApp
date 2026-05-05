enum ThemeModePreference { light, dark, system }

extension ThemeModePreferenceX on ThemeModePreference {
  String get storageValue {
    switch (this) {
      case ThemeModePreference.light:
        return 'light';
      case ThemeModePreference.dark:
        return 'dark';
      case ThemeModePreference.system:
        return 'system';
    }
  }

  String get label {
    switch (this) {
      case ThemeModePreference.light:
        return 'Light';
      case ThemeModePreference.dark:
        return 'Dark';
      case ThemeModePreference.system:
        return 'System Default';
    }
  }
}

ThemeModePreference themeModePreferenceFromStorage(String? value) {
  switch (value) {
    case 'dark':
      return ThemeModePreference.dark;
    case 'system':
      return ThemeModePreference.system;
    case 'light':
    default:
      return ThemeModePreference.light;
  }
}

class NotificationSettingsPreference {
  const NotificationSettingsPreference({
    this.testReminders = true,
    this.patientUpdates = true,
    this.syncNotifications = false,
    this.soundEnabled = true,
  });

  final bool testReminders;
  final bool patientUpdates;
  final bool syncNotifications;
  final bool soundEnabled;

  NotificationSettingsPreference copyWith({
    bool? testReminders,
    bool? patientUpdates,
    bool? syncNotifications,
    bool? soundEnabled,
  }) {
    return NotificationSettingsPreference(
      testReminders: testReminders ?? this.testReminders,
      patientUpdates: patientUpdates ?? this.patientUpdates,
      syncNotifications: syncNotifications ?? this.syncNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class SharedSettings {
  const SharedSettings({
    this.themeMode = ThemeModePreference.light,
    this.notifications = const NotificationSettingsPreference(),
    this.defaultHeadphone = 'TDH-39 Supra-aural',
    this.toneDurationMs = 1000,
    this.demoDataEnabled = false,
  });

  final ThemeModePreference themeMode;
  final NotificationSettingsPreference notifications;
  final String defaultHeadphone;
  final int toneDurationMs;
  final bool demoDataEnabled;

  SharedSettings copyWith({
    ThemeModePreference? themeMode,
    NotificationSettingsPreference? notifications,
    String? defaultHeadphone,
    int? toneDurationMs,
    bool? demoDataEnabled,
  }) {
    return SharedSettings(
      themeMode: themeMode ?? this.themeMode,
      notifications: notifications ?? this.notifications,
      defaultHeadphone: defaultHeadphone ?? this.defaultHeadphone,
      toneDurationMs: toneDurationMs ?? this.toneDurationMs,
      demoDataEnabled: demoDataEnabled ?? this.demoDataEnabled,
    );
  }
}
