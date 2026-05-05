class ClinicianPatientViewModel {
  const ClinicianPatientViewModel({
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
}
