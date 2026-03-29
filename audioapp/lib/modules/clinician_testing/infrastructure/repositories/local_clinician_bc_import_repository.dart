import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/local/app_database.dart'
    show AppDatabase, BcImport, BcImportsCompanion;
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../../../services/bc/bc_import_parser.dart';
import '../../domain/entities/clinician_bc_import_record.dart';
import '../../domain/repositories/clinician_bc_import_repository.dart';
import '../../domain/services/test_result_factory.dart';

class LocalClinicianBcImportRepository implements ClinicianBcImportRepository {
  LocalClinicianBcImportRepository({
    required AppDatabase database,
    required TestResultFactory testResultFactory,
    BcImportParser? parser,
    Uuid? uuid,
  }) : _database = database,
       _testResultFactory = testResultFactory,
       _parser = parser ?? BcImportParser(),
       _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final TestResultFactory _testResultFactory;
  final BcImportParser _parser;
  final Uuid _uuid;

  ClinicianBcImportRecord _toRecord(BcImport item) {
    return ClinicianBcImportRecord(
      id: item.id,
      patientId: item.patientId,
      screeningId: item.screeningId,
      fileName: item.fileName,
      filePath: item.filePath,
      fileType: item.fileType,
      importedBy: item.importedBy,
      importedAt: item.importedAt,
      status: item.status,
      notes: item.notes,
    );
  }

  @override
  Future<ClinicianBcImportRecord> addImport({
    required String patientId,
    String? screeningId,
    required File sourceFile,
    required String fileType,
    required String importedBy,
  }) async {
    final id = _uuid.v4();
    final appDir = await getApplicationDocumentsDirectory();
    final bcDir = Directory('${appDir.path}/bc_imports');
    if (!await bcDir.exists()) {
      await bcDir.create(recursive: true);
    }

    final fileName = sourceFile.uri.pathSegments.last;
    final targetPath = '${bcDir.path}/$id-$fileName';
    await sourceFile.copy(targetPath);

    final companion = BcImportsCompanion.insert(
      id: id,
      patientId: patientId,
      screeningId: screeningId == null || screeningId.isEmpty
          ? const Value.absent()
          : Value(screeningId),
      fileName: fileName,
      filePath: targetPath,
      fileType: fileType,
      importedBy: importedBy,
      importedAt: DateTime.now(),
      status: const Value('pending'),
      notes: const Value.absent(),
    );

    await _database.insertBcImport(companion);
    final inserted = (await _database.getAllBcImports()).firstWhere(
      (value) => value.id == id,
    );

    await _tryParseImport(inserted);
    return _toRecord(inserted);
  }

  @override
  Future<List<ClinicianBcImportRecord>> getAll() async {
    final imports = await _database.getAllBcImports();
    return imports.map(_toRecord).toList();
  }

  @override
  Future<List<ClinicianBcImportRecord>> getForPatient(String patientId) async {
    final imports = await _database.getBcImportsForPatient(patientId);
    return imports.map(_toRecord).toList();
  }

  Future<void> _tryParseImport(BcImport item) async {
    try {
      final file = File(item.filePath);
      if (!await file.exists()) {
        await _database.updateBcImportStatus(
          item.id,
          'failed',
          notes: 'File missing on device',
        );
        return;
      }

      final parsed = await _parser.parse(file, item.fileType);
      if (!parsed.hasData) {
        await _database.updateBcImportStatus(
          item.id,
          'failed',
          notes: parsed.notes ?? 'No data parsed',
        );
        return;
      }

      final rightPoints = parsed.rightEar.entries
          .map(
            (entry) => AudiogramPoint(
              frequency: entry.key,
              thresholdDb: entry.value,
              ear: Ear.right,
            ),
          )
          .toList();
      final leftPoints = parsed.leftEar.entries
          .map(
            (entry) => AudiogramPoint(
              frequency: entry.key,
              thresholdDb: entry.value,
              ear: Ear.left,
            ),
          )
          .toList();

      final result = _testResultFactory.create(
        patientId: item.patientId,
        audiologistId: item.importedBy,
        testDate: parsed.testDate,
        rightEarResults: rightPoints,
        leftEarResults: leftPoints,
        testType: 'bone',
        screeningId: item.screeningId,
        notes: 'Imported from ${item.fileName}',
      );

      await _database.upsertClinicianTestResult(result, synced: false);
      await _database.updateBcImportStatus(item.id, 'parsed');
    } catch (error) {
      await _database.updateBcImportStatus(
        item.id,
        'failed',
        notes: error.toString(),
      );
    }
  }
}
