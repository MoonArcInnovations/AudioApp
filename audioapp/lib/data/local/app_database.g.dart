// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients
    with TableInfo<$PatientsTable, DbPatient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicalRecordNumberMeta =
      const VerificationMeta('medicalRecordNumber');
  @override
  late final GeneratedColumn<String> medicalRecordNumber =
      GeneratedColumn<String>('medical_record_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audiologistIdMeta =
      const VerificationMeta('audiologistId');
  @override
  late final GeneratedColumn<String> audiologistId = GeneratedColumn<String>(
      'audiologist_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        dateOfBirth,
        phoneNumber,
        email,
        gender,
        medicalRecordNumber,
        notes,
        audiologistId,
        createdBy,
        createdAt,
        updatedAt,
        synced,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<DbPatient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('medical_record_number')) {
      context.handle(
          _medicalRecordNumberMeta,
          medicalRecordNumber.isAcceptableOrUnknown(
              data['medical_record_number']!, _medicalRecordNumberMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('audiologist_id')) {
      context.handle(
          _audiologistIdMeta,
          audiologistId.isAcceptableOrUnknown(
              data['audiologist_id']!, _audiologistIdMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbPatient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbPatient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      medicalRecordNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}medical_record_number']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      audiologistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audiologist_id']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class DbPatient extends DataClass implements Insertable<DbPatient> {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? email;
  final String? gender;
  final String? medicalRecordNumber;
  final String? notes;
  final String? audiologistId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool synced;
  final bool isActive;
  const DbPatient(
      {required this.id,
      required this.name,
      required this.dateOfBirth,
      this.phoneNumber,
      this.email,
      this.gender,
      this.medicalRecordNumber,
      this.notes,
      this.audiologistId,
      required this.createdBy,
      required this.createdAt,
      this.updatedAt,
      required this.synced,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || medicalRecordNumber != null) {
      map['medical_record_number'] = Variable<String>(medicalRecordNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || audiologistId != null) {
      map['audiologist_id'] = Variable<String>(audiologistId);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['synced'] = Variable<bool>(synced);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      dateOfBirth: Value(dateOfBirth),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      medicalRecordNumber: medicalRecordNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalRecordNumber),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      audiologistId: audiologistId == null && nullToAbsent
          ? const Value.absent()
          : Value(audiologistId),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      synced: Value(synced),
      isActive: Value(isActive),
    );
  }

  factory DbPatient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbPatient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      gender: serializer.fromJson<String?>(json['gender']),
      medicalRecordNumber:
          serializer.fromJson<String?>(json['medicalRecordNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      audiologistId: serializer.fromJson<String?>(json['audiologistId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'gender': serializer.toJson<String?>(gender),
      'medicalRecordNumber': serializer.toJson<String?>(medicalRecordNumber),
      'notes': serializer.toJson<String?>(notes),
      'audiologistId': serializer.toJson<String?>(audiologistId),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  DbPatient copyWith(
          {String? id,
          String? name,
          DateTime? dateOfBirth,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<String?> medicalRecordNumber = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> audiologistId = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? synced,
          bool? isActive}) =>
      DbPatient(
        id: id ?? this.id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        email: email.present ? email.value : this.email,
        gender: gender.present ? gender.value : this.gender,
        medicalRecordNumber: medicalRecordNumber.present
            ? medicalRecordNumber.value
            : this.medicalRecordNumber,
        notes: notes.present ? notes.value : this.notes,
        audiologistId:
            audiologistId.present ? audiologistId.value : this.audiologistId,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        synced: synced ?? this.synced,
        isActive: isActive ?? this.isActive,
      );
  DbPatient copyWithCompanion(PatientsCompanion data) {
    return DbPatient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      gender: data.gender.present ? data.gender.value : this.gender,
      medicalRecordNumber: data.medicalRecordNumber.present
          ? data.medicalRecordNumber.value
          : this.medicalRecordNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      audiologistId: data.audiologistId.present
          ? data.audiologistId.value
          : this.audiologistId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbPatient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('gender: $gender, ')
          ..write('medicalRecordNumber: $medicalRecordNumber, ')
          ..write('notes: $notes, ')
          ..write('audiologistId: $audiologistId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      dateOfBirth,
      phoneNumber,
      email,
      gender,
      medicalRecordNumber,
      notes,
      audiologistId,
      createdBy,
      createdAt,
      updatedAt,
      synced,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbPatient &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateOfBirth == this.dateOfBirth &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.gender == this.gender &&
          other.medicalRecordNumber == this.medicalRecordNumber &&
          other.notes == this.notes &&
          other.audiologistId == this.audiologistId &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced &&
          other.isActive == this.isActive);
}

class PatientsCompanion extends UpdateCompanion<DbPatient> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> dateOfBirth;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<String?> gender;
  final Value<String?> medicalRecordNumber;
  final Value<String?> notes;
  final Value<String?> audiologistId;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> synced;
  final Value<bool> isActive;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.gender = const Value.absent(),
    this.medicalRecordNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.audiologistId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.gender = const Value.absent(),
    this.medicalRecordNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.audiologistId = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        dateOfBirth = Value(dateOfBirth),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt);
  static Insertable<DbPatient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<String>? gender,
    Expression<String>? medicalRecordNumber,
    Expression<String>? notes,
    Expression<String>? audiologistId,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (medicalRecordNumber != null)
        'medical_record_number': medicalRecordNumber,
      if (notes != null) 'notes': notes,
      if (audiologistId != null) 'audiologist_id': audiologistId,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? dateOfBirth,
      Value<String?>? phoneNumber,
      Value<String?>? email,
      Value<String?>? gender,
      Value<String?>? medicalRecordNumber,
      Value<String?>? notes,
      Value<String?>? audiologistId,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? synced,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      notes: notes ?? this.notes,
      audiologistId: audiologistId ?? this.audiologistId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (medicalRecordNumber.present) {
      map['medical_record_number'] =
          Variable<String>(medicalRecordNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (audiologistId.present) {
      map['audiologist_id'] = Variable<String>(audiologistId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('gender: $gender, ')
          ..write('medicalRecordNumber: $medicalRecordNumber, ')
          ..write('notes: $notes, ')
          ..write('audiologistId: $audiologistId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestResultsTable extends TestResults
    with TableInfo<$TestResultsTable, DbTestResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _audiologistIdMeta =
      const VerificationMeta('audiologistId');
  @override
  late final GeneratedColumn<String> audiologistId = GeneratedColumn<String>(
      'audiologist_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testDateMeta =
      const VerificationMeta('testDate');
  @override
  late final GeneratedColumn<DateTime> testDate = GeneratedColumn<DateTime>(
      'test_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _testTypeMeta =
      const VerificationMeta('testType');
  @override
  late final GeneratedColumn<String> testType = GeneratedColumn<String>(
      'test_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('air'));
  static const VerificationMeta _screeningIdMeta =
      const VerificationMeta('screeningId');
  @override
  late final GeneratedColumn<String> screeningId = GeneratedColumn<String>(
      'screening_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _headphoneModelMeta =
      const VerificationMeta('headphoneModel');
  @override
  late final GeneratedColumn<String> headphoneModel = GeneratedColumn<String>(
      'headphone_model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ambientNoiseDbMeta =
      const VerificationMeta('ambientNoiseDb');
  @override
  late final GeneratedColumn<double> ambientNoiseDb = GeneratedColumn<double>(
      'ambient_noise_db', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rightEarResultsMeta =
      const VerificationMeta('rightEarResults');
  @override
  late final GeneratedColumn<String> rightEarResults = GeneratedColumn<String>(
      'right_ear_results', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _leftEarResultsMeta =
      const VerificationMeta('leftEarResults');
  @override
  late final GeneratedColumn<String> leftEarResults = GeneratedColumn<String>(
      'left_ear_results', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rightPtaMeta =
      const VerificationMeta('rightPta');
  @override
  late final GeneratedColumn<double> rightPta = GeneratedColumn<double>(
      'right_pta', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _leftPtaMeta =
      const VerificationMeta('leftPta');
  @override
  late final GeneratedColumn<double> leftPta = GeneratedColumn<double>(
      'left_pta', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _rightClassificationMeta =
      const VerificationMeta('rightClassification');
  @override
  late final GeneratedColumn<String> rightClassification =
      GeneratedColumn<String>('right_classification', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _leftClassificationMeta =
      const VerificationMeta('leftClassification');
  @override
  late final GeneratedColumn<String> leftClassification =
      GeneratedColumn<String>('left_classification', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recommendationsMeta =
      const VerificationMeta('recommendations');
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
      'recommendations', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompleteMeta =
      const VerificationMeta('isComplete');
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
      'is_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_complete" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        audiologistId,
        testDate,
        testType,
        screeningId,
        headphoneModel,
        ambientNoiseDb,
        rightEarResults,
        leftEarResults,
        rightPta,
        leftPta,
        rightClassification,
        leftClassification,
        notes,
        recommendations,
        isComplete,
        synced,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_results';
  @override
  VerificationContext validateIntegrity(Insertable<DbTestResult> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('audiologist_id')) {
      context.handle(
          _audiologistIdMeta,
          audiologistId.isAcceptableOrUnknown(
              data['audiologist_id']!, _audiologistIdMeta));
    } else if (isInserting) {
      context.missing(_audiologistIdMeta);
    }
    if (data.containsKey('test_date')) {
      context.handle(_testDateMeta,
          testDate.isAcceptableOrUnknown(data['test_date']!, _testDateMeta));
    } else if (isInserting) {
      context.missing(_testDateMeta);
    }
    if (data.containsKey('test_type')) {
      context.handle(_testTypeMeta,
          testType.isAcceptableOrUnknown(data['test_type']!, _testTypeMeta));
    }
    if (data.containsKey('screening_id')) {
      context.handle(
          _screeningIdMeta,
          screeningId.isAcceptableOrUnknown(
              data['screening_id']!, _screeningIdMeta));
    }
    if (data.containsKey('headphone_model')) {
      context.handle(
          _headphoneModelMeta,
          headphoneModel.isAcceptableOrUnknown(
              data['headphone_model']!, _headphoneModelMeta));
    }
    if (data.containsKey('ambient_noise_db')) {
      context.handle(
          _ambientNoiseDbMeta,
          ambientNoiseDb.isAcceptableOrUnknown(
              data['ambient_noise_db']!, _ambientNoiseDbMeta));
    }
    if (data.containsKey('right_ear_results')) {
      context.handle(
          _rightEarResultsMeta,
          rightEarResults.isAcceptableOrUnknown(
              data['right_ear_results']!, _rightEarResultsMeta));
    } else if (isInserting) {
      context.missing(_rightEarResultsMeta);
    }
    if (data.containsKey('left_ear_results')) {
      context.handle(
          _leftEarResultsMeta,
          leftEarResults.isAcceptableOrUnknown(
              data['left_ear_results']!, _leftEarResultsMeta));
    } else if (isInserting) {
      context.missing(_leftEarResultsMeta);
    }
    if (data.containsKey('right_pta')) {
      context.handle(_rightPtaMeta,
          rightPta.isAcceptableOrUnknown(data['right_pta']!, _rightPtaMeta));
    } else if (isInserting) {
      context.missing(_rightPtaMeta);
    }
    if (data.containsKey('left_pta')) {
      context.handle(_leftPtaMeta,
          leftPta.isAcceptableOrUnknown(data['left_pta']!, _leftPtaMeta));
    } else if (isInserting) {
      context.missing(_leftPtaMeta);
    }
    if (data.containsKey('right_classification')) {
      context.handle(
          _rightClassificationMeta,
          rightClassification.isAcceptableOrUnknown(
              data['right_classification']!, _rightClassificationMeta));
    } else if (isInserting) {
      context.missing(_rightClassificationMeta);
    }
    if (data.containsKey('left_classification')) {
      context.handle(
          _leftClassificationMeta,
          leftClassification.isAcceptableOrUnknown(
              data['left_classification']!, _leftClassificationMeta));
    } else if (isInserting) {
      context.missing(_leftClassificationMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('recommendations')) {
      context.handle(
          _recommendationsMeta,
          recommendations.isAcceptableOrUnknown(
              data['recommendations']!, _recommendationsMeta));
    }
    if (data.containsKey('is_complete')) {
      context.handle(
          _isCompleteMeta,
          isComplete.isAcceptableOrUnknown(
              data['is_complete']!, _isCompleteMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTestResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTestResult(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      audiologistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audiologist_id'])!,
      testDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}test_date'])!,
      testType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_type'])!,
      screeningId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}screening_id']),
      headphoneModel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headphone_model']),
      ambientNoiseDb: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}ambient_noise_db']),
      rightEarResults: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}right_ear_results'])!,
      leftEarResults: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}left_ear_results'])!,
      rightPta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}right_pta'])!,
      leftPta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}left_pta'])!,
      rightClassification: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}right_classification'])!,
      leftClassification: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}left_classification'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      recommendations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recommendations']),
      isComplete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_complete'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TestResultsTable createAlias(String alias) {
    return $TestResultsTable(attachedDatabase, alias);
  }
}

class DbTestResult extends DataClass implements Insertable<DbTestResult> {
  final String id;
  final String patientId;
  final String audiologistId;
  final DateTime testDate;
  final String testType;
  final String? screeningId;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final String rightEarResults;
  final String leftEarResults;
  final double rightPta;
  final double leftPta;
  final String rightClassification;
  final String leftClassification;
  final String? notes;
  final String? recommendations;
  final bool isComplete;
  final bool synced;
  final DateTime createdAt;
  const DbTestResult(
      {required this.id,
      required this.patientId,
      required this.audiologistId,
      required this.testDate,
      required this.testType,
      this.screeningId,
      this.headphoneModel,
      this.ambientNoiseDb,
      required this.rightEarResults,
      required this.leftEarResults,
      required this.rightPta,
      required this.leftPta,
      required this.rightClassification,
      required this.leftClassification,
      this.notes,
      this.recommendations,
      required this.isComplete,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['audiologist_id'] = Variable<String>(audiologistId);
    map['test_date'] = Variable<DateTime>(testDate);
    map['test_type'] = Variable<String>(testType);
    if (!nullToAbsent || screeningId != null) {
      map['screening_id'] = Variable<String>(screeningId);
    }
    if (!nullToAbsent || headphoneModel != null) {
      map['headphone_model'] = Variable<String>(headphoneModel);
    }
    if (!nullToAbsent || ambientNoiseDb != null) {
      map['ambient_noise_db'] = Variable<double>(ambientNoiseDb);
    }
    map['right_ear_results'] = Variable<String>(rightEarResults);
    map['left_ear_results'] = Variable<String>(leftEarResults);
    map['right_pta'] = Variable<double>(rightPta);
    map['left_pta'] = Variable<double>(leftPta);
    map['right_classification'] = Variable<String>(rightClassification);
    map['left_classification'] = Variable<String>(leftClassification);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || recommendations != null) {
      map['recommendations'] = Variable<String>(recommendations);
    }
    map['is_complete'] = Variable<bool>(isComplete);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TestResultsCompanion toCompanion(bool nullToAbsent) {
    return TestResultsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      audiologistId: Value(audiologistId),
      testDate: Value(testDate),
      testType: Value(testType),
      screeningId: screeningId == null && nullToAbsent
          ? const Value.absent()
          : Value(screeningId),
      headphoneModel: headphoneModel == null && nullToAbsent
          ? const Value.absent()
          : Value(headphoneModel),
      ambientNoiseDb: ambientNoiseDb == null && nullToAbsent
          ? const Value.absent()
          : Value(ambientNoiseDb),
      rightEarResults: Value(rightEarResults),
      leftEarResults: Value(leftEarResults),
      rightPta: Value(rightPta),
      leftPta: Value(leftPta),
      rightClassification: Value(rightClassification),
      leftClassification: Value(leftClassification),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      recommendations: recommendations == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendations),
      isComplete: Value(isComplete),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory DbTestResult.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTestResult(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      audiologistId: serializer.fromJson<String>(json['audiologistId']),
      testDate: serializer.fromJson<DateTime>(json['testDate']),
      testType: serializer.fromJson<String>(json['testType']),
      screeningId: serializer.fromJson<String?>(json['screeningId']),
      headphoneModel: serializer.fromJson<String?>(json['headphoneModel']),
      ambientNoiseDb: serializer.fromJson<double?>(json['ambientNoiseDb']),
      rightEarResults: serializer.fromJson<String>(json['rightEarResults']),
      leftEarResults: serializer.fromJson<String>(json['leftEarResults']),
      rightPta: serializer.fromJson<double>(json['rightPta']),
      leftPta: serializer.fromJson<double>(json['leftPta']),
      rightClassification:
          serializer.fromJson<String>(json['rightClassification']),
      leftClassification:
          serializer.fromJson<String>(json['leftClassification']),
      notes: serializer.fromJson<String?>(json['notes']),
      recommendations: serializer.fromJson<String?>(json['recommendations']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'audiologistId': serializer.toJson<String>(audiologistId),
      'testDate': serializer.toJson<DateTime>(testDate),
      'testType': serializer.toJson<String>(testType),
      'screeningId': serializer.toJson<String?>(screeningId),
      'headphoneModel': serializer.toJson<String?>(headphoneModel),
      'ambientNoiseDb': serializer.toJson<double?>(ambientNoiseDb),
      'rightEarResults': serializer.toJson<String>(rightEarResults),
      'leftEarResults': serializer.toJson<String>(leftEarResults),
      'rightPta': serializer.toJson<double>(rightPta),
      'leftPta': serializer.toJson<double>(leftPta),
      'rightClassification': serializer.toJson<String>(rightClassification),
      'leftClassification': serializer.toJson<String>(leftClassification),
      'notes': serializer.toJson<String?>(notes),
      'recommendations': serializer.toJson<String?>(recommendations),
      'isComplete': serializer.toJson<bool>(isComplete),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbTestResult copyWith(
          {String? id,
          String? patientId,
          String? audiologistId,
          DateTime? testDate,
          String? testType,
          Value<String?> screeningId = const Value.absent(),
          Value<String?> headphoneModel = const Value.absent(),
          Value<double?> ambientNoiseDb = const Value.absent(),
          String? rightEarResults,
          String? leftEarResults,
          double? rightPta,
          double? leftPta,
          String? rightClassification,
          String? leftClassification,
          Value<String?> notes = const Value.absent(),
          Value<String?> recommendations = const Value.absent(),
          bool? isComplete,
          bool? synced,
          DateTime? createdAt}) =>
      DbTestResult(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        audiologistId: audiologistId ?? this.audiologistId,
        testDate: testDate ?? this.testDate,
        testType: testType ?? this.testType,
        screeningId: screeningId.present ? screeningId.value : this.screeningId,
        headphoneModel:
            headphoneModel.present ? headphoneModel.value : this.headphoneModel,
        ambientNoiseDb:
            ambientNoiseDb.present ? ambientNoiseDb.value : this.ambientNoiseDb,
        rightEarResults: rightEarResults ?? this.rightEarResults,
        leftEarResults: leftEarResults ?? this.leftEarResults,
        rightPta: rightPta ?? this.rightPta,
        leftPta: leftPta ?? this.leftPta,
        rightClassification: rightClassification ?? this.rightClassification,
        leftClassification: leftClassification ?? this.leftClassification,
        notes: notes.present ? notes.value : this.notes,
        recommendations: recommendations.present
            ? recommendations.value
            : this.recommendations,
        isComplete: isComplete ?? this.isComplete,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  DbTestResult copyWithCompanion(TestResultsCompanion data) {
    return DbTestResult(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      audiologistId: data.audiologistId.present
          ? data.audiologistId.value
          : this.audiologistId,
      testDate: data.testDate.present ? data.testDate.value : this.testDate,
      testType: data.testType.present ? data.testType.value : this.testType,
      screeningId:
          data.screeningId.present ? data.screeningId.value : this.screeningId,
      headphoneModel: data.headphoneModel.present
          ? data.headphoneModel.value
          : this.headphoneModel,
      ambientNoiseDb: data.ambientNoiseDb.present
          ? data.ambientNoiseDb.value
          : this.ambientNoiseDb,
      rightEarResults: data.rightEarResults.present
          ? data.rightEarResults.value
          : this.rightEarResults,
      leftEarResults: data.leftEarResults.present
          ? data.leftEarResults.value
          : this.leftEarResults,
      rightPta: data.rightPta.present ? data.rightPta.value : this.rightPta,
      leftPta: data.leftPta.present ? data.leftPta.value : this.leftPta,
      rightClassification: data.rightClassification.present
          ? data.rightClassification.value
          : this.rightClassification,
      leftClassification: data.leftClassification.present
          ? data.leftClassification.value
          : this.leftClassification,
      notes: data.notes.present ? data.notes.value : this.notes,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      isComplete:
          data.isComplete.present ? data.isComplete.value : this.isComplete,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTestResult(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('audiologistId: $audiologistId, ')
          ..write('testDate: $testDate, ')
          ..write('testType: $testType, ')
          ..write('screeningId: $screeningId, ')
          ..write('headphoneModel: $headphoneModel, ')
          ..write('ambientNoiseDb: $ambientNoiseDb, ')
          ..write('rightEarResults: $rightEarResults, ')
          ..write('leftEarResults: $leftEarResults, ')
          ..write('rightPta: $rightPta, ')
          ..write('leftPta: $leftPta, ')
          ..write('rightClassification: $rightClassification, ')
          ..write('leftClassification: $leftClassification, ')
          ..write('notes: $notes, ')
          ..write('recommendations: $recommendations, ')
          ..write('isComplete: $isComplete, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      audiologistId,
      testDate,
      testType,
      screeningId,
      headphoneModel,
      ambientNoiseDb,
      rightEarResults,
      leftEarResults,
      rightPta,
      leftPta,
      rightClassification,
      leftClassification,
      notes,
      recommendations,
      isComplete,
      synced,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTestResult &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.audiologistId == this.audiologistId &&
          other.testDate == this.testDate &&
          other.testType == this.testType &&
          other.screeningId == this.screeningId &&
          other.headphoneModel == this.headphoneModel &&
          other.ambientNoiseDb == this.ambientNoiseDb &&
          other.rightEarResults == this.rightEarResults &&
          other.leftEarResults == this.leftEarResults &&
          other.rightPta == this.rightPta &&
          other.leftPta == this.leftPta &&
          other.rightClassification == this.rightClassification &&
          other.leftClassification == this.leftClassification &&
          other.notes == this.notes &&
          other.recommendations == this.recommendations &&
          other.isComplete == this.isComplete &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class TestResultsCompanion extends UpdateCompanion<DbTestResult> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> audiologistId;
  final Value<DateTime> testDate;
  final Value<String> testType;
  final Value<String?> screeningId;
  final Value<String?> headphoneModel;
  final Value<double?> ambientNoiseDb;
  final Value<String> rightEarResults;
  final Value<String> leftEarResults;
  final Value<double> rightPta;
  final Value<double> leftPta;
  final Value<String> rightClassification;
  final Value<String> leftClassification;
  final Value<String?> notes;
  final Value<String?> recommendations;
  final Value<bool> isComplete;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TestResultsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.audiologistId = const Value.absent(),
    this.testDate = const Value.absent(),
    this.testType = const Value.absent(),
    this.screeningId = const Value.absent(),
    this.headphoneModel = const Value.absent(),
    this.ambientNoiseDb = const Value.absent(),
    this.rightEarResults = const Value.absent(),
    this.leftEarResults = const Value.absent(),
    this.rightPta = const Value.absent(),
    this.leftPta = const Value.absent(),
    this.rightClassification = const Value.absent(),
    this.leftClassification = const Value.absent(),
    this.notes = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestResultsCompanion.insert({
    required String id,
    required String patientId,
    required String audiologistId,
    required DateTime testDate,
    this.testType = const Value.absent(),
    this.screeningId = const Value.absent(),
    this.headphoneModel = const Value.absent(),
    this.ambientNoiseDb = const Value.absent(),
    required String rightEarResults,
    required String leftEarResults,
    required double rightPta,
    required double leftPta,
    required String rightClassification,
    required String leftClassification,
    this.notes = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        audiologistId = Value(audiologistId),
        testDate = Value(testDate),
        rightEarResults = Value(rightEarResults),
        leftEarResults = Value(leftEarResults),
        rightPta = Value(rightPta),
        leftPta = Value(leftPta),
        rightClassification = Value(rightClassification),
        leftClassification = Value(leftClassification),
        createdAt = Value(createdAt);
  static Insertable<DbTestResult> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? audiologistId,
    Expression<DateTime>? testDate,
    Expression<String>? testType,
    Expression<String>? screeningId,
    Expression<String>? headphoneModel,
    Expression<double>? ambientNoiseDb,
    Expression<String>? rightEarResults,
    Expression<String>? leftEarResults,
    Expression<double>? rightPta,
    Expression<double>? leftPta,
    Expression<String>? rightClassification,
    Expression<String>? leftClassification,
    Expression<String>? notes,
    Expression<String>? recommendations,
    Expression<bool>? isComplete,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (audiologistId != null) 'audiologist_id': audiologistId,
      if (testDate != null) 'test_date': testDate,
      if (testType != null) 'test_type': testType,
      if (screeningId != null) 'screening_id': screeningId,
      if (headphoneModel != null) 'headphone_model': headphoneModel,
      if (ambientNoiseDb != null) 'ambient_noise_db': ambientNoiseDb,
      if (rightEarResults != null) 'right_ear_results': rightEarResults,
      if (leftEarResults != null) 'left_ear_results': leftEarResults,
      if (rightPta != null) 'right_pta': rightPta,
      if (leftPta != null) 'left_pta': leftPta,
      if (rightClassification != null)
        'right_classification': rightClassification,
      if (leftClassification != null) 'left_classification': leftClassification,
      if (notes != null) 'notes': notes,
      if (recommendations != null) 'recommendations': recommendations,
      if (isComplete != null) 'is_complete': isComplete,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestResultsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? audiologistId,
      Value<DateTime>? testDate,
      Value<String>? testType,
      Value<String?>? screeningId,
      Value<String?>? headphoneModel,
      Value<double?>? ambientNoiseDb,
      Value<String>? rightEarResults,
      Value<String>? leftEarResults,
      Value<double>? rightPta,
      Value<double>? leftPta,
      Value<String>? rightClassification,
      Value<String>? leftClassification,
      Value<String?>? notes,
      Value<String?>? recommendations,
      Value<bool>? isComplete,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TestResultsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      audiologistId: audiologistId ?? this.audiologistId,
      testDate: testDate ?? this.testDate,
      testType: testType ?? this.testType,
      screeningId: screeningId ?? this.screeningId,
      headphoneModel: headphoneModel ?? this.headphoneModel,
      ambientNoiseDb: ambientNoiseDb ?? this.ambientNoiseDb,
      rightEarResults: rightEarResults ?? this.rightEarResults,
      leftEarResults: leftEarResults ?? this.leftEarResults,
      rightPta: rightPta ?? this.rightPta,
      leftPta: leftPta ?? this.leftPta,
      rightClassification: rightClassification ?? this.rightClassification,
      leftClassification: leftClassification ?? this.leftClassification,
      notes: notes ?? this.notes,
      recommendations: recommendations ?? this.recommendations,
      isComplete: isComplete ?? this.isComplete,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (audiologistId.present) {
      map['audiologist_id'] = Variable<String>(audiologistId.value);
    }
    if (testDate.present) {
      map['test_date'] = Variable<DateTime>(testDate.value);
    }
    if (testType.present) {
      map['test_type'] = Variable<String>(testType.value);
    }
    if (screeningId.present) {
      map['screening_id'] = Variable<String>(screeningId.value);
    }
    if (headphoneModel.present) {
      map['headphone_model'] = Variable<String>(headphoneModel.value);
    }
    if (ambientNoiseDb.present) {
      map['ambient_noise_db'] = Variable<double>(ambientNoiseDb.value);
    }
    if (rightEarResults.present) {
      map['right_ear_results'] = Variable<String>(rightEarResults.value);
    }
    if (leftEarResults.present) {
      map['left_ear_results'] = Variable<String>(leftEarResults.value);
    }
    if (rightPta.present) {
      map['right_pta'] = Variable<double>(rightPta.value);
    }
    if (leftPta.present) {
      map['left_pta'] = Variable<double>(leftPta.value);
    }
    if (rightClassification.present) {
      map['right_classification'] = Variable<String>(rightClassification.value);
    }
    if (leftClassification.present) {
      map['left_classification'] = Variable<String>(leftClassification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestResultsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('audiologistId: $audiologistId, ')
          ..write('testDate: $testDate, ')
          ..write('testType: $testType, ')
          ..write('screeningId: $screeningId, ')
          ..write('headphoneModel: $headphoneModel, ')
          ..write('ambientNoiseDb: $ambientNoiseDb, ')
          ..write('rightEarResults: $rightEarResults, ')
          ..write('leftEarResults: $leftEarResults, ')
          ..write('rightPta: $rightPta, ')
          ..write('leftPta: $leftPta, ')
          ..write('rightClassification: $rightClassification, ')
          ..write('leftClassification: $leftClassification, ')
          ..write('notes: $notes, ')
          ..write('recommendations: $recommendations, ')
          ..write('isComplete: $isComplete, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScreeningResultsTable extends ScreeningResults
    with TableInfo<$ScreeningResultsTable, ScreeningResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreeningResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testDateMeta =
      const VerificationMeta('testDate');
  @override
  late final GeneratedColumn<DateTime> testDate = GeneratedColumn<DateTime>(
      'test_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _headphoneModelMeta =
      const VerificationMeta('headphoneModel');
  @override
  late final GeneratedColumn<String> headphoneModel = GeneratedColumn<String>(
      'headphone_model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ambientNoiseDbMeta =
      const VerificationMeta('ambientNoiseDb');
  @override
  late final GeneratedColumn<double> ambientNoiseDb = GeneratedColumn<double>(
      'ambient_noise_db', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequenciesTestedMeta =
      const VerificationMeta('frequenciesTested');
  @override
  late final GeneratedColumn<String> frequenciesTested =
      GeneratedColumn<String>('frequencies_tested', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thresholdsMeta =
      const VerificationMeta('thresholds');
  @override
  late final GeneratedColumn<String> thresholds = GeneratedColumn<String>(
      'thresholds', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceInfoMeta =
      const VerificationMeta('deviceInfo');
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
      'device_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        testDate,
        headphoneModel,
        ambientNoiseDb,
        result,
        frequenciesTested,
        thresholds,
        deviceInfo,
        synced,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screening_results';
  @override
  VerificationContext validateIntegrity(Insertable<ScreeningResult> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('test_date')) {
      context.handle(_testDateMeta,
          testDate.isAcceptableOrUnknown(data['test_date']!, _testDateMeta));
    } else if (isInserting) {
      context.missing(_testDateMeta);
    }
    if (data.containsKey('headphone_model')) {
      context.handle(
          _headphoneModelMeta,
          headphoneModel.isAcceptableOrUnknown(
              data['headphone_model']!, _headphoneModelMeta));
    }
    if (data.containsKey('ambient_noise_db')) {
      context.handle(
          _ambientNoiseDbMeta,
          ambientNoiseDb.isAcceptableOrUnknown(
              data['ambient_noise_db']!, _ambientNoiseDbMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('frequencies_tested')) {
      context.handle(
          _frequenciesTestedMeta,
          frequenciesTested.isAcceptableOrUnknown(
              data['frequencies_tested']!, _frequenciesTestedMeta));
    } else if (isInserting) {
      context.missing(_frequenciesTestedMeta);
    }
    if (data.containsKey('thresholds')) {
      context.handle(
          _thresholdsMeta,
          thresholds.isAcceptableOrUnknown(
              data['thresholds']!, _thresholdsMeta));
    } else if (isInserting) {
      context.missing(_thresholdsMeta);
    }
    if (data.containsKey('device_info')) {
      context.handle(
          _deviceInfoMeta,
          deviceInfo.isAcceptableOrUnknown(
              data['device_info']!, _deviceInfoMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreeningResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreeningResult(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      testDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}test_date'])!,
      headphoneModel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headphone_model']),
      ambientNoiseDb: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}ambient_noise_db']),
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      frequenciesTested: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}frequencies_tested'])!,
      thresholds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thresholds'])!,
      deviceInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_info']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScreeningResultsTable createAlias(String alias) {
    return $ScreeningResultsTable(attachedDatabase, alias);
  }
}

class ScreeningResult extends DataClass implements Insertable<ScreeningResult> {
  final String id;
  final String userId;
  final DateTime testDate;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final String result;
  final String frequenciesTested;
  final String thresholds;
  final String? deviceInfo;
  final bool synced;
  final DateTime createdAt;
  const ScreeningResult(
      {required this.id,
      required this.userId,
      required this.testDate,
      this.headphoneModel,
      this.ambientNoiseDb,
      required this.result,
      required this.frequenciesTested,
      required this.thresholds,
      this.deviceInfo,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['test_date'] = Variable<DateTime>(testDate);
    if (!nullToAbsent || headphoneModel != null) {
      map['headphone_model'] = Variable<String>(headphoneModel);
    }
    if (!nullToAbsent || ambientNoiseDb != null) {
      map['ambient_noise_db'] = Variable<double>(ambientNoiseDb);
    }
    map['result'] = Variable<String>(result);
    map['frequencies_tested'] = Variable<String>(frequenciesTested);
    map['thresholds'] = Variable<String>(thresholds);
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScreeningResultsCompanion toCompanion(bool nullToAbsent) {
    return ScreeningResultsCompanion(
      id: Value(id),
      userId: Value(userId),
      testDate: Value(testDate),
      headphoneModel: headphoneModel == null && nullToAbsent
          ? const Value.absent()
          : Value(headphoneModel),
      ambientNoiseDb: ambientNoiseDb == null && nullToAbsent
          ? const Value.absent()
          : Value(ambientNoiseDb),
      result: Value(result),
      frequenciesTested: Value(frequenciesTested),
      thresholds: Value(thresholds),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory ScreeningResult.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreeningResult(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      testDate: serializer.fromJson<DateTime>(json['testDate']),
      headphoneModel: serializer.fromJson<String?>(json['headphoneModel']),
      ambientNoiseDb: serializer.fromJson<double?>(json['ambientNoiseDb']),
      result: serializer.fromJson<String>(json['result']),
      frequenciesTested: serializer.fromJson<String>(json['frequenciesTested']),
      thresholds: serializer.fromJson<String>(json['thresholds']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'testDate': serializer.toJson<DateTime>(testDate),
      'headphoneModel': serializer.toJson<String?>(headphoneModel),
      'ambientNoiseDb': serializer.toJson<double?>(ambientNoiseDb),
      'result': serializer.toJson<String>(result),
      'frequenciesTested': serializer.toJson<String>(frequenciesTested),
      'thresholds': serializer.toJson<String>(thresholds),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScreeningResult copyWith(
          {String? id,
          String? userId,
          DateTime? testDate,
          Value<String?> headphoneModel = const Value.absent(),
          Value<double?> ambientNoiseDb = const Value.absent(),
          String? result,
          String? frequenciesTested,
          String? thresholds,
          Value<String?> deviceInfo = const Value.absent(),
          bool? synced,
          DateTime? createdAt}) =>
      ScreeningResult(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        testDate: testDate ?? this.testDate,
        headphoneModel:
            headphoneModel.present ? headphoneModel.value : this.headphoneModel,
        ambientNoiseDb:
            ambientNoiseDb.present ? ambientNoiseDb.value : this.ambientNoiseDb,
        result: result ?? this.result,
        frequenciesTested: frequenciesTested ?? this.frequenciesTested,
        thresholds: thresholds ?? this.thresholds,
        deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  ScreeningResult copyWithCompanion(ScreeningResultsCompanion data) {
    return ScreeningResult(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      testDate: data.testDate.present ? data.testDate.value : this.testDate,
      headphoneModel: data.headphoneModel.present
          ? data.headphoneModel.value
          : this.headphoneModel,
      ambientNoiseDb: data.ambientNoiseDb.present
          ? data.ambientNoiseDb.value
          : this.ambientNoiseDb,
      result: data.result.present ? data.result.value : this.result,
      frequenciesTested: data.frequenciesTested.present
          ? data.frequenciesTested.value
          : this.frequenciesTested,
      thresholds:
          data.thresholds.present ? data.thresholds.value : this.thresholds,
      deviceInfo:
          data.deviceInfo.present ? data.deviceInfo.value : this.deviceInfo,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreeningResult(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('testDate: $testDate, ')
          ..write('headphoneModel: $headphoneModel, ')
          ..write('ambientNoiseDb: $ambientNoiseDb, ')
          ..write('result: $result, ')
          ..write('frequenciesTested: $frequenciesTested, ')
          ..write('thresholds: $thresholds, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      testDate,
      headphoneModel,
      ambientNoiseDb,
      result,
      frequenciesTested,
      thresholds,
      deviceInfo,
      synced,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreeningResult &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.testDate == this.testDate &&
          other.headphoneModel == this.headphoneModel &&
          other.ambientNoiseDb == this.ambientNoiseDb &&
          other.result == this.result &&
          other.frequenciesTested == this.frequenciesTested &&
          other.thresholds == this.thresholds &&
          other.deviceInfo == this.deviceInfo &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class ScreeningResultsCompanion extends UpdateCompanion<ScreeningResult> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> testDate;
  final Value<String?> headphoneModel;
  final Value<double?> ambientNoiseDb;
  final Value<String> result;
  final Value<String> frequenciesTested;
  final Value<String> thresholds;
  final Value<String?> deviceInfo;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScreeningResultsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.testDate = const Value.absent(),
    this.headphoneModel = const Value.absent(),
    this.ambientNoiseDb = const Value.absent(),
    this.result = const Value.absent(),
    this.frequenciesTested = const Value.absent(),
    this.thresholds = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScreeningResultsCompanion.insert({
    required String id,
    required String userId,
    required DateTime testDate,
    this.headphoneModel = const Value.absent(),
    this.ambientNoiseDb = const Value.absent(),
    required String result,
    required String frequenciesTested,
    required String thresholds,
    this.deviceInfo = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        testDate = Value(testDate),
        result = Value(result),
        frequenciesTested = Value(frequenciesTested),
        thresholds = Value(thresholds),
        createdAt = Value(createdAt);
  static Insertable<ScreeningResult> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? testDate,
    Expression<String>? headphoneModel,
    Expression<double>? ambientNoiseDb,
    Expression<String>? result,
    Expression<String>? frequenciesTested,
    Expression<String>? thresholds,
    Expression<String>? deviceInfo,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (testDate != null) 'test_date': testDate,
      if (headphoneModel != null) 'headphone_model': headphoneModel,
      if (ambientNoiseDb != null) 'ambient_noise_db': ambientNoiseDb,
      if (result != null) 'result': result,
      if (frequenciesTested != null) 'frequencies_tested': frequenciesTested,
      if (thresholds != null) 'thresholds': thresholds,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScreeningResultsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DateTime>? testDate,
      Value<String?>? headphoneModel,
      Value<double?>? ambientNoiseDb,
      Value<String>? result,
      Value<String>? frequenciesTested,
      Value<String>? thresholds,
      Value<String?>? deviceInfo,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ScreeningResultsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      testDate: testDate ?? this.testDate,
      headphoneModel: headphoneModel ?? this.headphoneModel,
      ambientNoiseDb: ambientNoiseDb ?? this.ambientNoiseDb,
      result: result ?? this.result,
      frequenciesTested: frequenciesTested ?? this.frequenciesTested,
      thresholds: thresholds ?? this.thresholds,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (testDate.present) {
      map['test_date'] = Variable<DateTime>(testDate.value);
    }
    if (headphoneModel.present) {
      map['headphone_model'] = Variable<String>(headphoneModel.value);
    }
    if (ambientNoiseDb.present) {
      map['ambient_noise_db'] = Variable<double>(ambientNoiseDb.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (frequenciesTested.present) {
      map['frequencies_tested'] = Variable<String>(frequenciesTested.value);
    }
    if (thresholds.present) {
      map['thresholds'] = Variable<String>(thresholds.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreeningResultsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('testDate: $testDate, ')
          ..write('headphoneModel: $headphoneModel, ')
          ..write('ambientNoiseDb: $ambientNoiseDb, ')
          ..write('result: $result, ')
          ..write('frequenciesTested: $frequenciesTested, ')
          ..write('thresholds: $thresholds, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseNumberMeta =
      const VerificationMeta('licenseNumber');
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
      'license_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseStateMeta =
      const VerificationMeta('licenseState');
  @override
  late final GeneratedColumn<String> licenseState = GeneratedColumn<String>(
      'license_state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseExpiryDateMeta =
      const VerificationMeta('licenseExpiryDate');
  @override
  late final GeneratedColumn<DateTime> licenseExpiryDate =
      GeneratedColumn<DateTime>('license_expiry_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _verifiedByMeta =
      const VerificationMeta('verifiedBy');
  @override
  late final GeneratedColumn<String> verifiedBy = GeneratedColumn<String>(
      'verified_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedAtMeta =
      const VerificationMeta('verifiedAt');
  @override
  late final GeneratedColumn<DateTime> verifiedAt = GeneratedColumn<DateTime>(
      'verified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSuspendedMeta =
      const VerificationMeta('isSuspended');
  @override
  late final GeneratedColumn<bool> isSuspended = GeneratedColumn<bool>(
      'is_suspended', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_suspended" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _suspensionReasonMeta =
      const VerificationMeta('suspensionReason');
  @override
  late final GeneratedColumn<String> suspensionReason = GeneratedColumn<String>(
      'suspension_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _failedLoginAttemptsMeta =
      const VerificationMeta('failedLoginAttempts');
  @override
  late final GeneratedColumn<int> failedLoginAttempts = GeneratedColumn<int>(
      'failed_login_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<DateTime> lockedUntil = GeneratedColumn<DateTime>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastLoginIpMeta =
      const VerificationMeta('lastLoginIp');
  @override
  late final GeneratedColumn<String> lastLoginIp = GeneratedColumn<String>(
      'last_login_ip', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        name,
        role,
        avatarUrl,
        licenseNumber,
        licenseState,
        licenseExpiryDate,
        isVerified,
        verifiedBy,
        verifiedAt,
        isActive,
        isSuspended,
        suspensionReason,
        failedLoginAttempts,
        lockedUntil,
        lastLoginAt,
        lastLoginIp,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('license_number')) {
      context.handle(
          _licenseNumberMeta,
          licenseNumber.isAcceptableOrUnknown(
              data['license_number']!, _licenseNumberMeta));
    }
    if (data.containsKey('license_state')) {
      context.handle(
          _licenseStateMeta,
          licenseState.isAcceptableOrUnknown(
              data['license_state']!, _licenseStateMeta));
    }
    if (data.containsKey('license_expiry_date')) {
      context.handle(
          _licenseExpiryDateMeta,
          licenseExpiryDate.isAcceptableOrUnknown(
              data['license_expiry_date']!, _licenseExpiryDateMeta));
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
    }
    if (data.containsKey('verified_by')) {
      context.handle(
          _verifiedByMeta,
          verifiedBy.isAcceptableOrUnknown(
              data['verified_by']!, _verifiedByMeta));
    }
    if (data.containsKey('verified_at')) {
      context.handle(
          _verifiedAtMeta,
          verifiedAt.isAcceptableOrUnknown(
              data['verified_at']!, _verifiedAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_suspended')) {
      context.handle(
          _isSuspendedMeta,
          isSuspended.isAcceptableOrUnknown(
              data['is_suspended']!, _isSuspendedMeta));
    }
    if (data.containsKey('suspension_reason')) {
      context.handle(
          _suspensionReasonMeta,
          suspensionReason.isAcceptableOrUnknown(
              data['suspension_reason']!, _suspensionReasonMeta));
    }
    if (data.containsKey('failed_login_attempts')) {
      context.handle(
          _failedLoginAttemptsMeta,
          failedLoginAttempts.isAcceptableOrUnknown(
              data['failed_login_attempts']!, _failedLoginAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('last_login_ip')) {
      context.handle(
          _lastLoginIpMeta,
          lastLoginIp.isAcceptableOrUnknown(
              data['last_login_ip']!, _lastLoginIpMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      licenseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_number']),
      licenseState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_state']),
      licenseExpiryDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}license_expiry_date']),
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      verifiedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by']),
      verifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}verified_at']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isSuspended: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_suspended'])!,
      suspensionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}suspension_reason']),
      failedLoginAttempts: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}failed_login_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}locked_until']),
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      lastLoginIp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_login_ip']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
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
  final DateTime? updatedAt;
  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.role,
      this.avatarUrl,
      this.licenseNumber,
      this.licenseState,
      this.licenseExpiryDate,
      required this.isVerified,
      this.verifiedBy,
      this.verifiedAt,
      required this.isActive,
      required this.isSuspended,
      this.suspensionReason,
      required this.failedLoginAttempts,
      this.lockedUntil,
      this.lastLoginAt,
      this.lastLoginIp,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || licenseNumber != null) {
      map['license_number'] = Variable<String>(licenseNumber);
    }
    if (!nullToAbsent || licenseState != null) {
      map['license_state'] = Variable<String>(licenseState);
    }
    if (!nullToAbsent || licenseExpiryDate != null) {
      map['license_expiry_date'] = Variable<DateTime>(licenseExpiryDate);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    if (!nullToAbsent || verifiedBy != null) {
      map['verified_by'] = Variable<String>(verifiedBy);
    }
    if (!nullToAbsent || verifiedAt != null) {
      map['verified_at'] = Variable<DateTime>(verifiedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_suspended'] = Variable<bool>(isSuspended);
    if (!nullToAbsent || suspensionReason != null) {
      map['suspension_reason'] = Variable<String>(suspensionReason);
    }
    map['failed_login_attempts'] = Variable<int>(failedLoginAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<DateTime>(lockedUntil);
    }
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    if (!nullToAbsent || lastLoginIp != null) {
      map['last_login_ip'] = Variable<String>(lastLoginIp);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      name: Value(name),
      role: Value(role),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      licenseNumber: licenseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseNumber),
      licenseState: licenseState == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseState),
      licenseExpiryDate: licenseExpiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseExpiryDate),
      isVerified: Value(isVerified),
      verifiedBy: verifiedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy),
      verifiedAt: verifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedAt),
      isActive: Value(isActive),
      isSuspended: Value(isSuspended),
      suspensionReason: suspensionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(suspensionReason),
      failedLoginAttempts: Value(failedLoginAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      lastLoginIp: lastLoginIp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginIp),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      licenseNumber: serializer.fromJson<String?>(json['licenseNumber']),
      licenseState: serializer.fromJson<String?>(json['licenseState']),
      licenseExpiryDate:
          serializer.fromJson<DateTime?>(json['licenseExpiryDate']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      verifiedBy: serializer.fromJson<String?>(json['verifiedBy']),
      verifiedAt: serializer.fromJson<DateTime?>(json['verifiedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSuspended: serializer.fromJson<bool>(json['isSuspended']),
      suspensionReason: serializer.fromJson<String?>(json['suspensionReason']),
      failedLoginAttempts:
          serializer.fromJson<int>(json['failedLoginAttempts']),
      lockedUntil: serializer.fromJson<DateTime?>(json['lockedUntil']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      lastLoginIp: serializer.fromJson<String?>(json['lastLoginIp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'licenseNumber': serializer.toJson<String?>(licenseNumber),
      'licenseState': serializer.toJson<String?>(licenseState),
      'licenseExpiryDate': serializer.toJson<DateTime?>(licenseExpiryDate),
      'isVerified': serializer.toJson<bool>(isVerified),
      'verifiedBy': serializer.toJson<String?>(verifiedBy),
      'verifiedAt': serializer.toJson<DateTime?>(verifiedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'isSuspended': serializer.toJson<bool>(isSuspended),
      'suspensionReason': serializer.toJson<String?>(suspensionReason),
      'failedLoginAttempts': serializer.toJson<int>(failedLoginAttempts),
      'lockedUntil': serializer.toJson<DateTime?>(lockedUntil),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'lastLoginIp': serializer.toJson<String?>(lastLoginIp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          String? email,
          String? name,
          String? role,
          Value<String?> avatarUrl = const Value.absent(),
          Value<String?> licenseNumber = const Value.absent(),
          Value<String?> licenseState = const Value.absent(),
          Value<DateTime?> licenseExpiryDate = const Value.absent(),
          bool? isVerified,
          Value<String?> verifiedBy = const Value.absent(),
          Value<DateTime?> verifiedAt = const Value.absent(),
          bool? isActive,
          bool? isSuspended,
          Value<String?> suspensionReason = const Value.absent(),
          int? failedLoginAttempts,
          Value<DateTime?> lockedUntil = const Value.absent(),
          Value<DateTime?> lastLoginAt = const Value.absent(),
          Value<String?> lastLoginIp = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        licenseNumber:
            licenseNumber.present ? licenseNumber.value : this.licenseNumber,
        licenseState:
            licenseState.present ? licenseState.value : this.licenseState,
        licenseExpiryDate: licenseExpiryDate.present
            ? licenseExpiryDate.value
            : this.licenseExpiryDate,
        isVerified: isVerified ?? this.isVerified,
        verifiedBy: verifiedBy.present ? verifiedBy.value : this.verifiedBy,
        verifiedAt: verifiedAt.present ? verifiedAt.value : this.verifiedAt,
        isActive: isActive ?? this.isActive,
        isSuspended: isSuspended ?? this.isSuspended,
        suspensionReason: suspensionReason.present
            ? suspensionReason.value
            : this.suspensionReason,
        failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        lastLoginIp: lastLoginIp.present ? lastLoginIp.value : this.lastLoginIp,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      licenseState: data.licenseState.present
          ? data.licenseState.value
          : this.licenseState,
      licenseExpiryDate: data.licenseExpiryDate.present
          ? data.licenseExpiryDate.value
          : this.licenseExpiryDate,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      verifiedBy:
          data.verifiedBy.present ? data.verifiedBy.value : this.verifiedBy,
      verifiedAt:
          data.verifiedAt.present ? data.verifiedAt.value : this.verifiedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSuspended:
          data.isSuspended.present ? data.isSuspended.value : this.isSuspended,
      suspensionReason: data.suspensionReason.present
          ? data.suspensionReason.value
          : this.suspensionReason,
      failedLoginAttempts: data.failedLoginAttempts.present
          ? data.failedLoginAttempts.value
          : this.failedLoginAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      lastLoginIp:
          data.lastLoginIp.present ? data.lastLoginIp.value : this.lastLoginIp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('licenseState: $licenseState, ')
          ..write('licenseExpiryDate: $licenseExpiryDate, ')
          ..write('isVerified: $isVerified, ')
          ..write('verifiedBy: $verifiedBy, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('isActive: $isActive, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('suspensionReason: $suspensionReason, ')
          ..write('failedLoginAttempts: $failedLoginAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('lastLoginIp: $lastLoginIp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      email,
      name,
      role,
      avatarUrl,
      licenseNumber,
      licenseState,
      licenseExpiryDate,
      isVerified,
      verifiedBy,
      verifiedAt,
      isActive,
      isSuspended,
      suspensionReason,
      failedLoginAttempts,
      lockedUntil,
      lastLoginAt,
      lastLoginIp,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.name == this.name &&
          other.role == this.role &&
          other.avatarUrl == this.avatarUrl &&
          other.licenseNumber == this.licenseNumber &&
          other.licenseState == this.licenseState &&
          other.licenseExpiryDate == this.licenseExpiryDate &&
          other.isVerified == this.isVerified &&
          other.verifiedBy == this.verifiedBy &&
          other.verifiedAt == this.verifiedAt &&
          other.isActive == this.isActive &&
          other.isSuspended == this.isSuspended &&
          other.suspensionReason == this.suspensionReason &&
          other.failedLoginAttempts == this.failedLoginAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.lastLoginAt == this.lastLoginAt &&
          other.lastLoginIp == this.lastLoginIp &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> name;
  final Value<String> role;
  final Value<String?> avatarUrl;
  final Value<String?> licenseNumber;
  final Value<String?> licenseState;
  final Value<DateTime?> licenseExpiryDate;
  final Value<bool> isVerified;
  final Value<String?> verifiedBy;
  final Value<DateTime?> verifiedAt;
  final Value<bool> isActive;
  final Value<bool> isSuspended;
  final Value<String?> suspensionReason;
  final Value<int> failedLoginAttempts;
  final Value<DateTime?> lockedUntil;
  final Value<DateTime?> lastLoginAt;
  final Value<String?> lastLoginIp;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.licenseState = const Value.absent(),
    this.licenseExpiryDate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.verifiedBy = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.suspensionReason = const Value.absent(),
    this.failedLoginAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.lastLoginIp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String name,
    required String role,
    this.avatarUrl = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.licenseState = const Value.absent(),
    this.licenseExpiryDate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.verifiedBy = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.suspensionReason = const Value.absent(),
    this.failedLoginAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.lastLoginIp = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        name = Value(name),
        role = Value(role),
        createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? avatarUrl,
    Expression<String>? licenseNumber,
    Expression<String>? licenseState,
    Expression<DateTime>? licenseExpiryDate,
    Expression<bool>? isVerified,
    Expression<String>? verifiedBy,
    Expression<DateTime>? verifiedAt,
    Expression<bool>? isActive,
    Expression<bool>? isSuspended,
    Expression<String>? suspensionReason,
    Expression<int>? failedLoginAttempts,
    Expression<DateTime>? lockedUntil,
    Expression<DateTime>? lastLoginAt,
    Expression<String>? lastLoginIp,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (licenseState != null) 'license_state': licenseState,
      if (licenseExpiryDate != null) 'license_expiry_date': licenseExpiryDate,
      if (isVerified != null) 'is_verified': isVerified,
      if (verifiedBy != null) 'verified_by': verifiedBy,
      if (verifiedAt != null) 'verified_at': verifiedAt,
      if (isActive != null) 'is_active': isActive,
      if (isSuspended != null) 'is_suspended': isSuspended,
      if (suspensionReason != null) 'suspension_reason': suspensionReason,
      if (failedLoginAttempts != null)
        'failed_login_attempts': failedLoginAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (lastLoginIp != null) 'last_login_ip': lastLoginIp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? name,
      Value<String>? role,
      Value<String?>? avatarUrl,
      Value<String?>? licenseNumber,
      Value<String?>? licenseState,
      Value<DateTime?>? licenseExpiryDate,
      Value<bool>? isVerified,
      Value<String?>? verifiedBy,
      Value<DateTime?>? verifiedAt,
      Value<bool>? isActive,
      Value<bool>? isSuspended,
      Value<String?>? suspensionReason,
      Value<int>? failedLoginAttempts,
      Value<DateTime?>? lockedUntil,
      Value<DateTime?>? lastLoginAt,
      Value<String?>? lastLoginIp,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
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
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (licenseState.present) {
      map['license_state'] = Variable<String>(licenseState.value);
    }
    if (licenseExpiryDate.present) {
      map['license_expiry_date'] = Variable<DateTime>(licenseExpiryDate.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (verifiedBy.present) {
      map['verified_by'] = Variable<String>(verifiedBy.value);
    }
    if (verifiedAt.present) {
      map['verified_at'] = Variable<DateTime>(verifiedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSuspended.present) {
      map['is_suspended'] = Variable<bool>(isSuspended.value);
    }
    if (suspensionReason.present) {
      map['suspension_reason'] = Variable<String>(suspensionReason.value);
    }
    if (failedLoginAttempts.present) {
      map['failed_login_attempts'] = Variable<int>(failedLoginAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<DateTime>(lockedUntil.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (lastLoginIp.present) {
      map['last_login_ip'] = Variable<String>(lastLoginIp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('licenseState: $licenseState, ')
          ..write('licenseExpiryDate: $licenseExpiryDate, ')
          ..write('isVerified: $isVerified, ')
          ..write('verifiedBy: $verifiedBy, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('isActive: $isActive, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('suspensionReason: $suspensionReason, ')
          ..write('failedLoginAttempts: $failedLoginAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('lastLoginIp: $lastLoginIp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userEmailMeta =
      const VerificationMeta('userEmail');
  @override
  late final GeneratedColumn<String> userEmail = GeneratedColumn<String>(
      'user_email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resourceTypeMeta =
      const VerificationMeta('resourceType');
  @override
  late final GeneratedColumn<String> resourceType = GeneratedColumn<String>(
      'resource_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resourceIdMeta =
      const VerificationMeta('resourceId');
  @override
  late final GeneratedColumn<String> resourceId = GeneratedColumn<String>(
      'resource_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userAgentMeta =
      const VerificationMeta('userAgent');
  @override
  late final GeneratedColumn<String> userAgent = GeneratedColumn<String>(
      'user_agent', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _successMeta =
      const VerificationMeta('success');
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
      'success', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("success" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        userEmail,
        action,
        resourceType,
        resourceId,
        details,
        ipAddress,
        userAgent,
        sessionId,
        success,
        errorMessage,
        createdAt,
        archived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_email')) {
      context.handle(_userEmailMeta,
          userEmail.isAcceptableOrUnknown(data['user_email']!, _userEmailMeta));
    } else if (isInserting) {
      context.missing(_userEmailMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('resource_type')) {
      context.handle(
          _resourceTypeMeta,
          resourceType.isAcceptableOrUnknown(
              data['resource_type']!, _resourceTypeMeta));
    } else if (isInserting) {
      context.missing(_resourceTypeMeta);
    }
    if (data.containsKey('resource_id')) {
      context.handle(
          _resourceIdMeta,
          resourceId.isAcceptableOrUnknown(
              data['resource_id']!, _resourceIdMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('user_agent')) {
      context.handle(_userAgentMeta,
          userAgent.isAcceptableOrUnknown(data['user_agent']!, _userAgentMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('success')) {
      context.handle(_successMeta,
          success.isAcceptableOrUnknown(data['success']!, _successMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      userEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_email'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      resourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_type'])!,
      resourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_id']),
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      userAgent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_agent']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      success: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}success'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final String userId;
  final String userEmail;
  final String action;
  final String resourceType;
  final String? resourceId;
  final String? details;
  final String? ipAddress;
  final String? userAgent;
  final String? sessionId;
  final bool success;
  final String? errorMessage;
  final DateTime createdAt;
  final bool archived;
  const AuditLog(
      {required this.id,
      required this.userId,
      required this.userEmail,
      required this.action,
      required this.resourceType,
      this.resourceId,
      this.details,
      this.ipAddress,
      this.userAgent,
      this.sessionId,
      required this.success,
      this.errorMessage,
      required this.createdAt,
      required this.archived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['user_email'] = Variable<String>(userEmail);
    map['action'] = Variable<String>(action);
    map['resource_type'] = Variable<String>(resourceType);
    if (!nullToAbsent || resourceId != null) {
      map['resource_id'] = Variable<String>(resourceId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    if (!nullToAbsent || userAgent != null) {
      map['user_agent'] = Variable<String>(userAgent);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      userEmail: Value(userEmail),
      action: Value(action),
      resourceType: Value(resourceType),
      resourceId: resourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(resourceId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      userAgent: userAgent == null && nullToAbsent
          ? const Value.absent()
          : Value(userAgent),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      success: Value(success),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      archived: Value(archived),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      userEmail: serializer.fromJson<String>(json['userEmail']),
      action: serializer.fromJson<String>(json['action']),
      resourceType: serializer.fromJson<String>(json['resourceType']),
      resourceId: serializer.fromJson<String?>(json['resourceId']),
      details: serializer.fromJson<String?>(json['details']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      userAgent: serializer.fromJson<String?>(json['userAgent']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      success: serializer.fromJson<bool>(json['success']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'userEmail': serializer.toJson<String>(userEmail),
      'action': serializer.toJson<String>(action),
      'resourceType': serializer.toJson<String>(resourceType),
      'resourceId': serializer.toJson<String?>(resourceId),
      'details': serializer.toJson<String?>(details),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'userAgent': serializer.toJson<String?>(userAgent),
      'sessionId': serializer.toJson<String?>(sessionId),
      'success': serializer.toJson<bool>(success),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  AuditLog copyWith(
          {int? id,
          String? userId,
          String? userEmail,
          String? action,
          String? resourceType,
          Value<String?> resourceId = const Value.absent(),
          Value<String?> details = const Value.absent(),
          Value<String?> ipAddress = const Value.absent(),
          Value<String?> userAgent = const Value.absent(),
          Value<String?> sessionId = const Value.absent(),
          bool? success,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt,
          bool? archived}) =>
      AuditLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userEmail: userEmail ?? this.userEmail,
        action: action ?? this.action,
        resourceType: resourceType ?? this.resourceType,
        resourceId: resourceId.present ? resourceId.value : this.resourceId,
        details: details.present ? details.value : this.details,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        userAgent: userAgent.present ? userAgent.value : this.userAgent,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        success: success ?? this.success,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
        archived: archived ?? this.archived,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      userEmail: data.userEmail.present ? data.userEmail.value : this.userEmail,
      action: data.action.present ? data.action.value : this.action,
      resourceType: data.resourceType.present
          ? data.resourceType.value
          : this.resourceType,
      resourceId:
          data.resourceId.present ? data.resourceId.value : this.resourceId,
      details: data.details.present ? data.details.value : this.details,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      userAgent: data.userAgent.present ? data.userAgent.value : this.userAgent,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      success: data.success.present ? data.success.value : this.success,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('userEmail: $userEmail, ')
          ..write('action: $action, ')
          ..write('resourceType: $resourceType, ')
          ..write('resourceId: $resourceId, ')
          ..write('details: $details, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('userAgent: $userAgent, ')
          ..write('sessionId: $sessionId, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      userEmail,
      action,
      resourceType,
      resourceId,
      details,
      ipAddress,
      userAgent,
      sessionId,
      success,
      errorMessage,
      createdAt,
      archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.userEmail == this.userEmail &&
          other.action == this.action &&
          other.resourceType == this.resourceType &&
          other.resourceId == this.resourceId &&
          other.details == this.details &&
          other.ipAddress == this.ipAddress &&
          other.userAgent == this.userAgent &&
          other.sessionId == this.sessionId &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.archived == this.archived);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> userEmail;
  final Value<String> action;
  final Value<String> resourceType;
  final Value<String?> resourceId;
  final Value<String?> details;
  final Value<String?> ipAddress;
  final Value<String?> userAgent;
  final Value<String?> sessionId;
  final Value<bool> success;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<bool> archived;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.userEmail = const Value.absent(),
    this.action = const Value.absent(),
    this.resourceType = const Value.absent(),
    this.resourceId = const Value.absent(),
    this.details = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archived = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String userEmail,
    required String action,
    required String resourceType,
    this.resourceId = const Value.absent(),
    this.details = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    this.archived = const Value.absent(),
  })  : userId = Value(userId),
        userEmail = Value(userEmail),
        action = Value(action),
        resourceType = Value(resourceType),
        createdAt = Value(createdAt);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? userEmail,
    Expression<String>? action,
    Expression<String>? resourceType,
    Expression<String>? resourceId,
    Expression<String>? details,
    Expression<String>? ipAddress,
    Expression<String>? userAgent,
    Expression<String>? sessionId,
    Expression<bool>? success,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (userEmail != null) 'user_email': userEmail,
      if (action != null) 'action': action,
      if (resourceType != null) 'resource_type': resourceType,
      if (resourceId != null) 'resource_id': resourceId,
      if (details != null) 'details': details,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
      if (sessionId != null) 'session_id': sessionId,
      if (success != null) 'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (archived != null) 'archived': archived,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? userEmail,
      Value<String>? action,
      Value<String>? resourceType,
      Value<String?>? resourceId,
      Value<String?>? details,
      Value<String?>? ipAddress,
      Value<String?>? userAgent,
      Value<String?>? sessionId,
      Value<bool>? success,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<bool>? archived}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      action: action ?? this.action,
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      sessionId: sessionId ?? this.sessionId,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (userEmail.present) {
      map['user_email'] = Variable<String>(userEmail.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (resourceType.present) {
      map['resource_type'] = Variable<String>(resourceType.value);
    }
    if (resourceId.present) {
      map['resource_id'] = Variable<String>(resourceId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (userAgent.present) {
      map['user_agent'] = Variable<String>(userAgent.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('userEmail: $userEmail, ')
          ..write('action: $action, ')
          ..write('resourceType: $resourceType, ')
          ..write('resourceId: $resourceId, ')
          ..write('details: $details, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('userAgent: $userAgent, ')
          ..write('sessionId: $sessionId, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceNameMeta =
      const VerificationMeta('deviceName');
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
      'device_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceTypeMeta =
      const VerificationMeta('deviceType');
  @override
  late final GeneratedColumn<String> deviceType = GeneratedColumn<String>(
      'device_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<DateTime> lastActivityAt =
      GeneratedColumn<DateTime>('last_activity_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        deviceId,
        deviceName,
        deviceType,
        ipAddress,
        createdAt,
        lastActivityAt,
        expiresAt,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
          _deviceNameMeta,
          deviceName.isAcceptableOrUnknown(
              data['device_name']!, _deviceNameMeta));
    }
    if (data.containsKey('device_type')) {
      context.handle(
          _deviceTypeMeta,
          deviceType.isAcceptableOrUnknown(
              data['device_type']!, _deviceTypeMeta));
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
    } else if (isInserting) {
      context.missing(_lastActivityAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      deviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_name']),
      deviceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_type']),
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastActivityAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_activity_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String userId;
  final String deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? ipAddress;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final DateTime expiresAt;
  final bool isActive;
  const Session(
      {required this.id,
      required this.userId,
      required this.deviceId,
      this.deviceName,
      this.deviceType,
      this.ipAddress,
      required this.createdAt,
      required this.lastActivityAt,
      required this.expiresAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || deviceName != null) {
      map['device_name'] = Variable<String>(deviceName);
    }
    if (!nullToAbsent || deviceType != null) {
      map['device_type'] = Variable<String>(deviceType);
    }
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_activity_at'] = Variable<DateTime>(lastActivityAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      deviceId: Value(deviceId),
      deviceName: deviceName == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceName),
      deviceType: deviceType == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceType),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      createdAt: Value(createdAt),
      lastActivityAt: Value(lastActivityAt),
      expiresAt: Value(expiresAt),
      isActive: Value(isActive),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceName: serializer.fromJson<String?>(json['deviceName']),
      deviceType: serializer.fromJson<String?>(json['deviceType']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastActivityAt: serializer.fromJson<DateTime>(json['lastActivityAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceName': serializer.toJson<String?>(deviceName),
      'deviceType': serializer.toJson<String?>(deviceType),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastActivityAt': serializer.toJson<DateTime>(lastActivityAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Session copyWith(
          {String? id,
          String? userId,
          String? deviceId,
          Value<String?> deviceName = const Value.absent(),
          Value<String?> deviceType = const Value.absent(),
          Value<String?> ipAddress = const Value.absent(),
          DateTime? createdAt,
          DateTime? lastActivityAt,
          DateTime? expiresAt,
          bool? isActive}) =>
      Session(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName.present ? deviceName.value : this.deviceName,
        deviceType: deviceType.present ? deviceType.value : this.deviceType,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        createdAt: createdAt ?? this.createdAt,
        lastActivityAt: lastActivityAt ?? this.lastActivityAt,
        expiresAt: expiresAt ?? this.expiresAt,
        isActive: isActive ?? this.isActive,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceName:
          data.deviceName.present ? data.deviceName.value : this.deviceName,
      deviceType:
          data.deviceType.present ? data.deviceType.value : this.deviceType,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceType: $deviceType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, deviceId, deviceName, deviceType,
      ipAddress, createdAt, lastActivityAt, expiresAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.deviceName == this.deviceName &&
          other.deviceType == this.deviceType &&
          other.ipAddress == this.ipAddress &&
          other.createdAt == this.createdAt &&
          other.lastActivityAt == this.lastActivityAt &&
          other.expiresAt == this.expiresAt &&
          other.isActive == this.isActive);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> deviceId;
  final Value<String?> deviceName;
  final Value<String?> deviceType;
  final Value<String?> ipAddress;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastActivityAt;
  final Value<DateTime> expiresAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.deviceType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String userId,
    required String deviceId,
    this.deviceName = const Value.absent(),
    this.deviceType = const Value.absent(),
    this.ipAddress = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        deviceId = Value(deviceId),
        createdAt = Value(createdAt),
        lastActivityAt = Value(lastActivityAt),
        expiresAt = Value(expiresAt);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? deviceName,
    Expression<String>? deviceType,
    Expression<String>? ipAddress,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastActivityAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (deviceType != null) 'device_type': deviceType,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (createdAt != null) 'created_at': createdAt,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? deviceId,
      Value<String?>? deviceName,
      Value<String?>? deviceType,
      Value<String?>? ipAddress,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastActivityAt,
      Value<DateTime>? expiresAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      ipAddress: ipAddress ?? this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (deviceType.present) {
      map['device_type'] = Variable<String>(deviceType.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceType: $deviceType, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HeadphoneProfilesTable extends HeadphoneProfiles
    with TableInfo<$HeadphoneProfilesTable, HeadphoneProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeadphoneProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retsplValuesMeta =
      const VerificationMeta('retsplValues');
  @override
  late final GeneratedColumn<String> retsplValues = GeneratedColumn<String>(
      'retspl_values', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctionsMeta =
      const VerificationMeta('corrections');
  @override
  late final GeneratedColumn<String> corrections = GeneratedColumn<String>(
      'corrections', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isValidatedMeta =
      const VerificationMeta('isValidated');
  @override
  late final GeneratedColumn<bool> isValidated = GeneratedColumn<bool>(
      'is_validated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_validated" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _validationDateMeta =
      const VerificationMeta('validationDate');
  @override
  late final GeneratedColumn<DateTime> validationDate =
      GeneratedColumn<DateTime>('validation_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _validationAccuracyMeta =
      const VerificationMeta('validationAccuracy');
  @override
  late final GeneratedColumn<double> validationAccuracy =
      GeneratedColumn<double>('validation_accuracy', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _participantCountMeta =
      const VerificationMeta('participantCount');
  @override
  late final GeneratedColumn<int> participantCount = GeneratedColumn<int>(
      'participant_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _approvedUsageMeta =
      const VerificationMeta('approvedUsage');
  @override
  late final GeneratedColumn<String> approvedUsage = GeneratedColumn<String>(
      'approved_usage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        brand,
        model,
        type,
        retsplValues,
        corrections,
        isValidated,
        validationDate,
        validationAccuracy,
        participantCount,
        approvedUsage,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'headphone_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<HeadphoneProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('retspl_values')) {
      context.handle(
          _retsplValuesMeta,
          retsplValues.isAcceptableOrUnknown(
              data['retspl_values']!, _retsplValuesMeta));
    } else if (isInserting) {
      context.missing(_retsplValuesMeta);
    }
    if (data.containsKey('corrections')) {
      context.handle(
          _correctionsMeta,
          corrections.isAcceptableOrUnknown(
              data['corrections']!, _correctionsMeta));
    }
    if (data.containsKey('is_validated')) {
      context.handle(
          _isValidatedMeta,
          isValidated.isAcceptableOrUnknown(
              data['is_validated']!, _isValidatedMeta));
    }
    if (data.containsKey('validation_date')) {
      context.handle(
          _validationDateMeta,
          validationDate.isAcceptableOrUnknown(
              data['validation_date']!, _validationDateMeta));
    }
    if (data.containsKey('validation_accuracy')) {
      context.handle(
          _validationAccuracyMeta,
          validationAccuracy.isAcceptableOrUnknown(
              data['validation_accuracy']!, _validationAccuracyMeta));
    }
    if (data.containsKey('participant_count')) {
      context.handle(
          _participantCountMeta,
          participantCount.isAcceptableOrUnknown(
              data['participant_count']!, _participantCountMeta));
    }
    if (data.containsKey('approved_usage')) {
      context.handle(
          _approvedUsageMeta,
          approvedUsage.isAcceptableOrUnknown(
              data['approved_usage']!, _approvedUsageMeta));
    } else if (isInserting) {
      context.missing(_approvedUsageMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeadphoneProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeadphoneProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      retsplValues: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}retspl_values'])!,
      corrections: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}corrections']),
      isValidated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_validated'])!,
      validationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}validation_date']),
      validationAccuracy: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}validation_accuracy']),
      participantCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}participant_count']),
      approvedUsage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approved_usage'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $HeadphoneProfilesTable createAlias(String alias) {
    return $HeadphoneProfilesTable(attachedDatabase, alias);
  }
}

class HeadphoneProfile extends DataClass
    implements Insertable<HeadphoneProfile> {
  final String id;
  final String brand;
  final String model;
  final String type;
  final String retsplValues;
  final String? corrections;
  final bool isValidated;
  final DateTime? validationDate;
  final double? validationAccuracy;
  final int? participantCount;
  final String approvedUsage;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const HeadphoneProfile(
      {required this.id,
      required this.brand,
      required this.model,
      required this.type,
      required this.retsplValues,
      this.corrections,
      required this.isValidated,
      this.validationDate,
      this.validationAccuracy,
      this.participantCount,
      required this.approvedUsage,
      this.notes,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['type'] = Variable<String>(type);
    map['retspl_values'] = Variable<String>(retsplValues);
    if (!nullToAbsent || corrections != null) {
      map['corrections'] = Variable<String>(corrections);
    }
    map['is_validated'] = Variable<bool>(isValidated);
    if (!nullToAbsent || validationDate != null) {
      map['validation_date'] = Variable<DateTime>(validationDate);
    }
    if (!nullToAbsent || validationAccuracy != null) {
      map['validation_accuracy'] = Variable<double>(validationAccuracy);
    }
    if (!nullToAbsent || participantCount != null) {
      map['participant_count'] = Variable<int>(participantCount);
    }
    map['approved_usage'] = Variable<String>(approvedUsage);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  HeadphoneProfilesCompanion toCompanion(bool nullToAbsent) {
    return HeadphoneProfilesCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      type: Value(type),
      retsplValues: Value(retsplValues),
      corrections: corrections == null && nullToAbsent
          ? const Value.absent()
          : Value(corrections),
      isValidated: Value(isValidated),
      validationDate: validationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(validationDate),
      validationAccuracy: validationAccuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(validationAccuracy),
      participantCount: participantCount == null && nullToAbsent
          ? const Value.absent()
          : Value(participantCount),
      approvedUsage: Value(approvedUsage),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory HeadphoneProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeadphoneProfile(
      id: serializer.fromJson<String>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      type: serializer.fromJson<String>(json['type']),
      retsplValues: serializer.fromJson<String>(json['retsplValues']),
      corrections: serializer.fromJson<String?>(json['corrections']),
      isValidated: serializer.fromJson<bool>(json['isValidated']),
      validationDate: serializer.fromJson<DateTime?>(json['validationDate']),
      validationAccuracy:
          serializer.fromJson<double?>(json['validationAccuracy']),
      participantCount: serializer.fromJson<int?>(json['participantCount']),
      approvedUsage: serializer.fromJson<String>(json['approvedUsage']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'type': serializer.toJson<String>(type),
      'retsplValues': serializer.toJson<String>(retsplValues),
      'corrections': serializer.toJson<String?>(corrections),
      'isValidated': serializer.toJson<bool>(isValidated),
      'validationDate': serializer.toJson<DateTime?>(validationDate),
      'validationAccuracy': serializer.toJson<double?>(validationAccuracy),
      'participantCount': serializer.toJson<int?>(participantCount),
      'approvedUsage': serializer.toJson<String>(approvedUsage),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  HeadphoneProfile copyWith(
          {String? id,
          String? brand,
          String? model,
          String? type,
          String? retsplValues,
          Value<String?> corrections = const Value.absent(),
          bool? isValidated,
          Value<DateTime?> validationDate = const Value.absent(),
          Value<double?> validationAccuracy = const Value.absent(),
          Value<int?> participantCount = const Value.absent(),
          String? approvedUsage,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      HeadphoneProfile(
        id: id ?? this.id,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        type: type ?? this.type,
        retsplValues: retsplValues ?? this.retsplValues,
        corrections: corrections.present ? corrections.value : this.corrections,
        isValidated: isValidated ?? this.isValidated,
        validationDate:
            validationDate.present ? validationDate.value : this.validationDate,
        validationAccuracy: validationAccuracy.present
            ? validationAccuracy.value
            : this.validationAccuracy,
        participantCount: participantCount.present
            ? participantCount.value
            : this.participantCount,
        approvedUsage: approvedUsage ?? this.approvedUsage,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  HeadphoneProfile copyWithCompanion(HeadphoneProfilesCompanion data) {
    return HeadphoneProfile(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      type: data.type.present ? data.type.value : this.type,
      retsplValues: data.retsplValues.present
          ? data.retsplValues.value
          : this.retsplValues,
      corrections:
          data.corrections.present ? data.corrections.value : this.corrections,
      isValidated:
          data.isValidated.present ? data.isValidated.value : this.isValidated,
      validationDate: data.validationDate.present
          ? data.validationDate.value
          : this.validationDate,
      validationAccuracy: data.validationAccuracy.present
          ? data.validationAccuracy.value
          : this.validationAccuracy,
      participantCount: data.participantCount.present
          ? data.participantCount.value
          : this.participantCount,
      approvedUsage: data.approvedUsage.present
          ? data.approvedUsage.value
          : this.approvedUsage,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeadphoneProfile(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('type: $type, ')
          ..write('retsplValues: $retsplValues, ')
          ..write('corrections: $corrections, ')
          ..write('isValidated: $isValidated, ')
          ..write('validationDate: $validationDate, ')
          ..write('validationAccuracy: $validationAccuracy, ')
          ..write('participantCount: $participantCount, ')
          ..write('approvedUsage: $approvedUsage, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      brand,
      model,
      type,
      retsplValues,
      corrections,
      isValidated,
      validationDate,
      validationAccuracy,
      participantCount,
      approvedUsage,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeadphoneProfile &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.type == this.type &&
          other.retsplValues == this.retsplValues &&
          other.corrections == this.corrections &&
          other.isValidated == this.isValidated &&
          other.validationDate == this.validationDate &&
          other.validationAccuracy == this.validationAccuracy &&
          other.participantCount == this.participantCount &&
          other.approvedUsage == this.approvedUsage &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HeadphoneProfilesCompanion extends UpdateCompanion<HeadphoneProfile> {
  final Value<String> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<String> type;
  final Value<String> retsplValues;
  final Value<String?> corrections;
  final Value<bool> isValidated;
  final Value<DateTime?> validationDate;
  final Value<double?> validationAccuracy;
  final Value<int?> participantCount;
  final Value<String> approvedUsage;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const HeadphoneProfilesCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.type = const Value.absent(),
    this.retsplValues = const Value.absent(),
    this.corrections = const Value.absent(),
    this.isValidated = const Value.absent(),
    this.validationDate = const Value.absent(),
    this.validationAccuracy = const Value.absent(),
    this.participantCount = const Value.absent(),
    this.approvedUsage = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HeadphoneProfilesCompanion.insert({
    required String id,
    required String brand,
    required String model,
    required String type,
    required String retsplValues,
    this.corrections = const Value.absent(),
    this.isValidated = const Value.absent(),
    this.validationDate = const Value.absent(),
    this.validationAccuracy = const Value.absent(),
    this.participantCount = const Value.absent(),
    required String approvedUsage,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        brand = Value(brand),
        model = Value(model),
        type = Value(type),
        retsplValues = Value(retsplValues),
        approvedUsage = Value(approvedUsage),
        createdAt = Value(createdAt);
  static Insertable<HeadphoneProfile> custom({
    Expression<String>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<String>? type,
    Expression<String>? retsplValues,
    Expression<String>? corrections,
    Expression<bool>? isValidated,
    Expression<DateTime>? validationDate,
    Expression<double>? validationAccuracy,
    Expression<int>? participantCount,
    Expression<String>? approvedUsage,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (type != null) 'type': type,
      if (retsplValues != null) 'retspl_values': retsplValues,
      if (corrections != null) 'corrections': corrections,
      if (isValidated != null) 'is_validated': isValidated,
      if (validationDate != null) 'validation_date': validationDate,
      if (validationAccuracy != null) 'validation_accuracy': validationAccuracy,
      if (participantCount != null) 'participant_count': participantCount,
      if (approvedUsage != null) 'approved_usage': approvedUsage,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HeadphoneProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? brand,
      Value<String>? model,
      Value<String>? type,
      Value<String>? retsplValues,
      Value<String?>? corrections,
      Value<bool>? isValidated,
      Value<DateTime?>? validationDate,
      Value<double?>? validationAccuracy,
      Value<int?>? participantCount,
      Value<String>? approvedUsage,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return HeadphoneProfilesCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      retsplValues: retsplValues ?? this.retsplValues,
      corrections: corrections ?? this.corrections,
      isValidated: isValidated ?? this.isValidated,
      validationDate: validationDate ?? this.validationDate,
      validationAccuracy: validationAccuracy ?? this.validationAccuracy,
      participantCount: participantCount ?? this.participantCount,
      approvedUsage: approvedUsage ?? this.approvedUsage,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (retsplValues.present) {
      map['retspl_values'] = Variable<String>(retsplValues.value);
    }
    if (corrections.present) {
      map['corrections'] = Variable<String>(corrections.value);
    }
    if (isValidated.present) {
      map['is_validated'] = Variable<bool>(isValidated.value);
    }
    if (validationDate.present) {
      map['validation_date'] = Variable<DateTime>(validationDate.value);
    }
    if (validationAccuracy.present) {
      map['validation_accuracy'] = Variable<double>(validationAccuracy.value);
    }
    if (participantCount.present) {
      map['participant_count'] = Variable<int>(participantCount.value);
    }
    if (approvedUsage.present) {
      map['approved_usage'] = Variable<String>(approvedUsage.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeadphoneProfilesCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('type: $type, ')
          ..write('retsplValues: $retsplValues, ')
          ..write('corrections: $corrections, ')
          ..write('isValidated: $isValidated, ')
          ..write('validationDate: $validationDate, ')
          ..write('validationAccuracy: $validationAccuracy, ')
          ..write('participantCount: $participantCount, ')
          ..write('approvedUsage: $approvedUsage, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalibrationSettingsTable extends CalibrationSettings
    with TableInfo<$CalibrationSettingsTable, CalibrationSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
      'frequency', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctionMeta =
      const VerificationMeta('correction');
  @override
  late final GeneratedColumn<double> correction = GeneratedColumn<double>(
      'correction', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _calibratedAtMeta =
      const VerificationMeta('calibratedAt');
  @override
  late final GeneratedColumn<DateTime> calibratedAt = GeneratedColumn<DateTime>(
      'calibrated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _calibratedByMeta =
      const VerificationMeta('calibratedBy');
  @override
  late final GeneratedColumn<String> calibratedBy = GeneratedColumn<String>(
      'calibrated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _headphoneProfileIdMeta =
      const VerificationMeta('headphoneProfileId');
  @override
  late final GeneratedColumn<String> headphoneProfileId =
      GeneratedColumn<String>('headphone_profile_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        frequency,
        correction,
        calibratedAt,
        calibratedBy,
        headphoneProfileId,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibration_settings';
  @override
  VerificationContext validateIntegrity(Insertable<CalibrationSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('correction')) {
      context.handle(
          _correctionMeta,
          correction.isAcceptableOrUnknown(
              data['correction']!, _correctionMeta));
    } else if (isInserting) {
      context.missing(_correctionMeta);
    }
    if (data.containsKey('calibrated_at')) {
      context.handle(
          _calibratedAtMeta,
          calibratedAt.isAcceptableOrUnknown(
              data['calibrated_at']!, _calibratedAtMeta));
    } else if (isInserting) {
      context.missing(_calibratedAtMeta);
    }
    if (data.containsKey('calibrated_by')) {
      context.handle(
          _calibratedByMeta,
          calibratedBy.isAcceptableOrUnknown(
              data['calibrated_by']!, _calibratedByMeta));
    } else if (isInserting) {
      context.missing(_calibratedByMeta);
    }
    if (data.containsKey('headphone_profile_id')) {
      context.handle(
          _headphoneProfileIdMeta,
          headphoneProfileId.isAcceptableOrUnknown(
              data['headphone_profile_id']!, _headphoneProfileIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, frequency};
  @override
  CalibrationSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!,
      correction: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}correction'])!,
      calibratedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}calibrated_at'])!,
      calibratedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}calibrated_by'])!,
      headphoneProfileId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}headphone_profile_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $CalibrationSettingsTable createAlias(String alias) {
    return $CalibrationSettingsTable(attachedDatabase, alias);
  }
}

class CalibrationSetting extends DataClass
    implements Insertable<CalibrationSetting> {
  final String id;
  final int frequency;
  final double correction;
  final DateTime calibratedAt;
  final String calibratedBy;
  final String? headphoneProfileId;
  final String? notes;
  const CalibrationSetting(
      {required this.id,
      required this.frequency,
      required this.correction,
      required this.calibratedAt,
      required this.calibratedBy,
      this.headphoneProfileId,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['frequency'] = Variable<int>(frequency);
    map['correction'] = Variable<double>(correction);
    map['calibrated_at'] = Variable<DateTime>(calibratedAt);
    map['calibrated_by'] = Variable<String>(calibratedBy);
    if (!nullToAbsent || headphoneProfileId != null) {
      map['headphone_profile_id'] = Variable<String>(headphoneProfileId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CalibrationSettingsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationSettingsCompanion(
      id: Value(id),
      frequency: Value(frequency),
      correction: Value(correction),
      calibratedAt: Value(calibratedAt),
      calibratedBy: Value(calibratedBy),
      headphoneProfileId: headphoneProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(headphoneProfileId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory CalibrationSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationSetting(
      id: serializer.fromJson<String>(json['id']),
      frequency: serializer.fromJson<int>(json['frequency']),
      correction: serializer.fromJson<double>(json['correction']),
      calibratedAt: serializer.fromJson<DateTime>(json['calibratedAt']),
      calibratedBy: serializer.fromJson<String>(json['calibratedBy']),
      headphoneProfileId:
          serializer.fromJson<String?>(json['headphoneProfileId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'frequency': serializer.toJson<int>(frequency),
      'correction': serializer.toJson<double>(correction),
      'calibratedAt': serializer.toJson<DateTime>(calibratedAt),
      'calibratedBy': serializer.toJson<String>(calibratedBy),
      'headphoneProfileId': serializer.toJson<String?>(headphoneProfileId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CalibrationSetting copyWith(
          {String? id,
          int? frequency,
          double? correction,
          DateTime? calibratedAt,
          String? calibratedBy,
          Value<String?> headphoneProfileId = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      CalibrationSetting(
        id: id ?? this.id,
        frequency: frequency ?? this.frequency,
        correction: correction ?? this.correction,
        calibratedAt: calibratedAt ?? this.calibratedAt,
        calibratedBy: calibratedBy ?? this.calibratedBy,
        headphoneProfileId: headphoneProfileId.present
            ? headphoneProfileId.value
            : this.headphoneProfileId,
        notes: notes.present ? notes.value : this.notes,
      );
  CalibrationSetting copyWithCompanion(CalibrationSettingsCompanion data) {
    return CalibrationSetting(
      id: data.id.present ? data.id.value : this.id,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      correction:
          data.correction.present ? data.correction.value : this.correction,
      calibratedAt: data.calibratedAt.present
          ? data.calibratedAt.value
          : this.calibratedAt,
      calibratedBy: data.calibratedBy.present
          ? data.calibratedBy.value
          : this.calibratedBy,
      headphoneProfileId: data.headphoneProfileId.present
          ? data.headphoneProfileId.value
          : this.headphoneProfileId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationSetting(')
          ..write('id: $id, ')
          ..write('frequency: $frequency, ')
          ..write('correction: $correction, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('calibratedBy: $calibratedBy, ')
          ..write('headphoneProfileId: $headphoneProfileId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, frequency, correction, calibratedAt,
      calibratedBy, headphoneProfileId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationSetting &&
          other.id == this.id &&
          other.frequency == this.frequency &&
          other.correction == this.correction &&
          other.calibratedAt == this.calibratedAt &&
          other.calibratedBy == this.calibratedBy &&
          other.headphoneProfileId == this.headphoneProfileId &&
          other.notes == this.notes);
}

class CalibrationSettingsCompanion extends UpdateCompanion<CalibrationSetting> {
  final Value<String> id;
  final Value<int> frequency;
  final Value<double> correction;
  final Value<DateTime> calibratedAt;
  final Value<String> calibratedBy;
  final Value<String?> headphoneProfileId;
  final Value<String?> notes;
  final Value<int> rowid;
  const CalibrationSettingsCompanion({
    this.id = const Value.absent(),
    this.frequency = const Value.absent(),
    this.correction = const Value.absent(),
    this.calibratedAt = const Value.absent(),
    this.calibratedBy = const Value.absent(),
    this.headphoneProfileId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalibrationSettingsCompanion.insert({
    required String id,
    required int frequency,
    required double correction,
    required DateTime calibratedAt,
    required String calibratedBy,
    this.headphoneProfileId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        frequency = Value(frequency),
        correction = Value(correction),
        calibratedAt = Value(calibratedAt),
        calibratedBy = Value(calibratedBy);
  static Insertable<CalibrationSetting> custom({
    Expression<String>? id,
    Expression<int>? frequency,
    Expression<double>? correction,
    Expression<DateTime>? calibratedAt,
    Expression<String>? calibratedBy,
    Expression<String>? headphoneProfileId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frequency != null) 'frequency': frequency,
      if (correction != null) 'correction': correction,
      if (calibratedAt != null) 'calibrated_at': calibratedAt,
      if (calibratedBy != null) 'calibrated_by': calibratedBy,
      if (headphoneProfileId != null)
        'headphone_profile_id': headphoneProfileId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalibrationSettingsCompanion copyWith(
      {Value<String>? id,
      Value<int>? frequency,
      Value<double>? correction,
      Value<DateTime>? calibratedAt,
      Value<String>? calibratedBy,
      Value<String?>? headphoneProfileId,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return CalibrationSettingsCompanion(
      id: id ?? this.id,
      frequency: frequency ?? this.frequency,
      correction: correction ?? this.correction,
      calibratedAt: calibratedAt ?? this.calibratedAt,
      calibratedBy: calibratedBy ?? this.calibratedBy,
      headphoneProfileId: headphoneProfileId ?? this.headphoneProfileId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (correction.present) {
      map['correction'] = Variable<double>(correction.value);
    }
    if (calibratedAt.present) {
      map['calibrated_at'] = Variable<DateTime>(calibratedAt.value);
    }
    if (calibratedBy.present) {
      map['calibrated_by'] = Variable<String>(calibratedBy.value);
    }
    if (headphoneProfileId.present) {
      map['headphone_profile_id'] = Variable<String>(headphoneProfileId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationSettingsCompanion(')
          ..write('id: $id, ')
          ..write('frequency: $frequency, ')
          ..write('correction: $correction, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('calibratedBy: $calibratedBy, ')
          ..write('headphoneProfileId: $headphoneProfileId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BcImportsTable extends BcImports
    with TableInfo<$BcImportsTable, BcImport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BcImportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _screeningIdMeta =
      const VerificationMeta('screeningId');
  @override
  late final GeneratedColumn<String> screeningId = GeneratedColumn<String>(
      'screening_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _importedByMeta =
      const VerificationMeta('importedBy');
  @override
  late final GeneratedColumn<String> importedBy = GeneratedColumn<String>(
      'imported_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _importedAtMeta =
      const VerificationMeta('importedAt');
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
      'imported_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        screeningId,
        fileName,
        filePath,
        fileType,
        importedBy,
        importedAt,
        status,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bc_imports';
  @override
  VerificationContext validateIntegrity(Insertable<BcImport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('screening_id')) {
      context.handle(
          _screeningIdMeta,
          screeningId.isAcceptableOrUnknown(
              data['screening_id']!, _screeningIdMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('imported_by')) {
      context.handle(
          _importedByMeta,
          importedBy.isAcceptableOrUnknown(
              data['imported_by']!, _importedByMeta));
    } else if (isInserting) {
      context.missing(_importedByMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
          _importedAtMeta,
          importedAt.isAcceptableOrUnknown(
              data['imported_at']!, _importedAtMeta));
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BcImport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BcImport(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      screeningId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}screening_id']),
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      importedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imported_by'])!,
      importedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}imported_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $BcImportsTable createAlias(String alias) {
    return $BcImportsTable(attachedDatabase, alias);
  }
}

class BcImport extends DataClass implements Insertable<BcImport> {
  final String id;
  final String patientId;
  final String? screeningId;
  final String fileName;
  final String filePath;
  final String fileType;
  final String importedBy;
  final DateTime importedAt;
  final String status;
  final String? notes;
  const BcImport(
      {required this.id,
      required this.patientId,
      this.screeningId,
      required this.fileName,
      required this.filePath,
      required this.fileType,
      required this.importedBy,
      required this.importedAt,
      required this.status,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || screeningId != null) {
      map['screening_id'] = Variable<String>(screeningId);
    }
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    map['file_type'] = Variable<String>(fileType);
    map['imported_by'] = Variable<String>(importedBy);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BcImportsCompanion toCompanion(bool nullToAbsent) {
    return BcImportsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      screeningId: screeningId == null && nullToAbsent
          ? const Value.absent()
          : Value(screeningId),
      fileName: Value(fileName),
      filePath: Value(filePath),
      fileType: Value(fileType),
      importedBy: Value(importedBy),
      importedAt: Value(importedAt),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory BcImport.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BcImport(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      screeningId: serializer.fromJson<String?>(json['screeningId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      importedBy: serializer.fromJson<String>(json['importedBy']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'screeningId': serializer.toJson<String?>(screeningId),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String>(fileType),
      'importedBy': serializer.toJson<String>(importedBy),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  BcImport copyWith(
          {String? id,
          String? patientId,
          Value<String?> screeningId = const Value.absent(),
          String? fileName,
          String? filePath,
          String? fileType,
          String? importedBy,
          DateTime? importedAt,
          String? status,
          Value<String?> notes = const Value.absent()}) =>
      BcImport(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        screeningId: screeningId.present ? screeningId.value : this.screeningId,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        fileType: fileType ?? this.fileType,
        importedBy: importedBy ?? this.importedBy,
        importedAt: importedAt ?? this.importedAt,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
      );
  BcImport copyWithCompanion(BcImportsCompanion data) {
    return BcImport(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      screeningId:
          data.screeningId.present ? data.screeningId.value : this.screeningId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      importedBy:
          data.importedBy.present ? data.importedBy.value : this.importedBy,
      importedAt:
          data.importedAt.present ? data.importedAt.value : this.importedAt,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BcImport(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('screeningId: $screeningId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('importedBy: $importedBy, ')
          ..write('importedAt: $importedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, screeningId, fileName,
      filePath, fileType, importedBy, importedAt, status, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BcImport &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.screeningId == this.screeningId &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          other.importedBy == this.importedBy &&
          other.importedAt == this.importedAt &&
          other.status == this.status &&
          other.notes == this.notes);
}

class BcImportsCompanion extends UpdateCompanion<BcImport> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String?> screeningId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<String> fileType;
  final Value<String> importedBy;
  final Value<DateTime> importedAt;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> rowid;
  const BcImportsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.screeningId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.importedBy = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BcImportsCompanion.insert({
    required String id,
    required String patientId,
    this.screeningId = const Value.absent(),
    required String fileName,
    required String filePath,
    required String fileType,
    required String importedBy,
    required DateTime importedAt,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        fileName = Value(fileName),
        filePath = Value(filePath),
        fileType = Value(fileType),
        importedBy = Value(importedBy),
        importedAt = Value(importedAt);
  static Insertable<BcImport> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? screeningId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<String>? importedBy,
    Expression<DateTime>? importedAt,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (screeningId != null) 'screening_id': screeningId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (importedBy != null) 'imported_by': importedBy,
      if (importedAt != null) 'imported_at': importedAt,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BcImportsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String?>? screeningId,
      Value<String>? fileName,
      Value<String>? filePath,
      Value<String>? fileType,
      Value<String>? importedBy,
      Value<DateTime>? importedAt,
      Value<String>? status,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return BcImportsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      screeningId: screeningId ?? this.screeningId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      importedBy: importedBy ?? this.importedBy,
      importedAt: importedAt ?? this.importedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (screeningId.present) {
      map['screening_id'] = Variable<String>(screeningId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (importedBy.present) {
      map['imported_by'] = Variable<String>(importedBy.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BcImportsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('screeningId: $screeningId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('importedBy: $importedBy, ')
          ..write('importedAt: $importedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiRecommendationsTable extends AiRecommendations
    with TableInfo<$AiRecommendationsTable, AiRecommendation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRecommendationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<String> testId = GeneratedColumn<String>(
      'test_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES test_results (id)'));
  static const VerificationMeta _modelVersionMeta =
      const VerificationMeta('modelVersion');
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
      'model_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _suggestionTypeMeta =
      const VerificationMeta('suggestionType');
  @override
  late final GeneratedColumn<String> suggestionType = GeneratedColumn<String>(
      'suggestion_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _featuresJsonMeta =
      const VerificationMeta('featuresJson');
  @override
  late final GeneratedColumn<String> featuresJson = GeneratedColumn<String>(
      'features_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _acceptedMeta =
      const VerificationMeta('accepted');
  @override
  late final GeneratedColumn<bool> accepted = GeneratedColumn<bool>(
      'accepted', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("accepted" IN (0, 1))'));
  static const VerificationMeta _decisionByMeta =
      const VerificationMeta('decisionBy');
  @override
  late final GeneratedColumn<String> decisionBy = GeneratedColumn<String>(
      'decision_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _decisionAtMeta =
      const VerificationMeta('decisionAt');
  @override
  late final GeneratedColumn<DateTime> decisionAt = GeneratedColumn<DateTime>(
      'decision_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _decisionNotesMeta =
      const VerificationMeta('decisionNotes');
  @override
  late final GeneratedColumn<String> decisionNotes = GeneratedColumn<String>(
      'decision_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        testId,
        modelVersion,
        suggestionType,
        confidence,
        featuresJson,
        createdAt,
        accepted,
        decisionBy,
        decisionAt,
        decisionNotes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_recommendations';
  @override
  VerificationContext validateIntegrity(Insertable<AiRecommendation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('test_id')) {
      context.handle(_testIdMeta,
          testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta));
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('model_version')) {
      context.handle(
          _modelVersionMeta,
          modelVersion.isAcceptableOrUnknown(
              data['model_version']!, _modelVersionMeta));
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    if (data.containsKey('suggestion_type')) {
      context.handle(
          _suggestionTypeMeta,
          suggestionType.isAcceptableOrUnknown(
              data['suggestion_type']!, _suggestionTypeMeta));
    } else if (isInserting) {
      context.missing(_suggestionTypeMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('features_json')) {
      context.handle(
          _featuresJsonMeta,
          featuresJson.isAcceptableOrUnknown(
              data['features_json']!, _featuresJsonMeta));
    } else if (isInserting) {
      context.missing(_featuresJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('accepted')) {
      context.handle(_acceptedMeta,
          accepted.isAcceptableOrUnknown(data['accepted']!, _acceptedMeta));
    }
    if (data.containsKey('decision_by')) {
      context.handle(
          _decisionByMeta,
          decisionBy.isAcceptableOrUnknown(
              data['decision_by']!, _decisionByMeta));
    }
    if (data.containsKey('decision_at')) {
      context.handle(
          _decisionAtMeta,
          decisionAt.isAcceptableOrUnknown(
              data['decision_at']!, _decisionAtMeta));
    }
    if (data.containsKey('decision_notes')) {
      context.handle(
          _decisionNotesMeta,
          decisionNotes.isAcceptableOrUnknown(
              data['decision_notes']!, _decisionNotesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiRecommendation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiRecommendation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      testId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_id'])!,
      modelVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_version'])!,
      suggestionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}suggestion_type'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      featuresJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}features_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      accepted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}accepted']),
      decisionBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}decision_by']),
      decisionAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}decision_at']),
      decisionNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}decision_notes']),
    );
  }

  @override
  $AiRecommendationsTable createAlias(String alias) {
    return $AiRecommendationsTable(attachedDatabase, alias);
  }
}

class AiRecommendation extends DataClass
    implements Insertable<AiRecommendation> {
  final String id;
  final String testId;
  final String modelVersion;
  final String suggestionType;
  final double confidence;
  final String featuresJson;
  final DateTime createdAt;
  final bool? accepted;
  final String? decisionBy;
  final DateTime? decisionAt;
  final String? decisionNotes;
  const AiRecommendation(
      {required this.id,
      required this.testId,
      required this.modelVersion,
      required this.suggestionType,
      required this.confidence,
      required this.featuresJson,
      required this.createdAt,
      this.accepted,
      this.decisionBy,
      this.decisionAt,
      this.decisionNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['test_id'] = Variable<String>(testId);
    map['model_version'] = Variable<String>(modelVersion);
    map['suggestion_type'] = Variable<String>(suggestionType);
    map['confidence'] = Variable<double>(confidence);
    map['features_json'] = Variable<String>(featuresJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || accepted != null) {
      map['accepted'] = Variable<bool>(accepted);
    }
    if (!nullToAbsent || decisionBy != null) {
      map['decision_by'] = Variable<String>(decisionBy);
    }
    if (!nullToAbsent || decisionAt != null) {
      map['decision_at'] = Variable<DateTime>(decisionAt);
    }
    if (!nullToAbsent || decisionNotes != null) {
      map['decision_notes'] = Variable<String>(decisionNotes);
    }
    return map;
  }

  AiRecommendationsCompanion toCompanion(bool nullToAbsent) {
    return AiRecommendationsCompanion(
      id: Value(id),
      testId: Value(testId),
      modelVersion: Value(modelVersion),
      suggestionType: Value(suggestionType),
      confidence: Value(confidence),
      featuresJson: Value(featuresJson),
      createdAt: Value(createdAt),
      accepted: accepted == null && nullToAbsent
          ? const Value.absent()
          : Value(accepted),
      decisionBy: decisionBy == null && nullToAbsent
          ? const Value.absent()
          : Value(decisionBy),
      decisionAt: decisionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(decisionAt),
      decisionNotes: decisionNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(decisionNotes),
    );
  }

  factory AiRecommendation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiRecommendation(
      id: serializer.fromJson<String>(json['id']),
      testId: serializer.fromJson<String>(json['testId']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
      suggestionType: serializer.fromJson<String>(json['suggestionType']),
      confidence: serializer.fromJson<double>(json['confidence']),
      featuresJson: serializer.fromJson<String>(json['featuresJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      accepted: serializer.fromJson<bool?>(json['accepted']),
      decisionBy: serializer.fromJson<String?>(json['decisionBy']),
      decisionAt: serializer.fromJson<DateTime?>(json['decisionAt']),
      decisionNotes: serializer.fromJson<String?>(json['decisionNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'testId': serializer.toJson<String>(testId),
      'modelVersion': serializer.toJson<String>(modelVersion),
      'suggestionType': serializer.toJson<String>(suggestionType),
      'confidence': serializer.toJson<double>(confidence),
      'featuresJson': serializer.toJson<String>(featuresJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'accepted': serializer.toJson<bool?>(accepted),
      'decisionBy': serializer.toJson<String?>(decisionBy),
      'decisionAt': serializer.toJson<DateTime?>(decisionAt),
      'decisionNotes': serializer.toJson<String?>(decisionNotes),
    };
  }

  AiRecommendation copyWith(
          {String? id,
          String? testId,
          String? modelVersion,
          String? suggestionType,
          double? confidence,
          String? featuresJson,
          DateTime? createdAt,
          Value<bool?> accepted = const Value.absent(),
          Value<String?> decisionBy = const Value.absent(),
          Value<DateTime?> decisionAt = const Value.absent(),
          Value<String?> decisionNotes = const Value.absent()}) =>
      AiRecommendation(
        id: id ?? this.id,
        testId: testId ?? this.testId,
        modelVersion: modelVersion ?? this.modelVersion,
        suggestionType: suggestionType ?? this.suggestionType,
        confidence: confidence ?? this.confidence,
        featuresJson: featuresJson ?? this.featuresJson,
        createdAt: createdAt ?? this.createdAt,
        accepted: accepted.present ? accepted.value : this.accepted,
        decisionBy: decisionBy.present ? decisionBy.value : this.decisionBy,
        decisionAt: decisionAt.present ? decisionAt.value : this.decisionAt,
        decisionNotes:
            decisionNotes.present ? decisionNotes.value : this.decisionNotes,
      );
  AiRecommendation copyWithCompanion(AiRecommendationsCompanion data) {
    return AiRecommendation(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
      suggestionType: data.suggestionType.present
          ? data.suggestionType.value
          : this.suggestionType,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      featuresJson: data.featuresJson.present
          ? data.featuresJson.value
          : this.featuresJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      accepted: data.accepted.present ? data.accepted.value : this.accepted,
      decisionBy:
          data.decisionBy.present ? data.decisionBy.value : this.decisionBy,
      decisionAt:
          data.decisionAt.present ? data.decisionAt.value : this.decisionAt,
      decisionNotes: data.decisionNotes.present
          ? data.decisionNotes.value
          : this.decisionNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiRecommendation(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('suggestionType: $suggestionType, ')
          ..write('confidence: $confidence, ')
          ..write('featuresJson: $featuresJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('accepted: $accepted, ')
          ..write('decisionBy: $decisionBy, ')
          ..write('decisionAt: $decisionAt, ')
          ..write('decisionNotes: $decisionNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      testId,
      modelVersion,
      suggestionType,
      confidence,
      featuresJson,
      createdAt,
      accepted,
      decisionBy,
      decisionAt,
      decisionNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiRecommendation &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.modelVersion == this.modelVersion &&
          other.suggestionType == this.suggestionType &&
          other.confidence == this.confidence &&
          other.featuresJson == this.featuresJson &&
          other.createdAt == this.createdAt &&
          other.accepted == this.accepted &&
          other.decisionBy == this.decisionBy &&
          other.decisionAt == this.decisionAt &&
          other.decisionNotes == this.decisionNotes);
}

class AiRecommendationsCompanion extends UpdateCompanion<AiRecommendation> {
  final Value<String> id;
  final Value<String> testId;
  final Value<String> modelVersion;
  final Value<String> suggestionType;
  final Value<double> confidence;
  final Value<String> featuresJson;
  final Value<DateTime> createdAt;
  final Value<bool?> accepted;
  final Value<String?> decisionBy;
  final Value<DateTime?> decisionAt;
  final Value<String?> decisionNotes;
  final Value<int> rowid;
  const AiRecommendationsCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.suggestionType = const Value.absent(),
    this.confidence = const Value.absent(),
    this.featuresJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.accepted = const Value.absent(),
    this.decisionBy = const Value.absent(),
    this.decisionAt = const Value.absent(),
    this.decisionNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiRecommendationsCompanion.insert({
    required String id,
    required String testId,
    required String modelVersion,
    required String suggestionType,
    required double confidence,
    required String featuresJson,
    required DateTime createdAt,
    this.accepted = const Value.absent(),
    this.decisionBy = const Value.absent(),
    this.decisionAt = const Value.absent(),
    this.decisionNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        testId = Value(testId),
        modelVersion = Value(modelVersion),
        suggestionType = Value(suggestionType),
        confidence = Value(confidence),
        featuresJson = Value(featuresJson),
        createdAt = Value(createdAt);
  static Insertable<AiRecommendation> custom({
    Expression<String>? id,
    Expression<String>? testId,
    Expression<String>? modelVersion,
    Expression<String>? suggestionType,
    Expression<double>? confidence,
    Expression<String>? featuresJson,
    Expression<DateTime>? createdAt,
    Expression<bool>? accepted,
    Expression<String>? decisionBy,
    Expression<DateTime>? decisionAt,
    Expression<String>? decisionNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (modelVersion != null) 'model_version': modelVersion,
      if (suggestionType != null) 'suggestion_type': suggestionType,
      if (confidence != null) 'confidence': confidence,
      if (featuresJson != null) 'features_json': featuresJson,
      if (createdAt != null) 'created_at': createdAt,
      if (accepted != null) 'accepted': accepted,
      if (decisionBy != null) 'decision_by': decisionBy,
      if (decisionAt != null) 'decision_at': decisionAt,
      if (decisionNotes != null) 'decision_notes': decisionNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiRecommendationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? testId,
      Value<String>? modelVersion,
      Value<String>? suggestionType,
      Value<double>? confidence,
      Value<String>? featuresJson,
      Value<DateTime>? createdAt,
      Value<bool?>? accepted,
      Value<String?>? decisionBy,
      Value<DateTime?>? decisionAt,
      Value<String?>? decisionNotes,
      Value<int>? rowid}) {
    return AiRecommendationsCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      modelVersion: modelVersion ?? this.modelVersion,
      suggestionType: suggestionType ?? this.suggestionType,
      confidence: confidence ?? this.confidence,
      featuresJson: featuresJson ?? this.featuresJson,
      createdAt: createdAt ?? this.createdAt,
      accepted: accepted ?? this.accepted,
      decisionBy: decisionBy ?? this.decisionBy,
      decisionAt: decisionAt ?? this.decisionAt,
      decisionNotes: decisionNotes ?? this.decisionNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<String>(testId.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (suggestionType.present) {
      map['suggestion_type'] = Variable<String>(suggestionType.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (featuresJson.present) {
      map['features_json'] = Variable<String>(featuresJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (accepted.present) {
      map['accepted'] = Variable<bool>(accepted.value);
    }
    if (decisionBy.present) {
      map['decision_by'] = Variable<String>(decisionBy.value);
    }
    if (decisionAt.present) {
      map['decision_at'] = Variable<DateTime>(decisionAt.value);
    }
    if (decisionNotes.present) {
      map['decision_notes'] = Variable<String>(decisionNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiRecommendationsCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('suggestionType: $suggestionType, ')
          ..write('confidence: $confidence, ')
          ..write('featuresJson: $featuresJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('accepted: $accepted, ')
          ..write('decisionBy: $decisionBy, ')
          ..write('decisionAt: $decisionAt, ')
          ..write('decisionNotes: $decisionNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentRecordsTable extends ConsentRecords
    with TableInfo<$ConsentRecordsTable, ConsentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _consentTypeMeta =
      const VerificationMeta('consentType');
  @override
  late final GeneratedColumn<String> consentType = GeneratedColumn<String>(
      'consent_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _grantedMeta =
      const VerificationMeta('granted');
  @override
  late final GeneratedColumn<bool> granted = GeneratedColumn<bool>(
      'granted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("granted" IN (0, 1))'));
  static const VerificationMeta _grantedAtMeta =
      const VerificationMeta('grantedAt');
  @override
  late final GeneratedColumn<DateTime> grantedAt = GeneratedColumn<DateTime>(
      'granted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _documentVersionMeta =
      const VerificationMeta('documentVersion');
  @override
  late final GeneratedColumn<String> documentVersion = GeneratedColumn<String>(
      'document_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _witnessedByMeta =
      const VerificationMeta('witnessedBy');
  @override
  late final GeneratedColumn<String> witnessedBy = GeneratedColumn<String>(
      'witnessed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        consentType,
        granted,
        grantedAt,
        expiresAt,
        documentVersion,
        ipAddress,
        witnessedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consent_records';
  @override
  VerificationContext validateIntegrity(Insertable<ConsentRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('consent_type')) {
      context.handle(
          _consentTypeMeta,
          consentType.isAcceptableOrUnknown(
              data['consent_type']!, _consentTypeMeta));
    } else if (isInserting) {
      context.missing(_consentTypeMeta);
    }
    if (data.containsKey('granted')) {
      context.handle(_grantedMeta,
          granted.isAcceptableOrUnknown(data['granted']!, _grantedMeta));
    } else if (isInserting) {
      context.missing(_grantedMeta);
    }
    if (data.containsKey('granted_at')) {
      context.handle(_grantedAtMeta,
          grantedAt.isAcceptableOrUnknown(data['granted_at']!, _grantedAtMeta));
    } else if (isInserting) {
      context.missing(_grantedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('document_version')) {
      context.handle(
          _documentVersionMeta,
          documentVersion.isAcceptableOrUnknown(
              data['document_version']!, _documentVersionMeta));
    } else if (isInserting) {
      context.missing(_documentVersionMeta);
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('witnessed_by')) {
      context.handle(
          _witnessedByMeta,
          witnessedBy.isAcceptableOrUnknown(
              data['witnessed_by']!, _witnessedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      consentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}consent_type'])!,
      granted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}granted'])!,
      grantedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}granted_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      documentVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}document_version'])!,
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      witnessedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}witnessed_by']),
    );
  }

  @override
  $ConsentRecordsTable createAlias(String alias) {
    return $ConsentRecordsTable(attachedDatabase, alias);
  }
}

class ConsentRecord extends DataClass implements Insertable<ConsentRecord> {
  final String id;
  final String patientId;
  final String consentType;
  final bool granted;
  final DateTime grantedAt;
  final DateTime? expiresAt;
  final String documentVersion;
  final String? ipAddress;
  final String? witnessedBy;
  const ConsentRecord(
      {required this.id,
      required this.patientId,
      required this.consentType,
      required this.granted,
      required this.grantedAt,
      this.expiresAt,
      required this.documentVersion,
      this.ipAddress,
      this.witnessedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['consent_type'] = Variable<String>(consentType);
    map['granted'] = Variable<bool>(granted);
    map['granted_at'] = Variable<DateTime>(grantedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['document_version'] = Variable<String>(documentVersion);
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    if (!nullToAbsent || witnessedBy != null) {
      map['witnessed_by'] = Variable<String>(witnessedBy);
    }
    return map;
  }

  ConsentRecordsCompanion toCompanion(bool nullToAbsent) {
    return ConsentRecordsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      consentType: Value(consentType),
      granted: Value(granted),
      grantedAt: Value(grantedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      documentVersion: Value(documentVersion),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      witnessedBy: witnessedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(witnessedBy),
    );
  }

  factory ConsentRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentRecord(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      consentType: serializer.fromJson<String>(json['consentType']),
      granted: serializer.fromJson<bool>(json['granted']),
      grantedAt: serializer.fromJson<DateTime>(json['grantedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      documentVersion: serializer.fromJson<String>(json['documentVersion']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      witnessedBy: serializer.fromJson<String?>(json['witnessedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'consentType': serializer.toJson<String>(consentType),
      'granted': serializer.toJson<bool>(granted),
      'grantedAt': serializer.toJson<DateTime>(grantedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'documentVersion': serializer.toJson<String>(documentVersion),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'witnessedBy': serializer.toJson<String?>(witnessedBy),
    };
  }

  ConsentRecord copyWith(
          {String? id,
          String? patientId,
          String? consentType,
          bool? granted,
          DateTime? grantedAt,
          Value<DateTime?> expiresAt = const Value.absent(),
          String? documentVersion,
          Value<String?> ipAddress = const Value.absent(),
          Value<String?> witnessedBy = const Value.absent()}) =>
      ConsentRecord(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        consentType: consentType ?? this.consentType,
        granted: granted ?? this.granted,
        grantedAt: grantedAt ?? this.grantedAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        documentVersion: documentVersion ?? this.documentVersion,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        witnessedBy: witnessedBy.present ? witnessedBy.value : this.witnessedBy,
      );
  ConsentRecord copyWithCompanion(ConsentRecordsCompanion data) {
    return ConsentRecord(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      consentType:
          data.consentType.present ? data.consentType.value : this.consentType,
      granted: data.granted.present ? data.granted.value : this.granted,
      grantedAt: data.grantedAt.present ? data.grantedAt.value : this.grantedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      documentVersion: data.documentVersion.present
          ? data.documentVersion.value
          : this.documentVersion,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      witnessedBy:
          data.witnessedBy.present ? data.witnessedBy.value : this.witnessedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecord(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('consentType: $consentType, ')
          ..write('granted: $granted, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('documentVersion: $documentVersion, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('witnessedBy: $witnessedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, consentType, granted,
      grantedAt, expiresAt, documentVersion, ipAddress, witnessedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentRecord &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.consentType == this.consentType &&
          other.granted == this.granted &&
          other.grantedAt == this.grantedAt &&
          other.expiresAt == this.expiresAt &&
          other.documentVersion == this.documentVersion &&
          other.ipAddress == this.ipAddress &&
          other.witnessedBy == this.witnessedBy);
}

class ConsentRecordsCompanion extends UpdateCompanion<ConsentRecord> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> consentType;
  final Value<bool> granted;
  final Value<DateTime> grantedAt;
  final Value<DateTime?> expiresAt;
  final Value<String> documentVersion;
  final Value<String?> ipAddress;
  final Value<String?> witnessedBy;
  final Value<int> rowid;
  const ConsentRecordsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.consentType = const Value.absent(),
    this.granted = const Value.absent(),
    this.grantedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.documentVersion = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.witnessedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentRecordsCompanion.insert({
    required String id,
    required String patientId,
    required String consentType,
    required bool granted,
    required DateTime grantedAt,
    this.expiresAt = const Value.absent(),
    required String documentVersion,
    this.ipAddress = const Value.absent(),
    this.witnessedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        consentType = Value(consentType),
        granted = Value(granted),
        grantedAt = Value(grantedAt),
        documentVersion = Value(documentVersion);
  static Insertable<ConsentRecord> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? consentType,
    Expression<bool>? granted,
    Expression<DateTime>? grantedAt,
    Expression<DateTime>? expiresAt,
    Expression<String>? documentVersion,
    Expression<String>? ipAddress,
    Expression<String>? witnessedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (consentType != null) 'consent_type': consentType,
      if (granted != null) 'granted': granted,
      if (grantedAt != null) 'granted_at': grantedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (documentVersion != null) 'document_version': documentVersion,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (witnessedBy != null) 'witnessed_by': witnessedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? consentType,
      Value<bool>? granted,
      Value<DateTime>? grantedAt,
      Value<DateTime?>? expiresAt,
      Value<String>? documentVersion,
      Value<String?>? ipAddress,
      Value<String?>? witnessedBy,
      Value<int>? rowid}) {
    return ConsentRecordsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      consentType: consentType ?? this.consentType,
      granted: granted ?? this.granted,
      grantedAt: grantedAt ?? this.grantedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      documentVersion: documentVersion ?? this.documentVersion,
      ipAddress: ipAddress ?? this.ipAddress,
      witnessedBy: witnessedBy ?? this.witnessedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (consentType.present) {
      map['consent_type'] = Variable<String>(consentType.value);
    }
    if (granted.present) {
      map['granted'] = Variable<bool>(granted.value);
    }
    if (grantedAt.present) {
      map['granted_at'] = Variable<DateTime>(grantedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (documentVersion.present) {
      map['document_version'] = Variable<String>(documentVersion.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (witnessedBy.present) {
      map['witnessed_by'] = Variable<String>(witnessedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('consentType: $consentType, ')
          ..write('granted: $granted, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('documentVersion: $documentVersion, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('witnessedBy: $witnessedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $TestResultsTable testResults = $TestResultsTable(this);
  late final $ScreeningResultsTable screeningResults =
      $ScreeningResultsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $HeadphoneProfilesTable headphoneProfiles =
      $HeadphoneProfilesTable(this);
  late final $CalibrationSettingsTable calibrationSettings =
      $CalibrationSettingsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $BcImportsTable bcImports = $BcImportsTable(this);
  late final $AiRecommendationsTable aiRecommendations =
      $AiRecommendationsTable(this);
  late final $ConsentRecordsTable consentRecords = $ConsentRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patients,
        testResults,
        screeningResults,
        users,
        auditLogs,
        sessions,
        headphoneProfiles,
        calibrationSettings,
        appSettings,
        bcImports,
        aiRecommendations,
        consentRecords
      ];
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String id,
  required String name,
  required DateTime dateOfBirth,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> gender,
  Value<String?> medicalRecordNumber,
  Value<String?> notes,
  Value<String?> audiologistId,
  required String createdBy,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> synced,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> dateOfBirth,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> gender,
  Value<String?> medicalRecordNumber,
  Value<String?> notes,
  Value<String?> audiologistId,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> synced,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    DbPatient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PatientsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PatientsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> dateOfBirth = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> medicalRecordNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> audiologistId = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            id: id,
            name: name,
            dateOfBirth: dateOfBirth,
            phoneNumber: phoneNumber,
            email: email,
            gender: gender,
            medicalRecordNumber: medicalRecordNumber,
            notes: notes,
            audiologistId: audiologistId,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            synced: synced,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required DateTime dateOfBirth,
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> medicalRecordNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> audiologistId = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            id: id,
            name: name,
            dateOfBirth: dateOfBirth,
            phoneNumber: phoneNumber,
            email: email,
            gender: gender,
            medicalRecordNumber: medicalRecordNumber,
            notes: notes,
            audiologistId: audiologistId,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            synced: synced,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$PatientsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get medicalRecordNumber => $state.composableBuilder(
      column: $state.table.medicalRecordNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get audiologistId => $state.composableBuilder(
      column: $state.table.audiologistId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdBy => $state.composableBuilder(
      column: $state.table.createdBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter testResultsRefs(
      ComposableFilter Function($$TestResultsTableFilterComposer f) f) {
    final $$TestResultsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.testResults,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder, parentComposers) =>
            $$TestResultsTableFilterComposer(ComposerState($state.db,
                $state.db.testResults, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter bcImportsRefs(
      ComposableFilter Function($$BcImportsTableFilterComposer f) f) {
    final $$BcImportsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.bcImports,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder, parentComposers) =>
            $$BcImportsTableFilterComposer(ComposerState(
                $state.db, $state.db.bcImports, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter consentRecordsRefs(
      ComposableFilter Function($$ConsentRecordsTableFilterComposer f) f) {
    final $$ConsentRecordsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.consentRecords,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder, parentComposers) =>
            $$ConsentRecordsTableFilterComposer(ComposerState($state.db,
                $state.db.consentRecords, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateOfBirth => $state.composableBuilder(
      column: $state.table.dateOfBirth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phoneNumber => $state.composableBuilder(
      column: $state.table.phoneNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get medicalRecordNumber => $state.composableBuilder(
      column: $state.table.medicalRecordNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get audiologistId => $state.composableBuilder(
      column: $state.table.audiologistId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdBy => $state.composableBuilder(
      column: $state.table.createdBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TestResultsTableCreateCompanionBuilder = TestResultsCompanion
    Function({
  required String id,
  required String patientId,
  required String audiologistId,
  required DateTime testDate,
  Value<String> testType,
  Value<String?> screeningId,
  Value<String?> headphoneModel,
  Value<double?> ambientNoiseDb,
  required String rightEarResults,
  required String leftEarResults,
  required double rightPta,
  required double leftPta,
  required String rightClassification,
  required String leftClassification,
  Value<String?> notes,
  Value<String?> recommendations,
  Value<bool> isComplete,
  Value<bool> synced,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TestResultsTableUpdateCompanionBuilder = TestResultsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> audiologistId,
  Value<DateTime> testDate,
  Value<String> testType,
  Value<String?> screeningId,
  Value<String?> headphoneModel,
  Value<double?> ambientNoiseDb,
  Value<String> rightEarResults,
  Value<String> leftEarResults,
  Value<double> rightPta,
  Value<double> leftPta,
  Value<String> rightClassification,
  Value<String> leftClassification,
  Value<String?> notes,
  Value<String?> recommendations,
  Value<bool> isComplete,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$TestResultsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestResultsTable,
    DbTestResult,
    $$TestResultsTableFilterComposer,
    $$TestResultsTableOrderingComposer,
    $$TestResultsTableCreateCompanionBuilder,
    $$TestResultsTableUpdateCompanionBuilder> {
  $$TestResultsTableTableManager(_$AppDatabase db, $TestResultsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TestResultsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TestResultsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> audiologistId = const Value.absent(),
            Value<DateTime> testDate = const Value.absent(),
            Value<String> testType = const Value.absent(),
            Value<String?> screeningId = const Value.absent(),
            Value<String?> headphoneModel = const Value.absent(),
            Value<double?> ambientNoiseDb = const Value.absent(),
            Value<String> rightEarResults = const Value.absent(),
            Value<String> leftEarResults = const Value.absent(),
            Value<double> rightPta = const Value.absent(),
            Value<double> leftPta = const Value.absent(),
            Value<String> rightClassification = const Value.absent(),
            Value<String> leftClassification = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> recommendations = const Value.absent(),
            Value<bool> isComplete = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TestResultsCompanion(
            id: id,
            patientId: patientId,
            audiologistId: audiologistId,
            testDate: testDate,
            testType: testType,
            screeningId: screeningId,
            headphoneModel: headphoneModel,
            ambientNoiseDb: ambientNoiseDb,
            rightEarResults: rightEarResults,
            leftEarResults: leftEarResults,
            rightPta: rightPta,
            leftPta: leftPta,
            rightClassification: rightClassification,
            leftClassification: leftClassification,
            notes: notes,
            recommendations: recommendations,
            isComplete: isComplete,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String audiologistId,
            required DateTime testDate,
            Value<String> testType = const Value.absent(),
            Value<String?> screeningId = const Value.absent(),
            Value<String?> headphoneModel = const Value.absent(),
            Value<double?> ambientNoiseDb = const Value.absent(),
            required String rightEarResults,
            required String leftEarResults,
            required double rightPta,
            required double leftPta,
            required String rightClassification,
            required String leftClassification,
            Value<String?> notes = const Value.absent(),
            Value<String?> recommendations = const Value.absent(),
            Value<bool> isComplete = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TestResultsCompanion.insert(
            id: id,
            patientId: patientId,
            audiologistId: audiologistId,
            testDate: testDate,
            testType: testType,
            screeningId: screeningId,
            headphoneModel: headphoneModel,
            ambientNoiseDb: ambientNoiseDb,
            rightEarResults: rightEarResults,
            leftEarResults: leftEarResults,
            rightPta: rightPta,
            leftPta: leftPta,
            rightClassification: rightClassification,
            leftClassification: leftClassification,
            notes: notes,
            recommendations: recommendations,
            isComplete: isComplete,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$TestResultsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TestResultsTable> {
  $$TestResultsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get audiologistId => $state.composableBuilder(
      column: $state.table.audiologistId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get testDate => $state.composableBuilder(
      column: $state.table.testDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get testType => $state.composableBuilder(
      column: $state.table.testType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get screeningId => $state.composableBuilder(
      column: $state.table.screeningId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get headphoneModel => $state.composableBuilder(
      column: $state.table.headphoneModel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ambientNoiseDb => $state.composableBuilder(
      column: $state.table.ambientNoiseDb,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rightEarResults => $state.composableBuilder(
      column: $state.table.rightEarResults,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get leftEarResults => $state.composableBuilder(
      column: $state.table.leftEarResults,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get rightPta => $state.composableBuilder(
      column: $state.table.rightPta,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get leftPta => $state.composableBuilder(
      column: $state.table.leftPta,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rightClassification => $state.composableBuilder(
      column: $state.table.rightClassification,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get leftClassification => $state.composableBuilder(
      column: $state.table.leftClassification,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get recommendations => $state.composableBuilder(
      column: $state.table.recommendations,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isComplete => $state.composableBuilder(
      column: $state.table.isComplete,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableFilterComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter aiRecommendationsRefs(
      ComposableFilter Function($$AiRecommendationsTableFilterComposer f) f) {
    final $$AiRecommendationsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.aiRecommendations,
            getReferencedColumn: (t) => t.testId,
            builder: (joinBuilder, parentComposers) =>
                $$AiRecommendationsTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.aiRecommendations,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$TestResultsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TestResultsTable> {
  $$TestResultsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get audiologistId => $state.composableBuilder(
      column: $state.table.audiologistId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get testDate => $state.composableBuilder(
      column: $state.table.testDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get testType => $state.composableBuilder(
      column: $state.table.testType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get screeningId => $state.composableBuilder(
      column: $state.table.screeningId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get headphoneModel => $state.composableBuilder(
      column: $state.table.headphoneModel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ambientNoiseDb => $state.composableBuilder(
      column: $state.table.ambientNoiseDb,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rightEarResults => $state.composableBuilder(
      column: $state.table.rightEarResults,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get leftEarResults => $state.composableBuilder(
      column: $state.table.leftEarResults,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get rightPta => $state.composableBuilder(
      column: $state.table.rightPta,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get leftPta => $state.composableBuilder(
      column: $state.table.leftPta,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rightClassification => $state.composableBuilder(
      column: $state.table.rightClassification,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get leftClassification => $state.composableBuilder(
      column: $state.table.leftClassification,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get recommendations => $state.composableBuilder(
      column: $state.table.recommendations,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isComplete => $state.composableBuilder(
      column: $state.table.isComplete,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableOrderingComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ScreeningResultsTableCreateCompanionBuilder
    = ScreeningResultsCompanion Function({
  required String id,
  required String userId,
  required DateTime testDate,
  Value<String?> headphoneModel,
  Value<double?> ambientNoiseDb,
  required String result,
  required String frequenciesTested,
  required String thresholds,
  Value<String?> deviceInfo,
  Value<bool> synced,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ScreeningResultsTableUpdateCompanionBuilder
    = ScreeningResultsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<DateTime> testDate,
  Value<String?> headphoneModel,
  Value<double?> ambientNoiseDb,
  Value<String> result,
  Value<String> frequenciesTested,
  Value<String> thresholds,
  Value<String?> deviceInfo,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ScreeningResultsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScreeningResultsTable,
    ScreeningResult,
    $$ScreeningResultsTableFilterComposer,
    $$ScreeningResultsTableOrderingComposer,
    $$ScreeningResultsTableCreateCompanionBuilder,
    $$ScreeningResultsTableUpdateCompanionBuilder> {
  $$ScreeningResultsTableTableManager(
      _$AppDatabase db, $ScreeningResultsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ScreeningResultsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ScreeningResultsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> testDate = const Value.absent(),
            Value<String?> headphoneModel = const Value.absent(),
            Value<double?> ambientNoiseDb = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<String> frequenciesTested = const Value.absent(),
            Value<String> thresholds = const Value.absent(),
            Value<String?> deviceInfo = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScreeningResultsCompanion(
            id: id,
            userId: userId,
            testDate: testDate,
            headphoneModel: headphoneModel,
            ambientNoiseDb: ambientNoiseDb,
            result: result,
            frequenciesTested: frequenciesTested,
            thresholds: thresholds,
            deviceInfo: deviceInfo,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required DateTime testDate,
            Value<String?> headphoneModel = const Value.absent(),
            Value<double?> ambientNoiseDb = const Value.absent(),
            required String result,
            required String frequenciesTested,
            required String thresholds,
            Value<String?> deviceInfo = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScreeningResultsCompanion.insert(
            id: id,
            userId: userId,
            testDate: testDate,
            headphoneModel: headphoneModel,
            ambientNoiseDb: ambientNoiseDb,
            result: result,
            frequenciesTested: frequenciesTested,
            thresholds: thresholds,
            deviceInfo: deviceInfo,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$ScreeningResultsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScreeningResultsTable> {
  $$ScreeningResultsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get testDate => $state.composableBuilder(
      column: $state.table.testDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get headphoneModel => $state.composableBuilder(
      column: $state.table.headphoneModel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ambientNoiseDb => $state.composableBuilder(
      column: $state.table.ambientNoiseDb,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get result => $state.composableBuilder(
      column: $state.table.result,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get frequenciesTested => $state.composableBuilder(
      column: $state.table.frequenciesTested,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get thresholds => $state.composableBuilder(
      column: $state.table.thresholds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceInfo => $state.composableBuilder(
      column: $state.table.deviceInfo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ScreeningResultsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScreeningResultsTable> {
  $$ScreeningResultsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get testDate => $state.composableBuilder(
      column: $state.table.testDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get headphoneModel => $state.composableBuilder(
      column: $state.table.headphoneModel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ambientNoiseDb => $state.composableBuilder(
      column: $state.table.ambientNoiseDb,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get result => $state.composableBuilder(
      column: $state.table.result,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get frequenciesTested => $state.composableBuilder(
      column: $state.table.frequenciesTested,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get thresholds => $state.composableBuilder(
      column: $state.table.thresholds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceInfo => $state.composableBuilder(
      column: $state.table.deviceInfo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String email,
  required String name,
  required String role,
  Value<String?> avatarUrl,
  Value<String?> licenseNumber,
  Value<String?> licenseState,
  Value<DateTime?> licenseExpiryDate,
  Value<bool> isVerified,
  Value<String?> verifiedBy,
  Value<DateTime?> verifiedAt,
  Value<bool> isActive,
  Value<bool> isSuspended,
  Value<String?> suspensionReason,
  Value<int> failedLoginAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime?> lastLoginAt,
  Value<String?> lastLoginIp,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> name,
  Value<String> role,
  Value<String?> avatarUrl,
  Value<String?> licenseNumber,
  Value<String?> licenseState,
  Value<DateTime?> licenseExpiryDate,
  Value<bool> isVerified,
  Value<String?> verifiedBy,
  Value<DateTime?> verifiedAt,
  Value<bool> isActive,
  Value<bool> isSuspended,
  Value<String?> suspensionReason,
  Value<int> failedLoginAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime?> lastLoginAt,
  Value<String?> lastLoginIp,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UsersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UsersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> licenseNumber = const Value.absent(),
            Value<String?> licenseState = const Value.absent(),
            Value<DateTime?> licenseExpiryDate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<String?> verifiedBy = const Value.absent(),
            Value<DateTime?> verifiedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSuspended = const Value.absent(),
            Value<String?> suspensionReason = const Value.absent(),
            Value<int> failedLoginAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<String?> lastLoginIp = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
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
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String name,
            required String role,
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> licenseNumber = const Value.absent(),
            Value<String?> licenseState = const Value.absent(),
            Value<DateTime?> licenseExpiryDate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<String?> verifiedBy = const Value.absent(),
            Value<DateTime?> verifiedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSuspended = const Value.absent(),
            Value<String?> suspensionReason = const Value.absent(),
            Value<int> failedLoginAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<String?> lastLoginIp = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
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
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$UsersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarUrl => $state.composableBuilder(
      column: $state.table.avatarUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get licenseNumber => $state.composableBuilder(
      column: $state.table.licenseNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get licenseState => $state.composableBuilder(
      column: $state.table.licenseState,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get licenseExpiryDate => $state.composableBuilder(
      column: $state.table.licenseExpiryDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVerified => $state.composableBuilder(
      column: $state.table.isVerified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get verifiedBy => $state.composableBuilder(
      column: $state.table.verifiedBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get verifiedAt => $state.composableBuilder(
      column: $state.table.verifiedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isSuspended => $state.composableBuilder(
      column: $state.table.isSuspended,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get suspensionReason => $state.composableBuilder(
      column: $state.table.suspensionReason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get failedLoginAttempts => $state.composableBuilder(
      column: $state.table.failedLoginAttempts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lockedUntil => $state.composableBuilder(
      column: $state.table.lockedUntil,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastLoginAt => $state.composableBuilder(
      column: $state.table.lastLoginAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lastLoginIp => $state.composableBuilder(
      column: $state.table.lastLoginIp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter sessionsRefs(
      ComposableFilter Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.sessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder, parentComposers) =>
            $$SessionsTableFilterComposer(ComposerState(
                $state.db, $state.db.sessions, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarUrl => $state.composableBuilder(
      column: $state.table.avatarUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get licenseNumber => $state.composableBuilder(
      column: $state.table.licenseNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get licenseState => $state.composableBuilder(
      column: $state.table.licenseState,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get licenseExpiryDate => $state.composableBuilder(
      column: $state.table.licenseExpiryDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVerified => $state.composableBuilder(
      column: $state.table.isVerified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get verifiedBy => $state.composableBuilder(
      column: $state.table.verifiedBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get verifiedAt => $state.composableBuilder(
      column: $state.table.verifiedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isSuspended => $state.composableBuilder(
      column: $state.table.isSuspended,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get suspensionReason => $state.composableBuilder(
      column: $state.table.suspensionReason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get failedLoginAttempts => $state.composableBuilder(
      column: $state.table.failedLoginAttempts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lockedUntil => $state.composableBuilder(
      column: $state.table.lockedUntil,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastLoginAt => $state.composableBuilder(
      column: $state.table.lastLoginAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lastLoginIp => $state.composableBuilder(
      column: $state.table.lastLoginIp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  required String userId,
  required String userEmail,
  required String action,
  required String resourceType,
  Value<String?> resourceId,
  Value<String?> details,
  Value<String?> ipAddress,
  Value<String?> userAgent,
  Value<String?> sessionId,
  Value<bool> success,
  Value<String?> errorMessage,
  required DateTime createdAt,
  Value<bool> archived,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String> userEmail,
  Value<String> action,
  Value<String> resourceType,
  Value<String?> resourceId,
  Value<String?> details,
  Value<String?> ipAddress,
  Value<String?> userAgent,
  Value<String?> sessionId,
  Value<bool> success,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<bool> archived,
});

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AuditLogsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AuditLogsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> userEmail = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> resourceType = const Value.absent(),
            Value<String?> resourceId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> userAgent = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<bool> success = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> archived = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            userId: userId,
            userEmail: userEmail,
            action: action,
            resourceType: resourceType,
            resourceId: resourceId,
            details: details,
            ipAddress: ipAddress,
            userAgent: userAgent,
            sessionId: sessionId,
            success: success,
            errorMessage: errorMessage,
            createdAt: createdAt,
            archived: archived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required String userEmail,
            required String action,
            required String resourceType,
            Value<String?> resourceId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> userAgent = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<bool> success = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime createdAt,
            Value<bool> archived = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            userId: userId,
            userEmail: userEmail,
            action: action,
            resourceType: resourceType,
            resourceId: resourceId,
            details: details,
            ipAddress: ipAddress,
            userAgent: userAgent,
            sessionId: sessionId,
            success: success,
            errorMessage: errorMessage,
            createdAt: createdAt,
            archived: archived,
          ),
        ));
}

class $$AuditLogsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userEmail => $state.composableBuilder(
      column: $state.table.userEmail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get resourceType => $state.composableBuilder(
      column: $state.table.resourceType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get resourceId => $state.composableBuilder(
      column: $state.table.resourceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userAgent => $state.composableBuilder(
      column: $state.table.userAgent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get success => $state.composableBuilder(
      column: $state.table.success,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get archived => $state.composableBuilder(
      column: $state.table.archived,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AuditLogsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userEmail => $state.composableBuilder(
      column: $state.table.userEmail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get resourceType => $state.composableBuilder(
      column: $state.table.resourceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get resourceId => $state.composableBuilder(
      column: $state.table.resourceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userAgent => $state.composableBuilder(
      column: $state.table.userAgent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get success => $state.composableBuilder(
      column: $state.table.success,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get archived => $state.composableBuilder(
      column: $state.table.archived,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String userId,
  required String deviceId,
  Value<String?> deviceName,
  Value<String?> deviceType,
  Value<String?> ipAddress,
  required DateTime createdAt,
  required DateTime lastActivityAt,
  required DateTime expiresAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> deviceId,
  Value<String?> deviceName,
  Value<String?> deviceType,
  Value<String?> ipAddress,
  Value<DateTime> createdAt,
  Value<DateTime> lastActivityAt,
  Value<DateTime> expiresAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String?> deviceName = const Value.absent(),
            Value<String?> deviceType = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastActivityAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            userId: userId,
            deviceId: deviceId,
            deviceName: deviceName,
            deviceType: deviceType,
            ipAddress: ipAddress,
            createdAt: createdAt,
            lastActivityAt: lastActivityAt,
            expiresAt: expiresAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String deviceId,
            Value<String?> deviceName = const Value.absent(),
            Value<String?> deviceType = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            required DateTime createdAt,
            required DateTime lastActivityAt,
            required DateTime expiresAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            userId: userId,
            deviceId: deviceId,
            deviceName: deviceName,
            deviceType: deviceType,
            ipAddress: ipAddress,
            createdAt: createdAt,
            lastActivityAt: lastActivityAt,
            expiresAt: expiresAt,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$SessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceName => $state.composableBuilder(
      column: $state.table.deviceName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceType => $state.composableBuilder(
      column: $state.table.deviceType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastActivityAt => $state.composableBuilder(
      column: $state.table.lastActivityAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableFilterComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceName => $state.composableBuilder(
      column: $state.table.deviceName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceType => $state.composableBuilder(
      column: $state.table.deviceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastActivityAt => $state.composableBuilder(
      column: $state.table.lastActivityAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $state.db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$UsersTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.users, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$HeadphoneProfilesTableCreateCompanionBuilder
    = HeadphoneProfilesCompanion Function({
  required String id,
  required String brand,
  required String model,
  required String type,
  required String retsplValues,
  Value<String?> corrections,
  Value<bool> isValidated,
  Value<DateTime?> validationDate,
  Value<double?> validationAccuracy,
  Value<int?> participantCount,
  required String approvedUsage,
  Value<String?> notes,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$HeadphoneProfilesTableUpdateCompanionBuilder
    = HeadphoneProfilesCompanion Function({
  Value<String> id,
  Value<String> brand,
  Value<String> model,
  Value<String> type,
  Value<String> retsplValues,
  Value<String?> corrections,
  Value<bool> isValidated,
  Value<DateTime?> validationDate,
  Value<double?> validationAccuracy,
  Value<int?> participantCount,
  Value<String> approvedUsage,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$HeadphoneProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HeadphoneProfilesTable,
    HeadphoneProfile,
    $$HeadphoneProfilesTableFilterComposer,
    $$HeadphoneProfilesTableOrderingComposer,
    $$HeadphoneProfilesTableCreateCompanionBuilder,
    $$HeadphoneProfilesTableUpdateCompanionBuilder> {
  $$HeadphoneProfilesTableTableManager(
      _$AppDatabase db, $HeadphoneProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HeadphoneProfilesTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$HeadphoneProfilesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> retsplValues = const Value.absent(),
            Value<String?> corrections = const Value.absent(),
            Value<bool> isValidated = const Value.absent(),
            Value<DateTime?> validationDate = const Value.absent(),
            Value<double?> validationAccuracy = const Value.absent(),
            Value<int?> participantCount = const Value.absent(),
            Value<String> approvedUsage = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HeadphoneProfilesCompanion(
            id: id,
            brand: brand,
            model: model,
            type: type,
            retsplValues: retsplValues,
            corrections: corrections,
            isValidated: isValidated,
            validationDate: validationDate,
            validationAccuracy: validationAccuracy,
            participantCount: participantCount,
            approvedUsage: approvedUsage,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String brand,
            required String model,
            required String type,
            required String retsplValues,
            Value<String?> corrections = const Value.absent(),
            Value<bool> isValidated = const Value.absent(),
            Value<DateTime?> validationDate = const Value.absent(),
            Value<double?> validationAccuracy = const Value.absent(),
            Value<int?> participantCount = const Value.absent(),
            required String approvedUsage,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HeadphoneProfilesCompanion.insert(
            id: id,
            brand: brand,
            model: model,
            type: type,
            retsplValues: retsplValues,
            corrections: corrections,
            isValidated: isValidated,
            validationDate: validationDate,
            validationAccuracy: validationAccuracy,
            participantCount: participantCount,
            approvedUsage: approvedUsage,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$HeadphoneProfilesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HeadphoneProfilesTable> {
  $$HeadphoneProfilesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get model => $state.composableBuilder(
      column: $state.table.model,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get retsplValues => $state.composableBuilder(
      column: $state.table.retsplValues,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get corrections => $state.composableBuilder(
      column: $state.table.corrections,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isValidated => $state.composableBuilder(
      column: $state.table.isValidated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get validationDate => $state.composableBuilder(
      column: $state.table.validationDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get validationAccuracy => $state.composableBuilder(
      column: $state.table.validationAccuracy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get participantCount => $state.composableBuilder(
      column: $state.table.participantCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get approvedUsage => $state.composableBuilder(
      column: $state.table.approvedUsage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HeadphoneProfilesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HeadphoneProfilesTable> {
  $$HeadphoneProfilesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get brand => $state.composableBuilder(
      column: $state.table.brand,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get model => $state.composableBuilder(
      column: $state.table.model,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get retsplValues => $state.composableBuilder(
      column: $state.table.retsplValues,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get corrections => $state.composableBuilder(
      column: $state.table.corrections,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isValidated => $state.composableBuilder(
      column: $state.table.isValidated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get validationDate => $state.composableBuilder(
      column: $state.table.validationDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get validationAccuracy => $state.composableBuilder(
      column: $state.table.validationAccuracy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get participantCount => $state.composableBuilder(
      column: $state.table.participantCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get approvedUsage => $state.composableBuilder(
      column: $state.table.approvedUsage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CalibrationSettingsTableCreateCompanionBuilder
    = CalibrationSettingsCompanion Function({
  required String id,
  required int frequency,
  required double correction,
  required DateTime calibratedAt,
  required String calibratedBy,
  Value<String?> headphoneProfileId,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$CalibrationSettingsTableUpdateCompanionBuilder
    = CalibrationSettingsCompanion Function({
  Value<String> id,
  Value<int> frequency,
  Value<double> correction,
  Value<DateTime> calibratedAt,
  Value<String> calibratedBy,
  Value<String?> headphoneProfileId,
  Value<String?> notes,
  Value<int> rowid,
});

class $$CalibrationSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CalibrationSettingsTable,
    CalibrationSetting,
    $$CalibrationSettingsTableFilterComposer,
    $$CalibrationSettingsTableOrderingComposer,
    $$CalibrationSettingsTableCreateCompanionBuilder,
    $$CalibrationSettingsTableUpdateCompanionBuilder> {
  $$CalibrationSettingsTableTableManager(
      _$AppDatabase db, $CalibrationSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$CalibrationSettingsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$CalibrationSettingsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> frequency = const Value.absent(),
            Value<double> correction = const Value.absent(),
            Value<DateTime> calibratedAt = const Value.absent(),
            Value<String> calibratedBy = const Value.absent(),
            Value<String?> headphoneProfileId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalibrationSettingsCompanion(
            id: id,
            frequency: frequency,
            correction: correction,
            calibratedAt: calibratedAt,
            calibratedBy: calibratedBy,
            headphoneProfileId: headphoneProfileId,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int frequency,
            required double correction,
            required DateTime calibratedAt,
            required String calibratedBy,
            Value<String?> headphoneProfileId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalibrationSettingsCompanion.insert(
            id: id,
            frequency: frequency,
            correction: correction,
            calibratedAt: calibratedAt,
            calibratedBy: calibratedBy,
            headphoneProfileId: headphoneProfileId,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$CalibrationSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CalibrationSettingsTable> {
  $$CalibrationSettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get frequency => $state.composableBuilder(
      column: $state.table.frequency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get correction => $state.composableBuilder(
      column: $state.table.correction,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get calibratedAt => $state.composableBuilder(
      column: $state.table.calibratedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get calibratedBy => $state.composableBuilder(
      column: $state.table.calibratedBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get headphoneProfileId => $state.composableBuilder(
      column: $state.table.headphoneProfileId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CalibrationSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CalibrationSettingsTable> {
  $$CalibrationSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get frequency => $state.composableBuilder(
      column: $state.table.frequency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get correction => $state.composableBuilder(
      column: $state.table.correction,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get calibratedAt => $state.composableBuilder(
      column: $state.table.calibratedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get calibratedBy => $state.composableBuilder(
      column: $state.table.calibratedBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get headphoneProfileId => $state.composableBuilder(
      column: $state.table.headphoneProfileId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AppSettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AppSettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$AppSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AppSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BcImportsTableCreateCompanionBuilder = BcImportsCompanion Function({
  required String id,
  required String patientId,
  Value<String?> screeningId,
  required String fileName,
  required String filePath,
  required String fileType,
  required String importedBy,
  required DateTime importedAt,
  Value<String> status,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$BcImportsTableUpdateCompanionBuilder = BcImportsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String?> screeningId,
  Value<String> fileName,
  Value<String> filePath,
  Value<String> fileType,
  Value<String> importedBy,
  Value<DateTime> importedAt,
  Value<String> status,
  Value<String?> notes,
  Value<int> rowid,
});

class $$BcImportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BcImportsTable,
    BcImport,
    $$BcImportsTableFilterComposer,
    $$BcImportsTableOrderingComposer,
    $$BcImportsTableCreateCompanionBuilder,
    $$BcImportsTableUpdateCompanionBuilder> {
  $$BcImportsTableTableManager(_$AppDatabase db, $BcImportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BcImportsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BcImportsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> screeningId = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<String> importedBy = const Value.absent(),
            Value<DateTime> importedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BcImportsCompanion(
            id: id,
            patientId: patientId,
            screeningId: screeningId,
            fileName: fileName,
            filePath: filePath,
            fileType: fileType,
            importedBy: importedBy,
            importedAt: importedAt,
            status: status,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<String?> screeningId = const Value.absent(),
            required String fileName,
            required String filePath,
            required String fileType,
            required String importedBy,
            required DateTime importedAt,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BcImportsCompanion.insert(
            id: id,
            patientId: patientId,
            screeningId: screeningId,
            fileName: fileName,
            filePath: filePath,
            fileType: fileType,
            importedBy: importedBy,
            importedAt: importedAt,
            status: status,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$BcImportsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BcImportsTable> {
  $$BcImportsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get screeningId => $state.composableBuilder(
      column: $state.table.screeningId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get filePath => $state.composableBuilder(
      column: $state.table.filePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fileType => $state.composableBuilder(
      column: $state.table.fileType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get importedBy => $state.composableBuilder(
      column: $state.table.importedBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get importedAt => $state.composableBuilder(
      column: $state.table.importedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableFilterComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$BcImportsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BcImportsTable> {
  $$BcImportsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get screeningId => $state.composableBuilder(
      column: $state.table.screeningId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileName => $state.composableBuilder(
      column: $state.table.fileName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get filePath => $state.composableBuilder(
      column: $state.table.filePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fileType => $state.composableBuilder(
      column: $state.table.fileType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get importedBy => $state.composableBuilder(
      column: $state.table.importedBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get importedAt => $state.composableBuilder(
      column: $state.table.importedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableOrderingComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$AiRecommendationsTableCreateCompanionBuilder
    = AiRecommendationsCompanion Function({
  required String id,
  required String testId,
  required String modelVersion,
  required String suggestionType,
  required double confidence,
  required String featuresJson,
  required DateTime createdAt,
  Value<bool?> accepted,
  Value<String?> decisionBy,
  Value<DateTime?> decisionAt,
  Value<String?> decisionNotes,
  Value<int> rowid,
});
typedef $$AiRecommendationsTableUpdateCompanionBuilder
    = AiRecommendationsCompanion Function({
  Value<String> id,
  Value<String> testId,
  Value<String> modelVersion,
  Value<String> suggestionType,
  Value<double> confidence,
  Value<String> featuresJson,
  Value<DateTime> createdAt,
  Value<bool?> accepted,
  Value<String?> decisionBy,
  Value<DateTime?> decisionAt,
  Value<String?> decisionNotes,
  Value<int> rowid,
});

class $$AiRecommendationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiRecommendationsTable,
    AiRecommendation,
    $$AiRecommendationsTableFilterComposer,
    $$AiRecommendationsTableOrderingComposer,
    $$AiRecommendationsTableCreateCompanionBuilder,
    $$AiRecommendationsTableUpdateCompanionBuilder> {
  $$AiRecommendationsTableTableManager(
      _$AppDatabase db, $AiRecommendationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AiRecommendationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$AiRecommendationsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> testId = const Value.absent(),
            Value<String> modelVersion = const Value.absent(),
            Value<String> suggestionType = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> featuresJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool?> accepted = const Value.absent(),
            Value<String?> decisionBy = const Value.absent(),
            Value<DateTime?> decisionAt = const Value.absent(),
            Value<String?> decisionNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiRecommendationsCompanion(
            id: id,
            testId: testId,
            modelVersion: modelVersion,
            suggestionType: suggestionType,
            confidence: confidence,
            featuresJson: featuresJson,
            createdAt: createdAt,
            accepted: accepted,
            decisionBy: decisionBy,
            decisionAt: decisionAt,
            decisionNotes: decisionNotes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String testId,
            required String modelVersion,
            required String suggestionType,
            required double confidence,
            required String featuresJson,
            required DateTime createdAt,
            Value<bool?> accepted = const Value.absent(),
            Value<String?> decisionBy = const Value.absent(),
            Value<DateTime?> decisionAt = const Value.absent(),
            Value<String?> decisionNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiRecommendationsCompanion.insert(
            id: id,
            testId: testId,
            modelVersion: modelVersion,
            suggestionType: suggestionType,
            confidence: confidence,
            featuresJson: featuresJson,
            createdAt: createdAt,
            accepted: accepted,
            decisionBy: decisionBy,
            decisionAt: decisionAt,
            decisionNotes: decisionNotes,
            rowid: rowid,
          ),
        ));
}

class $$AiRecommendationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AiRecommendationsTable> {
  $$AiRecommendationsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get modelVersion => $state.composableBuilder(
      column: $state.table.modelVersion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get suggestionType => $state.composableBuilder(
      column: $state.table.suggestionType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get confidence => $state.composableBuilder(
      column: $state.table.confidence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get featuresJson => $state.composableBuilder(
      column: $state.table.featuresJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get accepted => $state.composableBuilder(
      column: $state.table.accepted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get decisionBy => $state.composableBuilder(
      column: $state.table.decisionBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get decisionAt => $state.composableBuilder(
      column: $state.table.decisionAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get decisionNotes => $state.composableBuilder(
      column: $state.table.decisionNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TestResultsTableFilterComposer get testId {
    final $$TestResultsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testId,
        referencedTable: $state.db.testResults,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TestResultsTableFilterComposer(ComposerState($state.db,
                $state.db.testResults, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$AiRecommendationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AiRecommendationsTable> {
  $$AiRecommendationsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get modelVersion => $state.composableBuilder(
      column: $state.table.modelVersion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get suggestionType => $state.composableBuilder(
      column: $state.table.suggestionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get confidence => $state.composableBuilder(
      column: $state.table.confidence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get featuresJson => $state.composableBuilder(
      column: $state.table.featuresJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get accepted => $state.composableBuilder(
      column: $state.table.accepted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get decisionBy => $state.composableBuilder(
      column: $state.table.decisionBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get decisionAt => $state.composableBuilder(
      column: $state.table.decisionAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get decisionNotes => $state.composableBuilder(
      column: $state.table.decisionNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TestResultsTableOrderingComposer get testId {
    final $$TestResultsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.testId,
        referencedTable: $state.db.testResults,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TestResultsTableOrderingComposer(ComposerState($state.db,
                $state.db.testResults, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ConsentRecordsTableCreateCompanionBuilder = ConsentRecordsCompanion
    Function({
  required String id,
  required String patientId,
  required String consentType,
  required bool granted,
  required DateTime grantedAt,
  Value<DateTime?> expiresAt,
  required String documentVersion,
  Value<String?> ipAddress,
  Value<String?> witnessedBy,
  Value<int> rowid,
});
typedef $$ConsentRecordsTableUpdateCompanionBuilder = ConsentRecordsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> consentType,
  Value<bool> granted,
  Value<DateTime> grantedAt,
  Value<DateTime?> expiresAt,
  Value<String> documentVersion,
  Value<String?> ipAddress,
  Value<String?> witnessedBy,
  Value<int> rowid,
});

class $$ConsentRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConsentRecordsTable,
    ConsentRecord,
    $$ConsentRecordsTableFilterComposer,
    $$ConsentRecordsTableOrderingComposer,
    $$ConsentRecordsTableCreateCompanionBuilder,
    $$ConsentRecordsTableUpdateCompanionBuilder> {
  $$ConsentRecordsTableTableManager(
      _$AppDatabase db, $ConsentRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ConsentRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ConsentRecordsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> consentType = const Value.absent(),
            Value<bool> granted = const Value.absent(),
            Value<DateTime> grantedAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<String> documentVersion = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> witnessedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsentRecordsCompanion(
            id: id,
            patientId: patientId,
            consentType: consentType,
            granted: granted,
            grantedAt: grantedAt,
            expiresAt: expiresAt,
            documentVersion: documentVersion,
            ipAddress: ipAddress,
            witnessedBy: witnessedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String consentType,
            required bool granted,
            required DateTime grantedAt,
            Value<DateTime?> expiresAt = const Value.absent(),
            required String documentVersion,
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> witnessedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsentRecordsCompanion.insert(
            id: id,
            patientId: patientId,
            consentType: consentType,
            granted: granted,
            grantedAt: grantedAt,
            expiresAt: expiresAt,
            documentVersion: documentVersion,
            ipAddress: ipAddress,
            witnessedBy: witnessedBy,
            rowid: rowid,
          ),
        ));
}

class $$ConsentRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get consentType => $state.composableBuilder(
      column: $state.table.consentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get granted => $state.composableBuilder(
      column: $state.table.granted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get grantedAt => $state.composableBuilder(
      column: $state.table.grantedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get documentVersion => $state.composableBuilder(
      column: $state.table.documentVersion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get witnessedBy => $state.composableBuilder(
      column: $state.table.witnessedBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableFilterComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ConsentRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get consentType => $state.composableBuilder(
      column: $state.table.consentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get granted => $state.composableBuilder(
      column: $state.table.granted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get grantedAt => $state.composableBuilder(
      column: $state.table.grantedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get documentVersion => $state.composableBuilder(
      column: $state.table.documentVersion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ipAddress => $state.composableBuilder(
      column: $state.table.ipAddress,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get witnessedBy => $state.composableBuilder(
      column: $state.table.witnessedBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $state.db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PatientsTableOrderingComposer(ComposerState(
                $state.db, $state.db.patients, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$TestResultsTableTableManager get testResults =>
      $$TestResultsTableTableManager(_db, _db.testResults);
  $$ScreeningResultsTableTableManager get screeningResults =>
      $$ScreeningResultsTableTableManager(_db, _db.screeningResults);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$HeadphoneProfilesTableTableManager get headphoneProfiles =>
      $$HeadphoneProfilesTableTableManager(_db, _db.headphoneProfiles);
  $$CalibrationSettingsTableTableManager get calibrationSettings =>
      $$CalibrationSettingsTableTableManager(_db, _db.calibrationSettings);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$BcImportsTableTableManager get bcImports =>
      $$BcImportsTableTableManager(_db, _db.bcImports);
  $$AiRecommendationsTableTableManager get aiRecommendations =>
      $$AiRecommendationsTableTableManager(_db, _db.aiRecommendations);
  $$ConsentRecordsTableTableManager get consentRecords =>
      $$ConsentRecordsTableTableManager(_db, _db.consentRecords);
}
