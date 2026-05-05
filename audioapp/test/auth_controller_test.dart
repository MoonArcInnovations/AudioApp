import 'package:audioapp/core/constants/app_constants.dart';
import 'package:audioapp/modules/auth/application/use_cases/get_current_user_use_case.dart';
import 'package:audioapp/modules/auth/application/use_cases/register_user_use_case.dart';
import 'package:audioapp/modules/auth/application/use_cases/send_password_reset_email_use_case.dart';
import 'package:audioapp/modules/auth/application/use_cases/sign_in_use_case.dart';
import 'package:audioapp/modules/auth/application/use_cases/sign_out_use_case.dart';
import 'package:audioapp/modules/auth/application/use_cases/update_user_profile_use_case.dart';
import 'package:audioapp/modules/auth/domain/entities/app_user.dart';
import 'package:audioapp/modules/auth/domain/repositories/auth_repository.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.currentUser,
    this.throwOnGetCurrentUser = false,
    this.throwOnPasswordReset = false,
  });

  AppUser? currentUser;
  bool throwOnGetCurrentUser;
  bool throwOnPasswordReset;

  @override
  Future<AppUser?> getCurrentUser() async {
    if (throwOnGetCurrentUser) {
      throw 'restore failed';
    }
    return currentUser;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    currentUser = AppUser(
      id: 'registered-user',
      email: email,
      name: name,
      role: role,
      verificationState: UserVerificationState.defaultForRole(role),
      createdAt: DateTime(2026, 1, 1),
    );
    return currentUser!;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    currentUser = AppUser(
      id: 'signed-in-user',
      email: email,
      name: 'Signed In User',
      role: email.contains('audio') ? UserRole.audiologist : UserRole.patient,
      verificationState: email.contains('audio')
          ? UserVerificationState.verified
          : UserVerificationState.notRequired,
      createdAt: DateTime(2026, 1, 1),
    );
    return currentUser!;
  }

  @override
  Future<void> signOut() async {
    currentUser = null;
  }

  @override
  Future<AppUser> updateProfile({
    required AppUser user,
    required String name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    currentUser = user.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
    return currentUser!;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    if (throwOnPasswordReset) {
      throw 'reset failed';
    }
  }
}

void main() {
  group('AuthStateNotifier', () {
    test('restores existing authenticated session', () async {
      final repo = FakeAuthRepository(
        currentUser: AppUser(
          id: 'existing-user',
          email: 'patient@test.com',
          name: 'Existing User',
          role: UserRole.patient,
          verificationState: UserVerificationState.notRequired,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.user?.email, 'patient@test.com');
    });

    test('sign in updates auth state and role', () async {
      final repo = FakeAuthRepository();
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      final success = await notifier.signIn('audio@test.com', 'password123');

      expect(success, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.userRole, UserRole.audiologist);
    });

    test('register updates auth state with selected role', () async {
      final repo = FakeAuthRepository();
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      final success = await notifier.register(
        email: 'patient@test.com',
        password: 'password123',
        name: 'New Patient',
        role: UserRole.patient,
      );

      expect(success, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.user?.name, 'New Patient');
      expect(notifier.state.userRole, UserRole.patient);
      expect(notifier.state.verificationState, UserVerificationState.notRequired);
    });

    test('register keeps audiologist in pending approval state', () async {
      final repo = FakeAuthRepository();
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      final success = await notifier.register(
        email: 'audio@test.com',
        password: 'password123',
        name: 'New Audiologist',
        role: UserRole.audiologist,
      );

      expect(success, isTrue);
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.isPendingApproval, isTrue);
      expect(notifier.state.user?.verificationState, UserVerificationState.pending);
    });

    test('sign out clears auth state', () async {
      final repo = FakeAuthRepository();
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      await notifier.signIn('patient@test.com', 'password123');
      await notifier.signOut();

      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.user, isNull);
    });

    test('restore failure is surfaced as an auth error', () async {
      final repo = FakeAuthRepository(throwOnGetCurrentUser: true);
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.isAuthenticated, isFalse);
      expect(notifier.state.errorMessage, contains('Session restore failed'));
    });

    test('password reset success clears error state', () async {
      final repo = FakeAuthRepository();
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      final success = await notifier.sendPasswordResetEmail('patient@test.com');

      expect(success, isTrue);
      expect(notifier.state.errorMessage, isNull);
    });

    test('password reset failure surfaces repository error', () async {
      final repo = FakeAuthRepository(throwOnPasswordReset: true);
      final notifier = AuthStateNotifier(
        getCurrentUserUseCase: GetCurrentUserUseCase(repo),
        signInUseCase: SignInUseCase(repo),
        registerUserUseCase: RegisterUserUseCase(repo),
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      );
      addTearDown(notifier.dispose);

      final success = await notifier.sendPasswordResetEmail('patient@test.com');

      expect(success, isFalse);
      expect(notifier.state.errorMessage, contains('reset failed'));
    });
  });
}
