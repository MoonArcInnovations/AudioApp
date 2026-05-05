import '../../../../core/application/use_case.dart';
import '../../domain/repositories/clinician_patient_repository.dart';

class DeleteClinicianPatientUseCase implements UseCase<void, String> {
  const DeleteClinicianPatientUseCase(this._repository);

  final ClinicianPatientRepository _repository;

  @override
  Future<void> call(String params) {
    return _repository.deletePatient(params);
  }
}
