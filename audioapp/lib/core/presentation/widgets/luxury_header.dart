import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioapp/core/theme/app_theme.dart';

class LuxuryHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget>? actions;

  const LuxuryHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBackButton && context.canPop()) ...[
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  color: AppTheme.primaryColor,
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.surfaceLight,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppTheme.borderLight),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: showBackButton ? 56.0 : 0),
              child: Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
