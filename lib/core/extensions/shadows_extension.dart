import 'package:flutter/material.dart';

/// Extension for consistent shadow and elevation values throughout the app
/// Usage: context.shadows.small, context.elevation.medium, etc.
extension ThemeShadowsExtension on BuildContext {
  AppShadows get shadows => const AppShadows();
  AppElevation get elevation => const AppElevation();
}

/// Consistent shadow values based on Figma design system
class AppShadows {
  const AppShadows();

  // Shadow colors (from Figma)
  static const Color _lightShadowColor = Color(0x1A000000); // 10% black
  static const Color _mediumShadowColor = Color(0x33000000); // 20% black
  static const Color _darkShadowColor = Color(0x4D000000); // 30% black

  // Shadow definitions
  List<BoxShadow> get none => [];

  List<BoxShadow> get small => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ];

  List<BoxShadow> get medium => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ];

  List<BoxShadow> get large => [
        const BoxShadow(
          color: _mediumShadowColor,
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ];

  List<BoxShadow> get extraLarge => [
        const BoxShadow(
          color: _mediumShadowColor,
          offset: Offset(0, 8),
          blurRadius: 16,
        ),
      ];

  List<BoxShadow> get huge => [
        const BoxShadow(
          color: _darkShadowColor,
          offset: Offset(0, 16),
          blurRadius: 32,
        ),
      ];

  // Component-specific shadows
  List<BoxShadow> get card => medium;
  List<BoxShadow> get button => small;
  List<BoxShadow> get fab => large;
  List<BoxShadow> get dialog => large;
  List<BoxShadow> get bottomSheet => huge;
  List<BoxShadow> get appBar => small;
  List<BoxShadow> get chip => small;

  // Directional shadows
  List<BoxShadow> get topShadow => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(0, -2),
          blurRadius: 4,
        ),
      ];

  List<BoxShadow> get bottomShadow => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ];

  List<BoxShadow> get leftShadow => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(-2, 0),
          blurRadius: 4,
        ),
      ];

  List<BoxShadow> get rightShadow => [
        const BoxShadow(
          color: _lightShadowColor,
          offset: Offset(2, 0),
          blurRadius: 4,
        ),
      ];
}

/// Consistent elevation values for Material Design
class AppElevation {
  const AppElevation();

  // Material Design elevation levels
  double get level0 => 0; // Surface level
  double get level1 => 1; // Cards, search bars
  double get level2 => 2; // Buttons
  double get level3 => 3; // Refresh indicators, selection controls
  double get level4 => 4; // App bars, FABs
  double get level5 => 5; // Navigation drawers
  double get level6 => 6; // FAB pressed state
  double get level8 => 8; // Navigation bar, dialogs
  double get level12 => 12; // Bottom sheets
  double get level16 => 16; // Modal bottom sheets
  double get level24 => 24; // Dialogs, pickers

  // Component-specific elevations
  double get card => level1;
  double get button => level2;
  double get buttonPressed => level8;
  double get appBar => level4;
  double get fab => level6;
  double get fabPressed => level12;
  double get dialog => level24;
  double get bottomSheet => level16;
  double get navigationBar => level8;
  double get drawer => level16;
  double get snackBar => level6;
  double get tooltip => level4;
  double get menu => level8;
}
