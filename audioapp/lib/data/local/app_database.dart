import 'dart:convert';
import 'package:drift/drift.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';
import '../../services/security/audit_service.dart';
import '../../services/security/session_service.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'connection/connection.dart' as conn;
import 'database_tables.dart';

part 'app_database.g.dart';

/// Main application database with HIPAA-compliant data handling
@DriftDatabase(
  tables: [
    Patients,
    TestResults,
    ScreeningResults,
    Users,
    AuditLogs,
    Sessions,
    HeadphoneProfiles,
    CalibrationSettings,
    AppSettings,
    BcImports,
    AiRecommendations,
    ConsentRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations for version upgrades
        if (from < 2) {
          // Add new tables for v2
          await m.createTable(screeningResults);
          await m.createTable(auditLogs);
          await m.createTable(sessions);
          await m.createTable(headphoneProfiles);
          await m.createTable(consentRecords);
          await m.createTable(appSettings);
        }
        if (from < 3) {
          await m.createTable(bcImports);
        }
        if (from < 4) {
          await m.addColumn(testResults, testResults.screeningId);
        }
        if (from < 5) {
          await m.createTable(aiRecommendations);
        }
      },
    );
  }

  // ============ PATIENTS ============

  Future<List<ClinicianPatientRecord>> getClinicianPatientsByAudiologist(
    String audiologistId,
  ) async {
    final results =
        await (select(patients)
              ..where((p) => p.audiologistId.equals(audiologistId))
              ..where((p) => p.isActive.equals(true))
              ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
            .get();
    return results.map(_clinicianPatientFromRow).toList();
  }

  Future<ClinicianPatientRecord?> getClinicianPatientById(String id) async {
    final result = await (select(
      patients,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    return result != null ? _clinicianPatientFromRow(result) : null;
  }

  Future<void> upsertClinicianPatient(
    ClinicianPatientRecord patient, {
    required String createdBy,
    bool synced = false,
  }) async {
    await into(patients).insertOnConflictUpdate(
      PatientsCompanion(
        id: Value(patient.id),
        name: Value(patient.name),
        dateOfBirth: Value(patient.dateOfBirth),
        phoneNumber: Value(patient.phoneNumber),
        email: Value(patient.email),
        gender: Value(patient.gender),
        medicalRecordNumber: Value(patient.medicalRecordNumber),
        notes: Value(patient.notes),
        audiologistId: Value(patient.audiologistId),
        createdBy: Value(createdBy),
        createdAt: Value(patient.createdAt),
        updatedAt: Value(DateTime.now()),
        synced: Value(synced),
        isActive: const Value(true),
      ),
    );
  }

  /// Soft delete patient (HIPAA: don't hard delete)
  Future<void> deactivatePatient(String id) async {
    await (update(patients)..where((p) => p.id.equals(id))).write(
      PatientsCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<ClinicianPatientRecord>> getUnsyncedClinicianPatients() async {
    final results = await (select(
      patients,
    )..where((p) => p.synced.equals(false))).get();
    return results.map(_clinicianPatientFromRow).toList();
  }

  /// Mark patient as synced
  Future<void> markPatientSynced(String id) async {
    await (update(patients)..where((p) => p.id.equals(id))).write(
      const PatientsCompanion(synced: Value(true)),
    );
  }

  ClinicianPatientRecord _clinicianPatientFromRow(DbPatient row) {
    return ClinicianPatientRecord(
      id: row.id,
      name: row.name,
      dateOfBirth: row.dateOfBirth,
      phoneNumber: row.phoneNumber,
      email: row.email,
      gender: row.gender,
      medicalRecordNumber: row.medicalRecordNumber,
      notes: row.notes,
      audiologistId: row.audiologistId,
      createdAt: row.createdAt,
      createdBy: row.createdBy,
      synced: row.synced,
    );
  }

  // ============ TEST RESULTS ============

  Future<List<ClinicianTestRecord>> getClinicianTestsForPatient(
    String patientId,
  ) async {
    final results =
        await (select(testResults)
              ..where((t) => t.patientId.equals(patientId))
              ..orderBy([(t) => OrderingTerm.desc(t.testDate)]))
            .get();
    return results.map(_clinicianTestFromRow).toList();
  }

  Future<List<ClinicianTestRecord>> getAllClinicianTestsForAudiologist(
    String audiologistId,
  ) async {
    final results =
        await (select(testResults)
              ..where((t) => t.audiologistId.equals(audiologistId))
              ..orderBy([(t) => OrderingTerm.desc(t.testDate)]))
            .get();
    return results.map(_clinicianTestFromRow).toList();
  }

  Future<void> upsertClinicianTestResult(
    ClinicianTestRecord test, {
    bool synced = false,
  }) async {
    await into(testResults).insertOnConflictUpdate(
      TestResultsCompanion(
        id: Value(test.id),
        patientId: Value(test.patientId),
        audiologistId: Value(test.audiologistId),
        testDate: Value(test.testDate),
        testType: Value(test.testType ?? 'air'),
        screeningId: Value(test.screeningId),
        headphoneModel: Value(test.headphoneModel),
        ambientNoiseDb: Value(test.ambientNoiseDb),
        rightEarResults: Value(_encodeAudiogramPoints(test.rightEarResults)),
        leftEarResults: Value(_encodeAudiogramPoints(test.leftEarResults)),
        rightPta: Value(test.rightPta),
        leftPta: Value(test.leftPta),
        rightClassification: Value(test.rightClassification),
        leftClassification: Value(test.leftClassification),
        notes: Value(test.notes),
        recommendations: Value(test.recommendations),
        isComplete: Value(test.isComplete),
        synced: Value(synced),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete test result
  Future<void> deleteTestResult(String id) async {
    await (delete(testResults)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ClinicianTestRecord>> getUnsyncedClinicianTests() async {
    final results = await (select(
      testResults,
    )..where((t) => t.synced.equals(false))).get();
    return results.map(_clinicianTestFromRow).toList();
  }

  /// Mark test as synced
  Future<void> markTestSynced(String id) async {
    await (update(testResults)..where((t) => t.id.equals(id))).write(
      const TestResultsCompanion(synced: Value(true)),
    );
  }

  String _encodeAudiogramPoints(List<AudiogramPoint> points) {
    return jsonEncode(
      points
          .map(
            (p) => {
              'frequency': p.frequency,
              'thresholdDb': p.thresholdDb,
              'noResponse': p.noResponse,
              'masked': p.masked,
              'maskingLevel': p.maskingLevel,
              'maskingEar': p.maskingEar?.name,
            },
          )
          .toList(),
    );
  }

  List<AudiogramPoint> _decodeAudiogramPoints(String json, Ear ear) {
    final list = jsonDecode(json) as List;
    return list
        .map(
          (p) => AudiogramPoint(
            frequency: p['frequency'] as int,
            thresholdDb: p['thresholdDb'] as int,
            ear: ear,
            noResponse: p['noResponse'] as bool? ?? false,
            masked: p['masked'] as bool? ?? false,
            maskingLevel: p['maskingLevel'] as int?,
            maskingEar: _decodeEar(p['maskingEar'] as String?),
          ),
        )
        .toList();
  }

  Ear? _decodeEar(String? value) {
    if (value == null) {
      return null;
    }
    return Ear.values.where((ear) => ear.name == value).firstOrNull;
  }

  ClinicianTestRecord _clinicianTestFromRow(DbTestResult row) {
    return ClinicianTestRecord(
      id: row.id,
      patientId: row.patientId,
      audiologistId: row.audiologistId,
      testDate: row.testDate,
      testType: row.testType,
      screeningId: row.screeningId,
      headphoneModel: row.headphoneModel,
      ambientNoiseDb: row.ambientNoiseDb,
      rightEarResults: _decodeAudiogramPoints(row.rightEarResults, Ear.right),
      leftEarResults: _decodeAudiogramPoints(row.leftEarResults, Ear.left),
      rightPta: row.rightPta,
      leftPta: row.leftPta,
      rightClassification: row.rightClassification,
      leftClassification: row.leftClassification,
      notes: row.notes,
      recommendations: row.recommendations,
      isComplete: row.isComplete,
      synced: row.synced,
    );
  }

  // ============ SCREENING RESULTS ============

  /// Save screening result
  Future<void> saveScreeningResult(ScreeningResultModel result) async {
    await into(screeningResults).insertOnConflictUpdate(
      ScreeningResultsCompanion(
        id: Value(result.id),
        userId: Value(result.userId),
        testDate: Value(result.testDate),
        headphoneModel: Value(result.headphoneModel),
        ambientNoiseDb: Value(result.ambientNoiseDb),
        result: Value(result.result),
        frequenciesTested: Value(jsonEncode(result.frequenciesTested)),
        thresholds: Value(jsonEncode(result.thresholds)),
        deviceInfo: Value(result.deviceInfo),
        synced: const Value(false),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get screening results for user
  Future<List<ScreeningResultModel>> getScreeningResultsForUser(
    String userId,
  ) async {
    final results =
        await (select(screeningResults)
              ..where((s) => s.userId.equals(userId))
              ..orderBy([(s) => OrderingTerm.desc(s.testDate)]))
            .get();
    return results.map(_screeningFromRow).toList();
  }

  /// Get screening result by ID
  Future<ScreeningResultModel?> getScreeningResultById(String id) async {
    final result = await (select(
      screeningResults,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return result != null ? _screeningFromRow(result) : null;
  }

  /// Get all screening results
  Future<List<ScreeningResultModel>> getAllScreeningResults() async {
    final results = await (select(
      screeningResults,
    )..orderBy([(s) => OrderingTerm.desc(s.testDate)])).get();
    return results.map(_screeningFromRow).toList();
  }

  ScreeningResultModel _screeningFromRow(ScreeningResult row) {
    return ScreeningResultModel(
      id: row.id,
      userId: row.userId,
      testDate: row.testDate,
      headphoneModel: row.headphoneModel,
      ambientNoiseDb: row.ambientNoiseDb,
      result: row.result,
      frequenciesTested: (jsonDecode(row.frequenciesTested) as List)
          .cast<int>(),
      thresholds: Map<String, int>.from(jsonDecode(row.thresholds)),
      deviceInfo: row.deviceInfo,
    );
  }

  // ============ AUDIT LOGS ============

  /// Insert audit log entry
  Future<void> insertAuditLog({
    required String userId,
    required String userEmail,
    required String action,
    required String resourceType,
    String? resourceId,
    String? details,
    String? ipAddress,
    String? userAgent,
    String? sessionId,
    bool success = true,
    String? errorMessage,
  }) async {
    await into(auditLogs).insert(
      AuditLogsCompanion(
        userId: Value(userId),
        userEmail: Value(userEmail),
        action: Value(action),
        resourceType: Value(resourceType),
        resourceId: Value(resourceId),
        details: Value(details),
        ipAddress: Value(ipAddress),
        userAgent: Value(userAgent),
        sessionId: Value(sessionId),
        success: Value(success),
        errorMessage: Value(errorMessage),
        createdAt: Value(DateTime.now()),
        archived: const Value(false),
      ),
    );
  }

  /// Get audit logs for user
  Future<List<AuditLogEntry>> getAuditLogsForUser(
    String userId, {
    int limit = 100,
  }) async {
    final results =
        await (select(auditLogs)
              ..where((a) => a.userId.equals(userId))
              ..where((a) => a.archived.equals(false))
              ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
              ..limit(limit))
            .get();
    return results.map(_auditLogFromRow).toList();
  }

  /// Get audit logs for resource
  Future<List<AuditLogEntry>> getAuditLogsForResource(
    String resourceType,
    String resourceId, {
    int limit = 100,
  }) async {
    final results =
        await (select(auditLogs)
              ..where((a) => a.resourceType.equals(resourceType))
              ..where((a) => a.resourceId.equals(resourceId))
              ..where((a) => a.archived.equals(false))
              ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
              ..limit(limit))
            .get();
    return results.map(_auditLogFromRow).toList();
  }

  /// Get recent audit logs
  Future<List<AuditLogEntry>> getRecentAuditLogs({int limit = 100}) async {
    final results =
        await (select(auditLogs)
              ..where((a) => a.archived.equals(false))
              ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
              ..limit(limit))
            .get();
    return results.map(_auditLogFromRow).toList();
  }

  AuditLogEntry _auditLogFromRow(AuditLog row) {
    return AuditLogEntry(
      id: row.id,
      userId: row.userId,
      userEmail: row.userEmail,
      action: row.action,
      resourceType: row.resourceType,
      resourceId: row.resourceId,
      details: row.details,
      ipAddress: row.ipAddress,
      userAgent: row.userAgent,
      sessionId: row.sessionId,
      success: row.success,
      errorMessage: row.errorMessage,
      createdAt: row.createdAt,
    );
  }

  // ============ SESSIONS ============

  /// Create session
  Future<void> createSession({
    required String sessionId,
    required String userId,
    required String deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) async {
    await into(sessions).insert(
      SessionsCompanion(
        id: Value(sessionId),
        userId: Value(userId),
        deviceId: Value(deviceId),
        deviceName: Value(deviceName),
        deviceType: Value(deviceType),
        ipAddress: Value(ipAddress),
        createdAt: Value(createdAt),
        lastActivityAt: Value(createdAt),
        expiresAt: Value(expiresAt),
        isActive: const Value(true),
      ),
    );
  }

  /// Get session by ID
  Future<Session?> getSession(String sessionId) async {
    return await (select(
      sessions,
    )..where((s) => s.id.equals(sessionId))).getSingleOrNull();
  }

  /// Update session activity
  Future<void> updateSessionActivity({
    required String sessionId,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
  }) async {
    await (update(sessions)..where((s) => s.id.equals(sessionId))).write(
      SessionsCompanion(
        lastActivityAt: Value(lastActivityAt),
        expiresAt: Value(expiresAt),
      ),
    );
  }

  /// Invalidate session
  Future<void> invalidateSession(String sessionId) async {
    await (update(sessions)..where((s) => s.id.equals(sessionId))).write(
      const SessionsCompanion(isActive: Value(false)),
    );
  }

  /// Invalidate all user sessions
  Future<void> invalidateAllUserSessions(String userId) async {
    await (update(sessions)..where((s) => s.userId.equals(userId))).write(
      const SessionsCompanion(isActive: Value(false)),
    );
  }

  /// Invalidate other sessions for device
  Future<void> invalidateOtherSessionsForDevice({
    required String userId,
    required String deviceId,
    required String currentSessionId,
  }) async {
    await (update(sessions)
          ..where((s) => s.userId.equals(userId))
          ..where((s) => s.deviceId.equals(deviceId))
          ..where((s) => s.id.isNotValue(currentSessionId)))
        .write(const SessionsCompanion(isActive: Value(false)));
  }

  /// Get active sessions for user
  Future<List<SessionInfo>> getActiveSessionsForUser(String userId) async {
    final results =
        await (select(sessions)
              ..where((s) => s.userId.equals(userId))
              ..where((s) => s.isActive.equals(true))
              ..orderBy([(s) => OrderingTerm.desc(s.lastActivityAt)]))
            .get();
    return results
        .map(
          (r) => SessionInfo(
            id: r.id,
            userId: r.userId,
            deviceId: r.deviceId,
            deviceName: r.deviceName,
            deviceType: r.deviceType,
            ipAddress: r.ipAddress,
            createdAt: r.createdAt,
            lastActivityAt: r.lastActivityAt,
            expiresAt: r.expiresAt,
            isActive: r.isActive,
          ),
        )
        .toList();
  }

  /// Cleanup expired sessions
  Future<void> cleanupExpiredSessions() async {
    final now = DateTime.now();
    await (update(sessions)
          ..where((s) => s.expiresAt.isSmallerThanValue(now))
          ..where((s) => s.isActive.equals(true)))
        .write(const SessionsCompanion(isActive: Value(false)));
  }

  // ============ HEADPHONE PROFILES ============

  /// Get all headphone profiles
  Future<List<HeadphoneProfile>> getAllHeadphoneProfiles() async {
    return await select(headphoneProfiles).get();
  }

  /// Get validated headphone profiles
  Future<List<HeadphoneProfile>> getValidatedHeadphoneProfiles() async {
    return await (select(
      headphoneProfiles,
    )..where((h) => h.isValidated.equals(true))).get();
  }

  /// Get headphone profile by brand and model
  Future<HeadphoneProfile?> getHeadphoneProfile(
    String brand,
    String model,
  ) async {
    return await (select(headphoneProfiles)
          ..where((h) => h.brand.equals(brand))
          ..where((h) => h.model.equals(model)))
        .getSingleOrNull();
  }

  /// Insert or update headphone profile
  Future<void> upsertHeadphoneProfile(HeadphoneProfileModel profile) async {
    await into(headphoneProfiles).insertOnConflictUpdate(
      HeadphoneProfilesCompanion(
        id: Value(profile.id),
        brand: Value(profile.brand),
        model: Value(profile.model),
        type: Value(profile.type),
        retsplValues: Value(jsonEncode(profile.retsplValues)),
        corrections: Value(
          profile.corrections != null ? jsonEncode(profile.corrections) : null,
        ),
        isValidated: Value(profile.isValidated),
        validationDate: Value(profile.validationDate),
        validationAccuracy: Value(profile.validationAccuracy),
        participantCount: Value(profile.participantCount),
        approvedUsage: Value(profile.approvedUsage),
        notes: Value(profile.notes),
        createdAt: Value(profile.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ============ CALIBRATION ============

  /// Get calibration for frequency
  Future<double> getCalibrationCorrection(int frequency) async {
    final result = await (select(
      calibrationSettings,
    )..where((c) => c.frequency.equals(frequency))).getSingleOrNull();
    return result?.correction ?? 0.0;
  }

  /// Set calibration for frequency
  Future<void> setCalibration({
    required int frequency,
    required double correction,
    required String calibratedBy,
    String? headphoneProfileId,
    String? notes,
  }) async {
    await into(calibrationSettings).insertOnConflictUpdate(
      CalibrationSettingsCompanion(
        id: Value('cal_$frequency'),
        frequency: Value(frequency),
        correction: Value(correction),
        calibratedAt: Value(DateTime.now()),
        calibratedBy: Value(calibratedBy),
        headphoneProfileId: Value(headphoneProfileId),
        notes: Value(notes),
      ),
    );
  }

  /// Get all calibration settings
  Future<Map<int, double>> getAllCalibrations() async {
    final results = await select(calibrationSettings).get();
    return {for (var r in results) r.frequency: r.correction};
  }

  // ============ APP SETTINGS ============

  /// Get app setting
  Future<String?> getAppSetting(String key) async {
    final result = await (select(
      appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  /// Set app setting
  Future<void> setAppSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ============ BC IMPORTS ============

  /// Insert BC import record
  Future<void> insertBcImport(BcImportsCompanion data) async {
    await into(bcImports).insertOnConflictUpdate(data);
  }

  /// Get all BC imports
  Future<List<BcImport>> getAllBcImports() async {
    return await select(bcImports).get();
  }

  /// Get BC imports for a patient
  Future<List<BcImport>> getBcImportsForPatient(String patientId) async {
    return await (select(bcImports)
          ..where((b) => b.patientId.equals(patientId))
          ..orderBy([(b) => OrderingTerm.desc(b.importedAt)]))
        .get();
  }

  /// Update BC import status
  Future<void> updateBcImportStatus(
    String id,
    String status, {
    String? notes,
  }) async {
    await (update(bcImports)..where((b) => b.id.equals(id))).write(
      BcImportsCompanion(status: Value(status), notes: Value(notes)),
    );
  }

  // ============ USERS ============

  /// Get user by ID
  Future<User?> getUserById(String id) async {
    return await (select(
      users,
    )..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    return await (select(
      users,
    )..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  /// Get all audiologists (for admin)
  Future<List<User>> getAllAudiologists() async {
    return await (select(users)
          ..where((u) => u.role.equals('audiologist'))
          ..orderBy([(u) => OrderingTerm.asc(u.name)]))
        .get();
  }

  /// Get pending audiologist verifications (for admin)
  Future<List<User>> getPendingAudiologistVerifications() async {
    return await (select(users)
          ..where((u) => u.role.equals('audiologist'))
          ..where((u) => u.isVerified.equals(false))
          ..where((u) => u.isActive.equals(true)))
        .get();
  }

  /// Get all users (for admin)
  Future<List<UserModel>> getAllUsers() async {
    final results = await (select(
      users,
    )..orderBy([(u) => OrderingTerm.asc(u.name)])).get();
    return results.map(_userModelFromRow).toList();
  }

  /// Create user
  Future<void> createUser(UserModel user) async {
    await into(users).insert(
      UsersCompanion(
        id: Value(user.id),
        email: Value(user.email),
        name: Value(user.name),
        role: Value(user.role),
        avatarUrl: Value(user.avatarUrl),
        licenseNumber: Value(user.licenseNumber),
        licenseState: Value(user.licenseState),
        licenseExpiryDate: Value(user.licenseExpiryDate),
        isVerified: Value(user.isVerified),
        verifiedBy: Value(user.verifiedBy),
        verifiedAt: Value(user.verifiedAt),
        isActive: Value(user.isActive),
        isSuspended: Value(user.isSuspended),
        suspensionReason: Value(user.suspensionReason),
        failedLoginAttempts: Value(user.failedLoginAttempts),
        lockedUntil: Value(user.lockedUntil),
        lastLoginAt: Value(user.lastLoginAt),
        lastLoginIp: Value(user.lastLoginIp),
        createdAt: Value(user.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    await (update(users)..where((u) => u.id.equals(user.id))).write(
      UsersCompanion(
        email: Value(user.email),
        name: Value(user.name),
        role: Value(user.role),
        avatarUrl: Value(user.avatarUrl),
        licenseNumber: Value(user.licenseNumber),
        licenseState: Value(user.licenseState),
        licenseExpiryDate: Value(user.licenseExpiryDate),
        isVerified: Value(user.isVerified),
        verifiedBy: Value(user.verifiedBy),
        verifiedAt: Value(user.verifiedAt),
        isActive: Value(user.isActive),
        isSuspended: Value(user.isSuspended),
        suspensionReason: Value(user.suspensionReason),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete user (soft delete)
  Future<void> deleteUser(String userId) async {
    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Convert User row to UserModel
  UserModel _userModelFromRow(User row) {
    return UserModel(
      id: row.id,
      email: row.email,
      name: row.name,
      role: row.role,
      avatarUrl: row.avatarUrl,
      licenseNumber: row.licenseNumber,
      licenseState: row.licenseState,
      licenseExpiryDate: row.licenseExpiryDate,
      isVerified: row.isVerified,
      verifiedBy: row.verifiedBy,
      verifiedAt: row.verifiedAt,
      isActive: row.isActive,
      isSuspended: row.isSuspended,
      suspensionReason: row.suspensionReason,
      failedLoginAttempts: row.failedLoginAttempts,
      lockedUntil: row.lockedUntil,
      lastLoginAt: row.lastLoginAt,
      lastLoginIp: row.lastLoginIp,
      createdAt: row.createdAt,
    );
  }

  /// Insert or update user
  Future<void> upsertUser(UserModel user) async {
    await into(users).insertOnConflictUpdate(
      UsersCompanion(
        id: Value(user.id),
        email: Value(user.email),
        name: Value(user.name),
        role: Value(user.role),
        avatarUrl: Value(user.avatarUrl),
        licenseNumber: Value(user.licenseNumber),
        licenseState: Value(user.licenseState),
        licenseExpiryDate: Value(user.licenseExpiryDate),
        isVerified: Value(user.isVerified),
        verifiedBy: Value(user.verifiedBy),
        verifiedAt: Value(user.verifiedAt),
        isActive: Value(user.isActive),
        isSuspended: Value(user.isSuspended),
        suspensionReason: Value(user.suspensionReason),
        failedLoginAttempts: Value(user.failedLoginAttempts),
        lockedUntil: Value(user.lockedUntil),
        lastLoginAt: Value(user.lastLoginAt),
        lastLoginIp: Value(user.lastLoginIp),
        createdAt: Value(user.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update failed login attempts
  Future<void> incrementFailedLoginAttempts(String userId) async {
    final user = await getUserById(userId);
    if (user == null) return;

    final newAttempts = user.failedLoginAttempts + 1;
    DateTime? lockUntil;

    if (newAttempts >= AppConstants.maxLoginAttempts) {
      lockUntil = DateTime.now().add(
        Duration(minutes: AppConstants.lockoutDurationMinutes),
      );
    }

    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        failedLoginAttempts: Value(newAttempts),
        lockedUntil: Value(lockUntil),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Reset failed login attempts on successful login
  Future<void> resetFailedLoginAttempts(String userId) async {
    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        failedLoginAttempts: const Value(0),
        lockedUntil: const Value(null),
        lastLoginAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Verify audiologist
  Future<void> verifyAudiologist(String userId, String verifiedBy) async {
    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        isVerified: const Value(true),
        verifiedBy: Value(verifiedBy),
        verifiedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Suspend user
  Future<void> suspendUser(String userId, String reason) async {
    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        isSuspended: const Value(true),
        suspensionReason: Value(reason),
        updatedAt: Value(DateTime.now()),
      ),
    );
    // Invalidate all sessions for suspended user
    await invalidateAllUserSessions(userId);
  }

  /// Reactivate user
  Future<void> reactivateUser(String userId) async {
    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        isSuspended: const Value(false),
        suspensionReason: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

/// Open SQLite database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      // For web verification, we'll use a mock connection that doesn't rely on FFI.
      // In a real production web app, we would use WasmDatabase or drift_web.
      // This allows the app to start and show the UI without crashing.
      return _WebDatabaseMock();
    }
    return conn.openConnection();
  });
}

/// A simple mock database for web UI verification
class _WebDatabaseMock extends QueryExecutor {
  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  bool get isSequential => true;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

  Future<void> runBatch(BatchedStatements statements) async {}

  @override
  Future<void> runBatched(BatchedStatements statements) async {}

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {}

  @override
  Future<int> runDelete(String statement, List<Object?> args) async => 0;

  @override
  Future<int> runInsert(String statement, List<Object?> args) async => 0;

  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) async => [];

  @override
  Future<int> runUpdate(String statement, List<Object?> args) async => 0;

  @override
  TransactionExecutor beginTransaction() => _WebTransactionMock();

  @override
  QueryExecutor beginExclusive() => this;
}

class _WebTransactionMock extends TransactionExecutor {
  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;
  Future<void> runBatch(BatchedStatements statements) async {}
  @override
  Future<void> runBatched(BatchedStatements statements) async {}
  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {}
  @override
  Future<int> runDelete(String statement, List<Object?> args) async => 0;
  @override
  Future<int> runInsert(String statement, List<Object?> args) async => 0;
  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) async => [];
  @override
  Future<int> runUpdate(String statement, List<Object?> args) async => 0;
  Future<void> commit() async {}
  @override
  Future<void> rollback() async {}
  @override
  Future<void> send() async {}
  @override
  bool get supportsNestedTransactions => false;
  @override
  TransactionExecutor beginTransaction() => this;
  @override
  QueryExecutor beginExclusive() => this;
}

// Type aliases for generated classes
typedef Patientobj = DbPatient;
typedef TestResultobj = DbTestResult;

// ============ MODELS ============

/// Screening result model
class ScreeningResultModel {
  final String id;
  final String userId;
  final DateTime testDate;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final String result; // 'pass', 'refer', 'incomplete'
  final List<int> frequenciesTested;
  final Map<String, int> thresholds;
  final String? deviceInfo;

  const ScreeningResultModel({
    required this.id,
    required this.userId,
    required this.testDate,
    this.headphoneModel,
    this.ambientNoiseDb,
    required this.result,
    required this.frequenciesTested,
    required this.thresholds,
    this.deviceInfo,
  });
}

/// Headphone profile model
class HeadphoneProfileModel {
  final String id;
  final String brand;
  final String model;
  final String type; // 'professional', 'validated', 'generic'
  final Map<String, double> retsplValues;
  final Map<String, double>? corrections;
  final bool isValidated;
  final DateTime? validationDate;
  final double? validationAccuracy;
  final int? participantCount;
  final String
  approvedUsage; // 'diagnostic', 'screening', 'screeningWithWarning'
  final String? notes;
  final DateTime? createdAt;

  const HeadphoneProfileModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.type,
    required this.retsplValues,
    this.corrections,
    this.isValidated = false,
    this.validationDate,
    this.validationAccuracy,
    this.participantCount,
    required this.approvedUsage,
    this.notes,
    this.createdAt,
  });
}

/// User model with security fields
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatarUrl;
  final String? licenseNumber;
  final String? licenseState;
  final DateTime? licenseExpiryDate;
  final bool isVerified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final bool isActive;
  final bool isSuspended;
  final String? suspensionReason;
  final int failedLoginAttempts;
  final DateTime? lockedUntil;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.licenseNumber,
    this.licenseState,
    this.licenseExpiryDate,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.isActive = true,
    this.isSuspended = false,
    this.suspensionReason,
    this.failedLoginAttempts = 0,
    this.lockedUntil,
    this.lastLoginAt,
    this.lastLoginIp,
    required this.createdAt,
  });

  bool get isLocked =>
      lockedUntil != null && DateTime.now().isBefore(lockedUntil!);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? avatarUrl,
    String? licenseNumber,
    String? licenseState,
    DateTime? licenseExpiryDate,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isActive,
    bool? isSuspended,
    String? suspensionReason,
    int? failedLoginAttempts,
    DateTime? lockedUntil,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseState: licenseState ?? this.licenseState,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isActive: isActive ?? this.isActive,
      isSuspended: isSuspended ?? this.isSuspended,
      suspensionReason: suspensionReason ?? this.suspensionReason,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
