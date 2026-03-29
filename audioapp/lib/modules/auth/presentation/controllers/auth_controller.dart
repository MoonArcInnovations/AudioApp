import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../application/use_cases/get_current_user_use_case.dart';
import '../../application/use_cases/register_user_use_case.dart';
import '../../application/use_cases/send_password_reset_email_use_case.dart';
import '../../application/use_cases/sign_in_use_case.dart';
import '../../application/use_cases/sign_out_use_case.dart';
import '../../application/use_cases/update_user_profile_use_case.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../infrastructure/repositories/firebase_auth_repository.dart';

const _userNotProvided = Object();
const _errorMessageNotProvided = Object();

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final AppUser? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  UserRole? get userRole => user?.role;
  UserVerificationState get verificationState =>
      user?.verificationState ?? UserVerificationState.notRequired;
  bool get isPendingApproval => user?.isPendingApproval ?? false;
  bool get canAccessAssignedWorkspace =>
      user?.canAccessAssignedWorkspace ?? false;

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Object? user = _userNotProvided,
    Object? errorMessage = _errorMessageNotProvided,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: identical(user, _userNotProvided) ? this.user : user as AppUser?,
      errorMessage: identical(errorMessage, _errorMessageNotProvided)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  return UpdateUserProfileUseCase(ref.watch(authRepositoryProvider));
});

final sendPasswordResetEmailUseCaseProvider =
    Provider<SendPasswordResetEmailUseCase>((ref) {
      return SendPasswordResetEmailUseCase(ref.watch(authRepositoryProvider));
    });

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInUseCase signInUseCase,
    required RegisterUserUseCase registerUserUseCase,
    required SignOutUseCase signOutUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _signInUseCase = signInUseCase,
       _registerUserUseCase = registerUserUseCase,
       _signOutUseCase = signOutUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
       super(const AuthState(isLoading: true)) {
    _restoreSession();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInUseCase _signInUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  final SignOutUseCase _signOutUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;

  Future<void> _restoreSession() async {
    try {
      final user = await _getCurrentUserUseCase(const NoParams());
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          errorMessage: null,
        );
        return;
      }
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        errorMessage: 'Session restore failed: $error',
      );
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _signInUseCase(
        SignInParams(email: email, password: password),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _registerUserUseCase(
        RegisterUserParams(
          email: email,
          password: password,
          name: name,
          role: role,
        ),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _signOutUseCase(const NoParams());
      state = const AuthState();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedUser = await _updateUserProfileUseCase(
        UpdateUserProfileParams(
          user: currentUser,
          name: name,
          phoneNumber: phoneNumber,
          avatarUrl: avatarUrl,
        ),
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: updatedUser,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _sendPasswordResetEmailUseCase(
        SendPasswordResetEmailParams(email: email),
      );
      state = state.copyWith(isLoading: false, errorMessage: null);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    signInUseCase: ref.watch(signInUseCaseProvider),
    registerUserUseCase: ref.watch(registerUserUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
    updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
    sendPasswordResetEmailUseCase: ref.watch(
      sendPasswordResetEmailUseCaseProvider,
    ),
  ),
);
