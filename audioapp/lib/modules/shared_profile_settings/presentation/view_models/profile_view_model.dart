import '../../../auth/domain/entities/app_user.dart';

class ProfileViewModel {
  const ProfileViewModel({
    required this.user,
    required this.isSaving,
    required this.errorMessage,
  });

  final AppUser user;
  final bool isSaving;
  final String? errorMessage;
}
