import 'package:flutter/material.dart';
import 'package:loan/core/theme/app_theme.dart';

/// A chip-style badge that displays status with color-coded backgrounds.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (type) {
      StatusType.success => (
          AppColors.success.withValues(alpha: 0.15),
          AppColors.success
        ),
      StatusType.warning => (
          AppColors.warning.withValues(alpha: 0.15),
          AppColors.warning
        ),
      StatusType.error => (
          AppColors.error.withValues(alpha: 0.15),
          AppColors.error
        ),
      StatusType.info => (
          AppColors.info.withValues(alpha: 0.15),
          AppColors.info
        ),
      StatusType.neutral => (
          AppColors.textHint.withValues(alpha: 0.15),
          AppColors.textSecondary
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

enum StatusType { success, warning, error, info, neutral }
