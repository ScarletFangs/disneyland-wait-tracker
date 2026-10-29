import 'package:disneyapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Required credit line at the bottom of every list fed by the API.
class AttributionFooter extends StatelessWidget {
  const AttributionFooter({super.key});

  static const String _attributionText = 'Data from ThemeParks.wiki';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(_attributionText, style: AppTextStyles.caption),
      ),
    );
  }
}
