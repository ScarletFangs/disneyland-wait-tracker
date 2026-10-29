import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/utils/land_display.dart';
import 'package:disneyapp/utils/ride_display.dart';

/// Rides grouped by land in park walking order, A–Z inside each land.
/// Empty lands are left out; unlisted lands collect under [otherLandName].
Map<String, List<Ride>> groupRidesByLand(List<Ride> rides) {
  final sortedByName = [...rides]..sort((a, b) => a.name.compareTo(b.name));
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

String _groupNameFor(Ride ride) {
  final land = ride.land;
  return land != null && parkLandOrder.contains(land) ? land : otherLandName;
}

/// Operating rides from shortest to longest wait, then everything without a
/// live wait (closed, down, refurb) A–Z at the bottom.
List<Ride> sortByShortestWait(List<Ride> rides) {
  return [...rides]..sort((a, b) {
    final waitA = a.activeWait;
    final waitB = b.activeWait;

    if (waitA == null && waitB == null) return a.name.compareTo(b.name);
    if (waitA == null) return 1;
    if (waitB == null) return -1;

    final byWait = waitA.compareTo(waitB);
    return byWait != 0 ? byWait : a.name.compareTo(b.name);
  });
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
