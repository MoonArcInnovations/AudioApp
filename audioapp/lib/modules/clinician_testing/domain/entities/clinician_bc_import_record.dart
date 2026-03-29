class ClinicianBcImportRecord {
  const ClinicianBcImportRecord({
    required this.id,
    required this.patientId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.importedBy,
    required this.importedAt,
    required this.status,
    this.screeningId,
    this.notes,
  });

  final String id;
  final String patientId;
  final String? screeningId;
  final String fileName;
  final String filePath;
  final String fileType;
  final String importedBy;
  final DateTime importedAt;
  final String status;
  final String? notes;
}
