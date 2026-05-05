import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../../services/app_initialization_service.dart';

class AppBootstrapResult {
  const AppBootstrapResult({
    required this.firebaseReady,
    required this.localServicesReady,
    this.firebaseError,
    this.localServicesError,
  });

  const AppBootstrapResult.ready()
    : firebaseReady = true,
      localServicesReady = true,
      firebaseError = null,
      localServicesError = null;

  final bool firebaseReady;
  final bool localServicesReady;
  final String? firebaseError;
  final String? localServicesError;

  bool get isReady => firebaseReady && localServicesReady;

  String get title {
    if (firebaseError != null && localServicesError != null) {
      return 'Startup Configuration Error';
    }
    if (firebaseError != null) {
      return 'Authentication Services Unavailable';
    }
    if (localServicesError != null) {
      return 'Local Services Unavailable';
    }
    return 'AudioApp Ready';
  }

  String get userMessage {
    if (firebaseError != null && localServicesError != null) {
      return 'AudioApp could not start because cloud authentication and local '
          'services both failed to initialize.';
    }
    if (firebaseError != null) {
      return 'AudioApp could not initialize Firebase authentication. Please '
          'verify the project configuration and try again.';
    }
    if (localServicesError != null) {
      return 'AudioApp could not initialize local secure services. Please try '
          'again.';
    }
    return 'AudioApp initialized successfully.';
  }

  String? get technicalDetails {
    final parts = <String>[
      if (firebaseError != null) 'Firebase: $firebaseError',
      if (localServicesError != null) 'Local: $localServicesError',
    ];
    if (parts.isEmpty) {
      return null;
    }
    return parts.join('\n');
  }
}

/// Central bootstrap entry point for application services.
///
/// This is the first step toward a dedicated app shell that owns startup
/// orchestration instead of scattering it inside `main.dart`.
class AppBootstrap {
  const AppBootstrap();

  Future<AppBootstrapResult> initialize() async {
    final firebaseError = await _initializeFirebase();
    final localServicesError = await _initializeLocalServices();

    return AppBootstrapResult(
      firebaseReady: firebaseError == null,
      localServicesReady: localServicesError == null,
      firebaseError: firebaseError,
      localServicesError: localServicesError,
    );
  }

  Future<String?> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return null;
    } catch (error) {
      debugPrint('Firebase not initialized: $error');
      return error.toString();
    }
  }

  Future<String?> _initializeLocalServices() async {
    try {
      await appInitService.initialize();
      debugPrint('App services initialized successfully');
      return null;
    } catch (error) {
      debugPrint('App services initialization error: $error');
      return error.toString();
    }
  }
}
