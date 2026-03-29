import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioapp/core/theme/app_theme.dart';

enum LuxuryButtonType { primary, secondary, outline, ghost }

class LuxuryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final LuxuryButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const LuxuryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = LuxuryButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  State<LuxuryButton> createState() => _LuxuryButtonState();
}

class _LuxuryButtonState extends State<LuxuryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: disabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: 100.ms,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: 56,
          decoration: _buildDecoration(disabled),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: widget.isLoading ? _buildLoader() : _buildContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool disabled) {
    if (disabled) {
      return BoxDecoration(
        color: AppTheme.surfaceSubtleLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      );
    }

    switch (widget.type) {
      case LuxuryButtonType.primary:
        return BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case LuxuryButtonType.secondary:
        return BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.secondaryColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case LuxuryButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor, width: 1.5),
        );
      case LuxuryButtonType.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        );
    }
  }

  Widget _buildContent() {
    final textColor = _getTextColor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }

  Color _getTextColor() {
    if (widget.onPressed == null) return AppTheme.textSecondaryLight;

    switch (widget.type) {
      case LuxuryButtonType.primary:
        return AppTheme.secondaryColor;
      case LuxuryButtonType.secondary:
        return AppTheme.primaryColor;
      case LuxuryButtonType.outline:
      case LuxuryButtonType.ghost:
        return AppTheme.primaryColor;
    }
  }
}
