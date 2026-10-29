import 'package:intl/intl.dart';

/// "2:45 PM" in the device's zone — same format as ShowTime and LightningLane.
String formatClockTime(DateTime time) {
  return DateFormat('h:mm a').format(time.toLocal());
}
