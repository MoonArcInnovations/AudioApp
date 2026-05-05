class AdminUserViewModel {
  const AdminUserViewModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.avatarUrl,
    this.licenseNumber,
    this.licenseState,
    this.licenseExpiryDate,
    this.isVerified,
    this.verifiedAt,
    this.isActive,
    this.isSuspended,
    this.suspensionReason,
    this.lastLoginAt,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatarUrl;
  final String? licenseNumber;
  final String? licenseState;
  final DateTime? licenseExpiryDate;
  final bool? isVerified;
  final DateTime? verifiedAt;
  final bool? isActive;
  final bool? isSuspended;
  final String? suspensionReason;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
