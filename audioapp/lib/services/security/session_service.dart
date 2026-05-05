import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../data/local/app_database.dart';
import 'encryption_service.dart';

/// Session management service
/// Handles session lifecycle, timeout, and device tracking
class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  AppDatabase? _database;
  String? _currentSessionId;
  String? _currentUserId;
  DateTime? _lastActivityTime;
  
  // Session timeout in minutes (from app constants)
  int get _sessionTimeoutMinutes => AppConstants.sessionTimeoutMinutes;

  /// Initialize session service
  void initialize(AppDatabase database) {
    _database = database;
  }

  /// Create a new session for user
  Future<String> createSession({
    required String userId,
    required String deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
  }) async {
    if (_database == null) {
      throw StateError('SessionService not initialized');
    }

    // Generate session ID
    final sessionId = encryptionService.generateSessionId();
    final now = DateTime.now();
    final expiresAt = now.add(Duration(minutes: _sessionTimeoutMinutes));

    // Insert session into database
    await _database!.createSession(
      sessionId: sessionId,
      userId: userId,
      deviceId: deviceId,
      deviceName: deviceName,
      deviceType: deviceType,
      ipAddress: ipAddress,
      createdAt: now,
      expiresAt: expiresAt,
    );

    // Invalidate old sessions for this device (only one session per device)
    await _database!.invalidateOtherSessionsForDevice(
      userId: userId,
      deviceId: deviceId,
      currentSessionId: sessionId,
    );

    _currentSessionId = sessionId;
    _currentUserId = userId;
    _lastActivityTime = now;

    return sessionId;
  }

  /// Validate current session
  Future<bool> validateSession() async {
    if (_currentSessionId == null || _database == null) {
      return false;
    }

    final session = await _database!.getSession(_currentSessionId!);
    if (session == null) {
      return false;
    }

    // Check if session is active
    if (!session.isActive) {
      return false;
    }

    // Check if session has expired
    final now = DateTime.now();
    if (now.isAfter(session.expiresAt)) {
      await invalidateSession();
      return false;
    }

    return true;
  }

  /// Update session activity (extends timeout)
  Future<void> updateActivity() async {
    if (_currentSessionId == null || _database == null) return;

    _lastActivityTime = DateTime.now();
    final newExpiresAt = _lastActivityTime!.add(Duration(minutes: _sessionTimeoutMinutes));

    await _database!.updateSessionActivity(
      sessionId: _currentSessionId!,
      lastActivityAt: _lastActivityTime!,
      expiresAt: newExpiresAt,
    );
  }

  /// Check if session has timed out due to inactivity
  bool isSessionTimedOut() {
    if (_lastActivityTime == null) return true;
    
    final now = DateTime.now();
    final timeSinceActivity = now.difference(_lastActivityTime!);
    return timeSinceActivity.inMinutes >= _sessionTimeoutMinutes;
  }

  /// Invalidate current session (logout)
  Future<void> invalidateSession() async {
    if (_currentSessionId == null || _database == null) return;

    await _database!.invalidateSession(_currentSessionId!);

    _currentSessionId = null;
    _currentUserId = null;
    _lastActivityTime = null;
  }

  /// Invalidate all sessions for a user (security measure)
  Future<void> invalidateAllUserSessions(String userId) async {
    if (_database == null) return;
    
    await _database!.invalidateAllUserSessions(userId);

    if (_currentUserId == userId) {
      _currentSessionId = null;
      _currentUserId = null;
      _lastActivityTime = null;
    }
  }

  /// Get active sessions for user (for security dashboard)
  Future<List<SessionInfo>> getActiveSessions(String userId) async {
    if (_database == null) return [];
    return await _database!.getActiveSessionsForUser(userId);
  }

  /// Get current session ID
  String? get currentSessionId => _currentSessionId;

  /// Get current user ID
  String? get currentUserId => _currentUserId;

  /// Check if there's an active session
  bool get hasActiveSession => _currentSessionId != null;

  /// Clean up expired sessions (call periodically or on app start)
  Future<void> cleanupExpiredSessions() async {
    if (_database == null) return;
    
    try {
      await _database!.cleanupExpiredSessions();
    } catch (e) {
      if (kDebugMode) {
        print('Error cleaning up sessions: $e');
      }
    }
  }
}

/// Session information model
class SessionInfo {
  final String id;
  final String userId;
  final String deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? ipAddress;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final DateTime expiresAt;
  final bool isActive;
  final bool isCurrent;

  const SessionInfo({
    required this.id,
    required this.userId,
    required this.deviceId,
    this.deviceName,
    this.deviceType,
    this.ipAddress,
    required this.createdAt,
    required this.lastActivityAt,
    required this.expiresAt,
    required this.isActive,
    this.isCurrent = false,
  });
}

/// Global session service instance
final sessionService = SessionService();
