import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../modules/ai_review/presentation/providers/ai_review_providers.dart';

class AiAuditLogScreen extends ConsumerStatefulWidget {
  const AiAuditLogScreen({super.key});

  @override
  ConsumerState<AiAuditLogScreen> createState() => _AiAuditLogScreenState();
}

class _AiAuditLogScreenState extends ConsumerState<AiAuditLogScreen> {
  String _actionFilter = 'all';
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final auditLogsAsync = ref.watch(aiAuditLogsByLimitProvider(200));

    return Scaffold(
      appBar: AppBar(title: const Text('AI Audit Log')),
      body: auditLogsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load AI audit logs: $error')),
        data: (rawLogs) {
          final logs = rawLogs
              .where((l) {
                if (_actionFilter == 'all') return true;
                return l.action == _actionFilter;
              })
              .where((l) {
                if (_dateRange == null) return true;
                return !l.createdAt.isBefore(_dateRange!.start) &&
                    !l.createdAt.isAfter(_dateRange!.end);
              })
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _actionFilter,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Actions')),
                        DropdownMenuItem(value: 'ai_accept', child: Text('AI Accepted')),
                        DropdownMenuItem(value: 'ai_override', child: Text('AI Overridden')),
                      ],
                      onChanged: (value) => setState(() => _actionFilter = value ?? 'all'),
                      decoration: const InputDecoration(labelText: 'Action Filter'),
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
                              if (picked != null) setState(() => _dateRange = picked);
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
                child: logs.isEmpty
                    ? Center(
                        child: Text(
                          'No AI audit logs match filters',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.policy),
                              title: Text(log.action),
                              subtitle: Text(DateFormat('MMM d, yyyy • h:mm a').format(log.createdAt)),
                              trailing: Text(log.userEmail),
                            ),
                          );
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
