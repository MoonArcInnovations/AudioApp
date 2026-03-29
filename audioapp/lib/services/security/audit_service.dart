import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../data/local/app_database.dart';

/// HIPAA-compliant audit logging service
/// Records all access to PHI and significant user actions
class AuditService {
  static final AuditService _instance = AuditService._internal();
  factory AuditService() => _instance;
  AuditService._internal();

  AppDatabase? _database;
  String? _currentSessionId;
  String? _currentUserId;
  String? _currentUserEmail;
  String? _currentIpAddress;
  String? _currentUserAgent;

  /// Initialize audit service with database
  void initialize(AppDatabase database) {
    _database = database;
  }

  /// Set current session context
  void setSessionContext({
    required String sessionId,
    required String userId,
    required String userEmail,
    String? ipAddress,
    String? userAgent,
  }) {
    _currentSessionId = sessionId;
    _currentUserId = userId;
    _currentUserEmail = userEmail;
    _currentIpAddress = ipAddress;
    _currentUserAgent = userAgent;
  }

  /// Clear session context on logout
  void clearSessionContext() {
    _currentSessionId = null;
    _currentUserId = null;
    _currentUserEmail = null;
    _currentIpAddress = null;
    _currentUserAgent = null;
  }

  // =========== AUDIT ACTIONS ===========

  /// Log user login attempt
  Future<void> logLogin({
    required String userId,
    required String email,
    required bool success,
    String? errorMessage,
    String? ipAddress,
  }) async {
    await _log(
      userId: userId,
      userEmail: email,
      action: AuditAction.login,
      resourceType: 'session',
      success: success,
      errorMessage: errorMessage,
      ipAddress: ipAddress,
    );
  }

  /// Log user logout
  Future<void> logLogout() async {
    if (_currentUserId == null) return;
    await _log(
      action: AuditAction.logout,
      resourceType: 'session',
    );
  }

  /// Log PHI access (viewing patient data)
  Future<void> logPatientView(String patientId) async {
    await _log(
      action: AuditAction.view,
      resourceType: 'patient',
      resourceId: patientId,
    );
  }

  /// Log patient creation
  Future<void> logPatientCreate(String patientId) async {
    await _log(
      action: AuditAction.create,
      resourceType: 'patient',
      resourceId: patientId,
    );
  }

  /// Log patient update
  Future<void> logPatientUpdate(String patientId, Map<String, dynamic> changes) async {
    await _log(
      action: AuditAction.update,
      resourceType: 'patient',
      resourceId: patientId,
      details: {'changes': changes},
    );
  }

  /// Log patient deletion/deactivation
  Future<void> logPatientDelete(String patientId, {bool hardDelete = false}) async {
    await _log(
      action: AuditAction.delete,
      resourceType: 'patient',
      resourceId: patientId,
      details: {'hardDelete': hardDelete},
    );
  }

  /// Log test result view
  Future<void> logTestResultView(String testId) async {
    await _log(
      action: AuditAction.view,
      resourceType: 'test_result',
      resourceId: testId,
    );
  }

  /// Log AI decision action
  Future<void> logAiDecision({
    required String testId,
    required bool accepted,
    String? notes,
  }) async {
    await _log(
      action: accepted ? AuditAction.aiAccept : AuditAction.aiOverride,
      resourceType: 'ai_recommendation',
      resourceId: testId,
      details: {'notes': notes},
    );
  }

  /// Log test result creation
  Future<void> logTestResultCreate(String testId, String patientId) async {
    await _log(
      action: AuditAction.create,
      resourceType: 'test_result',
      resourceId: testId,
      details: {'patientId': patientId},
    );
  }

  /// Log report export (PDF, CSV)
  Future<void> logReportExport({
    required String resourceType,
    required String resourceId,
    required String exportFormat,
  }) async {
    await _log(
      action: AuditAction.export,
      resourceType: resourceType,
      resourceId: resourceId,
      details: {'format': exportFormat},
    );
  }

  /// Log user management actions (admin only)
  Future<void> logUserManagement({
    required String targetUserId,
    required String action, // 'verify', 'suspend', 'activate', 'role_change'
    Map<String, dynamic>? details,
  }) async {
    await _log(
      action: AuditAction.admin,
      resourceType: 'user',
      resourceId: targetUserId,
      details: {'adminAction': action, ...?details},
    );
  }

  /// Log screening test completion
  Future<void> logScreeningComplete(String screeningId, String result) async {
    await _log(
      action: AuditAction.create,
      resourceType: 'screening',
      resourceId: screeningId,
      details: {'result': result},
    );
  }

  /// Log user creation
  Future<void> logUserCreated(String userId, String email) async {
    await _log(
      action: AuditAction.create,
      resourceType: 'user',
      resourceId: userId,
      details: {'email': email},
    );
  }

  /// Log user deletion
  Future<void> logUserDeleted(String userId, String email) async {
    await _log(
      action: AuditAction.delete,
      resourceType: 'user',
      resourceId: userId,
      details: {'email': email},
    );
  }

  /// Log audiologist verification
  Future<void> logAudiologistVerified(String userId, String email) async {
    await _log(
      action: AuditAction.admin,
      resourceType: 'user',
      resourceId: userId,
      details: {'action': 'verify', 'email': email},
    );
  }

  /// Log user suspension
  Future<void> logUserSuspended(String userId, String email, String reason) async {
    await _log(
      action: AuditAction.admin,
      resourceType: 'user',
      resourceId: userId,
      details: {'action': 'suspend', 'email': email, 'reason': reason},
    );
  }

  /// Log consent granted/revoked
  Future<void> logConsent({
    required String patientId,
    required String consentType,
    required bool granted,
  }) async {
    await _log(
      action: granted ? AuditAction.create : AuditAction.delete,
      resourceType: 'consent',
      resourceId: patientId,
      details: {'type': consentType, 'granted': granted},
    );
  }

  // =========== INTERNAL ===========

  /// Core logging method
  Future<void> _log({
    String? userId,
    String? userEmail,
    required AuditAction action,
    required String resourceType,
    String? resourceId,
    Map<String, dynamic>? details,
    bool success = true,
    String? errorMessage,
    String? ipAddress,
  }) async {
    if (_database == null) {
      if (kDebugMode) {
        print('[AUDIT] Warning: AuditService not initialized');
      }
      return;
    }

    try {
      await _database!.insertAuditLog(
        userId: userId ?? _currentUserId ?? 'unknown',
        userEmail: userEmail ?? _currentUserEmail ?? 'unknown',
        action: action.value,
        resourceType: resourceType,
        resourceId: resourceId,
        details: details != null ? jsonEncode(details) : null,
        ipAddress: ipAddress ?? _currentIpAddress,
        userAgent: _currentUserAgent,
        sessionId: _currentSessionId,
        success: success,
        errorMessage: errorMessage,
      );
    } catch (e) {
      // Never throw from audit logging - log to console in debug
      if (kDebugMode) {
        print('[AUDIT] Error logging: $e');
      }
    }
  }

  /// Get audit logs for a user (admin function)
  Future<List<AuditLogEntry>> getLogsForUser(String userId, {int limit = 100}) async {
    if (_database == null) return [];
    return await _database!.getAuditLogsForUser(userId, limit: limit);
  }

  /// Get audit logs for a patient (shows who accessed their data)
  Future<List<AuditLogEntry>> getLogsForPatient(String patientId, {int limit = 100}) async {
    if (_database == null) return [];
    return await _database!.getAuditLogsForResource('patient', patientId, limit: limit);
  }

  /// Get recent audit logs (admin function)
  Future<List<AuditLogEntry>> getRecentLogs({int limit = 100}) async {
    if (_database == null) return [];
    return await _database!.getRecentAuditLogs(limit: limit);
  }
}

/// Audit action types
enum AuditAction {
  login('login'),
  logout('logout'),
  view('view'),
  create('create'),
  update('update'),
  delete('delete'),
  export('export'),
  admin('admin'),
  aiAccept('ai_accept'),
  aiOverride('ai_override');

  const AuditAction(this.value);
  final String value;
}

/// Audit log entry model
class AuditLogEntry {
  final int id;
  final String userId;
  final String userEmail;
  final String action;
  final String resourceType;
  final String? resourceId;
  final String? details;
  final String? ipAddress;
  final String? userAgent;
  final String? sessionId;
  final bool success;
  final String? errorMessage;
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.action,
    required this.resourceType,
    this.resourceId,
    this.details,
    this.ipAddress,
    this.userAgent,
    this.sessionId,
    required this.success,
    this.errorMessage,
    required this.createdAt,
  });

  Map<String, dynamic>? get detailsJson {
    if (details == null) return null;
    try {
      return jsonDecode(details!) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

/// Global audit service instance
final auditService = AuditService();
