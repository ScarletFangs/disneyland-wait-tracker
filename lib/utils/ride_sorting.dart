import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/utils/land_display.dart';

/// Rides grouped by land in park walking order, A–Z inside each land.
/// Empty lands are left out; unlisted lands collect under [otherLandName].
Map<String, List<Ride>> groupRidesByLand(List<Ride> rides) {
  final sortedByName = sortByName(rides);
  final groups = <String, List<Ride>>{};

  for (final land in [...parkLandOrder, otherLandName]) {
    final ridesInLand = sortedByName
        .where((ride) => _groupNameFor(ride) == land)
        .toList();
    if (ridesInLand.isNotEmpty) {
      groups[land] = ridesInLand;
    }
  }

  return groups;
}

int _compareByName(Ride a, Ride b) {
  return a.name.toLowerCase().compareTo(b.name.toLowerCase());
}

String _groupNameFor(Ride ride) {
  final land = ride.land;
  return land != null && parkLandOrder.contains(land) ? land : otherLandName;
}

/// Every ride A–Z by name, ignoring capitalization.
List<Ride> sortByName(List<Ride> rides) {
  return [...rides]..sort(_compareByName);
}

/// The newest `lastUpdated` across all rides — shown as "Updated 2:41 PM".
DateTime? latestUpdate(List<Ride> rides) {
  DateTime? latest;
  for (final ride in rides) {
    final updated = ride.lastUpdated;
    if (updated != null && (latest == null || updated.isAfter(latest))) {
      latest = updated;
    }
  }

  return latest;
}
