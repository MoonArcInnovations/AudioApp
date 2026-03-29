import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../domain/services/clinician_tone_player.dart';

class TestingState {
  final int currentFrequency;
  final int currentIntensity;
  final Ear currentEar;
  final bool isPlaying;
  final List<AudiogramPoint> rightEarResults;
  final List<AudiogramPoint> leftEarResults;
  final bool testComplete;
  final int currentFrequencyIndex;

  const TestingState({
    this.currentFrequency = 1000,
    this.currentIntensity = 40,
    this.currentEar = Ear.right,
    this.isPlaying = false,
    this.rightEarResults = const [],
    this.leftEarResults = const [],
    this.testComplete = false,
    this.currentFrequencyIndex = 0,
  });

  TestingState copyWith({
    int? currentFrequency,
    int? currentIntensity,
    Ear? currentEar,
    bool? isPlaying,
    List<AudiogramPoint>? rightEarResults,
    List<AudiogramPoint>? leftEarResults,
    bool? testComplete,
    int? currentFrequencyIndex,
  }) {
    return TestingState(
      currentFrequency: currentFrequency ?? this.currentFrequency,
      currentIntensity: currentIntensity ?? this.currentIntensity,
      currentEar: currentEar ?? this.currentEar,
      isPlaying: isPlaying ?? this.isPlaying,
      rightEarResults: rightEarResults ?? this.rightEarResults,
      leftEarResults: leftEarResults ?? this.leftEarResults,
      testComplete: testComplete ?? this.testComplete,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
    );
  }
}

class TestingStateNotifier extends StateNotifier<TestingState> {
  TestingStateNotifier(this._tonePlayer) : super(const TestingState()) {
    _tonePlayer.initialize();
  }

  final ClinicianTonePlayer _tonePlayer;

  void setFrequency(int frequency) {
    final index = AppConstants.standardFrequencies.indexOf(frequency);
    state = state.copyWith(
      currentFrequency: frequency,
      currentFrequencyIndex: index >= 0 ? index : 0,
    );
  }

  void increaseIntensity() {
    if (state.currentIntensity < AppConstants.maxIntensity) {
      state = state.copyWith(
        currentIntensity: state.currentIntensity + AppConstants.intensityStep,
      );
    }
  }

  void decreaseIntensity() {
    if (state.currentIntensity > AppConstants.minIntensity) {
      state = state.copyWith(
        currentIntensity: state.currentIntensity - AppConstants.intensityStep,
      );
    }
  }

  void setIntensity(int intensity) {
    final clamped = intensity.clamp(
      AppConstants.minIntensity,
      AppConstants.maxIntensity,
    );
    state = state.copyWith(currentIntensity: clamped);
  }

  void toggleEar() {
    state = state.copyWith(
      currentEar: state.currentEar == Ear.right ? Ear.left : Ear.right,
    );
  }

  void setEar(Ear ear) {
    state = state.copyWith(currentEar: ear);
  }

  Future<void> playTone() async {
    if (state.isPlaying) {
      return;
    }

    state = state.copyWith(isPlaying: true);

    await _tonePlayer.playTone(
      frequency: state.currentFrequency,
      intensityDbHl: state.currentIntensity,
      ear: state.currentEar,
    );

    state = state.copyWith(isPlaying: false);
  }

  void recordResponse() {
    final point = AudiogramPoint(
      frequency: state.currentFrequency,
      thresholdDb: state.currentIntensity,
      ear: state.currentEar,
    );

    if (state.currentEar == Ear.right) {
      final updated = List<AudiogramPoint>.from(state.rightEarResults)
        ..removeWhere((value) => value.frequency == state.currentFrequency)
        ..add(point);
      state = state.copyWith(rightEarResults: updated);
    } else {
      final updated = List<AudiogramPoint>.from(state.leftEarResults)
        ..removeWhere((value) => value.frequency == state.currentFrequency)
        ..add(point);
      state = state.copyWith(leftEarResults: updated);
    }

    _advanceToNextFrequency();
  }

  void recordNoResponse() {
    final point = AudiogramPoint(
      frequency: state.currentFrequency,
      thresholdDb: state.currentIntensity,
      ear: state.currentEar,
      noResponse: true,
    );

    if (state.currentEar == Ear.right) {
      final updated = List<AudiogramPoint>.from(state.rightEarResults)
        ..removeWhere((value) => value.frequency == state.currentFrequency)
        ..add(point);
      state = state.copyWith(rightEarResults: updated);
    } else {
      final updated = List<AudiogramPoint>.from(state.leftEarResults)
        ..removeWhere((value) => value.frequency == state.currentFrequency)
        ..add(point);
      state = state.copyWith(leftEarResults: updated);
    }

    _advanceToNextFrequency();
  }

  void _advanceToNextFrequency() {
    final frequencies = AppConstants.standardFrequencies;
    final nextIndex = state.currentFrequencyIndex + 1;

    if (nextIndex < frequencies.length) {
      state = state.copyWith(
        currentFrequency: frequencies[nextIndex],
        currentFrequencyIndex: nextIndex,
        currentIntensity: 40,
      );
    } else if (state.currentEar == Ear.right) {
      state = state.copyWith(
        currentEar: Ear.left,
        currentFrequency: frequencies[0],
        currentFrequencyIndex: 0,
        currentIntensity: 40,
      );
    } else {
      state = state.copyWith(testComplete: true);
    }
  }

  void resetTest() {
    state = const TestingState();
  }

  @override
  void dispose() {
    _tonePlayer.dispose();
    super.dispose();
  }
}
