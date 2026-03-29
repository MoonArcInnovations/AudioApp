import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/sync/data_sync_service.dart';
import '../../domain/entities/shared_settings.dart';

class SharedSettingsViewModel {
  const SharedSettingsViewModel({
    required this.settings,
    required this.syncState,
    required this.currentUserRole,
  });

  final SharedSettings settings;
  final SyncState syncState;
  final UserRole? currentUserRole;

  ThemeMode get themeMode {
    switch (settings.themeMode) {
      case ThemeModePreference.light:
        return ThemeMode.light;
      case ThemeModePreference.dark:
        return ThemeMode.dark;
      case ThemeModePreference.system:
        return ThemeMode.system;
    }
  }

  String get themeLabel => settings.themeMode.label;

  String get syncSubtitle {
    switch (syncState.status) {
      case SyncStatus.syncing:
        return 'Syncing now...';
      case SyncStatus.success:
        return _lastSyncLabel(prefix: 'Last sync');
      case SyncStatus.error:
        return syncState.errorMessage ?? 'Sync failed';
      case SyncStatus.idle:
        if (syncState.pendingCount > 0) {
          return '${syncState.pendingCount} pending item${syncState.pendingCount == 1 ? '' : 's'}';
        }
        return _lastSyncLabel(prefix: 'Last sync');
    }
  }

  String get storageSubtitle {
    if (syncState.pendingCount > 0) {
      return 'Encrypted local cache with ${syncState.pendingCount} pending item${syncState.pendingCount == 1 ? '' : 's'}';
    }
    return 'Encrypted local cache active';
  }

  bool get canOpenCalibration =>
      currentUserRole == UserRole.audiologist ||
      currentUserRole == UserRole.superAdmin;

  String _lastSyncLabel({required String prefix}) {
    final lastSyncTime = syncState.lastSyncTime;
    if (lastSyncTime == null) {
      return '$prefix: Never';
    }

    final difference = DateTime.now().difference(lastSyncTime);
    if (difference.inMinutes < 1) {
      return '$prefix: Just now';
    }
    if (difference.inHours < 1) {
      return '$prefix: ${difference.inMinutes} min ago';
    }
    if (difference.inDays < 1) {
      return '$prefix: ${difference.inHours} hr ago';
    }
    return '$prefix: ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  }
}
