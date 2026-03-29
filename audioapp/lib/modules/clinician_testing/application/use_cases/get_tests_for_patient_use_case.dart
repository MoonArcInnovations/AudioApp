import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../domain/repositories/clinician_test_repository.dart';

class GetTestsForPatientUseCase
    implements UseCase<List<ClinicianTestRecord>, String> {
  const GetTestsForPatientUseCase(this._repository);

  final ClinicianTestRepository _repository;

  @override
  Future<List<ClinicianTestRecord>> call(String params) {
    return _repository.getTestsForPatient(params);
  }
}
