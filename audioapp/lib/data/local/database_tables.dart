import 'package:drift/drift.dart';

/// Patients table - stores patient demographic information
/// HIPAA Note: Contains PHI - must be encrypted at rest
@DataClassName('DbPatient')
class Patients extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get medicalRecordNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get audiologistId => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Test results table - stores audiometric test data
/// HIPAA Note: Contains PHI - must be encrypted at rest
@DataClassName('DbTestResult')
class TestResults extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get audiologistId => text()();
  DateTimeColumn get testDate => dateTime()();
  TextColumn get testType => text().withDefault(const Constant('air'))(); // 'air', 'bone', 'screening'
  TextColumn get screeningId => text().nullable()(); // links to ScreeningResults.id
  TextColumn get headphoneModel => text().nullable()();
  RealColumn get ambientNoiseDb => real().nullable()();
  TextColumn get rightEarResults => text()(); // JSON encoded
  TextColumn get leftEarResults => text()();   // JSON encoded
  RealColumn get rightPta => real()();
  RealColumn get leftPta => real()();
  TextColumn get rightClassification => text()();
  TextColumn get leftClassification => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get recommendations => text().nullable()();
  BoolColumn get isComplete => boolean().withDefault(const Constant(true))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Screening results table - for patient self-screening
class ScreeningResults extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get testDate => dateTime()();
  TextColumn get headphoneModel => text().nullable()();
  RealColumn get ambientNoiseDb => real().nullable()();
  TextColumn get result => text()(); // 'pass', 'refer', 'incomplete'
  TextColumn get frequenciesTested => text()(); // JSON array
  TextColumn get thresholds => text()(); // JSON object {frequency: dB}
  TextColumn get deviceInfo => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Users table - stores user account information
/// HIPAA Note: Contains user credentials and role info
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();
  TextColumn get role => text()(); // 'patient', 'audiologist', 'superAdmin'
  TextColumn get avatarUrl => text().nullable()();
  
  // Audiologist-specific fields
  TextColumn get licenseNumber => text().nullable()();
  TextColumn get licenseState => text().nullable()();
  DateTimeColumn get licenseExpiryDate => dateTime().nullable()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  TextColumn get verifiedBy => text().nullable()();
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  
  // Security fields
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSuspended => boolean().withDefault(const Constant(false))();
  TextColumn get suspensionReason => text().nullable()();
  IntColumn get failedLoginAttempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get lockedUntil => dateTime().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  TextColumn get lastLoginIp => text().nullable()();
  
  // Timestamps
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Audit log table - HIPAA-compliant activity logging
/// Records all access to PHI and significant actions
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get userEmail => text()();
  TextColumn get action => text()(); // 'view', 'create', 'update', 'delete', 'export', 'login', 'logout'
  TextColumn get resourceType => text()(); // 'patient', 'test_result', 'user', 'report'
  TextColumn get resourceId => text().nullable()();
  TextColumn get details => text().nullable()(); // JSON with additional context
  TextColumn get ipAddress => text().nullable()();
  TextColumn get userAgent => text().nullable()();
  TextColumn get sessionId => text().nullable()();
  BoolColumn get success => boolean().withDefault(const Constant(true))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  // Audit logs should never be deleted, only archived
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Session management table
class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text().nullable()();
  TextColumn get deviceType => text().nullable()(); // 'ios', 'android'
  TextColumn get ipAddress => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastActivityAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Headphone calibration profiles table
class HeadphoneProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  TextColumn get type => text()(); // 'professional', 'validated', 'generic'
  TextColumn get retsplValues => text()(); // JSON {frequency: dB SPL}
  TextColumn get corrections => text().nullable()(); // JSON {frequency: correction}
  BoolColumn get isValidated => boolean().withDefault(const Constant(false))();
  DateTimeColumn get validationDate => dateTime().nullable()();
  RealColumn get validationAccuracy => real().nullable()(); // RMSD
  IntColumn get participantCount => integer().nullable()();
  TextColumn get approvedUsage => text()(); // 'diagnostic', 'screening', 'screeningWithWarning'
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Calibration settings table
class CalibrationSettings extends Table {
  TextColumn get id => text()();
  IntColumn get frequency => integer()();
  RealColumn get correction => real()();
  DateTimeColumn get calibratedAt => dateTime()();
  TextColumn get calibratedBy => text()();
  TextColumn get headphoneProfileId => text().nullable()();
  TextColumn get notes => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id, frequency};
}

/// App settings table (non-PHI)
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {key};
}

/// BC import records - bridge uploads from vendor software
class BcImports extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get screeningId => text().nullable()();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  TextColumn get fileType => text()(); // 'pdf', 'xml', 'hl7'
  TextColumn get importedBy => text()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, parsed, failed
  TextColumn get notes => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// AI recommendations for AC+BC combined analysis
@DataClassName('AiRecommendation')
class AiRecommendations extends Table {
  TextColumn get id => text()();
  TextColumn get testId => text().references(TestResults, #id)();
  TextColumn get modelVersion => text()();
  TextColumn get suggestionType => text()(); // conductive, sensorineural, mixed
  RealColumn get confidence => real()();
  TextColumn get featuresJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get accepted => boolean().nullable()();
  TextColumn get decisionBy => text().nullable()();
  DateTimeColumn get decisionAt => dateTime().nullable()();
  TextColumn get decisionNotes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Consent records table - tracks patient consents
class ConsentRecords extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get consentType => text()(); // 'data_collection', 'testing', 'sharing'
  BoolColumn get granted => boolean()();
  DateTimeColumn get grantedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  TextColumn get documentVersion => text()();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get witnessedBy => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}
