import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../../../modules/ai_review/application/use_cases/ai_decision_export_params.dart';
import '../../../../modules/ai_review/presentation/providers/ai_review_providers.dart';
import '../../../../modules/ai_review/presentation/view_models/ai_decision_history_item_view_model.dart';
import '../../../../modules/clinician_testing/presentation/providers/clinician_testing_providers.dart';

class AiDecisionHistoryScreen extends ConsumerWidget {
  const AiDecisionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(clinicianTestResultsProvider);
    final historyItemsAsync = ref.watch(aiDecisionHistoryItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Decision History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportCsv(context, ref),
            tooltip: 'Export CSV',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPdf(context, ref),
            tooltip: 'Export PDF',
          ),
        ],
      ),
      body: tests.isEmpty
          ? Center(
              child: Text(
                'No tests available',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          : historyItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Failed to load AI decisions: $error')),
              data: (items) => _AiDecisionHistoryList(items: items),
            ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authStateProvider).user;
    if (user == null) {
      return;
    }
    final count = await ref.read(shareAiDecisionCsvUseCaseProvider)(
      AiDecisionExportParams(audiologistId: user.id),
    );
    if (!context.mounted) {
      return;
    }
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No AI decisions to export')),
      );
    }
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authStateProvider).user;
    if (user == null) {
      return;
    }
    final count = await ref.read(shareAiDecisionPdfUseCaseProvider)(
      AiDecisionExportParams(audiologistId: user.id),
    );
    if (!context.mounted) {
      return;
    }
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No AI decisions to export')),
      );
    }
  }
}

class _AiDecisionHistoryList extends ConsumerStatefulWidget {
  const _AiDecisionHistoryList({required this.items});

  final List<AiDecisionHistoryItemViewModel> items;

  @override
  ConsumerState<_AiDecisionHistoryList> createState() =>
      _AiDecisionHistoryListState();
}

class _AiDecisionHistoryListState
    extends ConsumerState<_AiDecisionHistoryList> {
  String? _patientId;
  DateTimeRange? _dateRange;
  String _decision = 'all';

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(clinicianPatientsProvider);
    final filtered = widget.items.where((item) {
      if (_patientId != null && item.patientId != _patientId) return false;
      if (_dateRange != null) {
        if (item.testDate.isBefore(_dateRange!.start) ||
            item.testDate.isAfter(_dateRange!.end)) {
          return false;
        }
      }
      if (_decision != 'all') {
        if (_decision == 'pending' && item.accepted != null) return false;
        if (_decision == 'accepted' && item.accepted != true) return false;
        if (_decision == 'overridden' && item.accepted != false) return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _patientId ?? 'all',
                items: [
                  const DropdownMenuItem(
                    value: 'all',
                    child: Text('All Patients'),
                  ),
                  ...patients.map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _patientId = value == 'all' ? null : value),
                decoration: const InputDecoration(labelText: 'Patient'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _decision,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Decisions')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
                  DropdownMenuItem(
                    value: 'overridden',
                    child: Text('Overridden'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _decision = value ?? 'all'),
                decoration: const InputDecoration(labelText: 'Decision Type'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(now.year - 5),
                          lastDate: now,
                        );
                        if (picked != null) {
                          setState(() => _dateRange = picked);
                        }
                      },
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _dateRange == null
                            ? 'Select Date Range'
                            : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => setState(() => _dateRange = null),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'No AI decisions match filters',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.psychology),
                        title: Text('Test ${item.testId}'),
                        subtitle: Text(
                          '${DateFormat('MMM d, yyyy').format(item.testDate)} • ${item.suggestionType} (${(item.confidence * 100).toStringAsFixed(0)}%)',
                        ),
                        trailing: Text(item.decisionLabel),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
