import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../application/use_cases/add_bc_import_use_case.dart';
import '../../application/use_cases/add_clinician_patient_use_case.dart';
import '../../application/use_cases/delete_clinician_patient_use_case.dart';
import '../../application/use_cases/delete_clinician_test_use_case.dart';
import '../../application/use_cases/get_bc_imports_for_patient_use_case.dart';
import '../../application/use_cases/get_bc_imports_use_case.dart';
import '../../application/use_cases/get_clinician_patients_use_case.dart';
import '../../application/use_cases/get_clinician_test_results_use_case.dart';
import '../../application/use_cases/get_tests_for_patient_use_case.dart';
import '../../application/use_cases/save_clinician_test_use_case.dart';
import '../../application/use_cases/update_clinician_patient_use_case.dart';
import '../../application/use_cases/update_clinician_test_use_case.dart';
import '../../domain/entities/clinician_bc_import_record.dart';
import '../../domain/entities/clinician_patient_record.dart';
import '../../domain/entities/clinician_test_record.dart';
import '../../infrastructure/providers/clinician_testing_infrastructure_providers.dart';
import '../controllers/air_conduction_test_controller.dart';
import '../controllers/bone_conduction_test_controller.dart';
import '../view_models/bc_import_view_model.dart';
import '../view_models/clinician_patient_view_model.dart';
import '../view_models/clinician_test_detail_view_model.dart';
import '../view_models/clinician_test_summary_view_model.dart';

final getClinicianPatientsUseCaseProvider =
    Provider<GetClinicianPatientsUseCase>((ref) {
      return GetClinicianPatientsUseCase(
        ref.watch(clinicianPatientRepositoryProvider),
      );
    });

final addClinicianPatientUseCaseProvider = Provider<AddClinicianPatientUseCase>(
  (ref) {
    return AddClinicianPatientUseCase(
      ref.watch(clinicianPatientRepositoryProvider),
    );
  },
);

final updateClinicianPatientUseCaseProvider =
    Provider<UpdateClinicianPatientUseCase>((ref) {
      return UpdateClinicianPatientUseCase(
        ref.watch(clinicianPatientRepositoryProvider),
      );
    });

final deleteClinicianPatientUseCaseProvider =
    Provider<DeleteClinicianPatientUseCase>((ref) {
      return DeleteClinicianPatientUseCase(
        ref.watch(clinicianPatientRepositoryProvider),
      );
    });

final getClinicianTestResultsUseCaseProvider =
    Provider<GetClinicianTestResultsUseCase>((ref) {
      return GetClinicianTestResultsUseCase(
        ref.watch(clinicianTestRepositoryProvider),
      );
    });

final getTestsForPatientUseCaseProvider = Provider<GetTestsForPatientUseCase>((
  ref,
) {
  return GetTestsForPatientUseCase(ref.watch(clinicianTestRepositoryProvider));
});

final saveClinicianTestUseCaseProvider = Provider<SaveClinicianTestUseCase>((
  ref,
) {
  return SaveClinicianTestUseCase(ref.watch(clinicianTestRepositoryProvider));
});

final updateClinicianTestUseCaseProvider = Provider<UpdateClinicianTestUseCase>(
  (ref) {
    return UpdateClinicianTestUseCase(
      ref.watch(clinicianTestRepositoryProvider),
    );
  },
);

final deleteClinicianTestUseCaseProvider = Provider<DeleteClinicianTestUseCase>(
  (ref) {
    return DeleteClinicianTestUseCase(
      ref.watch(clinicianTestRepositoryProvider),
    );
  },
);

final addBcImportUseCaseProvider = Provider<AddBcImportUseCase>((ref) {
  return AddBcImportUseCase(ref.watch(clinicianBcImportRepositoryProvider));
});

final getBcImportsUseCaseProvider = Provider<GetBcImportsUseCase>((ref) {
  return GetBcImportsUseCase(ref.watch(clinicianBcImportRepositoryProvider));
});

final getBcImportsForPatientUseCaseProvider =
    Provider<GetBcImportsForPatientUseCase>((ref) {
      return GetBcImportsForPatientUseCase(
        ref.watch(clinicianBcImportRepositoryProvider),
      );
    });

class ClinicianPatientsNotifier
    extends StateNotifier<List<ClinicianPatientRecord>> {
  ClinicianPatientsNotifier(this._ref) : super(const []) {
    _load();
    _ref.listen<AuthState>(authStateProvider, (_, _) => _load());
  }

  final Ref _ref;
  bool _isLoading = false;

  Future<void> _load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      state = const [];
      _isLoading = false;
      return;
    }

    state = await _ref.read(getClinicianPatientsUseCaseProvider)(user.id);
    _isLoading = false;
  }

  Future<void> refresh() => _load();

  Future<ClinicianPatientRecord?> addPatient({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
  }) async {
    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      return null;
    }

    final patient = await _ref.read(addClinicianPatientUseCaseProvider)(
      AddClinicianPatientParams(
        name: name,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        email: email,
        notes: notes,
        audiologistId: user.id,
        createdBy: user.id,
      ),
    );
    await _load();
    return patient;
  }

  Future<ClinicianPatientViewModel?> addPatientRecord({
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
  }) async {
    final patient = await addPatient(
      name: name,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      email: email,
      notes: notes,
    );
    return patient == null ? null : _toClinicianPatientViewModel(patient);
  }

  Future<void> updatePatient(ClinicianPatientRecord patient) async {
    await _ref.read(updateClinicianPatientUseCaseProvider)(patient);
    await _load();
  }

  Future<void> updatePatientRecord({
    required ClinicianPatientViewModel patient,
    required String name,
    required DateTime dateOfBirth,
    String? phoneNumber,
    String? email,
    String? notes,
  }) async {
    await updatePatient(
      ClinicianPatientRecord(
        id: patient.id,
        name: name,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        email: email,
        gender: patient.gender,
        medicalRecordNumber: patient.medicalRecordNumber,
        notes: notes,
        createdAt: patient.createdAt,
        audiologistId: patient.audiologistId,
        createdBy: patient.createdBy,
        synced: false,
      ),
    );
  }

  Future<void> deletePatient(String id) async {
    await _ref.read(deleteClinicianPatientUseCaseProvider)(id);
    await _load();
  }
}

class ClinicianTestResultsNotifier
    extends StateNotifier<List<ClinicianTestRecord>> {
  ClinicianTestResultsNotifier(this._ref) : super(const []) {
    _load();
    _ref.listen<AuthState>(authStateProvider, (_, _) => _load());
  }

  final Ref _ref;
  bool _isLoading = false;

  Future<void> _load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      state = const [];
      _isLoading = false;
      return;
    }

    state = await _ref.read(getClinicianTestResultsUseCaseProvider)(user.id);
    _isLoading = false;
  }

  Future<void> refresh() => _load();

  Future<ClinicianTestRecord?> saveTest({
    required String patientId,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? testType,
    String? screeningId,
    String? headphoneModel,
    double? ambientNoiseDb,
    String? notes,
    String? recommendations,
  }) async {
    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      return null;
    }

    final result = await _ref.read(saveClinicianTestUseCaseProvider)(
      SaveClinicianTestParams(
        patientId: patientId,
        audiologistId: user.id,
        rightEarResults: rightEarResults,
        leftEarResults: leftEarResults,
        testType: testType,
        screeningId: screeningId,
        headphoneModel: headphoneModel,
        ambientNoiseDb: ambientNoiseDb,
        notes: notes,
        recommendations: recommendations,
      ),
    );
    await _load();
    return result;
  }

  Future<void> updateTest(ClinicianTestRecord test) async {
    await _ref.read(updateClinicianTestUseCaseProvider)(test);
    await _load();
  }

  Future<void> updateTestNotes({
    required String testId,
    String? notes,
    String? recommendations,
  }) async {
    final existing = state.where((value) => value.id == testId).firstOrNull;
    if (existing == null) {
      return;
    }
    await updateTest(
      existing.copyWith(notes: notes, recommendations: recommendations),
    );
  }

  Future<void> deleteTest(String testId) async {
    await _ref.read(deleteClinicianTestUseCaseProvider)(testId);
    await _load();
  }
}

ClinicianTestSummaryViewModel _toClinicianTestSummaryViewModel(
  ClinicianTestRecord test,
) {
  return ClinicianTestSummaryViewModel(
    id: test.id,
    patientId: test.patientId,
    audiologistId: test.audiologistId,
    testDate: test.testDate,
    testType: test.testType,
    screeningId: test.screeningId,
    headphoneModel: test.headphoneModel,
    ambientNoiseDb: test.ambientNoiseDb,
    rightEarResults: test.rightEarResults,
    leftEarResults: test.leftEarResults,
    rightPta: test.rightPta,
    leftPta: test.leftPta,
    rightClassification: test.rightClassification,
    leftClassification: test.leftClassification,
    overallClassification: test.overallClassification,
    overallStatusColor: test.overallStatusColor,
    notes: test.notes,
    recommendations: test.recommendations,
  );
}

ClinicianPatientViewModel _toClinicianPatientViewModel(
  ClinicianPatientRecord patient,
) {
  return ClinicianPatientViewModel(
    id: patient.id,
    name: patient.name,
    dateOfBirth: patient.dateOfBirth,
    phoneNumber: patient.phoneNumber,
    email: patient.email,
    gender: patient.gender,
    medicalRecordNumber: patient.medicalRecordNumber,
    notes: patient.notes,
    createdAt: patient.createdAt,
    audiologistId: patient.audiologistId,
    createdBy: patient.createdBy,
    synced: patient.synced,
  );
}

Map<int, int> _computeAirBoneGap(
  List<AudiogramPoint> ac,
  List<AudiogramPoint> bc,
) {
  final acMap = {for (final point in ac) point.frequency: point.thresholdDb};
  final bcMap = {for (final point in bc) point.frequency: point.thresholdDb};
  final shared = acMap.keys.where(bcMap.containsKey).toList()..sort();
  return {
    for (final frequency in shared)
      frequency: acMap[frequency]! - bcMap[frequency]!,
  };
}

BcImportViewModel _toBcImportViewModel(ClinicianBcImportRecord item) {
  return BcImportViewModel(
    id: item.id,
    patientId: item.patientId,
    screeningId: item.screeningId,
    fileName: item.fileName,
    fileType: item.fileType,
    status: item.status,
    importedAt: item.importedAt,
  );
}

class BcImportSaveController
    extends StateNotifier<AsyncValue<BcImportViewModel?>> {
  BcImportSaveController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<BcImportViewModel?> save({
    required String patientId,
    String? screeningId,
    required File sourceFile,
    required String fileType,
  }) async {
    state = const AsyncValue.loading();
    final user = _ref.read(authStateProvider).user;
    if (user == null) {
      state = const AsyncValue.data(null);
      return null;
    }

    try {
      final result = await _ref.read(addBcImportUseCaseProvider)(
        AddBcImportParams(
          patientId: patientId,
          screeningId: screeningId,
          sourceFile: sourceFile,
          fileType: fileType,
          importedBy: user.id,
        ),
      );
      final mapped = _toBcImportViewModel(result);
      state = AsyncValue.data(mapped);
      return mapped;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final clinicianPatientsProvider =
    StateNotifierProvider<
      ClinicianPatientsNotifier,
      List<ClinicianPatientRecord>
    >((ref) => ClinicianPatientsNotifier(ref));

final clinicianTestResultsProvider =
    StateNotifierProvider<
      ClinicianTestResultsNotifier,
      List<ClinicianTestRecord>
    >((ref) => ClinicianTestResultsNotifier(ref));

final clinicianPatientProvider =
    Provider.family<ClinicianPatientRecord?, String>((ref, patientId) {
      final patients = ref.watch(clinicianPatientsProvider);
      return patients.where((value) => value.id == patientId).firstOrNull;
    });

final clinicianPatientSummariesProvider =
    Provider<List<ClinicianPatientViewModel>>((ref) {
      final patients = ref.watch(clinicianPatientsProvider);
      return patients.map(_toClinicianPatientViewModel).toList();
    });

final clinicianPatientSummaryProvider =
    Provider.family<ClinicianPatientViewModel?, String>((ref, patientId) {
      final patients = ref.watch(clinicianPatientSummariesProvider);
      return patients.where((value) => value.id == patientId).firstOrNull;
    });

final clinicianPatientTestsProvider =
    Provider.family<List<ClinicianTestRecord>, String>((ref, patientId) {
      final tests = ref.watch(clinicianTestResultsProvider);
      return tests.where((value) => value.patientId == patientId).toList()
        ..sort((a, b) => b.testDate.compareTo(a.testDate));
    });

final clinicianTestSummariesProvider =
    Provider<List<ClinicianTestSummaryViewModel>>((ref) {
      final tests = ref.watch(clinicianTestResultsProvider);
      return tests.map(_toClinicianTestSummaryViewModel).toList();
    });

final clinicianPatientTestSummariesProvider =
    Provider.family<List<ClinicianTestSummaryViewModel>, String>((
      ref,
      patientId,
    ) {
      return ref
          .watch(clinicianPatientTestsProvider(patientId))
          .map(_toClinicianTestSummaryViewModel)
          .toList();
    });

final clinicianTestByIdProvider = Provider.family<ClinicianTestRecord?, String>(
  (ref, testId) {
    final tests = ref.watch(clinicianTestResultsProvider);
    return tests.where((value) => value.id == testId).firstOrNull;
  },
);

final clinicianTestSummaryByIdProvider =
    Provider.family<ClinicianTestSummaryViewModel?, String>((ref, testId) {
      final tests = ref.watch(clinicianTestSummariesProvider);
      return tests.where((value) => value.id == testId).firstOrNull;
    });

final clinicianTestDetailProvider =
    Provider.family<ClinicianTestDetailViewModel?, String>((ref, testId) {
      final test = ref.watch(clinicianTestByIdProvider(testId));
      if (test == null) {
        return null;
      }

      final patientTests = ref.watch(
        clinicianPatientTestsProvider(test.patientId),
      );
      final related = ref
          .watch(testPairingServiceProvider)
          .findRelatedTest(test, patientTests);

      if (related == null) {
        return ClinicianTestDetailViewModel(
          test: _toClinicianTestSummaryViewModel(test),
          relatedTest: null,
          rightAirBoneGap: const {},
          leftAirBoneGap: const {},
        );
      }

      final ac = test.testType == 'bone' ? related : test;
      final bc = test.testType == 'bone' ? test : related;
      final hasPair = ac.testType != 'bone' && bc.testType == 'bone';

      return ClinicianTestDetailViewModel(
        test: _toClinicianTestSummaryViewModel(test),
        relatedTest: _toClinicianTestSummaryViewModel(related),
        rightAirBoneGap: hasPair
            ? _computeAirBoneGap(ac.rightEarResults, bc.rightEarResults)
            : const {},
        leftAirBoneGap: hasPair
            ? _computeAirBoneGap(ac.leftEarResults, bc.leftEarResults)
            : const {},
      );
    });

final clinicianBcImportListProvider = FutureProvider<List<BcImportViewModel>>((
  ref,
) async {
  final items = await ref.watch(getBcImportsUseCaseProvider)(const NoParams());
  return items.map(_toBcImportViewModel).toList();
});

final clinicianBcImportForPatientProvider =
    FutureProvider.family<List<BcImportViewModel>, String>((
      ref,
      patientId,
    ) async {
      final items = await ref.watch(getBcImportsForPatientUseCaseProvider)(
        patientId,
      );
      return items.map(_toBcImportViewModel).toList();
    });

final clinicianBcImportSaveProvider =
    StateNotifierProvider<
      BcImportSaveController,
      AsyncValue<BcImportViewModel?>
    >((ref) => BcImportSaveController(ref));

final testingStateProvider =
    StateNotifierProvider.autoDispose<TestingStateNotifier, TestingState>(
      (ref) => TestingStateNotifier(ref.watch(clinicianTonePlayerProvider)),
    );

final boneConductionProvider =
    StateNotifierProvider.autoDispose<
      BoneConductionNotifier,
      BoneConductionState
    >((ref) => BoneConductionNotifier(ref.watch(clinicianTonePlayerProvider)));
