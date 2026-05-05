import '../../../../core/application/use_case.dart';
import '../../domain/repositories/clinician_test_repository.dart';

class DeleteClinicianTestUseCase implements UseCase<void, String> {
  const DeleteClinicianTestUseCase(this._repository);

  final ClinicianTestRepository _repository;

  @override
  Future<void> call(String params) {
    return _repository.deleteTestResult(params);
  }
}
