import '../../../../core/application/use_case.dart';
import '../../domain/repositories/draft_audiometry_report_repository.dart';

class PreviewDraftAudiometryReportUseCase
    implements UseCase<void, DraftAudiometryReportData> {
  const PreviewDraftAudiometryReportUseCase(this._repository);

  final DraftAudiometryReportRepository _repository;

  @override
  Future<void> call(DraftAudiometryReportData params) {
    return _repository.previewDraft(params);
  }
}
