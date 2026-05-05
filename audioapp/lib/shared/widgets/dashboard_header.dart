import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? avatarText;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogoutTap;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.avatarText,
    this.onProfileTap,
    this.onNotificationTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSubtleLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Center(
                child: Text(
                  avatarText ??
                      (subtitle.isNotEmpty ? subtitle[0].toUpperCase() : '?'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          _buildActionIcon(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationTap ?? () {},
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.9),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          PopupMenuButton<String>(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.surfaceSubtleLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: const Icon(Icons.more_horiz),
            ),
            onSelected: (value) {
              if (value == 'logout' && onLogoutTap != null) {
                onLogoutTap!();
              } else if (value == 'profile' && onProfileTap != null) {
                onProfileTap!();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.errorColor),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required VoidCallback onTap,
    Widget? child,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.surfaceSubtleLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Center(child: child ?? Icon(icon)),
      ),
    );
  }
}
