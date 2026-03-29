import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_patient_record.dart';
import '../../domain/repositories/clinician_patient_repository.dart';

class UpdateClinicianPatientUseCase
    implements UseCase<void, ClinicianPatientRecord> {
  const UpdateClinicianPatientUseCase(this._repository);

  final ClinicianPatientRepository _repository;

  @override
  Future<void> call(ClinicianPatientRecord params) {
    return _repository.updatePatient(params);
  }
}
