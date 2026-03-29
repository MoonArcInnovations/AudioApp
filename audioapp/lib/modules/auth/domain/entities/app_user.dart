import '../../../../core/constants/app_constants.dart';

enum UserVerificationState {
  notRequired,
  pending,
  verified,
  rejected;

  bool get allowsRoleAccess =>
      this == UserVerificationState.notRequired ||
      this == UserVerificationState.verified;

  static UserVerificationState defaultForRole(UserRole role) {
    return role == UserRole.audiologist
        ? UserVerificationState.pending
        : UserVerificationState.notRequired;
  }

  static UserVerificationState fromStorageValue(
    String? value, {
    required UserRole role,
  }) {
    if (role != UserRole.audiologist) {
      return UserVerificationState.notRequired;
    }

    return UserVerificationState.values.firstWhere(
      (item) => item.name == value,
      orElse: () => UserVerificationState.pending,
    );
  }
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final UserRole role;
  final UserVerificationState verificationState;
  final String? avatarUrl;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.role,
    this.verificationState = UserVerificationState.notRequired,
    this.avatarUrl,
    required this.createdAt,
  });

  bool get requiresVerification => role == UserRole.audiologist;

  bool get canAccessAssignedWorkspace =>
      !requiresVerification || verificationState.allowsRoleAccess;

  bool get isPendingApproval =>
      requiresVerification &&
      verificationState == UserVerificationState.pending;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final role = UserRole.values.firstWhere(
      (value) => value.name == json['role'],
      orElse: () => UserRole.patient,
    );
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: role,
      verificationState: UserVerificationState.fromStorageValue(
        json['verificationState'] as String?,
        role: role,
      ),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'verificationState': verificationState.name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    UserRole? role,
    UserVerificationState? verificationState,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      verificationState: verificationState ?? this.verificationState,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
