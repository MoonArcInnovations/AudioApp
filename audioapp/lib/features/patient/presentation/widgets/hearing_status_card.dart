import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/modules/patient_screening/presentation/view_models/screening_summary_view_model.dart';

class HearingStatusCard extends StatelessWidget {
  final ScreeningSummaryViewModel? screening;
  final bool isLoading;
  final String? error;

  const HearingStatusCard({
    super.key,
    this.screening,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LuxuryCard(
        child: SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (error != null || screening == null) {
      return _buildEmptyState(context);
    }

    final statusColor = _screeningColor(screening!.result);
    final statusLabel = _screeningLabel(screening!.result);
    final rightAvg = screening!.averageThresholdForEar('R_');
    final leftAvg = screening!.averageThresholdForEar('L_');

    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hearing, color: statusColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hearing Status',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildEarStatus(
                  context,
                  'Right Ear',
                  _classificationFromThreshold(rightAvg),
                  AppTheme.rightEarColor,
                ),
              ),
              Container(width: 1, height: 40, color: AppTheme.borderLight),
              Expanded(
                child: _buildEarStatus(
                  context,
                  'Left Ear',
                  _classificationFromThreshold(leftAvg),
                  AppTheme.leftEarColor, // Standard Blue
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppTheme.borderLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last Screening',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                DateFormat('MMM d, yyyy').format(screening!.testDate),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return LuxuryCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.hearing_disabled_outlined,
              size: 48,
              color: AppTheme.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No Screening Data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Take a quick hearing test to monitor your health.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarStatus(
    BuildContext context,
    String ear,
    String status,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          ear,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondaryLight),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helpers (Logic extracted from screen)
  String _screeningLabel(String result) {
    switch (result) {
      case 'pass':
        return 'Normal Range';
      case 'borderline':
        return 'Borderline';
      case 'refer':
        return 'Evaluation Needed';
      default:
        return result.toUpperCase();
    }
  }

  Color _screeningColor(String result) {
    switch (result) {
      case 'pass':
        return AppTheme.successColor;
      case 'borderline':
        return AppTheme.warningColor;
      case 'refer':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _classificationFromThreshold(double threshold) {
    if (threshold <= 25) return 'Normal';
    if (threshold <= 40) return 'Mild Loss';
    if (threshold <= 55) return 'Moderate';
    return 'Significant';
  }
}
