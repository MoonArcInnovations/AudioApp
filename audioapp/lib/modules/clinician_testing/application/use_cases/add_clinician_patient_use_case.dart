import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_patient_record.dart';
import '../../domain/repositories/clinician_patient_repository.dart';

class AddClinicianPatientParams {
  final String name;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? email;
  final String? notes;
  final String? audiologistId;
  final String createdBy;

  const AddClinicianPatientParams({
    required this.name,
    required this.dateOfBirth,
    this.phoneNumber,
    this.email,
    this.notes,
    this.audiologistId,
    required this.createdBy,
  });
}

class AddClinicianPatientUseCase
    implements UseCase<ClinicianPatientRecord, AddClinicianPatientParams> {
  const AddClinicianPatientUseCase(this._repository);

  final ClinicianPatientRepository _repository;

  @override
  Future<ClinicianPatientRecord> call(AddClinicianPatientParams params) {
    return _repository.addPatient(
      name: params.name,
      dateOfBirth: params.dateOfBirth,
      phoneNumber: params.phoneNumber,
      email: params.email,
      notes: params.notes,
      audiologistId: params.audiologistId,
      createdBy: params.createdBy,
    );
  }
}
