import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../data/local/app_database.dart';
import 'security/audit_service.dart';
import 'security/encryption_service.dart';
import 'security/session_service.dart';

/// App initialization service
/// Handles secure startup and service configuration
class AppInitializationService {
  static final AppInitializationService _instance = AppInitializationService._internal();
  factory AppInitializationService() => _instance;
  AppInitializationService._internal();

  bool _isInitialized = false;
  late AppDatabase _database;
  String? _deviceId;
  String? _deviceName;
  String? _deviceType;

  /// Check if app is initialized
  bool get isInitialized => _isInitialized;

  /// Get database instance
  AppDatabase get database => _database;

  /// Get device ID
  String get deviceId => _deviceId ?? 'unknown';

  /// Get device name
  String? get deviceName => _deviceName;

  /// Get device type
  String? get deviceType => _deviceType;

  /// Initialize all app services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Initialize database
      _database = AppDatabase();

      // 2. Initialize encryption service
      await encryptionService.initialize();

      // 3. Initialize audit service with database
      auditService.initialize(_database);

      // 4. Initialize session service with database
      sessionService.initialize(_database);

      // 5. Get device information
      await _initializeDeviceInfo();

      // 6. Cleanup expired sessions
      await sessionService.cleanupExpiredSessions();

      // 7. Initialize default headphone profiles if empty
      await _initializeDefaultHeadphoneProfiles();

      _isInitialized = true;

      if (kDebugMode) {
        print('[AppInit] All services initialized successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[AppInit] Initialization error: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  /// Initialize device information
  Future<void> _initializeDeviceInfo() async {
    try {
      if (kIsWeb) {
        _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        _deviceType = 'web';
        return;
      }
      
      final deviceInfo = DeviceInfoPlugin();
      
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
        _deviceName = iosInfo.name;
        _deviceType = 'ios';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
        _deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
        _deviceType = 'android';
      } else {
        _deviceId = 'desktop_${DateTime.now().millisecondsSinceEpoch}';
        _deviceType = 'desktop';
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AppInit] Device info error: $e');
      }
      _deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      _deviceType = 'unknown';
    }
  }

  /// Initialize default headphone profiles
  Future<void> _initializeDefaultHeadphoneProfiles() async {
    final existingProfiles = await _database.getAllHeadphoneProfiles();
    if (existingProfiles.isNotEmpty) return;

    // Add professional headphone profiles
    final defaultProfiles = [
      HeadphoneProfileModel(
        id: 'tdh39',
        brand: 'Telephonics',
        model: 'TDH-39',
        type: 'professional',
        retsplValues: {
          '125': 45.5, '250': 27.0, '500': 13.5, '750': 9.0,
          '1000': 7.5, '1500': 7.5, '2000': 9.0, '3000': 11.5,
          '4000': 12.0, '6000': 16.0, '8000': 15.5,
        },
        isValidated: true,
        validationDate: DateTime(2024, 1, 1),
        approvedUsage: 'diagnostic',
        notes: 'Standard clinical supra-aural headphones',
      ),
      HeadphoneProfileModel(
        id: 'er3a',
        brand: 'Etymotic',
        model: 'ER-3A',
        type: 'professional',
        retsplValues: {
          '125': 26.0, '250': 14.0, '500': 5.5, '750': 2.0,
          '1000': 0.0, '1500': 2.0, '2000': 3.0, '3000': 3.5,
          '4000': 5.5, '6000': 2.0, '8000': 0.0,
        },
        isValidated: true,
        validationDate: DateTime(2024, 1, 1),
        approvedUsage: 'diagnostic',
        notes: 'Insert earphones with excellent ambient noise isolation',
      ),
      HeadphoneProfileModel(
        id: 'airpods_pro_2',
        brand: 'Apple',
        model: 'AirPods Pro 2',
        type: 'validated',
        retsplValues: {
          '250': 32.0, '500': 16.5, '1000': 7.5,
          '2000': 11.0, '4000': 16.0, '8000': 21.5,
        },
        corrections: {
          '250': -5.0, '500': -3.0, '1000': 0.0,
          '2000': -2.0, '4000': -4.0, '8000': -6.0,
        },
        isValidated: false, // Needs validation
        approvedUsage: 'screeningWithWarning',
        notes: 'Consumer earbuds - requires validation study',
      ),
      HeadphoneProfileModel(
        id: 'galaxy_buds_pro',
        brand: 'Samsung',
        model: 'Galaxy Buds Pro',
        type: 'validated',
        retsplValues: {
          '250': 28.0, '500': 14.5, '1000': 8.0,
          '2000': 10.5, '4000': 15.0, '8000': 20.0,
        },
        corrections: {
          '250': -1.0, '500': -1.0, '1000': 0.5,
          '2000': 1.5, '4000': 3.0, '8000': 4.5,
        },
        isValidated: false, // Needs validation
        approvedUsage: 'screeningWithWarning',
        notes: 'Consumer earbuds - requires validation study',
      ),
      HeadphoneProfileModel(
        id: 'earpods',
        brand: 'Apple',
        model: 'EarPods',
        type: 'generic',
        retsplValues: {
          '250': 35.0, '500': 20.0, '1000': 10.0,
          '2000': 12.0, '4000': 16.0, '8000': 22.0,
        },
        corrections: {
          '250': 8.0, '500': 6.5, '1000': 2.5,
          '2000': 3.0, '4000': 4.0, '8000': 6.5,
        },
        isValidated: false,
        approvedUsage: 'screeningWithWarning',
        notes: 'Wired earbuds - limited accuracy, screening only',
      ),
      HeadphoneProfileModel(
        id: 'generic_wired',
        brand: 'Generic',
        model: 'Wired Earbuds',
        type: 'generic',
        retsplValues: {
          '250': 40.0, '500': 22.0, '1000': 12.0,
          '2000': 14.0, '4000': 20.0, '8000': 28.0,
        },
        isValidated: false,
        approvedUsage: 'screeningWithWarning',
        notes: 'Generic baseline - high variability expected',
      ),
    ];

    for (final profile in defaultProfiles) {
      await _database.upsertHeadphoneProfile(profile);
    }

    if (kDebugMode) {
      print('[AppInit] Initialized ${defaultProfiles.length} default headphone profiles');
    }
  }

  /// Dispose services (call on app termination)
  Future<void> dispose() async {
    // Logout current session if active
    if (sessionService.hasActiveSession) {
      await auditService.logLogout();
      await sessionService.invalidateSession();
    }
    
    // Close database
    await _database.close();
    
    _isInitialized = false;
  }
}

/// Singleton app initialization service
final appInitService = AppInitializationService();

// ============ RIVERPOD PROVIDERS ============

/// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  if (!appInitService.isInitialized) {
    throw StateError('App not initialized. Call AppInitializationService.initialize() first.');
  }
  return appInitService.database;
});

/// App initialization state
enum AppInitState { loading, success, error }

/// App initialization notifier
class AppInitNotifier extends StateNotifier<AppInitState> {
  AppInitNotifier() : super(AppInitState.loading);

  String? errorMessage;

  Future<void> initialize() async {
    state = AppInitState.loading;
    try {
      await appInitService.initialize();
      state = AppInitState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = AppInitState.error;
    }
  }
}

/// App initialization provider
final appInitProvider = StateNotifierProvider<AppInitNotifier, AppInitState>((ref) {
  return AppInitNotifier();
});
