import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioapp/core/router/app_router.dart';
import 'package:audioapp/core/theme/app_theme.dart';
import 'package:audioapp/core/presentation/widgets/luxury_card.dart';
import 'package:audioapp/core/presentation/widgets/luxury_button.dart';

class QuickActionCard extends StatelessWidget {
  final VoidCallback onHistoryTap;

  const QuickActionCard({
    super.key,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      color: AppTheme.primaryColor, // Midnight Blue background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor, // Gold icon bg
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppTheme.primaryColor, // Dark icon
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Assessment',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.secondaryColor, // Gold text
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '5-minute self-check',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: LuxuryButton(
                  text: 'Start Now',
                  onPressed: () => context.push(AppRoutes.screeningStart),
                  type: LuxuryButtonType.secondary, // Gold button
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LuxuryButton(
                  text: 'History',
                  onPressed: onHistoryTap,
                  type: LuxuryButtonType.outline, // Outline on dark bg
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
