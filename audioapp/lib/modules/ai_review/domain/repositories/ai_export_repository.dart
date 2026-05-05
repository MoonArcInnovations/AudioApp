import '../entities/ai_decision_export_record.dart';
import '../entities/ai_export_document.dart';

abstract interface class AiExportRepository {
  Future<AiExportDocument> generateCsv({
    required String title,
    required String fileName,
    required List<AiDecisionExportRecord> records,
    String? shareText,
  });

  Future<AiExportDocument> generatePdf({
    required String title,
    required String fileName,
    required List<AiDecisionExportRecord> records,
    String? shareText,
  });
}
