import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../../../modules/clinician_testing/presentation/controllers/air_conduction_test_controller.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_patient_view_model.dart';
import '../../../../modules/reporting/domain/repositories/draft_audiometry_report_repository.dart';
import '../../../../modules/reporting/presentation/providers/reporting_providers.dart';
import '../../../../shared/widgets/audiogram_chart.dart';

/// Main audiometry testing screen
class AudiometryTestingScreen extends ConsumerWidget {
  final String? patientId;

  const AudiometryTestingScreen({super.key, this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(testingStateProvider);
    final patient = patientId == null
        ? null
        : ref.watch(clinicianPatientSummaryProvider(patientId!));

    if (testState.testComplete) {
      return _buildResultsView(context, ref, testState, patient);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(patient?.name ?? 'Audiometry Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(testingStateProvider.notifier).resetTest();
            },
            tooltip: 'Reset Test',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            _buildStatusBar(context, testState),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 10,
                  bottom: MediaQuery.of(context).viewPadding.bottom + 20,
                ),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AudiogramChart(
                          rightEarData: testState.rightEarResults,
                          leftEarData: testState.leftEarResults,
                          highlightedFrequency: testState.currentFrequency,
                          highlightedEar: testState.currentEar,
                          height: MediaQuery.sizeOf(context).height < 760
                              ? 240
                              : 280,
                        ),
                      ),
                    ),
                    _buildFrequencySelector(context, ref, testState),
                    _buildControls(context, ref, testState),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context, TestingState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: state.currentEar == Ear.right
          ? AppTheme.rightEarColor.withValues(alpha: 0.1)
          : AppTheme.leftEarColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusItem(
            context,
            'Ear',
            state.currentEar == Ear.right ? 'RIGHT' : 'LEFT',
            state.currentEar == Ear.right
                ? AppTheme.rightEarColor
                : AppTheme.leftEarColor,
          ),
          _buildStatusItem(
            context,
            'Frequency',
            '${state.currentFrequency} Hz',
            AppTheme.primaryColor,
          ),
          _buildStatusItem(
            context,
            'Intensity',
            '${state.currentIntensity} dB',
            AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySelector(
    BuildContext context,
    WidgetRef ref,
    TestingState state,
  ) {
    final frequencies = AppConstants.standardFrequencies;

    return Container(
      height: 58,
      margin: const EdgeInsets.only(top: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: frequencies.length,
        itemBuilder: (context, index) {
          final freq = frequencies[index];
          final isSelected = freq == state.currentFrequency;
          final hasResult = state.currentEar == Ear.right
              ? state.rightEarResults.any((p) => p.frequency == freq)
              : state.leftEarResults.any((p) => p.frequency == freq);

          return GestureDetector(
            onTap: () {
              ref.read(testingStateProvider.notifier).setFrequency(freq);
            },
            child: Container(
              width: 64,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : hasResult
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
                      fontSize: 13,
                    ),
                  ),
                  if (hasResult)
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: isSelected ? Colors.white : AppTheme.successColor,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    WidgetRef ref,
    TestingState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Column(
        children: [
          // Intensity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrease intensity
              IconButton.filled(
                onPressed: () {
                  ref.read(testingStateProvider.notifier).decreaseIntensity();
                },
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(56, 56),
                ),
              ),
              const SizedBox(width: 16),

              // Current intensity display
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.secondaryColor),
                ),
                child: Column(
                  children: [
                    Text(
                      '${state.currentIntensity}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                    ),
                    const Text('dB HL'),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Increase intensity
              IconButton.filled(
                onPressed: () {
                  ref.read(testingStateProvider.notifier).increaseIntensity();
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(56, 56),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Ear toggle button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(testingStateProvider.notifier).toggleEar();
              },
              icon: Icon(
                state.currentEar == Ear.right
                    ? Icons.hearing
                    : Icons.hearing_outlined,
              ),
              label: Text(
                state.currentEar == Ear.right
                    ? 'Active Ear: Right'
                    : 'Active Ear: Left',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: state.currentEar == Ear.right
                    ? AppTheme.rightEarColor
                    : AppTheme.leftEarColor,
                side: BorderSide(
                  color: state.currentEar == Ear.right
                      ? AppTheme.rightEarColor
                      : AppTheme.leftEarColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Play tone button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isPlaying
                  ? null
                  : () {
                      ref.read(testingStateProvider.notifier).playTone();
                    },
              icon: Icon(state.isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(state.isPlaying ? 'Playing...' : 'Play Tone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Response buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(testingStateProvider.notifier).recordResponse();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Heard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(testingStateProvider.notifier).recordNoResponse();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('No Response'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(
    BuildContext context,
    WidgetRef ref,
    TestingState state,
    ClinicianPatientViewModel? patient,
  ) {
    // Calculate PTAs
    final rightPta = _calculatePta(state.rightEarResults);
    final leftPta = _calculatePta(state.leftEarResults);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Audiogram
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AudiogramChart(
                  rightEarData: state.rightEarResults,
                  leftEarData: state.leftEarResults,
                  height: 300,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PTA Results
            Row(
              children: [
                Expanded(
                  child: _buildPtaCard(
                    context,
                    'Right Ear',
                    rightPta,
                    AppTheme.rightEarColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPtaCard(
                    context,
                    'Left Ear',
                    leftPta,
                    AppTheme.leftEarColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Threshold table
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Threshold Values (dB HL)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildThresholdTable(context, state),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(testingStateProvider.notifier).resetTest();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Test'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final audiologistName =
                            ref.read(authStateProvider).user?.name ??
                            'Audiologist';
                        await ref.read(
                          previewDraftAudiometryReportUseCaseProvider,
                        )(
                          DraftAudiometryReportData(
                            patientName: patient?.name ?? 'Patient',
                            patientDob: patient == null
                                ? 'Unknown'
                                : '${patient.dateOfBirth.year.toString().padLeft(4, '0')}-${patient.dateOfBirth.month.toString().padLeft(2, '0')}-${patient.dateOfBirth.day.toString().padLeft(2, '0')}',
                            patientId: patient?.id ?? 'unknown-patient',
                            audiologistName: audiologistName,
                            testDate: DateTime.now(),
                            rightEarResults: state.rightEarResults,
                            leftEarResults: state.leftEarResults,
                          ),
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error generating report: $e'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate Report'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPtaCard(
    BuildContext context,
    String title,
    double pta,
    Color color,
  ) {
    final classification = AudiogramClassification.getClassification(pta);
    final classColor = AudiogramClassification.getClassificationColor(pta);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            Text(
              '${pta.toStringAsFixed(1)} dB',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: classColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                classification,
                style: TextStyle(
                  color: classColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdTable(BuildContext context, TestingState state) {
    final frequencies = AppConstants.standardFrequencies;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {0: FlexColumnWidth(1.5)},
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Ear', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...frequencies.map(
              (f) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  f >= 1000 ? '${f ~/ 1000}k' : f.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        // Right ear
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Right',
                style: TextStyle(color: AppTheme.rightEarColor),
              ),
            ),
            ...frequencies.map((f) {
              final point = state.rightEarResults.firstWhere(
                (p) => p.frequency == f,
                orElse: () => const AudiogramPoint(
                  frequency: 0,
                  thresholdDb: -1,
                  ear: Ear.right,
                ),
              );
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  point.thresholdDb >= 0
                      ? point.noResponse
                            ? 'NR'
                            : point.thresholdDb.toString()
                      : '-',
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ],
        ),
        // Left ear
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Left',
                style: TextStyle(color: AppTheme.leftEarColor),
              ),
            ),
            ...frequencies.map((f) {
              final point = state.leftEarResults.firstWhere(
                (p) => p.frequency == f,
                orElse: () => const AudiogramPoint(
                  frequency: 0,
                  thresholdDb: -1,
                  ear: Ear.left,
                ),
              );
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  point.thresholdDb >= 0
                      ? point.noResponse
                            ? 'NR'
                            : point.thresholdDb.toString()
                      : '-',
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  double _calculatePta(List<AudiogramPoint> results) {
    // 4-frequency PTA: 500, 1000, 2000, 4000 Hz
    final ptaFrequencies = [500, 1000, 2000, 4000];
    final ptaValues = <int>[];

    for (final freq in ptaFrequencies) {
      final point = results.firstWhere(
        (p) => p.frequency == freq && !p.noResponse,
        orElse: () =>
            const AudiogramPoint(frequency: 0, thresholdDb: -1, ear: Ear.right),
      );
      if (point.thresholdDb >= 0) {
        ptaValues.add(point.thresholdDb);
      }
    }

    if (ptaValues.isEmpty) return 0;
    return ptaValues.reduce((a, b) => a + b) / ptaValues.length;
  }
}
