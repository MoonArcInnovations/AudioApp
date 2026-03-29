import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_bc_import_record.dart';
import '../../domain/repositories/clinician_bc_import_repository.dart';

class GetBcImportsUseCase
    implements UseCase<List<ClinicianBcImportRecord>, NoParams> {
  const GetBcImportsUseCase(this._repository);

  final ClinicianBcImportRepository _repository;

  @override
  Future<List<ClinicianBcImportRecord>> call(NoParams params) {
    return _repository.getAll();
  }
}
