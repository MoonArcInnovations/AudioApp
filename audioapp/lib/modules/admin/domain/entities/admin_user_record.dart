class AdminUserRecord {
  const AdminUserRecord({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.avatarUrl,
    this.licenseNumber,
    this.licenseState,
    this.licenseExpiryDate,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.isActive = true,
    this.isSuspended = false,
    this.suspensionReason,
    this.failedLoginAttempts = 0,
    this.lockedUntil,
    this.lastLoginAt,
    this.lastLoginIp,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatarUrl;
  final String? licenseNumber;
  final String? licenseState;
  final DateTime? licenseExpiryDate;
  final bool isVerified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final bool isActive;
  final bool isSuspended;
  final String? suspensionReason;
  final int failedLoginAttempts;
  final DateTime? lockedUntil;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final DateTime createdAt;

  AdminUserRecord copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? avatarUrl,
    String? licenseNumber,
    String? licenseState,
    DateTime? licenseExpiryDate,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isActive,
    bool? isSuspended,
    String? suspensionReason,
    int? failedLoginAttempts,
    DateTime? lockedUntil,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    DateTime? createdAt,
  }) {
    return AdminUserRecord(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseState: licenseState ?? this.licenseState,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isActive: isActive ?? this.isActive,
      isSuspended: isSuspended ?? this.isSuspended,
      suspensionReason: suspensionReason ?? this.suspensionReason,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
