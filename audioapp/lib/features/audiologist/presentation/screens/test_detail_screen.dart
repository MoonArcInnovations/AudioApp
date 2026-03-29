import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../modules/ai_review/application/use_cases/update_ai_decision_use_case.dart';
import '../../../../modules/ai_review/presentation/providers/ai_review_providers.dart';
import '../../../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_patient_view_model.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_test_detail_view_model.dart';
import '../../../../modules/clinician_testing/presentation/view_models/clinician_test_summary_view_model.dart';
import '../../../../modules/patient_screening/presentation/providers/patient_screening_providers.dart';
import '../../../../modules/reporting/presentation/providers/reporting_providers.dart';
import '../../../../shared/widgets/audiogram_chart.dart';

/// Test detail view screen for audiologists
/// Shows full audiogram, test info, and allows editing/export
class TestDetailScreen extends ConsumerStatefulWidget {
  final String testId;
  final String patientId;

  const TestDetailScreen({
    super.key,
    required this.testId,
    required this.patientId,
  });

  @override
  ConsumerState<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends ConsumerState<TestDetailScreen> {
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(logTestResultViewUseCaseProvider)(widget.testId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientAsync = ref.watch(
      clinicianPatientSummaryProvider(widget.patientId),
    );
    final test = ref.watch(clinicianTestSummaryByIdProvider(widget.testId));
    final testDetail = ref.watch(clinicianTestDetailProvider(widget.testId));

    if (test == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test Details')),
        body: const Center(child: Text('Test not found')),
      );
    }

    final patient = patientAsync;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with actions
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                patient?.name ?? 'Patient Test',
                style: const TextStyle(fontSize: 16),
              ),
              background: Container(color: AppTheme.surfaceSubtleLight),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _showShareOptions(context, test),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, test),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'export_pdf',
                    child: Text('Export PDF'),
                  ),
                  const PopupMenuItem(value: 'print', child: Text('Print')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit Notes')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete Test',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Test info card
                  _buildInfoCard(testDetail?.test ?? test, patient),

                  const SizedBox(height: 24),

                  // Audiogram
                  _buildAudiogramSection(testDetail?.test ?? test),

                  const SizedBox(height: 24),

                  // Classifications
                  _buildClassificationsSection(testDetail?.test ?? test),

                  const SizedBox(height: 24),

                  // Related AC/BC test
                  _buildRelatedTestSection(context, testDetail),

                  const SizedBox(height: 24),

                  // Air-bone gap summary (if both tests exist)
                  _buildAirBoneGapSection(testDetail),

                  const SizedBox(height: 24),

                  // AI assist (stub)
                  _buildAiAssistSection(test.id),

                  const SizedBox(height: 24),

                  // Linked screening (if imported BC references screening)
                  _buildLinkedScreeningSection(context, test),

                  const SizedBox(height: 24),

                  // Threshold table
                  _buildThresholdTable(testDetail?.test ?? test),

                  const SizedBox(height: 24),

                  // Notes and recommendations
                  if (test.notes != null || test.recommendations != null)
                    _buildNotesSection(testDetail?.test ?? test),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : () => _exportReport(test.id),
        icon: _isExporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.picture_as_pdf),
        label: Text(_isExporting ? 'Exporting...' : 'Generate Report'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildInfoCard(
    ClinicianTestSummaryViewModel test,
    ClinicianPatientViewModel? patient,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: test.overallStatusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.hearing,
                    color: test.overallStatusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _testTypeLabel(test.testType),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'EEEE, MMMM d, yyyy • h:mm a',
                        ).format(test.testDate),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoItem(
                  Icons.person,
                  'Patient',
                  patient?.name ?? 'Unknown',
                ),
                if (patient?.dateOfBirth != null)
                  _buildInfoItem(
                    Icons.cake,
                    'Age',
                    '${DateTime.now().year - patient!.dateOfBirth.year}',
                  ),
                if (test.audiologistId.isNotEmpty)
                  _buildInfoItem(
                    Icons.medical_services,
                    'Tester',
                    'Audiologist',
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _testTypeLabel(String? type) {
    switch (type) {
      case 'bone':
        return 'Bone Conduction Test';
      case 'screening':
        return 'AC Screening Test';
      case 'air':
        return 'Air Conduction Test';
      default:
        return 'Audiometry Test';
    }
  }

  Widget _buildRelatedTestSection(
    BuildContext context,
    ClinicianTestDetailViewModel? detail,
  ) {
    final related = detail?.relatedTest;
    if (related == null) return const SizedBox.shrink();

    return Card(
      child: ListTile(
        leading: Icon(
          related.testType == 'bone' ? Icons.vibration : Icons.hearing,
          color: AppTheme.primaryColor,
        ),
        title: Text(_testTypeLabel(related.testType)),
        subtitle: Text(
          DateFormat('MMM d, yyyy • h:mm a').format(related.testDate),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestDetailScreen(
                testId: related.id,
                patientId: related.patientId,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAirBoneGapSection(ClinicianTestDetailViewModel? detail) {
    final rightGap = detail?.rightAirBoneGap ?? const <int, int>{};
    final leftGap = detail?.leftAirBoneGap ?? const <int, int>{};
    if (rightGap.isEmpty && leftGap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Air-Bone Gap Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        _buildAbgTable('Right Ear', rightGap),
        const SizedBox(height: 12),
        _buildAbgTable('Left Ear', leftGap),
      ],
    );
  }

  Widget _buildAiAssistSection(String testId) {
    final recommendationAsync = ref.watch(aiAssistForTestProvider(testId));

    return recommendationAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Unable to load AI assist: $error'),
        ),
      ),
      data: (assist) {
        if (assist == null) {
          return const SizedBox.shrink();
        }

        final type = assist.suggestionType;
        final confidence = assist.confidence;
        final decision = assist.accepted;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assist',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('Suggested Type: $type'),
                Text('Confidence: ${(confidence * 100).toStringAsFixed(0)}%'),
                const SizedBox(height: 8),
                Text(
                  decision == null
                      ? 'Decision: Pending'
                      : (decision
                            ? 'Decision: Accepted'
                            : 'Decision: Overridden'),
                  style: TextStyle(
                    color: decision == null
                        ? Colors.grey.shade600
                        : (decision
                              ? AppTheme.successColor
                              : AppTheme.errorColor),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: decision == true
                            ? null
                            : () => _promptAiDecision(
                                assist.anchorTestId,
                                true,
                                testId,
                              ),
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: decision == false
                            ? null
                            : () => _promptAiDecision(
                                assist.anchorTestId,
                                false,
                                testId,
                              ),
                        child: const Text('Override'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Note: AI is assistive only. Clinician must verify.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _promptAiDecision(
    String testId,
    bool accepted,
    String sourceTestId,
  ) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          accepted ? 'Accept AI Suggestion' : 'Override AI Suggestion',
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Decision Notes (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null && !accepted) return;
    await _saveAiDecisionWithNotes(
      testId,
      accepted,
      result?.trim(),
      sourceTestId,
    );
  }

  Future<void> _saveAiDecisionWithNotes(
    String testId,
    bool accepted,
    String? notes,
    String sourceTestId,
  ) async {
    final user = ref.read(authStateProvider).user;
    if (user == null) return;
    await ref.read(updateAiDecisionUseCaseProvider)(
      UpdateAiDecisionParams(
        testId: testId,
        accepted: accepted,
        decisionBy: user.id,
        notes: notes,
      ),
    );
    ref.invalidate(aiAssistForTestProvider(sourceTestId));
    ref.invalidate(aiRecommendationByTestProvider(testId));
    ref.invalidate(allAiRecommendationsProvider);
    ref.invalidate(aiDecisionHistoryItemsProvider);
  }

  Widget _buildLinkedScreeningSection(
    BuildContext context,
    ClinicianTestSummaryViewModel test,
  ) {
    if (test.screeningId == null) return const SizedBox.shrink();
    final screeningAsync = ref.watch(
      screeningByIdSummaryProvider(test.screeningId!),
    );
    return screeningAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load screening: $error'),
      data: (screening) {
        if (screening == null) return const SizedBox.shrink();
        return Card(
          child: ListTile(
            leading: const Icon(Icons.hearing),
            title: const Text('Linked AC Screening'),
            subtitle: Text(
              DateFormat('MMM d, yyyy • h:mm a').format(screening.testDate),
            ),
            trailing: Text(screening.result.toUpperCase()),
          ),
        );
      },
    );
  }

  Widget _buildAbgTable(String title, Map<int, int> gapByFreq) {
    if (gapByFreq.isEmpty) {
      return Text('$title: No overlapping frequencies');
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...gapByFreq.entries.map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('${e.key} Hz'), Text('${e.value} dB')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudiogramSection(ClinicianTestSummaryViewModel test) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Audiogram',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
            // Legend
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.rightEarColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Right', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.leftEarColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Left', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AudiogramChart(
              rightEarData: test.rightEarResults,
              leftEarData: test.leftEarResults,
              showLegend: true,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildClassificationsSection(ClinicianTestSummaryViewModel test) {
    return Row(
      children: [
        Expanded(
          child: _buildEarClassification(
            'Right Ear',
            test.rightClassification,
            test.rightPta,
            AppTheme.rightEarColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEarClassification(
            'Left Ear',
            test.leftClassification,
            test.leftPta,
            AppTheme.leftEarColor,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildEarClassification(
    String earLabel,
    String classification,
    double pta,
    Color color,
  ) {
    final severityColor = _getSeverityColor(classification);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Text(earLabel, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            classification,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: severityColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PTA: ${pta.toStringAsFixed(1)} dB HL',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'normal':
        return AppTheme.successColor;
      case 'slight':
      case 'mild':
        return AppTheme.warningColor;
      case 'moderate':
        return AppTheme.warningColor;
      case 'moderately severe':
        return AppTheme.errorColor.withValues(alpha: 0.85);
      case 'severe':
        return AppTheme.errorColor;
      case 'profound':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  Widget _buildThresholdTable(ClinicianTestSummaryViewModel test) {
    final frequencies = [250, 500, 1000, 2000, 4000, 8000];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Threshold Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              // Header
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                children: [
                  _buildTableCell('Frequency', isHeader: true),
                  _buildTableCell(
                    'Right',
                    isHeader: true,
                    color: AppTheme.rightEarColor,
                  ),
                  _buildTableCell(
                    'Left',
                    isHeader: true,
                    color: AppTheme.leftEarColor,
                  ),
                ],
              ),
              // Data rows
              ...frequencies.map((freq) {
                final rightPoint = test.rightEarResults
                    .where((p) => p.frequency == freq)
                    .firstOrNull;
                final leftPoint = test.leftEarResults
                    .where((p) => p.frequency == freq)
                    .firstOrNull;
                return TableRow(
                  children: [
                    _buildTableCell('$freq Hz'),
                    _buildTableCell(
                      rightPoint != null ? '${rightPoint.thresholdDb} dB' : '-',
                    ),
                    _buildTableCell(
                      leftPoint != null ? '${leftPoint.thresholdDb} dB' : '-',
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNotesSection(ClinicianTestSummaryViewModel test) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes & Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        if (test.notes != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  test.notes!,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        if (test.notes != null && test.recommendations != null)
          const SizedBox(height: 12),
        if (test.recommendations != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Recommendations',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  test.recommendations!,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  void _showShareOptions(
    BuildContext context,
    ClinicianTestSummaryViewModel test,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Test Results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppTheme.errorColor,
                ),
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Generate detailed report'),
              onTap: () {
                Navigator.pop(context);
                _exportReport(test.id);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.email, color: AppTheme.infoColor),
              ),
              title: const Text('Share PDF'),
              subtitle: const Text('Open the system share sheet'),
              onTap: () {
                Navigator.pop(context);
                _shareReport(test.id);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.print, color: AppTheme.successColor),
              ),
              title: const Text('Print'),
              subtitle: const Text('Print audiogram report'),
              onTap: () {
                Navigator.pop(context);
                _previewReport(test.id);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, ClinicianTestSummaryViewModel test) {
    switch (action) {
      case 'export_pdf':
        _previewReport(test.id);
        break;
      case 'print':
        _previewReport(test.id);
        break;
      case 'edit':
        _showEditNotesDialog(test);
        break;
      case 'delete':
        _confirmDelete(test);
        break;
    }
  }

  Future<void> _exportReport(String testId) async {
    setState(() => _isExporting = true);

    try {
      await ref.read(previewSavedTestReportProvider)(testId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report generated successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _previewReport(String testId) {
    return _exportReport(testId);
  }

  Future<void> _shareReport(String testId) async {
    setState(() => _isExporting = true);

    try {
      await ref.read(shareSavedTestReportProvider)(testId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report shared successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _showEditNotesDialog(ClinicianTestSummaryViewModel test) {
    final notesController = TextEditingController(text: test.notes ?? '');
    final recommendationsController = TextEditingController(
      text: test.recommendations ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Notes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Clinical observations...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: recommendationsController,
              decoration: const InputDecoration(
                labelText: 'Recommendations',
                hintText: 'Follow-up actions...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(clinicianTestResultsProvider.notifier)
                  .updateTestNotes(
                    testId: test.id,
                    notes: notesController.text.trim().isEmpty
                        ? null
                        : notesController.text.trim(),
                    recommendations:
                        recommendationsController.text.trim().isEmpty
                        ? null
                        : recommendationsController.text.trim(),
                  );
              ref.invalidate(clinicianTestDetailProvider(test.id));
              ref.invalidate(clinicianTestSummaryByIdProvider(test.id));
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notes updated'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ClinicianTestSummaryViewModel test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Test'),
        content: const Text(
          'Are you sure you want to delete this test? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(clinicianTestResultsProvider.notifier)
                  .deleteTest(test.id);
              ref.invalidate(aiAssistForTestProvider(test.id));
              ref.invalidate(aiRecommendationByTestProvider(test.id));
              ref.invalidate(clinicianTestDetailProvider(test.id));
              ref.invalidate(clinicianTestSummaryByIdProvider(test.id));
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test deleted'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
