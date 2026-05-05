import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../modules/auth/domain/entities/app_user.dart';
import '../../../../modules/auth/presentation/controllers/auth_controller.dart';

class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final verificationState = authState.verificationState;
    final isRejected = verificationState == UserVerificationState.rejected;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: isRejected
                        ? AppTheme.errorColor.withValues(alpha: 0.1)
                        : AppTheme.warningColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRejected ? Icons.block_outlined : Icons.pending_actions,
                    color: isRejected
                        ? AppTheme.errorColor
                        : AppTheme.warningColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isRejected
                      ? 'Audiologist Access Not Approved'
                      : 'Audiologist Access Pending',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isRejected
                      ? 'Your account exists, but clinician access is currently '
                          'restricted. Please contact an administrator.'
                      : 'Your account has been created. An administrator must '
                          'verify your clinician access before testing tools are available.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Signed in as',
                          value: authState.user?.email ?? 'Unknown account',
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          label: 'Role',
                          value: UserRole.audiologist.displayName,
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          label: 'Status',
                          value: verificationState.name,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: authState.isLoading
                      ? null
                      : () => ref.read(authStateProvider.notifier).signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
