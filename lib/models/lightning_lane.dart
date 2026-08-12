import 'package:intl/intl.dart';

enum LightningLaneStatus { available, finished, unknown }

LightningLaneStatus lightningLaneStatusFromString(String? raw) {
  switch (raw) {
    case "AVAILABLE":
      return LightningLaneStatus.available;
    case "FINISHED":
      return LightningLaneStatus.finished;
    default:
      return LightningLaneStatus.unknown;
  }
}

class LightningLane {
  final LightningLaneStatus status;
  final DateTime? returnStart;
  final DateTime? returnEnd;
  final String? price;
  String? get formattedTime {
    final localReturnStart = returnStart;
    if (localReturnStart == null) return null;

    return DateFormat('h:mm a').format(localReturnStart.toLocal());
  }

  const LightningLane({
    required this.status,
    required this.returnStart,
    required this.returnEnd,
    required this.price,
  });

  factory LightningLane.fromJson(Map<String, dynamic> json) {
    return LightningLane(
      status: lightningLaneStatusFromString(json['state'] as String?),
      returnStart: json['returnStart'] != null
          ? DateTime.parse(json['returnStart'] as String)
          : null,
      returnEnd: json['returnEnd'] != null
          ? DateTime.parse(json['returnEnd'] as String)
          : null,
      price: json['price'] != null ? json['price']['formatted'] : null,
    );
  }
}
