import '../../../../core/application/use_case.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../domain/repositories/patient_screening_repository.dart';

class GetScreeningHistoryUseCase
    implements UseCase<List<PatientScreeningRecord>, String> {
  final PatientScreeningRepository _repository;

  const GetScreeningHistoryUseCase(this._repository);

  @override
  Future<List<PatientScreeningRecord>> call(String params) {
    return _repository.getScreeningHistory(params);
  }
}
