import '../entities/ai_export_document.dart';

abstract interface class AiExportDeliveryRepository {
  Future<void> shareDocument(AiExportDocument document);
}
