import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../application/use_cases/play_calibration_tone_use_case.dart';
import '../../application/use_cases/stop_calibration_tone_use_case.dart';
import '../../domain/entities/headphone_profile.dart';

class HeadphoneCalibrationState {
  const HeadphoneCalibrationState({
    this.selectedProfile,
    this.isPlayingTone = false,
    this.testFrequency = 1000,
    this.testEar = Ear.right,
  });

  final HeadphoneProfileType? selectedProfile;
  final bool isPlayingTone;
  final int testFrequency;
  final Ear testEar;

  HeadphoneCalibrationState copyWith({
    HeadphoneProfileType? selectedProfile,
    bool clearSelectedProfile = false,
    bool? isPlayingTone,
    int? testFrequency,
    Ear? testEar,
  }) {
    return HeadphoneCalibrationState(
      selectedProfile: clearSelectedProfile
          ? null
          : (selectedProfile ?? this.selectedProfile),
      isPlayingTone: isPlayingTone ?? this.isPlayingTone,
      testFrequency: testFrequency ?? this.testFrequency,
      testEar: testEar ?? this.testEar,
    );
  }
}

class HeadphoneCalibrationController
    extends StateNotifier<HeadphoneCalibrationState> {
  HeadphoneCalibrationController({
    required PlayCalibrationToneUseCase playCalibrationToneUseCase,
    required StopCalibrationToneUseCase stopCalibrationToneUseCase,
  }) : _playCalibrationToneUseCase = playCalibrationToneUseCase,
       _stopCalibrationToneUseCase = stopCalibrationToneUseCase,
       super(const HeadphoneCalibrationState());

  final PlayCalibrationToneUseCase _playCalibrationToneUseCase;
  final StopCalibrationToneUseCase _stopCalibrationToneUseCase;
  bool _disposed = false;

  void selectProfile(HeadphoneProfileType profileType) {
    state = state.copyWith(selectedProfile: profileType);
  }

  void selectTestFrequency(int frequency) {
    state = state.copyWith(testFrequency: frequency);
  }

  void selectTestEar(Ear ear) {
    state = state.copyWith(testEar: ear);
  }

  Future<void> toggleGeneralTone() async {
    if (state.isPlayingTone) {
      await _stopTone();
      return;
    }

    await _playTone(
      frequency: state.testFrequency,
      intensityDbHl: 40,
      durationMs: 3000,
    );
  }

  Future<void> toggleProfileTone(HeadphoneProfileType profileType) async {
    if (state.isPlayingTone && state.selectedProfile == profileType) {
      await _stopTone();
      return;
    }

    state = state.copyWith(selectedProfile: profileType);
    await _playTone(frequency: 1000, intensityDbHl: 40, durationMs: 2000);
  }

  Future<void> _playTone({
    required int frequency,
    required int intensityDbHl,
    required int durationMs,
  }) async {
    state = state.copyWith(isPlayingTone: true);
    try {
      await _playCalibrationToneUseCase(
        PlayCalibrationToneParams(
          frequency: frequency,
          intensityDbHl: intensityDbHl,
          ear: state.testEar,
          durationMs: durationMs,
        ),
      );
    } finally {
      if (!_disposed) {
        state = state.copyWith(isPlayingTone: false);
      }
    }
  }

  Future<void> _stopTone() async {
    await _stopCalibrationToneUseCase(const NoParams());
    if (!_disposed) {
      state = state.copyWith(isPlayingTone: false);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
