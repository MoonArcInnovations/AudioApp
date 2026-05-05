import '../entities/clinician_patient_record.dart';

abstract interface class ClinicianPatientRepository {
  Future<List<ClinicianPatientRecord>> getPatientsForAudiologist(
    String audiologistId,
  );

  Future<ClinicianPatientRecord?> getPatientById(String id);

  Future<ClinicianPatientRecord> addPatient({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
    String? audiologistId,
    required String createdBy,
  });

  Future<void> updatePatient(ClinicianPatientRecord patient);

  Future<void> deletePatient(String id);
}
