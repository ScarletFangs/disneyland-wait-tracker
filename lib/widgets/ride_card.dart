import 'package:flutter/material.dart';
import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/ride_display.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onTap;
  const RideCard({super.key, required this.ride, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(ride.name), Text(ride.land ?? "---")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
