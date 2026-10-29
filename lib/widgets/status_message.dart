import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Centered icon + message + optional hint — used for every empty and error
/// state so they all look the same.
class StatusMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? hint;
  final bool isError;
  const StatusMessage({
    super.key,
    required this.icon,
    required this.message,
    this.hint,
    this.isError = false,
  });

  static const double _iconSize = 56;

  @override
  Widget build(BuildContext context) {
    final hintText = hint;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: _iconSize,
              color: isError ? AppColors.errorDark : AppColors.primaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            if (hintText != null) ...[
              const SizedBox(height: 6),
              Text(
                hintText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
