import '../entities/app_user.dart';
import '../../../../core/constants/app_constants.dart';

abstract interface class AuthRepository {
  Future<AppUser?> getCurrentUser();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  Future<AppUser> updateProfile({
    required AppUser user,
    required String name,
    String? phoneNumber,
    String? avatarUrl,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}
