import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/clinician_testing/presentation/controllers/bone_conduction_test_controller.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../../shared/widgets/audiogram_chart.dart';

/// Bone conduction testing screen
class BoneConductionScreen extends ConsumerWidget {
  final String? patientId;
  final List<AudiogramPoint>? airConductionRight;
  final List<AudiogramPoint>? airConductionLeft;

  const BoneConductionScreen({
    super.key,
    this.patientId,
    this.airConductionRight,
    this.airConductionLeft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPatientId = patientId;
    if (currentPatientId == null || currentPatientId.isEmpty) {
      return const _BoneConductionPatientPicker();
    }

    final bcState = ref.watch(boneConductionProvider);
    final patient = ref.watch(
      clinicianPatientSummaryProvider(currentPatientId),
    );

    if (bcState.testComplete) {
      return _buildResultsView(context, ref, bcState);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          patient == null ? 'Bone Conduction Test' : 'BC: ${patient.name}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(boneConductionProvider.notifier).resetTest();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar with BC indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.vibration, color: AppTheme.secondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'BONE CONDUCTION',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Status row
            _buildStatusBar(context, ref, bcState),
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
                    // Audiogram with BC symbols
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            // Legend for BC
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _legendItem(
                                    'Right BC (<)',
                                    AppTheme.rightEarColor,
                                  ),
                                  const SizedBox(width: 24),
                                  _legendItem(
                                    'Left BC (>)',
                                    AppTheme.leftEarColor,
                                  ),
                                ],
                              ),
                            ),
                            AudiogramChart(
                              rightEarData: bcState.rightEarResults,
                              leftEarData: bcState.leftEarResults,
                              highlightedFrequency: bcState.currentFrequency,
                              highlightedEar: bcState.currentEar,
                              showLegend: false,
                              height: MediaQuery.sizeOf(context).height < 760
                                  ? 240
                                  : 280,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Frequency selector (BC range only)
                    _buildFrequencySelector(context, ref, bcState),
                    // Masking controls
                    if (bcState.isMasking)
                      _buildMaskingControls(context, ref, bcState),
                    // Main controls
                    _buildControls(context, ref, bcState),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text.contains('<') ? '<' : '>',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatusBar(
    BuildContext context,
    WidgetRef ref,
    BoneConductionState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: state.currentEar == Ear.right
          ? AppTheme.rightEarColor.withValues(alpha: 0.1)
          : AppTheme.leftEarColor.withValues(alpha: 0.1),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 20,
        runSpacing: 8,
        children: [
          Column(
            children: [
              const Text('Ear', style: TextStyle(fontSize: 12)),
              Text(
                state.currentEar == Ear.right ? 'RIGHT' : 'LEFT',
                style: TextStyle(
                  color: state.currentEar == Ear.right
                      ? AppTheme.rightEarColor
                      : AppTheme.leftEarColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text('Frequency', style: TextStyle(fontSize: 12)),
              Text(
                '${state.currentFrequency} Hz',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text('Intensity', style: TextStyle(fontSize: 12)),
              Text(
                '${state.currentIntensity} dB',
                style: const TextStyle(
                  color: AppTheme.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ref.read(boneConductionProvider.notifier).toggleMasking();
            },
            child: Column(
              children: [
                const Text('Masking', style: TextStyle(fontSize: 12)),
                Icon(
                  state.isMasking ? Icons.volume_up : Icons.volume_off,
                  color: state.isMasking ? AppTheme.warningColor : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySelector(
    BuildContext context,
    WidgetRef ref,
    BoneConductionState state,
  ) {
    final frequencies = BoneConductionNotifier.bcFrequencies;

    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: frequencies.map((freq) {
          final isSelected = freq == state.currentFrequency;
          final hasResult = state.currentEar == Ear.right
              ? state.rightEarResults.any((p) => p.frequency == freq)
              : state.leftEarResults.any((p) => p.frequency == freq);

          return GestureDetector(
            onTap: () {
              ref.read(boneConductionProvider.notifier).setFrequency(freq);
            },
            child: Container(
              width: 64,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.secondaryColor
                    : hasResult
                    ? AppTheme.successColor.withValues(alpha: 0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
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
        }).toList(),
      ),
    );
  }

  Widget _buildMaskingControls(
    BuildContext context,
    WidgetRef ref,
    BoneConductionState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.volume_up, color: AppTheme.warningColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contralateral Masking',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Level: ${state.maskingLevel} dB'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              ref.read(boneConductionProvider.notifier).adjustMaskingLevel(-5);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(boneConductionProvider.notifier).adjustMaskingLevel(5);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    WidgetRef ref,
    BoneConductionState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Column(
        children: [
          // Intensity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () {
                  ref.read(boneConductionProvider.notifier).decreaseIntensity();
                },
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(56, 56),
                ),
              ),
              const SizedBox(width: 16),
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
              IconButton.filled(
                onPressed: () {
                  ref.read(boneConductionProvider.notifier).increaseIntensity();
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

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(boneConductionProvider.notifier).toggleEar();
                  },
                  icon: const Icon(Icons.hearing),
                  label: Text(
                    state.currentEar == Ear.right
                        ? 'Active Ear: Right'
                        : 'Active Ear: Left',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: state.currentEar == Ear.right
                        ? AppTheme.rightEarColor
                        : AppTheme.leftEarColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(boneConductionProvider.notifier).toggleMasking();
                  },
                  icon: Icon(
                    state.isMasking ? Icons.volume_up : Icons.volume_off,
                  ),
                  label: Text(state.isMasking ? 'Masking: ON' : 'Masking: OFF'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: state.isMasking
                        ? AppTheme.warningColor
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isPlaying
                  ? null
                  : () {
                      ref.read(boneConductionProvider.notifier).playTone();
                    },
              icon: Icon(state.isPlaying ? Icons.vibration : Icons.play_arrow),
              label: Text(state.isPlaying ? 'Playing...' : 'Play Tone'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
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
                    ref.read(boneConductionProvider.notifier).recordResponse();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Heard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(boneConductionProvider.notifier)
                        .recordNoResponse();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('No Response'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
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
    BoneConductionState state,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('BC Test Results')),
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

            // Air-Bone Gap Analysis (if AC data provided)
            if (airConductionRight != null || airConductionLeft != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Air-Bone Gap Analysis',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Air-bone gap indicates conductive component of hearing loss.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text('• Gap > 10 dB suggests conductive loss'),
                      const Text('• Gap < 10 dB suggests sensorineural loss'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(boneConductionProvider.notifier).resetTest();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Test'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _saveBoneTest(context, ref, state),
                    icon: const Icon(Icons.check),
                    label: const Text('Save Results'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBoneTest(
    BuildContext context,
    WidgetRef ref,
    BoneConductionState state,
  ) async {
    final currentPatientId = patientId;
    if (currentPatientId == null || currentPatientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Open bone conduction from a patient before saving.'),
        ),
      );
      return;
    }

    final saved = await ref
        .read(clinicianTestResultsProvider.notifier)
        .saveTest(
          patientId: currentPatientId,
          rightEarResults: state.rightEarResults,
          leftEarResults: state.leftEarResults,
          testType: 'bone',
        );

    if (!context.mounted) {
      return;
    }

    if (saved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save bone conduction test.')),
      );
      return;
    }

    ref.read(boneConductionProvider.notifier).resetTest();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bone conduction test saved.')),
    );
    Navigator.of(context).pop();
  }
}

class _BoneConductionPatientPicker extends ConsumerWidget {
  const _BoneConductionPatientPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(clinicianPatientSummariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Patient')),
      body: patients.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 56,
                      color: AppTheme.textSecondaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No patients available',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a patient before starting bone conduction testing.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(patient.initials)),
                    title: Text(patient.name),
                    subtitle: Text('Age ${patient.age}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              BoneConductionScreen(patientId: patient.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
