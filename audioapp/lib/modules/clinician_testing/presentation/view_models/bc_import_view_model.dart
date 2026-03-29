class BcImportViewModel {
  const BcImportViewModel({
    required this.id,
    required this.patientId,
    required this.fileName,
    required this.fileType,
    required this.status,
    required this.importedAt,
    this.screeningId,
  });

  final String id;
  final String patientId;
  final String? screeningId;
  final String fileName;
  final String fileType;
  final String status;
  final DateTime importedAt;
}
