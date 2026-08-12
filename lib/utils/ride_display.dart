import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

extension RideDisplay on Ride {
  Color get waitColor {
    final wait = standbyWait;
    if (status != RideStatus.operating || wait == null) {
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
    if (standbyWait != null) {
      return "$standbyWait min";
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
}
