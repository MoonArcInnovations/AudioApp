import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/calibration/domain/entities/headphone_profile.dart';
import '../../../../modules/calibration/presentation/controllers/headphone_calibration_controller.dart';
import '../../../../modules/calibration/presentation/providers/calibration_providers.dart';

class HeadphoneCalibrationScreen extends ConsumerWidget {
  const HeadphoneCalibrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(headphoneCalibrationControllerProvider);
    final profiles = ref.watch(headphoneProfilesProvider);
    final savedCalibrations = ref.watch(savedCalibrationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Headphone Calibration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            Text(
              'Professional Audiometric Equipment',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...profiles
                .where(
                  (profile) => profile.accuracy == CalibrationAccuracy.clinical,
                )
                .map(
                  (profile) => _buildProfileCard(context, ref, state, profile),
                ),
            const SizedBox(height: 24),
            Text(
              'Consumer Headphones',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Requires validation study for clinical use',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            ...profiles
                .where(
                  (profile) => profile.accuracy != CalibrationAccuracy.clinical,
                )
                .map(
                  (profile) => _buildProfileCard(context, ref, state, profile),
                ),
            const SizedBox(height: 24),
            _buildTestToneSection(context, ref, state),
            const SizedBox(height: 24),
            savedCalibrations.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
              data: (calibrations) => calibrations.isEmpty
                  ? const SizedBox.shrink()
                  : _buildCustomCalibrationsSection(context, calibrations),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor.withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.infoColor),
              SizedBox(width: 12),
              Text(
                'About Calibration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.infoColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'RETSPL (Reference Equivalent Threshold Sound Pressure Level) values define the relationship between dB HL and dB SPL for each headphone and frequency. Professional audiometric headphones have standardized RETSPL values per ANSI S3.6.',
            style: TextStyle(color: AppTheme.textPrimaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    HeadphoneCalibrationState state,
    HeadphoneProfileDetails profile,
  ) {
    final isSelected = state.selectedProfile == profile.profileType;
    final accuracyColor = _getAccuracyColor(profile.accuracy);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(headphoneCalibrationControllerProvider.notifier)
              .selectProfile(profile.profileType);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: accuracyColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      profile.accuracy == CalibrationAccuracy.clinical
                          ? Icons.medical_services
                          : Icons.headphones,
                      color: accuracyColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (profile.isValidated) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified,
                                color: AppTheme.successColor,
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${profile.brand} • ${profile.type}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accuracyColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '±${profile.accuracyDb} dB',
                          style: TextStyle(
                            color: accuracyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getApprovedUseLabel(profile.approvedUse),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  profile.description,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                const Text(
                  'RETSPL Values (dB SPL)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRetsplTable(ref, profile.profileType),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Ear:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('Left'),
                      selected: state.testEar == Ear.left,
                      onSelected: (selected) {
                        if (selected) {
                          ref
                              .read(
                                headphoneCalibrationControllerProvider.notifier,
                              )
                              .selectTestEar(Ear.left);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Right'),
                      selected: state.testEar == Ear.right,
                      onSelected: (selected) {
                        if (selected) {
                          ref
                              .read(
                                headphoneCalibrationControllerProvider.notifier,
                              )
                              .selectTestEar(Ear.right);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(
                              headphoneCalibrationControllerProvider.notifier,
                            )
                            .toggleProfileTone(profile.profileType);
                      },
                      icon: Icon(
                        state.isPlayingTone &&
                                state.selectedProfile == profile.profileType
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      label: Text(
                        state.isPlayingTone &&
                                state.selectedProfile == profile.profileType
                            ? 'Stop'
                            : 'Test Tone',
                      ),
                    ),
                    const Spacer(),
                    if (!profile.isValidated)
                      TextButton.icon(
                        onPressed: () => _showValidationInfo(context, profile),
                        icon: const Icon(Icons.science),
                        label: const Text('Needs Validation'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildRetsplTable(WidgetRef ref, HeadphoneProfileType profileType) {
    final table = ref.watch(retsplTableProvider(profileType));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: table.entries.map((entry) {
          final freq = entry.key;
          final retspl = entry.value;
          return Expanded(
            child: Column(
              children: [
                Text(
                  freq >= 1000 ? '${freq ~/ 1000}k' : '$freq',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  retspl.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestToneSection(
    BuildContext context,
    WidgetRef ref,
    HeadphoneCalibrationState state,
  ) {
    const frequencies = [250, 500, 1000, 2000, 4000, 8000];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Tone Generator',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Play calibration tones to verify output',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          const Text('Frequency'),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: frequencies.map((frequency) {
                final isSelected = state.testFrequency == frequency;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$frequency Hz'),
                    selected: isSelected,
                    onSelected: (_) {
                      ref
                          .read(headphoneCalibrationControllerProvider.notifier)
                          .selectTestFrequency(frequency);
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(headphoneCalibrationControllerProvider.notifier)
                    .toggleGeneralTone();
              },
              icon: Icon(state.isPlayingTone ? Icons.stop : Icons.volume_up),
              label: Text(
                state.isPlayingTone ? 'Stop Tone' : 'Play Test Tone (40 dB HL)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isPlayingTone
                    ? AppTheme.errorColor
                    : AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCalibrationsSection(
    BuildContext context,
    Map<int, double> calibrations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Calibrations',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: calibrations.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${entry.key} Hz'),
                    Text(
                      '${entry.value > 0 ? '+' : ''}${entry.value.toStringAsFixed(1)} dB',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getAccuracyColor(CalibrationAccuracy accuracy) {
    switch (accuracy) {
      case CalibrationAccuracy.clinical:
        return AppTheme.successColor;
      case CalibrationAccuracy.validated:
        return AppTheme.infoColor;
      case CalibrationAccuracy.screening:
        return AppTheme.warningColor;
      case CalibrationAccuracy.approximate:
        return AppTheme.errorColor;
    }
  }

  String _getApprovedUseLabel(ApprovedUse use) {
    switch (use) {
      case ApprovedUse.diagnostic:
        return 'Diagnostic';
      case ApprovedUse.screening:
        return 'Screening';
      case ApprovedUse.screeningOnly:
        return 'Screening Only';
      case ApprovedUse.screeningWithWarning:
        return 'Warning Required';
    }
  }

  void _showValidationInfo(
    BuildContext context,
    HeadphoneProfileDetails profile,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Validation Required: ${profile.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This headphone profile needs validation before clinical use.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Validation Protocol:'),
            const SizedBox(height: 8),
            _buildValidationStep('1', 'Recruit 20+ participants'),
            _buildValidationStep('2', 'Reference audiometry with TDH-39'),
            _buildValidationStep('3', 'Test with target headphones'),
            _buildValidationStep('4', 'Calculate mean deviation per frequency'),
            _buildValidationStep('5', 'Confirm RMSD ≤ 10 dB'),
            const SizedBox(height: 16),
            Text(
              'Current Estimated Accuracy: ±${profile.accuracyDb} dB',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
