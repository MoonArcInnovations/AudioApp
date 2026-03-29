abstract interface class ReportAuditRepository {
  Future<void> logTestResultView(String testId);

  Future<void> logReportExport({
    required String resourceType,
    required String resourceId,
    required String exportFormat,
  });
}
