import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart' show AppDatabase;
import '../../../../services/app_initialization_service.dart';
import '../../../../services/firebase/firebase_auth_service.dart';
import '../../domain/repositories/admin_audit_repository.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../repositories/audit_admin_repository.dart';
import '../repositories/local_admin_user_repository.dart';

final adminDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  return LocalAdminUserRepository(
    ref.watch(adminDatabaseProvider),
    firebaseAuthService: FirebaseAuthService(),
  );
});

final adminAuditRepositoryProvider = Provider<AdminAuditRepository>((ref) {
  return const AuditAdminRepository();
});
