import 'package:disneyapp/models/lightning_lane.dart';

enum RideStatus { operating, closed, refurbishment, down, unknown }

RideStatus statusFromString(String? raw) {
  switch (raw) {
    case "OPERATING":
      return RideStatus.operating;
    case "CLOSED":
      return RideStatus.closed;
    case "REFURBISHMENT":
      return RideStatus.refurbishment;
    case "DOWN":
      return RideStatus.down;
    default:
      return RideStatus.unknown;
  }
}

class Ride {
  final String id;
  final String name;
  final RideStatus status;
  final int? standbyWait;
  final String? land;
  final DateTime? lastUpdated;
  final bool hasQueue; //Filters rides/shows from usage of queues
  final bool isRide; //Hardcoded filter (some shows have queue)
  final LightningLane? lightningLane;

  const Ride({
    required this.id,
    required this.name,
    required this.status,
    required this.standbyWait,
    this.land,
    required this.lastUpdated,
    required this.hasQueue,
    this.isRide = true,
    required this.lightningLane,
  });

  factory Ride.fromJson(
    Map<String, dynamic> json, {
    String? land,
    bool? isRide,
  }) {
    final queue = json['queue'] as Map<String, dynamic>?;
    final llBlock = queue?['PAID_RETURN_TIME'] ?? queue?['RETURN_TIME'];

    return Ride(
      id: json['id'] as String,
      name: json['name'] as String,
      status: statusFromString(json['status'] as String?),
      standbyWait: queue?["STANDBY"]?["waitTime"] as int?,
      land: land,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      hasQueue: queue != null,
      isRide: isRide ?? true,
      lightningLane: llBlock != null ? LightningLane.fromJson(llBlock) : null,
    );
  }

  //For printing ride objects
  @override
  String toString() {
    return "$name (Status: $status): $standbyWait min\t Land:$land\n";
  }
}
