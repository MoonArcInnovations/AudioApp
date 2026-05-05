import 'package:uuid/uuid.dart';

import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../domain/entities/clinician_patient_record.dart';
import '../../domain/repositories/clinician_patient_repository.dart';

class LocalClinicianPatientRepository implements ClinicianPatientRepository {
  const LocalClinicianPatientRepository(this._database);

  final AppDatabase _database;

  @override
  Future<ClinicianPatientRecord> addPatient({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
    String? audiologistId,
    required String createdBy,
  }) async {
    final patient = ClinicianPatientRecord(
      id: const Uuid().v4(),
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

    await _database.upsertClinicianPatient(
      patient,
      createdBy: createdBy,
      synced: false,
    );
    return patient;
  }

  @override
  Future<void> deletePatient(String id) {
    return _database.deactivatePatient(id);
  }

  @override
  Future<ClinicianPatientRecord?> getPatientById(String id) async {
    return _database.getClinicianPatientById(id);
  }

  @override
  Future<List<ClinicianPatientRecord>> getPatientsForAudiologist(
    String audiologistId,
  ) async {
    return _database.getClinicianPatientsByAudiologist(audiologistId);
  }

  @override
  Future<void> updatePatient(ClinicianPatientRecord patient) {
    return _database.upsertClinicianPatient(
      patient,
      createdBy: patient.createdBy,
      synced: false,
    );
  }
}
