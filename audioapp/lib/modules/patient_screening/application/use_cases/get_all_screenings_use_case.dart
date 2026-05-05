import '../../../../core/application/use_case.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../domain/repositories/patient_screening_repository.dart';

class GetAllScreeningsUseCase
    implements UseCase<List<PatientScreeningRecord>, NoParams> {
  final PatientScreeningRepository _repository;

  const GetAllScreeningsUseCase(this._repository);

  @override
  Future<List<PatientScreeningRecord>> call(NoParams params) {
    return _repository.getAllScreeningResults();
  }
}
