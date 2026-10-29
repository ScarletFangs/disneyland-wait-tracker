import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/utils/land_display.dart';
import 'package:disneyapp/utils/ride_sorting.dart';
import 'package:flutter_test/flutter_test.dart';

Ride _ride(
  String name, {
  int? wait,
  RideStatus status = RideStatus.operating,
  String? land,
  DateTime? lastUpdated,
}) {
  return Ride(
    id: name,
    name: name,
    status: status,
    standbyWait: wait,
    land: land,
    lastUpdated: lastUpdated,
    hasQueue: true,
    lightningLane: null,
  );
}

void main() {
  group('groupRidesByLand', () {
    test('should order lands by park walking order and rides A–Z', () {
      final groups = groupRidesByLand([
        _ride('Space Mountain', land: 'Tomorrowland'),
        _ride('Peter Pan', land: 'Fantasyland'),
        _ride('Dumbo', land: 'Fantasyland'),
        _ride('Indiana Jones', land: 'Adventureland'),
      ]);

      expect(groups.keys, ['Adventureland', 'Fantasyland', 'Tomorrowland']);
      expect(groups['Fantasyland']!.map((ride) => ride.name), [
        'Dumbo',
        'Peter Pan',
      ]);
    });

    test('should collect rides with no or unknown land under Other, last', () {
      final groups = groupRidesByLand([
        _ride('Mystery Ride'),
        _ride('New Land Ride', land: 'Brand New Land'),
        _ride('Dumbo', land: 'Fantasyland'),
      ]);

      expect(groups.keys, ['Fantasyland', otherLandName]);
      expect(groups[otherLandName], hasLength(2));
    });
  });

  group('sortByName', () {
    test('should sort A–Z ignoring capitalization and wait or status', () {
      final sorted = sortByName([
        _ride('Space Mountain', wait: 5),
        _ride('autopia', status: RideStatus.closed),
        _ride('Matterhorn Bobsleds', wait: 60),
      ]);

      expect(sorted.map((ride) => ride.name), [
        'autopia',
        'Matterhorn Bobsleds',
        'Space Mountain',
      ]);
    });
  });

  group('latestUpdate', () {
    test('should return the newest timestamp and skip nulls', () {
      final newest = DateTime.utc(2026, 10, 29, 21, 41);
      final latest = latestUpdate([
        _ride('A', lastUpdated: DateTime.utc(2026, 10, 29, 20)),
        _ride('B', lastUpdated: newest),
        _ride('C'),
      ]);

      expect(latest, newest);
    });

    test('should return null when no ride has a timestamp', () {
      expect(latestUpdate([_ride('A')]), isNull);
    });
  });
}
