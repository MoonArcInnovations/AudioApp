import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/firebase/firebase_auth_service.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  final FirebaseAuthService _authService;

  @override
  Future<AppUser?> getCurrentUser() {
    return _authService.getCurrentUserData();
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _authService.signInWithEmail(email, password);
    if (user == null) {
      throw 'Unable to sign in.';
    }
    return user;
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final user = await _authService.registerWithEmail(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    if (user == null) {
      throw 'Unable to create account.';
    }
    return user;
  }

  @override
  Future<AppUser> updateProfile({
    required AppUser user,
    required String name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    await _authService.updateUserProfile(
      uid: user.id,
      name: name,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );

    return user.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl ?? user.avatarUrl,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }
}
