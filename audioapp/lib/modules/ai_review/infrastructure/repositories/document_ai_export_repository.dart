import 'dart:convert';

import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/ai_decision_export_record.dart';
import '../../domain/entities/ai_export_document.dart';
import '../../domain/repositories/ai_export_repository.dart';

class DocumentAiExportRepository implements AiExportRepository {
  const DocumentAiExportRepository();

  @override
  Future<AiExportDocument> generateCsv({
    required String title,
    required String fileName,
    required List<AiDecisionExportRecord> records,
    String? shareText,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln(
      'testId,patientId,testDate,suggestion,confidence,decision,decisionAt',
    );
    for (final record in records) {
      buffer.writeln(
        [
          record.testId,
          record.patientId,
          record.testDateIso,
          record.suggestionType,
          record.confidence.toStringAsFixed(2),
          record.decision,
          record.decisionAtIso ?? '',
        ].map(_csvEscape).join(','),
      );
    }

    return AiExportDocument(
      bytes: utf8.encode(buffer.toString()),
      fileName: fileName,
      mimeType: 'text/csv',
      shareText: shareText ?? title,
    );
  }

  @override
  Future<AiExportDocument> generatePdf({
    required String title,
    required String fileName,
    required List<AiDecisionExportRecord> records,
    String? shareText,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Test',
              'Patient',
              'Date',
              'Suggestion',
              'Conf.',
              'Decision',
            ],
            data: records
                .map(
                  (record) => [
                    record.testId,
                    record.patientId,
                    record.testDateIso,
                    record.suggestionType,
                    record.confidence.toStringAsFixed(2),
                    record.decision,
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    return AiExportDocument(
      bytes: await document.save(),
      fileName: fileName,
      mimeType: 'application/pdf',
      shareText: shareText ?? title,
    );
  }

  String _csvEscape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
