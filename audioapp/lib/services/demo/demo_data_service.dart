import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../data/local/app_database.dart';
import '../../modules/clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';

class DemoDataService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  DemoDataService(this._db);

  Future<bool> isEnabled() async {
    final flag = await _db.getAppSetting('demo_data_seeded');
    return flag == 'true';
  }

  Future<void> seedIfNeeded() async {
    final flag = await _db.getAppSetting('demo_data_seeded');
    if (flag == 'true') return;
    await seedDemoData();
    await _db.setAppSetting('demo_data_seeded', 'true');
  }

  Future<void> setDemoEnabled(bool enabled) async {
    await _db.setAppSetting('demo_data_seeded', enabled ? 'true' : 'false');
  }

  Future<void> seedDemoData() async {
    final audiologistId = 'demo_audiologist';

    final patient1 = ClinicianPatientRecord(
      id: _uuid.v4(),
      name: 'Demo Patient 1',
      dateOfBirth: DateTime(1985, 5, 20),
      phoneNumber: '+977-9800000001',
      email: 'demo1@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      audiologistId: audiologistId,
      createdBy: audiologistId,
      synced: false,
    );

    final patient2 = ClinicianPatientRecord(
      id: _uuid.v4(),
      name: 'Demo Patient 2',
      dateOfBirth: DateTime(1992, 9, 12),
      phoneNumber: '+977-9800000002',
      email: 'demo2@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      audiologistId: audiologistId,
      createdBy: audiologistId,
      synced: false,
    );

    await _db.upsertClinicianPatient(
      patient1,
      createdBy: audiologistId,
      synced: false,
    );
    await _db.upsertClinicianPatient(
      patient2,
      createdBy: audiologistId,
      synced: false,
    );

    final screeningId = _uuid.v4();
    final screening = ScreeningResultModel(
      id: screeningId,
      userId: patient1.id,
      testDate: DateTime.now().subtract(const Duration(days: 2)),
      headphoneModel: 'Demo Headphones',
      ambientNoiseDb: 32.0,
      result: 'borderline',
      frequenciesTested: const [500, 1000, 2000, 4000],
      thresholds: {
        'R_500': 20,
        'R_1000': 25,
        'R_2000': 30,
        'R_4000': 35,
        'L_500': 15,
        'L_1000': 20,
        'L_2000': 25,
        'L_4000': 30,
      },
      deviceInfo: 'Demo Device',
    );
    await _db.saveScreeningResult(screening);

    final acTest = ClinicianTestRecord(
      id: _uuid.v4(),
      patientId: patient1.id,
      audiologistId: audiologistId,
      testDate: DateTime.now().subtract(const Duration(days: 2)),
      testType: 'air',
      screeningId: screeningId,
      rightEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 20, ear: Ear.right),
        AudiogramPoint(frequency: 1000, thresholdDb: 25, ear: Ear.right),
        AudiogramPoint(frequency: 2000, thresholdDb: 30, ear: Ear.right),
        AudiogramPoint(frequency: 4000, thresholdDb: 35, ear: Ear.right),
      ],
      leftEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 15, ear: Ear.left),
        AudiogramPoint(frequency: 1000, thresholdDb: 20, ear: Ear.left),
        AudiogramPoint(frequency: 2000, thresholdDb: 25, ear: Ear.left),
        AudiogramPoint(frequency: 4000, thresholdDb: 30, ear: Ear.left),
      ],
      rightPta: 27.5,
      leftPta: 22.5,
      rightClassification: 'Mild',
      leftClassification: 'Normal',
      synced: false,
    );
    await _db.upsertClinicianTestResult(acTest, synced: false);

    final bcTest = ClinicianTestRecord(
      id: _uuid.v4(),
      patientId: patient1.id,
      audiologistId: audiologistId,
      testDate: DateTime.now().subtract(const Duration(days: 1)),
      testType: 'bone',
      screeningId: screeningId,
      rightEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 10, ear: Ear.right),
        AudiogramPoint(frequency: 1000, thresholdDb: 15, ear: Ear.right),
        AudiogramPoint(frequency: 2000, thresholdDb: 20, ear: Ear.right),
        AudiogramPoint(frequency: 4000, thresholdDb: 25, ear: Ear.right),
      ],
      leftEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 10, ear: Ear.left),
        AudiogramPoint(frequency: 1000, thresholdDb: 15, ear: Ear.left),
        AudiogramPoint(frequency: 2000, thresholdDb: 20, ear: Ear.left),
        AudiogramPoint(frequency: 4000, thresholdDb: 25, ear: Ear.left),
      ],
      rightPta: 17.5,
      leftPta: 17.5,
      rightClassification: 'Normal',
      leftClassification: 'Normal',
      synced: false,
    );
    await _db.upsertClinicianTestResult(bcTest, synced: false);

    final ac2 = ClinicianTestRecord(
      id: _uuid.v4(),
      patientId: patient2.id,
      audiologistId: audiologistId,
      testDate: DateTime.now().subtract(const Duration(days: 3)),
      testType: 'air',
      rightEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 30, ear: Ear.right),
        AudiogramPoint(frequency: 1000, thresholdDb: 35, ear: Ear.right),
        AudiogramPoint(frequency: 2000, thresholdDb: 40, ear: Ear.right),
        AudiogramPoint(frequency: 4000, thresholdDb: 45, ear: Ear.right),
      ],
      leftEarResults: [
        AudiogramPoint(frequency: 500, thresholdDb: 25, ear: Ear.left),
        AudiogramPoint(frequency: 1000, thresholdDb: 30, ear: Ear.left),
        AudiogramPoint(frequency: 2000, thresholdDb: 35, ear: Ear.left),
        AudiogramPoint(frequency: 4000, thresholdDb: 40, ear: Ear.left),
      ],
      rightPta: 37.5,
      leftPta: 32.5,
      rightClassification: 'Moderate',
      leftClassification: 'Mild',
      synced: false,
    );
    await _db.upsertClinicianTestResult(ac2, synced: false);
  }
}
