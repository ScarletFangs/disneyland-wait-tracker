import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Lands in the order you walk them, clockwise from the front gate.
const List<String> parkLandOrder = [
  'Main Street, U.S.A.',
  'Adventureland',
  'New Orleans Square',
  'Critter Country',
  "Star Wars: Galaxy's Edge",
  'Frontierland',
  'Fantasyland',
  "Mickey's Toontown",
  'Tomorrowland',
];

/// Group name for rides with no land (or a land missing from the list above).
const String otherLandName = 'Other';

const Map<String, Color> _landColors = {
  'Main Street, U.S.A.': AppColors.landMainStreet,
  'Adventureland': AppColors.landAdventureland,
  'New Orleans Square': AppColors.landNewOrleansSquare,
  'Critter Country': AppColors.landCritterCountry,
  "Star Wars: Galaxy's Edge": AppColors.landGalaxysEdge,
  'Frontierland': AppColors.landFrontierland,
  'Fantasyland': AppColors.landFantasyland,
  "Mickey's Toontown": AppColors.landToontown,
  'Tomorrowland': AppColors.landTomorrowland,
};

Color landColorFor(String? land) {
  return _landColors[land] ?? AppColors.primary;
}
