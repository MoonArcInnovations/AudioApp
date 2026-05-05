import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/patient_screening/presentation/controllers/screening_test_controller.dart';
import '../../../../modules/patient_screening/presentation/providers/patient_screening_providers.dart';
import 'screening_results_screen.dart';

class ScreeningTestScreen extends ConsumerWidget {
  const ScreeningTestScreen({
    super.key,
    required this.headphoneModel,
    required this.ambientNoiseDb,
  });

  final String headphoneModel;
  final double ambientNoiseDb;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionConfig = ScreeningSessionConfig(
      headphoneModel: headphoneModel,
      ambientNoiseDb: ambientNoiseDb,
    );
    final screeningState = ref.watch(
      screeningTestControllerProvider(sessionConfig),
    );

    ref.listen<ScreeningTestState>(
      screeningTestControllerProvider(sessionConfig),
      (previous, next) {
        if (previous?.isPlayingTone != true && next.isPlayingTone) {
          HapticFeedback.lightImpact();
        }
      },
    );

    return Scaffold(
      backgroundColor: screeningState.isPlayingTone
          ? AppTheme.primaryColor.withValues(alpha: 0.05)
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: switch (screeningState.phase) {
          ScreeningTestPhase.instructions => _InstructionsView(
            onStart: () {
              ref
                  .read(screeningTestControllerProvider(sessionConfig).notifier)
                  .startTest();
            },
          ),
          ScreeningTestPhase.testing => _TestingView(
            state: screeningState,
            onRespond: () async {
              await HapticFeedback.mediumImpact();
              await ref
                  .read(screeningTestControllerProvider(sessionConfig).notifier)
                  .handleResponse();
            },
          ),
          ScreeningTestPhase.switching => _SwitchEarView(
            onContinue: () {
              ref
                  .read(screeningTestControllerProvider(sessionConfig).notifier)
                  .continueWithLeftEar();
            },
          ),
          ScreeningTestPhase.complete => _CompleteView(
            onViewResults: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ScreeningResultsScreen(
                    rightEarThresholds: screeningState.rightEarThresholds,
                    leftEarThresholds: screeningState.leftEarThresholds,
                    headphoneModel: headphoneModel,
                    ambientNoiseDb: ambientNoiseDb,
                  ),
                ),
              );
            },
          ),
        },
      ),
    );
  }
}

class _InstructionsView extends StatelessWidget {
  const _InstructionsView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hearing,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 1000.ms,
              ),
          const SizedBox(height: 32),
          Text(
            'Ready to Begin',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'We\'ll start testing your RIGHT ear first.\n\nTap the button whenever you hear a beep, even if it\'s very faint.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _TestingView extends StatelessWidget {
  const _TestingView({required this.state, required this.onRespond});

  final ScreeningTestState state;
  final Future<void> Function() onRespond;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTestHeader(context),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEarIndicator(),
              const SizedBox(height: 24),
              Text(
                '${state.currentFrequency} Hz',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),
              _buildResponseButton(),
              const SizedBox(height: 24),
              Text(
                state.isPlayingTone
                    ? 'Listen carefully...'
                    : state.waitingForResponse
                    ? 'Did you hear a tone?'
                    : 'Get ready...',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        _buildTestInfo(),
      ],
    );
  }

  Widget _buildTestHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(state.progress * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.hearing,
                    color: state.currentEar == Ear.right
                        ? AppTheme.rightEarColor
                        : AppTheme.leftEarColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${state.currentEar == Ear.right ? "Right" : "Left"} Ear',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                'Test ${state.completedTests + 1} of ${state.totalTests}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarIndicator() {
    final isRight = state.currentEar == Ear.right;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildEarIcon(
          isActive: !isRight,
          label: 'L',
          color: AppTheme.leftEarColor,
        ),
        const SizedBox(width: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(Icons.person, size: 48, color: Colors.grey.shade400),
        ),
        const SizedBox(width: 32),
        _buildEarIcon(
          isActive: isRight,
          label: 'R',
          color: AppTheme.rightEarColor,
        ),
      ],
    );
  }

  Widget _buildEarIcon({
    required bool isActive,
    required String label,
    required Color color,
  }) {
    return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.grey.shade200,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        )
        .animate(target: isActive ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 200.ms,
        );
  }

  Widget _buildResponseButton() {
    return GestureDetector(
          onTapDown: (_) => onRespond(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.isPlayingTone
                  ? AppTheme.primaryColor
                  : Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color:
                      (state.isPlayingTone
                              ? AppTheme.primaryColor
                              : Colors.grey)
                          .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 48,
                  color: state.isPlayingTone
                      ? Colors.white
                      : Colors.grey.shade600,
                ),
                const SizedBox(height: 8),
                Text(
                  'TAP',
                  style: TextStyle(
                    color: state.isPlayingTone
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(target: state.isPlayingTone ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 100.ms,
        );
  }

  Widget _buildTestInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tap the button as soon as you hear any sound',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchEarView extends StatelessWidget {
  const _SwitchEarView({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.leftEarColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hearing,
              size: 60,
              color: AppTheme.leftEarColor,
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 32),
          Text(
            'Now testing LEFT ear',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Make sure your headphones are on correctly.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.leftEarColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompleteView extends StatelessWidget {
  const _CompleteView({required this.onViewResults});

  final VoidCallback onViewResults;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: AppTheme.successColor,
            ),
          ).animate().scale().fadeIn(),
          const SizedBox(height: 32),
          Text(
            'Test Complete!',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap below to view your results.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
