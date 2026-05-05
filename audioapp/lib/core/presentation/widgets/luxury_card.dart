import 'package:flutter/material.dart';
import 'package:audioapp/core/theme/app_theme.dart';

class LuxuryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double elevation;

  const LuxuryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card color based on theme if not provided
    final cardColor =
        color ?? Theme.of(context).cardTheme.color ?? AppTheme.surfaceLight;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppTheme.secondaryColor.withValues(
            alpha: 0.1,
          ), // Subtle gold border
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
