import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../../../modules/patient_screening/presentation/providers/patient_screening_providers.dart';
import '../../../../modules/patient_screening/presentation/view_models/screening_summary_view_model.dart';
import 'screening_start_screen.dart';

/// Screening history screen - shows past screening results
class ScreeningHistoryScreen extends ConsumerWidget {
  const ScreeningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Screening History')),
        body: const Center(child: Text('Please log in to view your history')),
      );
    }

    final historyAsync = ref.watch(screeningHistorySummaryProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 16),
              Text('Error loading history: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(screeningHistorySummaryProvider(user.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (results) {
          if (results.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildHistoryList(context, results);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScreeningStartScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Screening'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hearing_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Screenings Yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Take your first hearing screening to start tracking your hearing health.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ScreeningStartScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start First Screening'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<ScreeningSummaryViewModel> results,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildHistoryCard(context, result, index);
      },
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    ScreeningSummaryViewModel result,
    int index,
  ) {
    final resultColor = _getResultColor(result.result);
    final resultIcon = _getResultIcon(result.result);
    final resultLabel = _getResultLabel(result.result);

    // Calculate average threshold
    final avgThreshold = result.averageThreshold;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: resultColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => _showResultDetails(context, result),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and result
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: resultColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(resultIcon, color: resultColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM d, yyyy').format(result.testDate),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('h:mm a').format(result.testDate),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: resultColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      resultLabel,
                      style: TextStyle(
                        color: resultColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Avg Threshold',
                    '${avgThreshold.toStringAsFixed(0)} dB',
                    Icons.hearing,
                  ),
                  _buildStatItem(
                    'Headphones',
                    result.headphoneModel ?? 'Unknown',
                    Icons.headphones,
                  ),
                  _buildStatItem(
                    'Noise',
                    '${(result.ambientNoiseDb ?? 0).toStringAsFixed(0)} dB',
                    Icons.volume_up,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }

  Color _getResultColor(String result) {
    switch (result.toLowerCase()) {
      case 'pass':
        return AppTheme.successColor;
      case 'borderline':
        return AppTheme.warningColor;
      case 'refer':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getResultIcon(String result) {
    switch (result.toLowerCase()) {
      case 'pass':
        return Icons.check_circle;
      case 'borderline':
        return Icons.warning_amber_rounded;
      case 'refer':
        return Icons.priority_high;
      default:
        return Icons.help_outline;
    }
  }

  String _getResultLabel(String result) {
    switch (result.toLowerCase()) {
      case 'pass':
        return 'Normal';
      case 'borderline':
        return 'Borderline';
      case 'refer':
        return 'Refer';
      default:
        return 'Unknown';
    }
  }

  void _showResultDetails(
    BuildContext context,
    ScreeningSummaryViewModel result,
  ) {
    final resultColor = _getResultColor(result.result);

    // Split thresholds into left and right
    final rightThresholds = <String, int>{};
    final leftThresholds = <String, int>{};

    result.thresholds.forEach((key, value) {
      if (key.startsWith('R_')) {
        rightThresholds[key.substring(2)] = value;
      } else if (key.startsWith('L_')) {
        leftThresholds[key.substring(2)] = value;
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getResultIcon(result.result),
                        color: resultColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM d, yyyy').format(result.testDate),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: resultColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getResultLabel(result.result),
                              style: TextStyle(
                                color: resultColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Thresholds section
                Text(
                  'Thresholds by Frequency',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Right ear
                _buildEarThresholds(
                  context,
                  'Right Ear',
                  rightThresholds,
                  AppTheme.rightEarColor,
                ),
                const SizedBox(height: 12),

                // Left ear
                _buildEarThresholds(
                  context,
                  'Left Ear',
                  leftThresholds,
                  AppTheme.leftEarColor,
                ),

                const SizedBox(height: 24),

                // Test details
                Text(
                  'Test Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Headphones',
                  result.headphoneModel ?? 'Unknown',
                ),
                _buildDetailRow(
                  'Ambient Noise',
                  '${(result.ambientNoiseDb ?? 0).toStringAsFixed(0)} dB',
                ),
                _buildDetailRow('Test ID', result.id.substring(0, 8)),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEarThresholds(
    BuildContext context,
    String ear,
    Map<String, int> thresholds,
    Color color,
  ) {
    if (thresholds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hearing, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                ear,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: thresholds.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${entry.key} Hz: ${entry.value} dB',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
