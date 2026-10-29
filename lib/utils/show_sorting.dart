import 'package:disneyapp/models/show.dart';

/// Shows with performances today first, then "no shows today" — A–Z in each.
List<Show> sortShowsForDisplay(List<Show> shows) {
  return [...shows]..sort((a, b) {
    final hasTimesA = a.showTimes.isNotEmpty;
    final hasTimesB = b.showTimes.isNotEmpty;

    if (hasTimesA != hasTimesB) return hasTimesA ? -1 : 1;
    return a.name.compareTo(b.name);
  });
}
