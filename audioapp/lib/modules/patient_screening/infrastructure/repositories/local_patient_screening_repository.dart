import 'package:uuid/uuid.dart';

import '../../../../data/local/app_database.dart'
    show AppDatabase, ScreeningResultModel;
import '../../../../services/security/audit_service.dart';
import '../../domain/entities/patient_screening_record.dart';
import '../../domain/repositories/patient_screening_repository.dart';
import '../../domain/services/screening_result_analyzer.dart';
import '../../domain/value_objects/screening_outcome.dart';

class LocalPatientScreeningRepository implements PatientScreeningRepository {
  LocalPatientScreeningRepository({
    required AppDatabase database,
    required ScreeningResultAnalyzer analyzer,
  }) : _database = database,
       _analyzer = analyzer;

  final AppDatabase _database;
  final ScreeningResultAnalyzer _analyzer;

  PatientScreeningRecord _toRecord(ScreeningResultModel model) {
    return PatientScreeningRecord(
      id: model.id,
      userId: model.userId,
      testDate: model.testDate,
      headphoneModel: model.headphoneModel,
      ambientNoiseDb: model.ambientNoiseDb,
      result: model.result,
      frequenciesTested: model.frequenciesTested,
      thresholds: model.thresholds,
      deviceInfo: model.deviceInfo,
    );
  }

  @override
  Future<PatientScreeningRecord> saveScreeningResult({
    required String userId,
    required Map<String, int> rightEarThresholds,
    required Map<String, int> leftEarThresholds,
    required String headphoneModel,
    required double ambientNoiseDb,
  }) async {
    final result = _analyzer
        .analyze(
          rightEarThresholds: rightEarThresholds,
          leftEarThresholds: leftEarThresholds,
        )
        .storageValue;

    final thresholds = <String, int>{};
    rightEarThresholds.forEach((frequency, value) {
      thresholds['R_$frequency'] = value;
    });
    leftEarThresholds.forEach((frequency, value) {
      thresholds['L_$frequency'] = value;
    });

    final screeningResult = ScreeningResultModel(
      id: const Uuid().v4(),
      userId: userId,
      testDate: DateTime.now(),
      headphoneModel: headphoneModel,
      ambientNoiseDb: ambientNoiseDb,
      result: result,
      frequenciesTested: rightEarThresholds.keys
          .map((value) => int.parse(value))
          .toList(),
      thresholds: thresholds,
      deviceInfo: null,
    );

    await _database.saveScreeningResult(screeningResult);
    await auditService.logScreeningComplete(
      screeningResult.id,
      screeningResult.result,
    );

    return _toRecord(screeningResult);
  }

  @override
  Future<List<PatientScreeningRecord>> getAllScreeningResults() async {
    final results = await _database.getAllScreeningResults();
    return results.map(_toRecord).toList();
  }

  @override
  Future<PatientScreeningRecord?> getLatestScreening(String userId) async {
    final results = await _database.getScreeningResultsForUser(userId);
    if (results.isEmpty) {
      return null;
    }
    return _toRecord(results.first);
  }

  @override
  Future<PatientScreeningRecord?> getScreeningById(String id) async {
    final result = await _database.getScreeningResultById(id);
    return result == null ? null : _toRecord(result);
  }

  @override
  Future<List<PatientScreeningRecord>> getScreeningHistory(
    String userId,
  ) async {
    final results = await _database.getScreeningResultsForUser(userId);
    return results.map(_toRecord).toList();
  }
}
