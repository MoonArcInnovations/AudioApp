import '../../../../core/application/use_case.dart';
import '../../../clinician_testing/domain/entities/clinician_test_record.dart';
import '../../../clinician_testing/domain/repositories/clinician_test_repository.dart';
import '../../domain/entities/ai_decision_export_record.dart';
import '../../domain/repositories/ai_export_audit_repository.dart';
import '../../domain/repositories/ai_export_delivery_repository.dart';
import '../../domain/repositories/ai_export_repository.dart';
import '../../domain/repositories/ai_review_repository.dart';
import 'ai_decision_export_params.dart';

class ShareAiDecisionPdfUseCase
    implements UseCase<int, AiDecisionExportParams> {
  const ShareAiDecisionPdfUseCase({
    required AiReviewRepository aiReviewRepository,
    required ClinicianTestRepository clinicianTestRepository,
    required AiExportRepository aiExportRepository,
    required AiExportDeliveryRepository aiExportDeliveryRepository,
    required AiExportAuditRepository aiExportAuditRepository,
  }) : _aiReviewRepository = aiReviewRepository,
       _clinicianTestRepository = clinicianTestRepository,
       _aiExportRepository = aiExportRepository,
       _aiExportDeliveryRepository = aiExportDeliveryRepository,
       _aiExportAuditRepository = aiExportAuditRepository;

  final AiReviewRepository _aiReviewRepository;
  final ClinicianTestRepository _clinicianTestRepository;
  final AiExportRepository _aiExportRepository;
  final AiExportDeliveryRepository _aiExportDeliveryRepository;
  final AiExportAuditRepository _aiExportAuditRepository;

  @override
  Future<int> call(AiDecisionExportParams params) async {
    final records = await _buildRecords(params);
    if (records.isEmpty) {
      return 0;
    }

    final document = await _aiExportRepository.generatePdf(
      title: _titleFor(params),
      fileName: _fileNameFor(params, 'pdf'),
      records: records,
      shareText: _shareTextFor(params),
    );
    await _aiExportDeliveryRepository.shareDocument(document);
    await _aiExportAuditRepository.logAiExport(
      resourceId: _resourceIdFor(params),
      exportFormat: 'pdf',
    );
    return records.length;
  }

  Future<List<AiDecisionExportRecord>> _buildRecords(
    AiDecisionExportParams params,
  ) async {
    final tests = await _loadTests(params);
    if (tests.isEmpty) {
      return const [];
    }

    final recommendations = await _aiReviewRepository.getAll();
    final recommendationByTestId = {
      for (final recommendation in recommendations)
        recommendation.testId: recommendation,
    };

    return tests
        .where((test) => recommendationByTestId.containsKey(test.id))
        .map((test) {
          final recommendation = recommendationByTestId[test.id]!;
          final decision = recommendation.accepted == null
              ? 'pending'
              : (recommendation.accepted! ? 'accepted' : 'overridden');
          return AiDecisionExportRecord(
            testId: test.id,
            patientId: test.patientId,
            testDateIso: test.testDate.toIso8601String(),
            suggestionType: recommendation.suggestionType,
            confidence: recommendation.confidence,
            decision: decision,
            decisionAtIso: recommendation.decisionAt?.toIso8601String(),
          );
        })
        .toList();
  }

  Future<List<ClinicianTestRecord>> _loadTests(AiDecisionExportParams params) {
    final patientId = params.patientId;
    if (patientId != null && patientId.isNotEmpty) {
      return _clinicianTestRepository.getTestsForPatient(patientId);
    }

    final audiologistId = params.audiologistId;
    if (audiologistId == null || audiologistId.isEmpty) {
      return Future.value(const []);
    }

    return _clinicianTestRepository.getAllTestResultsForAudiologist(
      audiologistId,
    );
  }

  String _titleFor(AiDecisionExportParams params) {
    final patientName = params.patientName;
    if (patientName != null && patientName.isNotEmpty) {
      return 'AI Decisions for $patientName';
    }
    return 'AI Decision History';
  }

  String _fileNameFor(AiDecisionExportParams params, String extension) {
    final patientId = params.patientId;
    if (patientId != null && patientId.isNotEmpty) {
      return 'ai_decisions_$patientId.$extension';
    }
    return 'ai_decisions.$extension';
  }

  String _shareTextFor(AiDecisionExportParams params) {
    final patientName = params.patientName;
    if (patientName != null && patientName.isNotEmpty) {
      return 'AI decisions for $patientName';
    }
    return 'AI decision history';
  }

  String _resourceIdFor(AiDecisionExportParams params) {
    final patientId = params.patientId;
    if (patientId != null && patientId.isNotEmpty) {
      return patientId;
    }
    return params.audiologistId ?? 'ai_decision_history';
  }
}
