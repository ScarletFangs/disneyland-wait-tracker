import 'package:disneyapp/models/ride.dart';
import 'package:disneyapp/theme/app_theme.dart';
import 'package:disneyapp/utils/ride_display.dart';
import 'package:flutter_test/flutter_test.dart';

Ride _ride({
  int? wait,
  RideStatus status = RideStatus.operating,
  String? land,
}) {
  return Ride(
    id: 'id',
    name: 'Ride',
    status: status,
    standbyWait: wait,
    land: land,
    lastUpdated: null,
    hasQueue: true,
    lightningLane: null,
  );
}

void main() {
  group('waitColor', () {
    test('should follow the low / medium / high wait scale', () {
      expect(_ride(wait: 20).waitColor, AppColors.waitLow);
      expect(_ride(wait: 45).waitColor, AppColors.waitMedium);
      expect(_ride(wait: 46).waitColor, AppColors.waitHigh);
    });

    test('should be grey for a non-operating ride even with a stale wait', () {
      final ride = _ride(wait: 30, status: RideStatus.down);

      expect(ride.waitColor, AppColors.waitClosed);
      expect(ride.waitLabel, 'Down');
    });
  });

  group('landColor', () {
    test('should use the land color, falling back to primary', () {
      expect(_ride(land: 'Fantasyland').landColor, AppColors.landFantasyland);
      expect(_ride().landColor, AppColors.primary);
    });
  });
}
