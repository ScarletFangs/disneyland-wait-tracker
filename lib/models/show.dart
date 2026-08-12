import 'package:disneyapp/models/ride.dart';
import 'package:intl/intl.dart';

class ShowTime {
  final String type; // can only be one type of show
  final DateTime startTime;
  final DateTime? endTime;
  String get formattedTime {
    final end = endTime;
    final format = DateFormat('h:mm a');

    if (end == null || end.isAtSameMomentAs(startTime)) {
      return format.format(startTime.toLocal());
    }

    return '${format.format(startTime.toLocal())} - ${format.format(end.toLocal())}';
  }

  ShowTime({
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  factory ShowTime.fromJson(Map<String, dynamic> json) {
    return ShowTime(
      type: json['type'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
    );
  }
}

class Show {
  final String id;
  final String name;
  final RideStatus status;
  final String? land;
  final List<ShowTime> showTimes;

  Show({
    required this.id,
    required this.name,
    required this.status,
    this.land,
    required this.showTimes,
  });

  factory Show.fromJson(Map<String, dynamic> json, {String? land}) {
    return Show(
      id: json['id'] as String,
      name: json['name'] as String,
      status: statusFromString(json['status'] as String?),
      land: land,
      showTimes:
          (json['showtimes'] as List<dynamic>?)
              ?.map((item) => ShowTime.fromJson(item as Map<String, dynamic>))
              .toList() ??
          <ShowTime>[],
    );
  }
}
