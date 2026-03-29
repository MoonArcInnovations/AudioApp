import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import 'feature_extractor.dart';

class DatasetExporter {
  final FeatureExtractor _extractor = FeatureExtractor();

  Future<File> export({
    required List<ClinicianTestRecord> acTests,
    required Map<String, ClinicianTestRecord> bcByScreeningId,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/ai_dataset.jsonl');
    final sink = file.openWrite();

    for (final ac in acTests) {
      final screeningId = ac.screeningId;
      if (screeningId == null) continue;
      final bc = bcByScreeningId[screeningId];
      if (bc == null) continue;

      final features = _extractor.extract(ac: ac, bc: bc);
      sink.writeln(jsonEncode({
        'screeningId': screeningId,
        'patientId': ac.patientId,
        'features': features,
      }));
    }

    await sink.flush();
    await sink.close();
    return file;
  }
}
