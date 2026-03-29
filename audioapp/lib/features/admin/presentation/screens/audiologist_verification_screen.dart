import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/core/presentation/widgets/luxury_header.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/core/presentation/widgets/luxury_button.dart';
import 'package:audioapp/modules/admin/application/use_cases/suspend_admin_user_use_case.dart';
import 'package:audioapp/modules/admin/application/use_cases/verify_admin_user_use_case.dart';
import 'package:audioapp/modules/admin/presentation/providers/admin_providers.dart';
import 'package:audioapp/modules/admin/presentation/view_models/admin_user_view_model.dart';

/// Audiologist verification screen with pending and verified lists
class AudiologistVerificationScreen extends ConsumerStatefulWidget {
  const AudiologistVerificationScreen({super.key});

  @override
  ConsumerState<AudiologistVerificationScreen> createState() =>
      _AudiologistVerificationScreenState();
}

class _AudiologistVerificationScreenState
    extends ConsumerState<AudiologistVerificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const LuxuryHeader(
              title: 'Verification',
              subtitle: 'Manage audiologist access',
            ),

            // Custom Luxury Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceSubtleLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondaryLight,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(
                    text: 'Pending',
                    icon: Icon(Icons.pending_actions_outlined),
                  ),
                  Tab(text: 'Verified', icon: Icon(Icons.verified_outlined)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildPendingTab(), _buildVerifiedTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    final pendingAsync = ref.watch(
      pendingAudiologistVerificationSummariesProvider,
    );

    return pendingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (audiologists) {
        if (audiologists.isEmpty) {
          return _buildEmptyState(
            'All Caught Up!',
            'No pending verifications at the moment.',
            Icons.check_circle_outline,
            AppTheme.successColor,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: audiologists.length,
          itemBuilder: (context, index) {
            return _buildPendingCard(audiologists[index], index);
          },
        );
      },
    );
  }

  Widget _buildVerifiedTab() {
    final verifiedAsync = ref.watch(verifiedAudiologistSummariesProvider);

    return verifiedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (audiologists) {
        if (audiologists.isEmpty) {
          return _buildEmptyState(
            'No Audiologists',
            'Verified accounts will appear here.',
            Icons.verified_outlined,
            AppTheme.textSecondaryLight,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: audiologists.length,
          itemBuilder: (context, index) {
            return _buildVerifiedCard(audiologists[index], index);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: color),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimaryLight),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(AdminUserViewModel audiologist, int index) {
    return LuxuryCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.warningColor.withValues(alpha: 0.1),
                child: Text(
                  audiologist.name.isNotEmpty
                      ? audiologist.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audiologist.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      audiologist.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: AppTheme.borderLight),
          const SizedBox(height: 16),

          _buildInfoRow(
            Icons.badge_outlined,
            'License',
            audiologist.licenseNumber ?? 'N/A',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.domain,
            'State',
            audiologist.licenseState ?? 'N/A',
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: LuxuryButton(
                  text: 'Reject',
                  onPressed: () => _rejectAudiologist(audiologist),
                  type: LuxuryButtonType.outline,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LuxuryButton(
                  text: 'Verify',
                  onPressed: () => _verifyAudiologist(audiologist),
                  type: LuxuryButtonType.primary,
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1);
  }

  Widget _buildVerifiedCard(AdminUserViewModel audiologist, int index) {
    return LuxuryCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppTheme.successColor.withValues(alpha: 0.1),
          child: const Icon(Icons.check, color: AppTheme.successColor),
        ),
        title: Text(
          audiologist.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Verified on ${DateFormat('MMM d').format(audiologist.verifiedAt ?? DateTime.now())}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _revokeVerification(audiologist),
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondaryLight),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(color: AppTheme.textSecondaryLight)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Future<void> _verifyAudiologist(AdminUserViewModel audiologist) async {
    try {
      await ref.read(verifyAdminUserUseCaseProvider)(
        VerifyAdminUserParams(userId: audiologist.id),
      );
      ref.invalidate(pendingAudiologistVerificationSummariesProvider);
      ref.invalidate(verifiedAudiologistSummariesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification Successful'),
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
    }
  }

  Future<void> _rejectAudiologist(AdminUserViewModel audiologist) async {
    try {
      await ref.read(suspendAdminUserUseCaseProvider)(
        SuspendAdminUserParams(
          userId: audiologist.id,
          reason: 'Verification rejected by admin',
        ),
      );
      ref.invalidate(pendingAudiologistVerificationSummariesProvider);
      ref.invalidate(verifiedAudiologistSummariesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audiologist rejected'),
            backgroundColor: AppTheme.warningColor,
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
    }
  }

  Future<void> _revokeVerification(AdminUserViewModel audiologist) async {
    try {
      await ref.read(revokeAdminUserVerificationUseCaseProvider)(
        audiologist.id,
      );
      ref.invalidate(pendingAudiologistVerificationSummariesProvider);
      ref.invalidate(verifiedAudiologistSummariesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification revoked'),
            backgroundColor: AppTheme.warningColor,
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
    }
  }
}
