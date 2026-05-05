import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/core/presentation/widgets/luxury_button.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/features/patient/presentation/widgets/recommendation_card.dart';
import 'package:audioapp/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:audioapp/modules/patient_screening/application/use_cases/save_screening_result_use_case.dart';
import 'package:audioapp/modules/patient_screening/presentation/providers/patient_screening_providers.dart';

/// Screening results screen with pass/refer recommendation
class ScreeningResultsScreen extends ConsumerStatefulWidget {
  final Map<String, int> rightEarThresholds;
  final Map<String, int> leftEarThresholds;
  final String headphoneModel;
  final double ambientNoiseDb;

  const ScreeningResultsScreen({
    super.key,
    required this.rightEarThresholds,
    required this.leftEarThresholds,
    required this.headphoneModel,
    required this.ambientNoiseDb,
  });

  @override
  ConsumerState<ScreeningResultsScreen> createState() => _ScreeningResultsScreenState();
}

class _ScreeningResultsScreenState extends ConsumerState<ScreeningResultsScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final result = _analyzeResults();
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const LuxuryHeader(title: 'Results', showBackButton: false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // 1. Result Summary Card
                    _buildResultHeader(context, result),
                    
                    const SizedBox(height: 24),
                    
                    // 2. Ear Breakdown
                    _buildEarResults(context),
                    
                    const SizedBox(height: 24),
                    
                    // 3. Recommendations
                    _buildRecommendations(context, result),
                    
                    const SizedBox(height: 24),
                    
                    // 4. Test Details
                    _buildTestDetails(context),
                    
                    const SizedBox(height: 24),
                    
                    // 5. Disclaimer
                    _buildDisclaimer(context),
                    
                    const SizedBox(height: 32),
                    
                    // 6. Actions
                    _buildActions(context),
                    
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader(BuildContext context, _ScreeningResult result) {
    Color headerColor;
    IconData icon;
    String title;
    String subtitle;
    
    switch (result) {
      case _ScreeningResult.pass:
        headerColor = AppTheme.successColor;
        icon = Icons.check_circle_outline;
        title = 'Normal Hearing';
        subtitle = 'Your results are within the normal range.';
        break;
      case _ScreeningResult.borderline:
        headerColor = AppTheme.warningColor;
        icon = Icons.warning_amber_rounded;
        title = 'Borderline';
        subtitle = 'Some frequencies showed mild changes.';
        break;
      case _ScreeningResult.refer:
        headerColor = AppTheme.errorColor;
        icon = Icons.priority_high_rounded;
        title = 'Consultation Needed';
        subtitle = 'We recommend a professional evaluation.';
        break;
    }

    return LuxuryCard(
      color: AppTheme.primaryColor, // Midnight Blue for impact
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: headerColor.withValues(alpha: 0.15),
              border: Border.all(color: headerColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(
              icon,
              size: 48,
              color: headerColor, // Keep success/warning/error color for semantic meaning
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
          
          const SizedBox(height: 20),
          
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.secondaryColor, // Gold Text
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          
          const SizedBox(height: 8),
          
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildEarResults(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Detailed Analysis',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildEarCard(
                context,
                ear: 'Right Ear',
                color: AppTheme.rightEarColor,
                thresholds: widget.rightEarThresholds,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEarCard(
                context,
                ear: 'Left Ear',
                color: AppTheme.leftEarColor,
                thresholds: widget.leftEarThresholds,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarCard(
    BuildContext context, {
    required String ear,
    required Color color,
    required Map<String, int> thresholds,
  }) {
    final averageThreshold = thresholds.isNotEmpty
        ? thresholds.values.reduce((a, b) => a + b) / thresholds.length
        : 0.0;
    
    final classification = _getClassification(averageThreshold);
    
    return LuxuryCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hearing, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                ear,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            '${averageThreshold.toStringAsFixed(0)} dB',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.textPrimaryLight,
            ),
          ),
          Text(
            'Avg Threshold',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
               color: AppTheme.textSecondaryLight,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: classification.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: classification.color.withValues(alpha: 0.2)),
            ),
            child: Text(
              classification.label,
              style: TextStyle(
                color: classification.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, duration: 400.ms);
  }

  Widget _buildRecommendations(BuildContext context, _ScreeningResult result) {
    List<_Recommendation> recommendations;
    
    switch (result) {
      case _ScreeningResult.pass:
        recommendations = [
          _Recommendation(
            icon: Icons.calendar_today_outlined,
            title: 'Annual Check-up',
            description: 'Schedule your next screening in 12 months.',
          ),
          _Recommendation(
            icon: Icons.volume_down_outlined,
            title: 'Protect Your Hearing',
            description: 'Use ear protection in loud environments.',
          ),
        ];
        break;
      case _ScreeningResult.borderline:
        recommendations = [
          _Recommendation(
            icon: Icons.update,
            title: 'Retest in 3 Months',
            description: 'Monitor any changes by retesting soon.',
          ),
          _Recommendation(
            icon: Icons.medical_services_outlined,
            title: 'Professional Evaluation',
            description: 'Consider seeing an audiologist for a full test.',
          ),
        ];
        break;
      case _ScreeningResult.refer:
        recommendations = [
          _Recommendation(
            icon: Icons.medical_services_outlined,
            title: 'See an Audiologist',
            description: 'We strongly recommend a comprehensive exam.',
            isHighPriority: true,
          ),
          _Recommendation(
            icon: Icons.share_outlined,
            title: 'Share Results',
            description: 'Share this report with your healthcare provider.',
          ),
        ];
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Recommendations',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        
        ...recommendations.map((rec) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RecommendationCard(
            icon: rec.icon,
            title: rec.title,
            description: rec.description,
            iconColor: rec.isHighPriority ? AppTheme.errorColor : null,
          ),
        )),
      ],
    );
  }

  Widget _buildTestDetails(BuildContext context) {
    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          _buildDetailRow('Date', DateTime.now().toString().split(' ')[0]),
          _buildDetailRow('Headphones', widget.headphoneModel),
          _buildDetailRow('Ambient Noise', '${widget.ambientNoiseDb.toStringAsFixed(0)} dB'),
          _buildDetailRow('Frequencies', '500, 1k, 2k, 4k Hz'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppTheme.textSecondaryLight),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppTheme.warningColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disclaimer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This screening is for informational purposes only. Results may be affected by equipment and noise. Not a medical diagnosis.',
                  style: TextStyle(
                    color: AppTheme.textPrimaryLight.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        LuxuryButton(
          text: _isSaved ? 'Saved to Profile' : 'Save Results',
          icon: _isSaved ? Icons.check : Icons.save_alt,
          onPressed: _isSaved ? null : _saveResults,
          isLoading: _isSaving,
          type: _isSaved ? LuxuryButtonType.secondary : LuxuryButtonType.primary,
        ),
        const SizedBox(height: 16),
        LuxuryButton(
          text: 'Return Home',
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          type: LuxuryButtonType.ghost,
        ),
      ],
    );
  }

  Future<void> _saveResults() async {
    final authState = ref.read(authStateProvider);
    final user = authState.user;
    
    if (user == null) {
      _showSnack('Please log in to save results', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(saveScreeningResultUseCaseProvider)(
        SaveScreeningResultParams(
          userId: user.id,
          rightEarThresholds: widget.rightEarThresholds,
          leftEarThresholds: widget.leftEarThresholds,
          headphoneModel: widget.headphoneModel,
          ambientNoiseDb: widget.ambientNoiseDb,
        ),
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
          _isSaved = true;
        });
        _showSnack('Results saved successfully!', isError: false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showSnack('Error saving results: $e', isError: true);
      }
    }
  }
  
  void _showSnack(String msg, {bool isError = false}) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  _ScreeningResult _analyzeResults() {
    final allThresholds = [...widget.rightEarThresholds.values, ...widget.leftEarThresholds.values];
    
    if (allThresholds.isEmpty) return _ScreeningResult.pass;
    
    final maxThreshold = allThresholds.reduce((a, b) => a > b ? a : b);
    final avgThreshold = allThresholds.reduce((a, b) => a + b) / allThresholds.length;
    
    if (maxThreshold > 40 || avgThreshold > 30) {
      return _ScreeningResult.refer;
    } else if (maxThreshold > 25 || avgThreshold > 20) {
      return _ScreeningResult.borderline;
    } else {
      return _ScreeningResult.pass;
    }
  }

  _Classification _getClassification(double threshold) {
    if (threshold <= 25) {
      return _Classification('Normal', AppTheme.successColor);
    } else if (threshold <= 40) {
      return _Classification('Mild', AppTheme.warningColor);
    } else if (threshold <= 55) {
      return _Classification('Moderate', AppTheme.warningColor);
    } else {
      return _Classification('Significant', AppTheme.errorColor);
    }
  }
}

enum _ScreeningResult { pass, borderline, refer }

class _Classification {
  final String label;
  final Color color;
  const _Classification(this.label, this.color);
}

class _Recommendation {
  final IconData icon;
  final String title;
  final String description;
  final bool isHighPriority;
  
  const _Recommendation({
    required this.icon,
    required this.title,
    required this.description,
    this.isHighPriority = false,
  });
}
