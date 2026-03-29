import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_bc_import_record.dart';
import '../../domain/repositories/clinician_bc_import_repository.dart';

class GetBcImportsForPatientUseCase
    implements UseCase<List<ClinicianBcImportRecord>, String> {
  const GetBcImportsForPatientUseCase(this._repository);

  final ClinicianBcImportRepository _repository;

  @override
  Future<List<ClinicianBcImportRecord>> call(String params) {
    return _repository.getForPatient(params);
  }
}
