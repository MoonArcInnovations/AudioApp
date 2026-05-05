import 'package:audioapp/core/constants/app_constants.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/modules/auth/domain/entities/app_user.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Spec', () {
    test('allows splash for unauthenticated users', () {
      const authState = AuthState();

      final redirect = appRedirect(
        authState: authState,
        matchedLocation: AppRoutes.splash,
      );

      expect(redirect, isNull);
    });

    test('redirects unauthenticated users away from protected routes', () {
      const authState = AuthState();

      final redirect = appRedirect(
        authState: authState,
        matchedLocation: AppRoutes.patientHome,
      );

      expect(redirect, AppRoutes.login);
    });

    test('allows unauthenticated users to stay on login and register', () {
      const authState = AuthState();

      expect(
        appRedirect(authState: authState, matchedLocation: AppRoutes.login),
        isNull,
      );
      expect(
        appRedirect(authState: authState, matchedLocation: AppRoutes.register),
        isNull,
      );
    });

    test('redirects authenticated patient from auth pages to patient home', () {
      final authState = AuthState(
        isAuthenticated: true,
        user: AppUser(
          id: 'patient-1',
          email: 'patient@test.com',
          name: 'Patient Tester',
          role: UserRole.patient,
          verificationState: UserVerificationState.notRequired,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final redirect = appRedirect(
        authState: authState,
        matchedLocation: AppRoutes.login,
      );

      expect(redirect, AppRoutes.patientHome);
    });

    test(
      'redirects authenticated audiologist from auth pages to audiologist home',
      () {
        final authState = AuthState(
          isAuthenticated: true,
          user: AppUser(
            id: 'audio-1',
            email: 'audio@test.com',
            name: 'Audiologist Tester',
            role: UserRole.audiologist,
            verificationState: UserVerificationState.verified,
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        final redirect = appRedirect(
          authState: authState,
          matchedLocation: AppRoutes.register,
        );

        expect(redirect, AppRoutes.audiologistHome);
      },
    );

    test('maps super admin to admin home route', () {
      expect(homeRouteForRole(UserRole.superAdmin), AppRoutes.adminHome);
    });

    test('redirects patient away from audiologist routes', () {
      final authState = AuthState(
        isAuthenticated: true,
        user: AppUser(
          id: 'patient-1',
          email: 'patient@test.com',
          name: 'Patient Tester',
          role: UserRole.patient,
          verificationState: UserVerificationState.notRequired,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        appRedirect(
          authState: authState,
          matchedLocation: AppRoutes.audiologistHome,
        ),
        AppRoutes.patientHome,
      );
    });

    test('redirects verified audiologist away from admin routes', () {
      final authState = AuthState(
        isAuthenticated: true,
        user: AppUser(
          id: 'audio-1',
          email: 'audio@test.com',
          name: 'Audiologist Tester',
          role: UserRole.audiologist,
          verificationState: UserVerificationState.verified,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        appRedirect(
          authState: authState,
          matchedLocation: AppRoutes.adminUsers,
        ),
        AppRoutes.audiologistHome,
      );
    });

    test('redirects pending audiologist to pending approval screen', () {
      final authState = AuthState(
        isAuthenticated: true,
        user: AppUser(
          id: 'audio-1',
          email: 'audio@test.com',
          name: 'Audiologist Tester',
          role: UserRole.audiologist,
          verificationState: UserVerificationState.pending,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        appRedirect(
          authState: authState,
          matchedLocation: AppRoutes.audiologistHome,
        ),
        AppRoutes.pendingApproval,
      );
    });

    test('allows authenticated users on shared settings route', () {
      final authState = AuthState(
        isAuthenticated: true,
        user: AppUser(
          id: 'audio-1',
          email: 'audio@test.com',
          name: 'Audiologist Tester',
          role: UserRole.audiologist,
          verificationState: UserVerificationState.pending,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(
        appRedirect(authState: authState, matchedLocation: AppRoutes.settings),
        isNull,
      );
    });
  });
}
