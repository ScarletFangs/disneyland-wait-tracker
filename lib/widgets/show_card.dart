import 'package:disneyapp/models/show.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/land_display.dart';
import 'package:flutter/material.dart';

/// One show: name, land (when known), and a chip per performance. Past
/// performances are greyed; shows with nothing scheduled today are dimmed.
class ShowCard extends StatelessWidget {
  final Show show;
  const ShowCard({super.key, required this.show});

  static const double _dimmedOpacity = 0.55;
  static const double _dotSize = 10;

  @override
  Widget build(BuildContext context) {
    final hasShowtimes = show.showTimes.isNotEmpty;

    return Opacity(
      opacity: hasShowtimes ? 1 : _dimmedOpacity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(show.name, style: AppTextStyles.headingSmall),
              if (show.land != null) ...[
                const SizedBox(height: 4),
                _buildLandRow(),
              ],
              const SizedBox(height: 12),
              hasShowtimes
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: show.showTimes.map(_buildTimeChip).toList(),
                    )
                  : Text('No shows today', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandRow() {
    return Row(
      children: [
        Container(
          width: _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            color: landColorFor(show.land),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(show.land ?? '', style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildTimeChip(ShowTime showTime) {
    final isPast = showTime.isPast;

    return Chip(
      label: Text(showTime.formattedTime),
      // Drops the 48px tap-target padding so wrapped rows sit close together.
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: isPast ? AppColors.inputFill : null,
      labelStyle: isPast
          ? AppTextStyles.labelMedium.copyWith(color: AppColors.textDisabled)
          : null,
    );
  }
}
