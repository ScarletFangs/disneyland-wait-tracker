import 'package:flutter/material.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/ride_display.dart';
import 'package:disneyapp/widgets/wait_badge.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onTap;
  final bool isLandShown;
  const RideCard({
    super.key,
    required this.ride,
    required this.onTap,
    this.isLandShown = true,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return Card(
      // Clips the InkWell ripple to the card's rounded corners.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.name, style: AppTextStyles.headingMedium),
                    if (isLandShown || ride.hasLightningLaneReturn) ...[
                      const SizedBox(height: 4),
                      _buildSubtitle(),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              WaitBadge(ride: ride),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    final returnTime = ride.lightningLane?.formattedTime;

    return Row(
      children: [
        if (isLandShown)
          Flexible(
            child: Text(
              ride.land ?? 'Disneyland Park',
              style: AppTextStyles.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (isLandShown && returnTime != null) const SizedBox(width: 10),
        if (returnTime != null) ...[
          const Icon(Icons.bolt, size: 16, color: AppColors.accentDark),
          Text(returnTime, style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}
