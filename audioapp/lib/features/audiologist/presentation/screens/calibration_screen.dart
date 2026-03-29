import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/calibration/presentation/controllers/manual_calibration_controller.dart';
import '../../../../modules/calibration/presentation/providers/calibration_providers.dart';

class CalibrationScreen extends ConsumerWidget {
  const CalibrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibState = ref.watch(manualCalibrationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Calibration'),
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(manualCalibrationControllerProvider.notifier)
                  .resetCalibration();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: calibState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: AppTheme.infoColor.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppTheme.infoColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Calibration Instructions',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppTheme.infoColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '1. Use external calibrated headphones\n'
                            '2. Play each frequency at 60 dB HL\n'
                            '3. Adjust until the sound level meter reads 60 dB SPL + RETSPL\n'
                            '4. Save the correction for each frequency',
                            style: TextStyle(height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select Frequency',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildFrequencyGrid(context, ref, calibState),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '${calibState.currentFrequency} Hz',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'RETSPL: ${AppConstants.retsplValues[calibState.currentFrequency]?.toStringAsFixed(1) ?? "N/A"} dB',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Correction: ${calibState.currentCorrection >= 0 ? "+" : ""}${calibState.currentCorrection.toStringAsFixed(1)} dB',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Slider(
                            value: calibState.currentCorrection,
                            min: -20,
                            max: 20,
                            divisions: 80,
                            label:
                                '${calibState.currentCorrection.toStringAsFixed(1)} dB',
                            onChanged: (value) {
                              ref
                                  .read(
                                    manualCalibrationControllerProvider
                                        .notifier,
                                  )
                                  .setCorrection(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '-20 dB',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '+20 dB',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              IconButton.filled(
                                onPressed: () {
                                  ref
                                      .read(
                                        manualCalibrationControllerProvider
                                            .notifier,
                                      )
                                      .adjustCorrection(-0.5);
                                },
                                icon: const Icon(Icons.remove),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: () {
                                  ref
                                      .read(
                                        manualCalibrationControllerProvider
                                            .notifier,
                                      )
                                      .adjustCorrection(0.5);
                                },
                                icon: const Icon(Icons.add),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: calibState.isPlaying
                                    ? null
                                    : () {
                                        ref
                                            .read(
                                              manualCalibrationControllerProvider
                                                  .notifier,
                                            )
                                            .playTestTone();
                                      },
                                icon: Icon(
                                  calibState.isPlaying
                                      ? Icons.volume_up
                                      : Icons.play_arrow,
                                ),
                                label: Text(
                                  calibState.isPlaying
                                      ? 'Playing...'
                                      : 'Play Tone',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(manualCalibrationControllerProvider.notifier)
                          .saveCurrentCalibration();
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saved calibration for ${calibState.currentFrequency} Hz',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Calibration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (calibState.calibrations.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saved Calibrations',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: calibState.calibrations.entries.map((
                                entry,
                              ) {
                                return Chip(
                                  label: Text(
                                    '${entry.key >= 1000 ? "${entry.key ~/ 1000}k" : entry.key} Hz: ${entry.value >= 0 ? "+" : ""}${entry.value.toStringAsFixed(1)}',
                                  ),
                                  backgroundColor: AppTheme.successColor
                                      .withValues(alpha: 0.2),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildFrequencyGrid(
    BuildContext context,
    WidgetRef ref,
    ManualCalibrationState state,
  ) {
    final frequencies = AppConstants.standardFrequencies;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: frequencies.map((freq) {
        final isSelected = freq == state.currentFrequency;
        final isCalibrated = state.calibrations.containsKey(freq);

        return GestureDetector(
          onTap: () {
            ref
                .read(manualCalibrationControllerProvider.notifier)
                .setFrequency(freq);
          },
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : isCalibrated
                  ? AppTheme.successColor.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: AppTheme.primaryColor, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  freq >= 1000 ? '${freq ~/ 1000}k' : freq.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isCalibrated)
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: isSelected ? Colors.white : AppTheme.successColor,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
