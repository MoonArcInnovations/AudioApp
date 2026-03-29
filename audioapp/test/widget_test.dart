import 'package:audioapp/app/bootstrap/app_bootstrap.dart';
import 'package:audioapp/features/auth/presentation/screens/login_screen.dart';
import 'package:audioapp/core/constants/app_constants.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/main.dart';
import 'package:audioapp/modules/auth/domain/entities/app_user.dart';
import 'package:audioapp/modules/auth/domain/repositories/auth_repository.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/shared_profile_settings/presentation/providers/shared_settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _TestAuthRepository implements AuthRepository {
  String? lastResetEmail;
  bool shouldFailReset = false;

  @override
  Future<AppUser?> getCurrentUser() async => null;

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser> updateProfile({
    required AppUser user,
    required String name,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    lastResetEmail = email;
    if (shouldFailReset) {
      throw 'reset failed';
    }
  }
}

void main() {
  testWidgets('AudioApp shows startup failure details when bootstrap fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: AudioApp(
          initialBootstrapResult: const AppBootstrapResult(
            firebaseReady: false,
            localServicesReady: true,
            firebaseError: 'Missing Firebase config',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Authentication Services Unavailable'), findsOneWidget);
    expect(find.textContaining('Missing Firebase config'), findsOneWidget);
  });

  testWidgets('AudioApp renders router content when bootstrap succeeds', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/test-login',
      routes: [
        GoRoute(
          path: '/test-login',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Router Ready')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
          appThemeModeProvider.overrideWithValue(ThemeMode.light),
          authRepositoryProvider.overrideWithValue(_TestAuthRepository()),
        ],
        child: const AudioApp(
          initialBootstrapResult: AppBootstrapResult.ready(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Router Ready'), findsOneWidget);
  });

  testWidgets('Login screen renders primary auth content', (
    WidgetTester tester,
  ) async {
    final authRepository = _TestAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.textContaining('demo', findRichText: true), findsNothing);
  });

  testWidgets('Forgot password dialog validates invalid email input', (
    WidgetTester tester,
  ) async {
    final authRepository = _TestAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    final resetField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(resetField, 'invalid-email');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter a valid email address.'),
      findsOneWidget,
    );
    expect(authRepository.lastResetEmail, isNull);
  });

  testWidgets('Forgot password dialog submits reset request successfully', (
    WidgetTester tester,
  ) async {
    final authRepository = _TestAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    final resetField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(resetField, 'patient@test.com');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    expect(authRepository.lastResetEmail, 'patient@test.com');
    expect(find.text('Password reset email sent.'), findsOneWidget);
  });

  testWidgets('Forgot password dialog surfaces reset request failures', (
    WidgetTester tester,
  ) async {
    final authRepository = _TestAuthRepository()..shouldFailReset = true;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    final resetField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(resetField, 'patient@test.com');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    expect(authRepository.lastResetEmail, 'patient@test.com');
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.textContaining('reset failed'),
      ),
      findsOneWidget,
    );
  });
}
