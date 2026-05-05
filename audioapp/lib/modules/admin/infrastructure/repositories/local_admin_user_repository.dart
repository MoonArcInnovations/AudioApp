import '../../../../data/local/app_database.dart'
    show AppDatabase, User, UserModel;
import '../../../../core/constants/app_constants.dart';
import '../../../../modules/auth/domain/entities/app_user.dart';
import '../../../../services/firebase/firebase_auth_service.dart';
import '../../domain/entities/admin_user_record.dart';
import '../../domain/repositories/admin_user_repository.dart';

class LocalAdminUserRepository implements AdminUserRepository {
  LocalAdminUserRepository(
    this._database, {
    FirebaseAuthService? firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService();

  final AppDatabase _database;
  final FirebaseAuthService _firebaseAuthService;

  AdminUserRecord _toRecord({
    required String id,
    required String email,
    required String name,
    required String role,
    String? avatarUrl,
    String? licenseNumber,
    String? licenseState,
    DateTime? licenseExpiryDate,
    required bool isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    required bool isActive,
    required bool isSuspended,
    String? suspensionReason,
    required int failedLoginAttempts,
    DateTime? lockedUntil,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    required DateTime createdAt,
  }) {
    return AdminUserRecord(
      id: id,
      email: email,
      name: name,
      role: role,
      avatarUrl: avatarUrl,
      licenseNumber: licenseNumber,
      licenseState: licenseState,
      licenseExpiryDate: licenseExpiryDate,
      isVerified: isVerified,
      verifiedBy: verifiedBy,
      verifiedAt: verifiedAt,
      isActive: isActive,
      isSuspended: isSuspended,
      suspensionReason: suspensionReason,
      failedLoginAttempts: failedLoginAttempts,
      lockedUntil: lockedUntil,
      lastLoginAt: lastLoginAt,
      lastLoginIp: lastLoginIp,
      createdAt: createdAt,
    );
  }

  AdminUserRecord _toRecordFromRow(User user) => _toRecord(
    id: user.id,
    email: user.email,
    name: user.name,
    role: user.role,
    avatarUrl: user.avatarUrl,
    licenseNumber: user.licenseNumber,
    licenseState: user.licenseState,
    licenseExpiryDate: user.licenseExpiryDate,
    isVerified: user.isVerified,
    verifiedBy: user.verifiedBy,
    verifiedAt: user.verifiedAt,
    isActive: user.isActive,
    isSuspended: user.isSuspended,
    suspensionReason: user.suspensionReason,
    failedLoginAttempts: user.failedLoginAttempts,
    lockedUntil: user.lockedUntil,
    lastLoginAt: user.lastLoginAt,
    lastLoginIp: user.lastLoginIp,
    createdAt: user.createdAt,
  );

  AdminUserRecord _toRecordFromModel(UserModel user) => _toRecord(
    id: user.id,
    email: user.email,
    name: user.name,
    role: user.role,
    avatarUrl: user.avatarUrl,
    licenseNumber: user.licenseNumber,
    licenseState: user.licenseState,
    licenseExpiryDate: user.licenseExpiryDate,
    isVerified: user.isVerified,
    verifiedBy: user.verifiedBy,
    verifiedAt: user.verifiedAt,
    isActive: user.isActive,
    isSuspended: user.isSuspended,
    suspensionReason: user.suspensionReason,
    failedLoginAttempts: user.failedLoginAttempts,
    lockedUntil: user.lockedUntil,
    lastLoginAt: user.lastLoginAt,
    lastLoginIp: user.lastLoginIp,
    createdAt: user.createdAt,
  );

  UserModel _toModel(AdminUserRecord user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      avatarUrl: user.avatarUrl,
      licenseNumber: user.licenseNumber,
      licenseState: user.licenseState,
      licenseExpiryDate: user.licenseExpiryDate,
      isVerified: user.isVerified,
      verifiedBy: user.verifiedBy,
      verifiedAt: user.verifiedAt,
      isActive: user.isActive,
      isSuspended: user.isSuspended,
      suspensionReason: user.suspensionReason,
      failedLoginAttempts: user.failedLoginAttempts,
      lockedUntil: user.lockedUntil,
      lastLoginAt: user.lastLoginAt,
      lastLoginIp: user.lastLoginIp,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<AdminUserRecord?> getUserById(String userId) async {
    final row = await _database.getUserById(userId);
    if (row == null) {
      return null;
    }

    return _toRecordFromRow(row);
  }

  @override
  Future<void> createUser(AdminUserRecord user) {
    return _persistAndSyncUser(
      dbWrite: () => _database.createUser(_toModel(user)),
      user: user,
    );
  }

  @override
  Future<void> deleteUser(String userId) {
    return _database.deleteUser(userId);
  }

  @override
  Future<List<AdminUserRecord>> getAllUsers() async {
    final users = await _database.getAllUsers();
    return users.map(_toRecordFromModel).toList();
  }

  @override
  Future<List<AdminUserRecord>> getPendingAudiologistVerifications() async {
    final users = await getAllUsers();
    return users
        .where(
          (user) =>
              user.role == 'audiologist' &&
              user.isVerified != true &&
              user.isActive == true,
        )
        .toList();
  }

  @override
  Future<List<AdminUserRecord>> getVerifiedAudiologists() async {
    final users = await getAllUsers();
    return users
        .where(
          (user) =>
              user.role == 'audiologist' &&
              user.isVerified == true &&
              user.isActive == true,
        )
        .toList();
  }

  @override
  Future<void> updateUser(AdminUserRecord user) {
    return _persistAndSyncUser(
      dbWrite: () => _database.updateUser(_toModel(user)),
      user: user,
    );
  }

  Future<void> _persistAndSyncUser({
    required Future<void> Function() dbWrite,
    required AdminUserRecord user,
  }) async {
    await dbWrite();
    final role = _toUserRole(user.role);
    if (role == null) {
      return;
    }

    await _firebaseAuthService.upsertUserAccessProfile(
      uid: user.id,
      email: user.email,
      name: user.name,
      role: role,
      verificationState: _toVerificationState(user),
      avatarUrl: user.avatarUrl,
    );
  }

  UserRole? _toUserRole(String role) {
    switch (role) {
      case 'patient':
        return UserRole.patient;
      case 'audiologist':
        return UserRole.audiologist;
      case 'superAdmin':
      case 'admin':
        return UserRole.superAdmin;
      default:
        return null;
    }
  }

  UserVerificationState _toVerificationState(AdminUserRecord user) {
    if (_toUserRole(user.role) != UserRole.audiologist) {
      return UserVerificationState.notRequired;
    }
    return user.isVerified
        ? UserVerificationState.verified
        : UserVerificationState.pending;
  }
}
