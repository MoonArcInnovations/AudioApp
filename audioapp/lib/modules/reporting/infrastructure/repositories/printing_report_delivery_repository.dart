import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../../domain/entities/report_document.dart';
import '../../domain/repositories/report_delivery_repository.dart';

class PrintingReportDeliveryRepository implements ReportDeliveryRepository {
  const PrintingReportDeliveryRepository();

  @override
  Future<void> previewReport(ReportDocument document) {
    return Printing.layoutPdf(
      onLayout: (format) async => Uint8List.fromList(document.bytes),
      name: document.fileName,
    );
  }

  @override
  Future<void> shareReport(ReportDocument document) {
    return Printing.sharePdf(
      bytes: Uint8List.fromList(document.bytes),
      filename: document.fileName,
    );
  }
}
