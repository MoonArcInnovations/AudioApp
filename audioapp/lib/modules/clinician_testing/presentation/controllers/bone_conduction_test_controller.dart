import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/audiogram_chart.dart';
import '../../domain/services/clinician_tone_player.dart';

class BoneConductionState {
  final int currentFrequency;
  final int currentIntensity;
  final Ear currentEar;
  final bool isPlaying;
  final bool isMasking;
  final int maskingLevel;
  final List<AudiogramPoint> rightEarResults;
  final List<AudiogramPoint> leftEarResults;
  final bool testComplete;
  final int currentFrequencyIndex;

  const BoneConductionState({
    this.currentFrequency = 1000,
    this.currentIntensity = 40,
    this.currentEar = Ear.right,
    this.isPlaying = false,
    this.isMasking = false,
    this.maskingLevel = 40,
    this.rightEarResults = const [],
    this.leftEarResults = const [],
    this.testComplete = false,
    this.currentFrequencyIndex = 0,
  });

  BoneConductionState copyWith({
    int? currentFrequency,
    int? currentIntensity,
    Ear? currentEar,
    bool? isPlaying,
    bool? isMasking,
    int? maskingLevel,
    List<AudiogramPoint>? rightEarResults,
    List<AudiogramPoint>? leftEarResults,
    bool? testComplete,
    int? currentFrequencyIndex,
  }) {
    return BoneConductionState(
      currentFrequency: currentFrequency ?? this.currentFrequency,
      currentIntensity: currentIntensity ?? this.currentIntensity,
      currentEar: currentEar ?? this.currentEar,
      isPlaying: isPlaying ?? this.isPlaying,
      isMasking: isMasking ?? this.isMasking,
      maskingLevel: maskingLevel ?? this.maskingLevel,
      rightEarResults: rightEarResults ?? this.rightEarResults,
      leftEarResults: leftEarResults ?? this.leftEarResults,
      testComplete: testComplete ?? this.testComplete,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
    );
  }
}

class BoneConductionNotifier extends StateNotifier<BoneConductionState> {
  BoneConductionNotifier(this._tonePlayer)
    : super(const BoneConductionState()) {
    _tonePlayer.initialize();
  }

  static const List<int> bcFrequencies = [250, 500, 1000, 2000, 4000];

  final ClinicianTonePlayer _tonePlayer;

  void setFrequency(int frequency) {
    final index = bcFrequencies.indexOf(frequency);
    state = state.copyWith(
      currentFrequency: frequency,
      currentFrequencyIndex: index >= 0 ? index : 0,
    );
  }

  void increaseIntensity() {
    if (state.currentIntensity < 70) {
      state = state.copyWith(currentIntensity: state.currentIntensity + 5);
    }
  }

  void decreaseIntensity() {
    if (state.currentIntensity > -10) {
      state = state.copyWith(currentIntensity: state.currentIntensity - 5);
    }
  }

  void toggleEar() {
    state = state.copyWith(
      currentEar: state.currentEar == Ear.right ? Ear.left : Ear.right,
    );
  }

  void toggleMasking() {
    state = state.copyWith(isMasking: !state.isMasking);
  }

  void adjustMaskingLevel(int delta) {
    final newLevel = (state.maskingLevel + delta).clamp(0, 100);
    state = state.copyWith(maskingLevel: newLevel);
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
    final nextIndex = state.currentFrequencyIndex + 1;

    if (nextIndex < bcFrequencies.length) {
      state = state.copyWith(
        currentFrequency: bcFrequencies[nextIndex],
        currentFrequencyIndex: nextIndex,
        currentIntensity: 40,
      );
    } else if (state.currentEar == Ear.right) {
      state = state.copyWith(
        currentEar: Ear.left,
        currentFrequency: bcFrequencies[0],
        currentFrequencyIndex: 0,
        currentIntensity: 40,
      );
    } else {
      state = state.copyWith(testComplete: true);
    }
  }

  void resetTest() {
    state = const BoneConductionState();
  }

  @override
  void dispose() {
    _tonePlayer.dispose();
    super.dispose();
  }
}
