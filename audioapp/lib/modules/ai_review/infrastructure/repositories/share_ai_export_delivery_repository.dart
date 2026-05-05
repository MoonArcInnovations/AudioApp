import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/ai_export_document.dart';
import '../../domain/repositories/ai_export_delivery_repository.dart';

class ShareAiExportDeliveryRepository implements AiExportDeliveryRepository {
  const ShareAiExportDeliveryRepository();

  @override
  Future<void> shareDocument(AiExportDocument document) async {
    if (document.mimeType == 'application/pdf') {
      await Printing.sharePdf(
        bytes: Uint8List.fromList(document.bytes),
        filename: document.fileName,
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${document.fileName}');
    await file.writeAsBytes(document.bytes, flush: true);
    await Share.shareXFiles([
      XFile(file.path, mimeType: document.mimeType),
    ], text: document.shareText);
  }
}
