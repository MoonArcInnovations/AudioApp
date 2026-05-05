import '../entities/admin_user_record.dart';

abstract interface class AdminUserRepository {
  Future<AdminUserRecord?> getUserById(String userId);

  Future<List<AdminUserRecord>> getAllUsers();

  Future<List<AdminUserRecord>> getPendingAudiologistVerifications();

  Future<List<AdminUserRecord>> getVerifiedAudiologists();

  Future<void> createUser(AdminUserRecord user);

  Future<void> updateUser(AdminUserRecord user);

  Future<void> deleteUser(String userId);
}
