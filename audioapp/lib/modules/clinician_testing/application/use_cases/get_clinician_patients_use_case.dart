import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_patient_record.dart';
import '../../domain/repositories/clinician_patient_repository.dart';

class GetClinicianPatientsUseCase
    implements UseCase<List<ClinicianPatientRecord>, String> {
  const GetClinicianPatientsUseCase(this._repository);

  final ClinicianPatientRepository _repository;

  @override
  Future<List<ClinicianPatientRecord>> call(String params) {
    return _repository.getPatientsForAudiologist(params);
  }
}
