import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../application/use_cases/get_saved_calibrations_use_case.dart';
import '../../application/use_cases/play_calibration_tone_use_case.dart';
import '../../application/use_cases/save_calibration_correction_use_case.dart';

class ManualCalibrationState {
  const ManualCalibrationState({
    this.currentFrequency = 1000,
    this.currentCorrection = 0,
    this.isPlaying = false,
    this.isLoading = true,
    this.calibrations = const {},
    this.isComplete = false,
  });

  final int currentFrequency;
  final double currentCorrection;
  final bool isPlaying;
  final bool isLoading;
  final Map<int, double> calibrations;
  final bool isComplete;

  ManualCalibrationState copyWith({
    int? currentFrequency,
    double? currentCorrection,
    bool? isPlaying,
    bool? isLoading,
    Map<int, double>? calibrations,
    bool? isComplete,
  }) {
    return ManualCalibrationState(
      currentFrequency: currentFrequency ?? this.currentFrequency,
      currentCorrection: currentCorrection ?? this.currentCorrection,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      calibrations: calibrations ?? this.calibrations,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class ManualCalibrationController
    extends StateNotifier<ManualCalibrationState> {
  ManualCalibrationController({
    required GetSavedCalibrationsUseCase getSavedCalibrationsUseCase,
    required SaveCalibrationCorrectionUseCase saveCalibrationCorrectionUseCase,
    required PlayCalibrationToneUseCase playCalibrationToneUseCase,
    required String Function() readCalibratorId,
    required void Function() refreshSavedCalibrations,
  }) : _getSavedCalibrationsUseCase = getSavedCalibrationsUseCase,
       _saveCalibrationCorrectionUseCase = saveCalibrationCorrectionUseCase,
       _playCalibrationToneUseCase = playCalibrationToneUseCase,
       _readCalibratorId = readCalibratorId,
       _refreshSavedCalibrations = refreshSavedCalibrations,
       super(const ManualCalibrationState()) {
    _initialize();
  }

  final GetSavedCalibrationsUseCase _getSavedCalibrationsUseCase;
  final SaveCalibrationCorrectionUseCase _saveCalibrationCorrectionUseCase;
  final PlayCalibrationToneUseCase _playCalibrationToneUseCase;
  final String Function() _readCalibratorId;
  final void Function() _refreshSavedCalibrations;
  bool _disposed = false;

  Future<void> _initialize() async {
    final calibrations = await _getSavedCalibrationsUseCase(const NoParams());
    if (_disposed) {
      return;
    }

    final currentCorrection = calibrations[state.currentFrequency] ?? 0;
    state = state.copyWith(
      isLoading: false,
      calibrations: calibrations,
      currentCorrection: currentCorrection,
      isComplete: _allStandardFrequenciesCalibrated(calibrations),
    );
  }

  void setFrequency(int frequency) {
    state = state.copyWith(
      currentFrequency: frequency,
      currentCorrection: state.calibrations[frequency] ?? 0,
    );
  }

  void adjustCorrection(double delta) {
    setCorrection(state.currentCorrection + delta);
  }

  void setCorrection(double correction) {
    state = state.copyWith(currentCorrection: correction.clamp(-20.0, 20.0));
  }

  Future<void> playTestTone() async {
    if (state.isPlaying) {
      return;
    }

    state = state.copyWith(isPlaying: true);
    try {
      await _playCalibrationToneUseCase(
        PlayCalibrationToneParams(
          frequency: state.currentFrequency,
          intensityDbHl: 60 + state.currentCorrection.round(),
          ear: Ear.right,
          durationMs: 2000,
        ),
      );
    } finally {
      if (!_disposed) {
        state = state.copyWith(isPlaying: false);
      }
    }
  }

  Future<void> saveCurrentCalibration() async {
    final updated = Map<int, double>.from(state.calibrations)
      ..[state.currentFrequency] = state.currentCorrection;

    await _saveCalibrationCorrectionUseCase(
      SaveCalibrationCorrectionParams(
        frequency: state.currentFrequency,
        correction: state.currentCorrection,
        calibratedBy: _readCalibratorId(),
      ),
    );

    if (_disposed) {
      return;
    }

    state = state.copyWith(
      calibrations: updated,
      isComplete: _allStandardFrequenciesCalibrated(updated),
    );
    _refreshSavedCalibrations();
  }

  void resetCalibration() {
    state = const ManualCalibrationState(isLoading: false);
  }

  bool _allStandardFrequenciesCalibrated(Map<int, double> calibrations) {
    return AppConstants.standardFrequencies.every(calibrations.containsKey);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
