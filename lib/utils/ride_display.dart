import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/land_display.dart';
import 'package:disneyapp/utils/time_format.dart';
import 'package:flutter/material.dart';

extension RideDisplay on Ride {
  /// The standby wait, but only while the ride is operating — a closed or
  /// down ride can still carry a stale number from the API.
  int? get activeWait => status == RideStatus.operating ? standbyWait : null;

  Color get waitColor {
    final wait = activeWait;
    if (wait == null) {
      return AppColors.waitClosed;
    } else if (wait <= 20) {
      return AppColors.waitLow;
    } else if (wait <= 45) {
      return AppColors.waitMedium;
    } else {
      return AppColors.waitHigh;
    }
  }

  String get waitLabel {
    final wait = activeWait;
    if (wait != null) {
      return "$wait min";
    }

    return statusLabel;
  }

  String get statusLabel {
    switch (status) {
      case RideStatus.closed:
        return "Closed";
      case RideStatus.down:
        return "Down";
      case RideStatus.refurbishment:
        return "Refurb";
      case RideStatus.operating:
        return "Unavail";
      case RideStatus.unknown:
        return "Unavail";
    }
  }

  Color get landColor => landColorFor(land);

  /// True when there's an open Lightning Lane return window right now.
  bool get hasLightningLaneReturn => lightningLane?.returnStart != null;

  String? get formattedLastUpdated {
    final updated = lastUpdated;
    if (updated == null) return null;

    return formatClockTime(updated);
  }
}
