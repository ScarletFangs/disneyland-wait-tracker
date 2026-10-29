import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOR CONSTANTS
//  Use these variables everywhere in your app.
//  Never hardcode a hex color outside this file.
// ─────────────────────────────────────────────

class AppColors {
  AppColors._(); // prevent instantiation

  // Primary — Soft Castle-Roof Blue (Sleeping Beauty Castle)
  static const Color primary = Color(0xFF9FC4E8);
  static const Color primaryDark = Color(
    0xFF6F9ED1,
  ); // text/icons on light, focus borders
  static const Color primaryLight = Color(0xFFDCEAF7); // chips, containers

  // Secondary — Blush Castle-Stone Pink
  static const Color secondary = Color(0xFFF4C6D2);

  // Accent — Pale Spire Gold
  static const Color accent = Color(0xFFF2D6A0);
  static const Color accentDark = Color(0xFFC9962E); // Lightning Lane bolt

  // Semantic (forms / validation — kept separate from the wait scale below)
  static const Color warning = Color(0xFFF3D89C);
  static const Color error = Color(0xFFEFAEB4);
  static const Color errorDark = Color(0xFFB4505C); // readable error text
  static const Color success = Color(0xFFA6D5B0);

  // Wait-time scale — the dashboard's core visual language (muted pastels)
  static const Color waitLow = Color(0xFFA6D5B0); // soft green  · ≤ 20 min
  static const Color waitMedium = Color(0xFFF3D89C); // soft amber  · 21–45 min
  static const Color waitHigh = Color(0xFFEFAEB4); // soft rose   · 46+ min
  static const Color waitClosed = Color(
    0xFFC7C5D2,
  ); // grey        · closed / refurb

  // Lands — section headers on Wait Times, header on Ride Detail
  static const Color landMainStreet = Color(0xFFF2B8B5); // soft rose
  static const Color landAdventureland = Color(0xFFB5D6A7); // jungle green
  static const Color landNewOrleansSquare = Color(0xFFCDB8E0); // lavender
  static const Color landCritterCountry = Color(0xFFDCC3A1); // warm tan
  static const Color landFrontierland = Color(0xFFF0C4A0); // terracotta
  static const Color landFantasyland = secondary; // blush pink
  static const Color landToontown = Color(0xFFF6E39B); // sunny yellow
  static const Color landTomorrowland = Color(0xFFA8D8E0); // sky teal
  static const Color landGalaxysEdge = Color(0xFFB9C2CF); // slate

  // Backgrounds
  static const Color background = Color(0xFFF7F6FB); // page background
  static const Color surface = Color(0xFFFFFFFF); // cards, sheets
  static const Color inputFill = Color(0xFFEFEDF7); // text field backgrounds

  // Text
  static const Color textPrimary = Color(0xFF353241);
  static const Color textSecondary = Color(0xFF807D90);
  static const Color textDisabled = Color(0xFFB6B3C4);

  // Divider / Border
  static const Color divider = Color(0xFFE6E3F0);
}

// ─────────────────────────────────────────────
//  TEXT STYLES
//  All use Inter via google_fonts.
// ─────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.inter(color: AppColors.textPrimary);

  // Display
  static TextStyle get displayLarge => _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static TextStyle get displayMedium => _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  // Headings
  static TextStyle get headingLarge =>
      _base.copyWith(fontSize: 22, fontWeight: FontWeight.w600);
  static TextStyle get headingMedium =>
      _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get headingSmall =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  // Body
  static TextStyle get bodyLarge =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodyMedium =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodySmall => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Labels & Buttons
  static TextStyle get labelLarge =>
      _base.copyWith(fontSize: 15, fontWeight: FontWeight.w500);
  static TextStyle get labelMedium =>
      _base.copyWith(fontSize: 13, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  // Caption
  static TextStyle get caption => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

// ─────────────────────────────────────────────
//  THEME DATA
//  Plug this into your MaterialApp.
// ─────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.surface,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // Global text theme
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1.5),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.errorDark,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTextStyles.labelLarge,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark, width: 1.5),
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primaryDark,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Segmented Button (Wait Times sort toggle)
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textSecondary,
          selectedBackgroundColor: AppColors.primaryLight,
          selectedForegroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.divider),
          textStyle: AppTextStyles.labelMedium,
        ),
      ),

      // Loading spinners
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Bottom Nav Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
