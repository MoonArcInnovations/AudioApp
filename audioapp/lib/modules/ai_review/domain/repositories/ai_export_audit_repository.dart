abstract interface class AiExportAuditRepository {
  Future<void> logAiExport({
    required String resourceId,
    required String exportFormat,
  });
}
