import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/land_display.dart';
import 'package:flutter/material.dart';

/// Land-colored dot + land name + ride count, above each group on Wait Times.
class LandSectionHeader extends StatelessWidget {
  final String land;
  final int rideCount;
  const LandSectionHeader({
    super.key,
    required this.land,
    required this.rideCount,
  });

  static const double _dotSize = 14;

  @override
  Widget build(BuildContext context) {
    final rideWord = rideCount == 1 ? 'ride' : 'rides';

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Row(
        children: [
          Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: landColorFor(land),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(land, style: AppTextStyles.headingMedium)),
          Text('$rideCount $rideWord', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
