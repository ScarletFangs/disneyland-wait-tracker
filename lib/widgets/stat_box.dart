import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Label above a filled box with one big value — Ride Detail's wait and
/// Lightning Lane boxes.
class StatBox extends StatelessWidget {
  final String label;
  final Color color;
  final String value;
  final String? caption;
  const StatBox({
    super.key,
    required this.label,
    required this.color,
    required this.value,
    this.caption,
  });

  static const double _boxHeight = 104;

  @override
  Widget build(BuildContext context) {
    final captionText = caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: _boxHeight,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shrinks long values ("Not available") instead of wrapping.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: AppTextStyles.displayMedium),
              ),
              if (captionText != null)
                Text(
                  captionText,
                  style: AppTextStyles.labelMedium,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
