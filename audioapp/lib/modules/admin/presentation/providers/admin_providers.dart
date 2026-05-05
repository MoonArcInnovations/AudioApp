import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../application/use_cases/create_admin_user_use_case.dart';
import '../../application/use_cases/delete_admin_user_use_case.dart';
import '../../application/use_cases/get_all_admin_users_use_case.dart';
import '../../application/use_cases/get_pending_audiologist_verifications_use_case.dart';
import '../../application/use_cases/get_verified_audiologists_use_case.dart';
import '../../application/use_cases/revoke_admin_user_verification_use_case.dart';
import '../../application/use_cases/suspend_admin_user_use_case.dart';
import '../../application/use_cases/unsuspend_admin_user_use_case.dart';
import '../../application/use_cases/update_admin_user_use_case.dart';
import '../../application/use_cases/verify_admin_user_use_case.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../infrastructure/providers/admin_infrastructure_providers.dart';
import '../view_models/admin_user_view_model.dart';

final getAllAdminUsersUseCaseProvider = Provider<GetAllAdminUsersUseCase>((
  ref,
) {
  return GetAllAdminUsersUseCase(ref.watch(adminUserRepositoryProvider));
});

final getPendingAudiologistVerificationsUseCaseProvider =
    Provider<GetPendingAudiologistVerificationsUseCase>((ref) {
      return GetPendingAudiologistVerificationsUseCase(
        ref.watch(adminUserRepositoryProvider),
      );
    });

final getVerifiedAudiologistsUseCaseProvider =
    Provider<GetVerifiedAudiologistsUseCase>((ref) {
      return GetVerifiedAudiologistsUseCase(
        ref.watch(adminUserRepositoryProvider),
      );
    });

final createAdminUserUseCaseProvider = Provider<CreateAdminUserUseCase>((ref) {
  return CreateAdminUserUseCase(
    userRepository: ref.watch(adminUserRepositoryProvider),
    auditRepository: ref.watch(adminAuditRepositoryProvider),
  );
});

final updateAdminUserUseCaseProvider = Provider<UpdateAdminUserUseCase>((ref) {
  return UpdateAdminUserUseCase(ref.watch(adminUserRepositoryProvider));
});

final verifyAdminUserUseCaseProvider = Provider<VerifyAdminUserUseCase>((ref) {
  return VerifyAdminUserUseCase(
    userRepository: ref.watch(adminUserRepositoryProvider),
    auditRepository: ref.watch(adminAuditRepositoryProvider),
  );
});

final suspendAdminUserUseCaseProvider = Provider<SuspendAdminUserUseCase>((
  ref,
) {
  return SuspendAdminUserUseCase(
    userRepository: ref.watch(adminUserRepositoryProvider),
    auditRepository: ref.watch(adminAuditRepositoryProvider),
  );
});

final unsuspendAdminUserUseCaseProvider = Provider<UnsuspendAdminUserUseCase>((
  ref,
) {
  return UnsuspendAdminUserUseCase(ref.watch(adminUserRepositoryProvider));
});

final revokeAdminUserVerificationUseCaseProvider =
    Provider<RevokeAdminUserVerificationUseCase>((ref) {
      return RevokeAdminUserVerificationUseCase(
        ref.watch(adminUserRepositoryProvider),
      );
    });

final deleteAdminUserUseCaseProvider = Provider<DeleteAdminUserUseCase>((ref) {
  return DeleteAdminUserUseCase(
    userRepository: ref.watch(adminUserRepositoryProvider),
    auditRepository: ref.watch(adminAuditRepositoryProvider),
  );
});

final _allAdminUsersProvider = FutureProvider<List<AdminUserRecord>>((ref) {
  return ref.watch(getAllAdminUsersUseCaseProvider)(const NoParams());
});

final _pendingAudiologistVerificationsProvider =
    FutureProvider<List<AdminUserRecord>>((ref) {
      return ref.watch(getPendingAudiologistVerificationsUseCaseProvider)(
        const NoParams(),
      );
    });

final _verifiedAdminAudiologistsProvider =
    FutureProvider<List<AdminUserRecord>>((ref) {
      return ref.watch(getVerifiedAudiologistsUseCaseProvider)(
        const NoParams(),
      );
    });

AdminUserViewModel _toAdminUserViewModel(AdminUserRecord model) {
  return AdminUserViewModel(
    id: model.id,
    email: model.email,
    name: model.name,
    role: model.role,
    avatarUrl: model.avatarUrl,
    licenseNumber: model.licenseNumber,
    licenseState: model.licenseState,
    licenseExpiryDate: model.licenseExpiryDate,
    isVerified: model.isVerified,
    verifiedAt: model.verifiedAt,
    isActive: model.isActive,
    isSuspended: model.isSuspended,
    suspensionReason: model.suspensionReason,
    lastLoginAt: model.lastLoginAt,
    createdAt: model.createdAt,
  );
}

final adminUserSummariesProvider = FutureProvider<List<AdminUserViewModel>>((
  ref,
) {
  return ref
      .watch(_allAdminUsersProvider.future)
      .then((users) => users.map(_toAdminUserViewModel).toList());
});

final pendingAudiologistVerificationSummariesProvider =
    FutureProvider<List<AdminUserViewModel>>((ref) {
      return ref
          .watch(_pendingAudiologistVerificationsProvider.future)
          .then((users) => users.map(_toAdminUserViewModel).toList());
    });

final verifiedAudiologistSummariesProvider =
    FutureProvider<List<AdminUserViewModel>>((ref) {
      return ref
          .watch(_verifiedAdminAudiologistsProvider.future)
          .then((users) => users.map(_toAdminUserViewModel).toList());
    });
