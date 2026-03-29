import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/pdf/pdf_report_service.dart';
import '../../domain/repositories/draft_audiometry_report_repository.dart';
import '../../domain/repositories/report_generation_repository.dart';
import '../repositories/pdf_draft_audiometry_report_repository.dart';
import '../repositories/pdf_report_generation_repository.dart';

final reportPdfServiceProvider = Provider<PdfReportService>((ref) {
  return PdfReportService();
});

final reportGenerationRepositoryProvider = Provider<ReportGenerationRepository>(
  (ref) {
    return PdfReportGenerationRepository(ref.watch(reportPdfServiceProvider));
  },
);

final draftAudiometryReportRepositoryProvider =
    Provider<DraftAudiometryReportRepository>((ref) {
      return PdfDraftAudiometryReportRepository(
        ref.watch(reportPdfServiceProvider),
      );
    });
