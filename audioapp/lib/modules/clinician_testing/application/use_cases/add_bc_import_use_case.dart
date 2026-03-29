import 'dart:io';

import '../../../../core/application/use_case.dart';
import '../../domain/entities/clinician_bc_import_record.dart';
import '../../domain/repositories/clinician_bc_import_repository.dart';

class AddBcImportParams {
  final String patientId;
  final String? screeningId;
  final File sourceFile;
  final String fileType;
  final String importedBy;

  const AddBcImportParams({
    required this.patientId,
    this.screeningId,
    required this.sourceFile,
    required this.fileType,
    required this.importedBy,
  });
}

class AddBcImportUseCase
    implements UseCase<ClinicianBcImportRecord, AddBcImportParams> {
  const AddBcImportUseCase(this._repository);

  final ClinicianBcImportRepository _repository;

  @override
  Future<ClinicianBcImportRecord> call(AddBcImportParams params) {
    return _repository.addImport(
      patientId: params.patientId,
      screeningId: params.screeningId,
      sourceFile: params.sourceFile,
      fileType: params.fileType,
      importedBy: params.importedBy,
    );
  }
}
