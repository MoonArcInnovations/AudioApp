import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';

/// Firestore Database Service for patients and test results
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference<Map<String, dynamic>> get _patientsCollection =>
      _firestore.collection('patients');

  CollectionReference<Map<String, dynamic>> get _testsCollection =>
      _firestore.collection('tests');

  // ============ PATIENTS ============

  /// Get all patients for an audiologist
  Stream<List<ClinicianPatientRecord>> getPatientsStream(String audiologistId) {
    return _patientsCollection
        .where('audiologistId', isEqualTo: audiologistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _patientFromSnapshot(doc)).toList(),
        );
  }

  /// Get all patients (for admin)
  Stream<List<ClinicianPatientRecord>> getAllPatientsStream() {
    return _patientsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _patientFromSnapshot(doc)).toList(),
        );
  }

  /// Get patient by ID
  Future<ClinicianPatientRecord?> getPatient(String patientId) async {
    final doc = await _patientsCollection.doc(patientId).get();
    if (doc.exists) {
      return _patientFromSnapshot(doc);
    }
    return null;
  }

  /// Add new patient
  Future<ClinicianPatientRecord> addPatient({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
    required String audiologistId,
    required String createdBy,
  }) async {
    final docRef = _patientsCollection.doc();

    final patientData = {
      'name': name,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'phoneNumber': phoneNumber,
      'email': email,
      'notes': notes,
      'audiologistId': audiologistId,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(patientData);

    return ClinicianPatientRecord(
      id: docRef.id,
      name: name,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      email: email,
      notes: notes,
      audiologistId: audiologistId,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      synced: true,
    );
  }

  /// Update patient
  Future<void> updatePatient(ClinicianPatientRecord patient) async {
    await _patientsCollection.doc(patient.id).update({
      'name': patient.name,
      'dateOfBirth': Timestamp.fromDate(patient.dateOfBirth),
      'phoneNumber': patient.phoneNumber,
      'email': patient.email,
      'notes': patient.notes,
    });
  }

  /// Delete patient and their tests
  Future<void> deletePatient(String patientId) async {
    // Delete all tests for this patient
    final tests = await _testsCollection
        .where('patientId', isEqualTo: patientId)
        .get();

    final batch = _firestore.batch();
    for (final doc in tests.docs) {
      batch.delete(doc.reference);
    }

    // Delete patient
    batch.delete(_patientsCollection.doc(patientId));

    await batch.commit();
  }

  ClinicianPatientRecord _patientFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ClinicianPatientRecord(
      id: doc.id,
      name: data['name'] ?? '',
      dateOfBirth:
          (data['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime.now(),
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      notes: data['notes'],
      audiologistId: data['audiologistId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      synced: true,
    );
  }

  // ============ TEST RESULTS ============

  /// Get tests for a patient
  Stream<List<ClinicianTestRecord>> getTestsForPatientStream(String patientId) {
    return _testsCollection
        .where('patientId', isEqualTo: patientId)
        .orderBy('testDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _testFromSnapshot(doc)).toList(),
        );
  }

  /// Get all tests for an audiologist
  Stream<List<ClinicianTestRecord>> getTestsForAudiologistStream(
    String audiologistId,
  ) {
    return _testsCollection
        .where('audiologistId', isEqualTo: audiologistId)
        .orderBy('testDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _testFromSnapshot(doc)).toList(),
        );
  }

  /// Get recent tests (for dashboard)
  Future<List<ClinicianTestRecord>> getRecentTests(
    String audiologistId, {
    int limit = 10,
  }) async {
    final snapshot = await _testsCollection
        .where('audiologistId', isEqualTo: audiologistId)
        .orderBy('testDate', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => _testFromSnapshot(doc)).toList();
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
    final docRef = _testsCollection.doc();

    final testData = {
      'patientId': patientId,
      'audiologistId': audiologistId,
      'testDate': FieldValue.serverTimestamp(),
      'testType': testType ?? 'air',
      'screeningId': screeningId,
      'headphoneModel': headphoneModel,
      'ambientNoiseDb': ambientNoiseDb,
      'rightEarResults': rightEarResults
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
      'leftEarResults': leftEarResults
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
      'rightPta': rightPta,
      'leftPta': leftPta,
      'rightClassification': rightClassification,
      'leftClassification': leftClassification,
      'notes': notes,
      'recommendations': recommendations,
      'isComplete': true,
    };

    await docRef.set(testData);

    return ClinicianTestRecord(
      id: docRef.id,
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
      synced: true,
    );
  }

  /// Get test by ID
  Future<ClinicianTestRecord?> getTest(String testId) async {
    final doc = await _testsCollection.doc(testId).get();
    if (doc.exists) {
      return _testFromSnapshot(doc);
    }
    return null;
  }

  /// Delete test
  Future<void> deleteTest(String testId) async {
    await _testsCollection.doc(testId).delete();
  }

  ClinicianTestRecord _testFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return ClinicianTestRecord(
      id: doc.id,
      patientId: data['patientId'] ?? '',
      audiologistId: data['audiologistId'] ?? '',
      testDate: (data['testDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      testType: data['testType'] as String?,
      screeningId: data['screeningId'] as String?,
      headphoneModel: data['headphoneModel'] as String?,
      ambientNoiseDb: (data['ambientNoiseDb'] as num?)?.toDouble(),
      rightEarResults:
          (data['rightEarResults'] as List?)?.map((p) {
            return AudiogramPoint(
              frequency: p['frequency'] as int,
              thresholdDb: p['thresholdDb'] as int,
              ear: Ear.right,
              noResponse: p['noResponse'] as bool? ?? false,
              masked: p['masked'] as bool? ?? false,
              maskingLevel: p['maskingLevel'] as int?,
              maskingEar: _decodeEar(p['maskingEar'] as String?),
            );
          }).toList() ??
          [],
      leftEarResults:
          (data['leftEarResults'] as List?)?.map((p) {
            return AudiogramPoint(
              frequency: p['frequency'] as int,
              thresholdDb: p['thresholdDb'] as int,
              ear: Ear.left,
              noResponse: p['noResponse'] as bool? ?? false,
              masked: p['masked'] as bool? ?? false,
              maskingLevel: p['maskingLevel'] as int?,
              maskingEar: _decodeEar(p['maskingEar'] as String?),
            );
          }).toList() ??
          [],
      rightPta: (data['rightPta'] as num?)?.toDouble() ?? 0,
      leftPta: (data['leftPta'] as num?)?.toDouble() ?? 0,
      rightClassification: data['rightClassification'] ?? 'Normal',
      leftClassification: data['leftClassification'] ?? 'Normal',
      notes: data['notes'],
      recommendations: data['recommendations'],
      isComplete: data['isComplete'] ?? true,
      synced: true,
    );
  }

  Ear? _decodeEar(String? value) {
    if (value == null) {
      return null;
    }
    return Ear.values.where((ear) => ear.name == value).firstOrNull;
  }

  // ============ ANALYTICS ============

  /// Get test count by date range
  Future<int> getTestCount(
    String audiologistId,
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _testsCollection
        .where('audiologistId', isEqualTo: audiologistId)
        .where('testDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('testDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    return snapshot.docs.length;
  }

  /// Get patient count for audiologist
  Future<int> getPatientCount(String audiologistId) async {
    final snapshot = await _patientsCollection
        .where('audiologistId', isEqualTo: audiologistId)
        .get();

    return snapshot.docs.length;
  }
}
