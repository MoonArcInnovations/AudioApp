class ClinicianPatientRecord {
  const ClinicianPatientRecord({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.createdAt,
    required this.createdBy,
    this.phoneNumber,
    this.email,
    this.gender,
    this.medicalRecordNumber,
    this.notes,
    this.audiologistId,
    this.synced = false,
  });

  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? email;
  final String? gender;
  final String? medicalRecordNumber;
  final String? notes;
  final DateTime createdAt;
  final String? audiologistId;
  final String createdBy;
  final bool synced;

  int get age {
    final today = DateTime.now();
    var age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  ClinicianPatientRecord copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? email,
    String? gender,
    String? medicalRecordNumber,
    String? notes,
    DateTime? createdAt,
    String? audiologistId,
    String? createdBy,
    bool? synced,
  }) {
    return ClinicianPatientRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      audiologistId: audiologistId ?? this.audiologistId,
      createdBy: createdBy ?? this.createdBy,
      synced: synced ?? this.synced,
    );
  }
}
