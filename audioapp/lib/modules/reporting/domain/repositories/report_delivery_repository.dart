import '../../domain/entities/report_document.dart';

abstract interface class ReportDeliveryRepository {
  Future<void> previewReport(ReportDocument document);

  Future<void> shareReport(ReportDocument document);
}
