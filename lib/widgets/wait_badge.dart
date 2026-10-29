import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/ride_display.dart';
import 'package:flutter/material.dart';

/// Filled, wait-colored square: big number + "min", or the status word when
/// the ride has no live wait.
class WaitBadge extends StatelessWidget {
  final Ride ride;
  const WaitBadge({super.key, required this.ride});

  static const double _width = 68;
  static const double _height = 58;

  @override
  Widget build(BuildContext context) {
    final wait = ride.activeWait;

    return Container(
      width: _width,
      height: _height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ride.waitColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: wait == null
          ? Text(
              ride.statusLabel,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$wait',
                  style: AppTextStyles.headingLarge.copyWith(height: 1.1),
                ),
                Text(
                  'min',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
    );
  }
}
