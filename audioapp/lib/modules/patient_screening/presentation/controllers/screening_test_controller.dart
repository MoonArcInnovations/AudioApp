import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/application/use_case.dart';
import '../../../../core/constants/app_constants.dart';
import '../../application/use_cases/play_screening_tone_use_case.dart';
import '../../application/use_cases/stop_screening_tone_use_case.dart';

enum ScreeningTestPhase { instructions, testing, switching, complete }

class ScreeningSessionConfig {
  const ScreeningSessionConfig({
    required this.headphoneModel,
    required this.ambientNoiseDb,
  });

  final String headphoneModel;
  final double ambientNoiseDb;

  @override
  bool operator ==(Object other) {
    return other is ScreeningSessionConfig &&
        other.headphoneModel == headphoneModel &&
        other.ambientNoiseDb == ambientNoiseDb;
  }

  @override
  int get hashCode => Object.hash(headphoneModel, ambientNoiseDb);
}

class ScreeningTestState {
  const ScreeningTestState({
    this.phase = ScreeningTestPhase.instructions,
    this.currentFrequencyIndex = 0,
    this.currentDb = 40,
    this.currentEar = Ear.right,
    this.isPlayingTone = false,
    this.waitingForResponse = false,
    this.rightEarThresholds = const {},
    this.leftEarThresholds = const {},
    this.responsesAtCurrentLevel = 0,
    this.noResponsesAtCurrentLevel = 0,
  });

  static const List<int> testFrequencies = [1000, 2000, 4000, 500];

  final ScreeningTestPhase phase;
  final int currentFrequencyIndex;
  final int currentDb;
  final Ear currentEar;
  final bool isPlayingTone;
  final bool waitingForResponse;
  final Map<String, int> rightEarThresholds;
  final Map<String, int> leftEarThresholds;
  final int responsesAtCurrentLevel;
  final int noResponsesAtCurrentLevel;

  int get totalTests => testFrequencies.length * 2;

  int get completedTests =>
      rightEarThresholds.length + leftEarThresholds.length;

  double get progress => completedTests / totalTests;

  int get currentFrequency => testFrequencies[currentFrequencyIndex];

  ScreeningTestState copyWith({
    ScreeningTestPhase? phase,
    int? currentFrequencyIndex,
    int? currentDb,
    Ear? currentEar,
    bool? isPlayingTone,
    bool? waitingForResponse,
    Map<String, int>? rightEarThresholds,
    Map<String, int>? leftEarThresholds,
    int? responsesAtCurrentLevel,
    int? noResponsesAtCurrentLevel,
  }) {
    return ScreeningTestState(
      phase: phase ?? this.phase,
      currentFrequencyIndex:
          currentFrequencyIndex ?? this.currentFrequencyIndex,
      currentDb: currentDb ?? this.currentDb,
      currentEar: currentEar ?? this.currentEar,
      isPlayingTone: isPlayingTone ?? this.isPlayingTone,
      waitingForResponse: waitingForResponse ?? this.waitingForResponse,
      rightEarThresholds: rightEarThresholds ?? this.rightEarThresholds,
      leftEarThresholds: leftEarThresholds ?? this.leftEarThresholds,
      responsesAtCurrentLevel:
          responsesAtCurrentLevel ?? this.responsesAtCurrentLevel,
      noResponsesAtCurrentLevel:
          noResponsesAtCurrentLevel ?? this.noResponsesAtCurrentLevel,
    );
  }
}

class ScreeningTestController extends StateNotifier<ScreeningTestState> {
  ScreeningTestController({
    required PlayScreeningToneUseCase playScreeningToneUseCase,
    required StopScreeningToneUseCase stopScreeningToneUseCase,
    Random? random,
  }) : _playScreeningToneUseCase = playScreeningToneUseCase,
       _stopScreeningToneUseCase = stopScreeningToneUseCase,
       _random = random ?? Random(),
       super(const ScreeningTestState());

  final PlayScreeningToneUseCase _playScreeningToneUseCase;
  final StopScreeningToneUseCase _stopScreeningToneUseCase;
  final Random _random;

  Timer? _toneTimer;
  Timer? _responseTimer;
  bool _disposed = false;

  void startTest() {
    state = state.copyWith(phase: ScreeningTestPhase.testing);
    _playTone();
  }

  void continueWithLeftEar() {
    state = state.copyWith(
      currentEar: Ear.left,
      currentFrequencyIndex: 0,
      currentDb: 40,
      phase: ScreeningTestPhase.testing,
      responsesAtCurrentLevel: 0,
      noResponsesAtCurrentLevel: 0,
    );
    _playTone();
  }

  Future<void> handleResponse() async {
    if (!state.isPlayingTone && !state.waitingForResponse) {
      return;
    }

    _responseTimer?.cancel();
    _toneTimer?.cancel();
    await _stopScreeningToneUseCase(const NoParams());

    if (_disposed) {
      return;
    }

    final responses = state.responsesAtCurrentLevel + 1;
    state = state.copyWith(
      isPlayingTone: false,
      waitingForResponse: false,
      responsesAtCurrentLevel: responses,
    );

    if (responses >= 2) {
      _recordThreshold(state.currentDb);
      _moveToNextFrequency();
      return;
    }

    final nextDb = state.currentDb - 10;
    if (nextDb < -10) {
      _recordThreshold(-10);
      _moveToNextFrequency();
      return;
    }

    state = state.copyWith(currentDb: nextDb);
    _playTone();
  }

  void handleNoResponse() {
    _toneTimer?.cancel();

    if (_disposed) {
      return;
    }

    final noResponses = state.noResponsesAtCurrentLevel + 1;
    state = state.copyWith(
      isPlayingTone: false,
      waitingForResponse: false,
      noResponsesAtCurrentLevel: noResponses,
    );

    if (noResponses >= 2) {
      final nextDb = state.currentDb + 10;
      if (nextDb > 80) {
        _recordThreshold(85);
        _moveToNextFrequency();
        return;
      }

      state = state.copyWith(
        currentDb: nextDb,
        noResponsesAtCurrentLevel: 0,
        responsesAtCurrentLevel: 0,
      );
    }

    _playTone();
  }

  void _recordThreshold(int dbHl) {
    final frequency = state.currentFrequency.toString();

    if (state.currentEar == Ear.right) {
      final updated = Map<String, int>.from(state.rightEarThresholds)
        ..[frequency] = dbHl;
      state = state.copyWith(rightEarThresholds: updated);
      return;
    }

    final updated = Map<String, int>.from(state.leftEarThresholds)
      ..[frequency] = dbHl;
    state = state.copyWith(leftEarThresholds: updated);
  }

  void _moveToNextFrequency() {
    final isLastFrequency =
        state.currentFrequencyIndex >=
        ScreeningTestState.testFrequencies.length - 1;

    if (!isLastFrequency) {
      state = state.copyWith(
        currentFrequencyIndex: state.currentFrequencyIndex + 1,
        currentDb: 40,
        responsesAtCurrentLevel: 0,
        noResponsesAtCurrentLevel: 0,
      );
      _playTone();
      return;
    }

    if (state.currentEar == Ear.right) {
      state = state.copyWith(
        phase: ScreeningTestPhase.switching,
        currentFrequencyIndex: 0,
        currentDb: 40,
        responsesAtCurrentLevel: 0,
        noResponsesAtCurrentLevel: 0,
      );
      return;
    }

    state = state.copyWith(phase: ScreeningTestPhase.complete);
  }

  void _playTone() {
    _toneTimer?.cancel();
    _responseTimer?.cancel();

    final delay = Duration(milliseconds: 1000 + _random.nextInt(2000));
    final frequency = state.currentFrequency;
    final intensity = state.currentDb;
    final ear = state.currentEar;

    state = state.copyWith(isPlayingTone: false, waitingForResponse: false);

    _toneTimer = Timer(delay, () async {
      if (_disposed) {
        return;
      }

      state = state.copyWith(isPlayingTone: true);

      try {
        await _playScreeningToneUseCase(
          PlayScreeningToneParams(
            frequency: frequency,
            intensityDbHl: intensity,
            ear: ear,
            durationMs: 1500,
          ),
        );
      } finally {
        if (!_disposed) {
          state = state.copyWith(
            isPlayingTone: false,
            waitingForResponse: true,
          );
          _responseTimer = Timer(const Duration(seconds: 2), handleNoResponse);
        }
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _toneTimer?.cancel();
    _responseTimer?.cancel();
    _stopScreeningToneUseCase(const NoParams());
    super.dispose();
  }
}
