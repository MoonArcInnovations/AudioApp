import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../domain/repositories/clinician_test_repository.dart';

class UpdateClinicianTestUseCase implements UseCase<void, ClinicianTestRecord> {
  const UpdateClinicianTestUseCase(this._repository);

  final ClinicianTestRepository _repository;

  @override
  Future<void> call(ClinicianTestRecord params) {
    return _repository.updateTestResult(params);
  }
}
