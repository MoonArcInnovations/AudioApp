import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import 'screening_environment_check_screen.dart';

/// Patient screening start screen with instructions and onboarding
class ScreeningStartScreen extends ConsumerStatefulWidget {
  const ScreeningStartScreen({super.key});

  @override
  ConsumerState<ScreeningStartScreen> createState() => _ScreeningStartScreenState();
}

class _ScreeningStartScreenState extends ConsumerState<ScreeningStartScreen> {
  int _currentStep = 0;
  
  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      icon: Icons.hearing,
      title: 'Quick Hearing Check',
      description: 'This 5-minute screening will help you understand your hearing health. It\'s not a medical diagnosis, but can indicate if you should see a professional.',
      color: AppTheme.primaryColor,
    ),
    _OnboardingStep(
      icon: Icons.headphones,
      title: 'Use Headphones',
      description: 'For accurate results, please use headphones. We\'ll help you select and verify your headphones in the next step.',
      color: AppTheme.secondaryColor,
    ),
    _OnboardingStep(
      icon: Icons.volume_off,
      title: 'Find a Quiet Place',
      description: 'Background noise can affect your results. Find a quiet room and we\'ll check if the environment is suitable.',
      color: AppTheme.successColor,
    ),
    _OnboardingStep(
      icon: Icons.touch_app,
      title: 'Tap When You Hear',
      description: 'You\'ll hear tones at different pitches and volumes. Tap the button whenever you hear a sound, even if it\'s very faint.',
      color: AppTheme.warningColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // App bar with skip option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                    TextButton(
                      onPressed: _startTest,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: List.generate(_steps.length, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? _steps[_currentStep].color
                              : AppTheme.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              // Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStepContent(_steps[_currentStep]),
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _currentStep < _steps.length - 1
                            ? () {
                                setState(() {
                                  _currentStep++;
                                });
                              }
                            : _startTest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _steps[_currentStep].color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentStep < _steps.length - 1 ? 'Next' : 'Start Test',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(_OnboardingStep step) {
    return Padding(
      key: ValueKey(step.title),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 80,
              color: step.color,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  void _startTest() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ScreeningEnvironmentCheckScreen(),
      ),
    );
  }
}

class _OnboardingStep {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
