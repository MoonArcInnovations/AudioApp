import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../domain/repositories/clinician_test_repository.dart';

class GetClinicianTestResultsUseCase
    implements UseCase<List<ClinicianTestRecord>, String> {
  const GetClinicianTestResultsUseCase(this._repository);

  final ClinicianTestRepository _repository;

  @override
  Future<List<ClinicianTestRecord>> call(String params) {
    return _repository.getAllTestResultsForAudiologist(params);
  }
}
