import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../../../services/app_initialization_service.dart';
import '../../../clinician_testing/domain/services/test_pairing_service.dart';
import '../../domain/repositories/ai_audit_repository.dart';
import '../../domain/repositories/ai_export_audit_repository.dart';
import '../../domain/repositories/ai_export_delivery_repository.dart';
import '../../domain/repositories/ai_export_repository.dart';
import '../../domain/repositories/ai_review_repository.dart';
import '../repositories/audit_ai_export_repository.dart';
import '../repositories/audit_ai_repository.dart';
import '../repositories/document_ai_export_repository.dart';
import '../repositories/local_ai_review_repository.dart';
import '../repositories/share_ai_export_delivery_repository.dart';

final aiReviewDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

final aiReviewPairingServiceProvider = Provider<TestPairingService>((ref) {
  return const TestPairingService();
});

final aiReviewRepositoryProvider = Provider<AiReviewRepository>((ref) {
  return LocalAiReviewRepository(ref.watch(aiReviewDatabaseProvider));
});

final aiAuditRepositoryProvider = Provider<AiAuditRepository>((ref) {
  return const AuditAiRepository();
});

final aiExportRepositoryProvider = Provider<AiExportRepository>((ref) {
  return const DocumentAiExportRepository();
});

final aiExportDeliveryRepositoryProvider = Provider<AiExportDeliveryRepository>(
  (ref) {
    return const ShareAiExportDeliveryRepository();
  },
);

final aiExportAuditRepositoryProvider = Provider<AiExportAuditRepository>((
  ref,
) {
  return const AuditAiExportRepository();
});
