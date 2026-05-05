import 'dart:io';

import '../entities/clinician_bc_import_record.dart';

abstract interface class ClinicianBcImportRepository {
  Future<ClinicianBcImportRecord> addImport({
    required String patientId,
    String? screeningId,
    required File sourceFile,
    required String fileType,
    required String importedBy,
  });

  Future<List<ClinicianBcImportRecord>> getAll();

  Future<List<ClinicianBcImportRecord>> getForPatient(String patientId);
}
