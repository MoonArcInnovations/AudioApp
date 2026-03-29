import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../view_models/profile_view_model.dart';

final profileViewModelProvider = Provider<ProfileViewModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;
  if (user == null) {
    return null;
  }

  return ProfileViewModel(
    user: user,
    isSaving: authState.isLoading,
    errorMessage: authState.errorMessage,
  );
});
