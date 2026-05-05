import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../../modules/clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../services/firebase/firestore_service.dart';
import '../../shared/widgets/audiogram_chart.dart';

/// Sync status
enum SyncStatus { idle, syncing, success, error }

/// Sync state
class SyncState {
  final SyncStatus status;
  final String? errorMessage;
  final int pendingCount;
  final DateTime? lastSyncTime;

  const SyncState({
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.pendingCount = 0,
    this.lastSyncTime,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? errorMessage,
    int? pendingCount,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

/// Provider for sync service
final syncServiceProvider = Provider<DataSyncService>((ref) {
  return DataSyncService();
});

/// Provider for sync state
final syncStateProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncServiceProvider));
});

/// Data Sync Service - handles offline-first data synchronization
class DataSyncService {
  final AppDatabase _localDb = AppDatabase();
  final FirestoreService _firestore = FirestoreService();
  final Connectivity _connectivity = Connectivity();

  StreamSubscription? _connectivitySubscription;
  bool _isOnline = false;

  DataSyncService() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result.isNotEmpty && !result.contains(ConnectivityResult.none);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      _isOnline =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });
  }

  bool get isOnline => _isOnline;

  // ============ PATIENTS ============

  /// Get all patients (local first, with background sync)
  Future<List<ClinicianPatientRecord>> getPatients(String audiologistId) async {
    // Always return local data first
    return await _localDb.getClinicianPatientsByAudiologist(audiologistId);
  }

  /// Add patient (saves locally first, then syncs)
  Future<ClinicianPatientRecord> addPatient({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
    required String audiologistId,
    required String createdBy,
  }) async {
    ClinicianPatientRecord patient;

    if (_isOnline) {
      // Add to Firestore first to get the ID
      patient = await _firestore.addPatient(
        name: name,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        email: email,
        notes: notes,
        audiologistId: audiologistId,
        createdBy: createdBy,
      );
      // Cache locally with synced = true
      await _localDb.upsertClinicianPatient(
        patient,
        createdBy: createdBy,
        synced: true,
      );
    } else {
      // Create locally with temp ID
      patient = ClinicianPatientRecord(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        email: email,
        notes: notes,
        audiologistId: audiologistId,
        createdAt: DateTime.now(),
        createdBy: createdBy,
        synced: false,
      );
      // Save locally with synced = false
      await _localDb.upsertClinicianPatient(
        patient,
        createdBy: createdBy,
        synced: false,
      );
    }

    return patient;
  }

  /// Delete patient
  Future<void> deletePatient(String patientId) async {
    // Delete locally first
    await _localDb.deactivatePatient(patientId);

    // Delete from Firestore if online
    if (_isOnline) {
      await _firestore.deletePatient(patientId);
    }
  }

  // ============ TEST RESULTS ============

  /// Get tests for patient
  Future<List<ClinicianTestRecord>> getTestsForPatient(String patientId) async {
    return await _localDb.getClinicianTestsForPatient(patientId);
  }

  /// Save test result
  Future<ClinicianTestRecord> saveTestResult({
    required String patientId,
    required String audiologistId,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    required double rightPta,
    required double leftPta,
    required String rightClassification,
    required String leftClassification,
    String? notes,
    String? recommendations,
    String? testType,
    String? screeningId,
    String? headphoneModel,
    double? ambientNoiseDb,
  }) async {
    ClinicianTestRecord test;

    if (_isOnline) {
      // Save to Firestore first
      test = await _firestore.saveTestResult(
        patientId: patientId,
        audiologistId: audiologistId,
        rightEarResults: rightEarResults,
        leftEarResults: leftEarResults,
        rightPta: rightPta,
        leftPta: leftPta,
        rightClassification: rightClassification,
        leftClassification: leftClassification,
        notes: notes,
        recommendations: recommendations,
        testType: testType,
        screeningId: screeningId,
        headphoneModel: headphoneModel,
        ambientNoiseDb: ambientNoiseDb,
      );
      // Cache locally
      await _localDb.upsertClinicianTestResult(test, synced: true);
    } else {
      // Save locally
      test = ClinicianTestRecord(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        patientId: patientId,
        audiologistId: audiologistId,
        testDate: DateTime.now(),
        testType: testType,
        screeningId: screeningId,
        headphoneModel: headphoneModel,
        ambientNoiseDb: ambientNoiseDb,
        rightEarResults: rightEarResults,
        leftEarResults: leftEarResults,
        rightPta: rightPta,
        leftPta: leftPta,
        rightClassification: rightClassification,
        leftClassification: leftClassification,
        notes: notes,
        recommendations: recommendations,
        synced: false,
      );
      await _localDb.upsertClinicianTestResult(test, synced: false);
    }

    return test;
  }

  // ============ SYNC ============

  /// Sync all pending data
  Future<SyncResult> syncAll() async {
    if (!_isOnline) {
      return SyncResult(success: false, message: 'No internet connection');
    }

    int syncedPatients = 0;
    int syncedTests = 0;
    final errors = <String>[];
    final patientIdMap = <String, String>{};

    try {
      // Sync unsynced patients
      final unsyncedPatients = await _localDb.getUnsyncedClinicianPatients();
      for (final patient in unsyncedPatients) {
        try {
          final newPatient = await _firestore.addPatient(
            name: patient.name,
            dateOfBirth: patient.dateOfBirth,
            phoneNumber: patient.phoneNumber,
            email: patient.email,
            notes: patient.notes,
            audiologistId: patient.audiologistId ?? '',
            createdBy: patient.createdBy,
          );

          // Update local with new ID
          await _localDb.deactivatePatient(patient.id);
          await _localDb.upsertClinicianPatient(
            newPatient,
            createdBy: patient.createdBy,
            synced: true,
          );
          patientIdMap[patient.id] = newPatient.id;
          syncedPatients++;
        } catch (e) {
          errors.add('Failed to sync patient ${patient.name}: $e');
        }
      }

      // Sync unsynced tests
      final unsyncedTests = await _localDb.getUnsyncedClinicianTests();
      for (final test in unsyncedTests) {
        try {
          final syncedTest = test.copyWith(
            patientId: patientIdMap[test.patientId] ?? test.patientId,
          );
          await _firestore.saveTestResult(
            patientId: syncedTest.patientId,
            audiologistId: syncedTest.audiologistId,
            rightEarResults: syncedTest.rightEarResults,
            leftEarResults: syncedTest.leftEarResults,
            rightPta: syncedTest.rightPta,
            leftPta: syncedTest.leftPta,
            rightClassification: syncedTest.rightClassification,
            leftClassification: syncedTest.leftClassification,
            notes: syncedTest.notes,
            recommendations: syncedTest.recommendations,
            testType: syncedTest.testType,
            screeningId: syncedTest.screeningId,
            headphoneModel: syncedTest.headphoneModel,
            ambientNoiseDb: syncedTest.ambientNoiseDb,
          );

          await _localDb.upsertClinicianTestResult(syncedTest, synced: true);
          syncedTests++;
        } catch (e) {
          errors.add('Failed to sync test: $e');
        }
      }

      return SyncResult(
        success: errors.isEmpty,
        message: 'Synced $syncedPatients patients, $syncedTests tests',
        syncedPatients: syncedPatients,
        syncedTests: syncedTests,
        errors: errors,
      );
    } catch (e) {
      return SyncResult(success: false, message: 'Sync failed: $e');
    }
  }

  /// Get count of pending sync items
  Future<int> getPendingSyncCount() async {
    final patients = await _localDb.getUnsyncedClinicianPatients();
    final tests = await _localDb.getUnsyncedClinicianTests();
    return patients.length + tests.length;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

/// Sync result
class SyncResult {
  final bool success;
  final String message;
  final int syncedPatients;
  final int syncedTests;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.message,
    this.syncedPatients = 0,
    this.syncedTests = 0,
    this.errors = const [],
  });
}

/// Sync state notifier
class SyncNotifier extends StateNotifier<SyncState> {
  final DataSyncService _syncService;
  Timer? _periodicSync;

  SyncNotifier(this._syncService) : super(const SyncState()) {
    _startPeriodicSync();
    _checkPendingCount();
  }

  void _startPeriodicSync() {
    // Sync every 5 minutes
    _periodicSync = Timer.periodic(const Duration(minutes: 5), (_) {
      sync();
    });
  }

  Future<void> _checkPendingCount() async {
    final count = await _syncService.getPendingSyncCount();
    state = state.copyWith(pendingCount: count);
  }

  Future<void> sync() async {
    if (!_syncService.isOnline) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: 'No internet connection',
      );
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing);

    final result = await _syncService.syncAll();

    if (result.success) {
      state = state.copyWith(
        status: SyncStatus.success,
        pendingCount: 0,
        lastSyncTime: DateTime.now(),
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: result.message,
      );
    }

    // Reset to idle after delay
    await Future.delayed(const Duration(seconds: 3));
    state = state.copyWith(status: SyncStatus.idle);
  }

  @override
  void dispose() {
    _periodicSync?.cancel();
    super.dispose();
  }
}
