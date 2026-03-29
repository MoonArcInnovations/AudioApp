import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/pending_approval_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/patient/presentation/screens/patient_home_screen.dart';
import '../../features/patient/presentation/screens/screening_start_screen.dart';
import '../../features/patient/presentation/screens/screening_environment_check_screen.dart';
import '../../features/patient/presentation/screens/screening_history_screen.dart';
import '../../features/audiologist/presentation/screens/audiologist_home_screen.dart';
import '../../features/audiologist/presentation/screens/audiometry_testing_screen.dart';
import '../../features/audiologist/presentation/screens/patients_list_screen.dart';
import '../../features/audiologist/presentation/screens/calibration_screen.dart';
import '../../features/audiologist/presentation/screens/headphone_calibration_screen.dart';
import '../../features/audiologist/presentation/screens/bone_conduction_screen.dart';
import '../../features/admin/presentation/screens/admin_home_screen.dart';
import '../../features/admin/presentation/screens/user_management_screen.dart';
import '../../features/admin/presentation/screens/audiologist_verification_screen.dart';
import '../../modules/shared_profile_settings/presentation/screens/profile_screen.dart';
import '../../modules/shared_profile_settings/presentation/screens/settings_screen.dart';
import '../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../modules/auth/domain/entities/app_user.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// Route names
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String pendingApproval = '/pending-approval';

  // Patient routes
  static const String patientHome = '/patient';
  static const String patientHistory = '/patient/history';
  static const String patientReport = '/patient/report/:id';
  static const String patientProfile = '/patient/profile';

  // Patient screening routes
  static const String screeningStart = '/patient/screening';
  static const String screeningEnvironment = '/patient/screening/environment';
  static const String screeningHeadphones = '/patient/screening/headphones';
  static const String screeningTest = '/patient/screening/test';
  static const String screeningResults = '/patient/screening/results';
  static const String screeningHistory = '/patient/screening/history';

  // Audiologist routes
  static const String audiologistHome = '/audiologist';
  static const String audiologistPatients = '/audiologist/patients';
  static const String audiologistNewPatient = '/audiologist/patients/new';
  static const String audiologistTest = '/audiologist/test';
  static const String audiologistTestWithPatient =
      '/audiologist/test/:patientId';
  static const String audiologistReport = '/audiologist/report/:testId';
  static const String audiologistCalibration = '/audiologist/calibration';
  static const String audiologistHeadphoneCalibration =
      '/audiologist/calibration/headphones';
  static const String audiologistBoneConduction =
      '/audiologist/bone-conduction';
  static const String audiologistSettings = '/audiologist/settings';

  // Admin routes
  static const String adminHome = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminVerification = '/admin/verification';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminAudit = '/admin/audit';
  static const String adminSettings = '/admin/settings';

  // Common routes
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return appRedirect(
        authState: authState,
        matchedLocation: state.matchedLocation,
      );
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.pendingApproval,
        builder: (context, state) => const PendingApprovalScreen(),
      ),

      // Patient routes
      GoRoute(
        path: AppRoutes.patientHome,
        builder: (context, state) => const PatientHomeScreen(),
      ),

      // Patient screening routes (entry points only - mid-flow screens use Navigator.push with parameters)
      GoRoute(
        path: AppRoutes.screeningStart,
        builder: (context, state) => const ScreeningStartScreen(),
      ),
      GoRoute(
        path: AppRoutes.screeningEnvironment,
        builder: (context, state) => const ScreeningEnvironmentCheckScreen(),
      ),
      GoRoute(
        path: AppRoutes.screeningHistory,
        builder: (context, state) => const ScreeningHistoryScreen(),
      ),

      // Audiologist routes
      GoRoute(
        path: AppRoutes.audiologistHome,
        builder: (context, state) => const AudiologistHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.audiologistPatients,
        builder: (context, state) => const PatientsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.audiologistTest,
        builder: (context, state) => const AudiometryTestingScreen(),
      ),
      GoRoute(
        path: AppRoutes.audiologistTestWithPatient,
        builder: (context, state) => AudiometryTestingScreen(
          patientId: state.pathParameters['patientId'],
        ),
      ),
      GoRoute(
        path: AppRoutes.audiologistCalibration,
        builder: (context, state) => const CalibrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.audiologistHeadphoneCalibration,
        builder: (context, state) => const HeadphoneCalibrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.audiologistBoneConduction,
        builder: (context, state) => const BoneConductionScreen(),
      ),

      // Admin routes
      GoRoute(
        path: AppRoutes.adminHome,
        builder: (context, state) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminVerification,
        builder: (context, state) => const AudiologistVerificationScreen(),
      ),

      // Common routes
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

String? appRedirect({
  required AuthState authState,
  required String matchedLocation,
}) {
  final isLoggedIn = authState.isAuthenticated;
  final accessLevel = routeAccessLevelForLocation(matchedLocation);

  if (matchedLocation == AppRoutes.splash) {
    return null;
  }

  if (!isLoggedIn) {
    return accessLevel == RouteAccessLevel.public ? null : AppRoutes.login;
  }

  if (accessLevel == RouteAccessLevel.public) {
    return homeRouteForUser(authState.user);
  }

  if (matchedLocation == AppRoutes.pendingApproval) {
    return authState.isPendingApproval ? null : homeRouteForUser(authState.user);
  }

  if (accessLevel == RouteAccessLevel.authenticated) {
    return null;
  }

  final user = authState.user;
  if (user == null) {
    return AppRoutes.login;
  }

  if (authState.isPendingApproval && accessLevel == RouteAccessLevel.audiologist) {
    return AppRoutes.pendingApproval;
  }

  switch (accessLevel) {
    case RouteAccessLevel.patient:
      return user.role == UserRole.patient ? null : homeRouteForUser(user);
    case RouteAccessLevel.audiologist:
      return user.role == UserRole.audiologist && user.canAccessAssignedWorkspace
          ? null
          : homeRouteForUser(user);
    case RouteAccessLevel.admin:
      return user.role == UserRole.superAdmin ? null : homeRouteForUser(user);
    case RouteAccessLevel.public:
    case RouteAccessLevel.authenticated:
      return null;
  }
}

/// Get home route based on user role
String homeRouteForRole(UserRole? role) {
  switch (role) {
    case UserRole.patient:
      return AppRoutes.patientHome;
    case UserRole.audiologist:
      return AppRoutes.audiologistHome;
    case UserRole.superAdmin:
      return AppRoutes.adminHome;
    default:
      return AppRoutes.login;
  }
}

String homeRouteForUser(AppUser? user) {
  if (user == null) {
    return AppRoutes.login;
  }
  if (user.role == UserRole.audiologist && !user.canAccessAssignedWorkspace) {
    return AppRoutes.pendingApproval;
  }
  return homeRouteForRole(user.role);
}

enum RouteAccessLevel { public, authenticated, patient, audiologist, admin }

RouteAccessLevel routeAccessLevelForLocation(String matchedLocation) {
  if (_publicRoutes.contains(matchedLocation)) {
    return RouteAccessLevel.public;
  }
  if (_sharedAuthenticatedRoutes.contains(matchedLocation)) {
    return RouteAccessLevel.authenticated;
  }
  if (matchedLocation.startsWith('/patient')) {
    return RouteAccessLevel.patient;
  }
  if (matchedLocation.startsWith('/audiologist')) {
    return RouteAccessLevel.audiologist;
  }
  if (matchedLocation.startsWith('/admin')) {
    return RouteAccessLevel.admin;
  }
  return RouteAccessLevel.authenticated;
}

const _publicRoutes = <String>{
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.register,
};

const _sharedAuthenticatedRoutes = <String>{
  AppRoutes.profile,
  AppRoutes.settings,
  AppRoutes.pendingApproval,
};
