import '../../../../core/application/use_case.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../domain/repositories/patient_screening_repository.dart';

class GetLatestScreeningUseCase
    implements UseCase<PatientScreeningRecord?, String> {
  final PatientScreeningRepository _repository;

  const GetLatestScreeningUseCase(this._repository);

  @override
  Future<PatientScreeningRecord?> call(String params) {
    return _repository.getLatestScreening(params);
  }
}
