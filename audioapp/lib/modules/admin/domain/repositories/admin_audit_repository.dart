abstract interface class AdminAuditRepository {
  Future<void> logUserCreated(String userId, String email);

  Future<void> logUserDeleted(String userId, String email);

  Future<void> logAudiologistVerified(String userId, String email);

  Future<void> logUserSuspended(String userId, String email, String reason);
}
