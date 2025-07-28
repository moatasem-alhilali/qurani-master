import 'package:flutter/material.dart';

/// Extension to easily access text styles from BuildContext
/// Usage: context.textStyles.headlineLarge, context.titleMedium, etc.
extension ThemeTextStylesExtension on BuildContext {
  /// Access to TextTheme
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Access to PrimaryTextTheme (for use on primary color backgrounds)
  TextTheme get primaryTextStyles => Theme.of(this).primaryTextTheme;

  // Display Styles (Largest)
  TextStyle? get displayLarge => textStyles.displayLarge;
  TextStyle? get displayMedium => textStyles.displayMedium;
  TextStyle? get displaySmall => textStyles.displaySmall;

  // Headline Styles
  TextStyle? get headlineLarge => textStyles.headlineLarge;
  TextStyle? get headlineMedium => textStyles.headlineMedium;
  TextStyle? get headlineSmall => textStyles.headlineSmall;

  // Title Styles
  TextStyle? get titleLarge => textStyles.titleLarge;
  TextStyle? get titleMedium => textStyles.titleMedium;
  TextStyle? get titleSmall => textStyles.titleSmall;

  // Label Styles
  TextStyle? get labelLarge => textStyles.labelLarge;
  TextStyle? get labelMedium => textStyles.labelMedium;
  TextStyle? get labelSmall => textStyles.labelSmall;

  // Body Styles
  TextStyle? get bodyLarge => textStyles.bodyLarge;
  TextStyle? get bodyMedium => textStyles.bodyMedium;
  TextStyle? get bodySmall => textStyles.bodySmall;

  // Primary text styles (for primary color backgrounds)
  TextStyle? get primaryDisplayLarge => primaryTextStyles.displayLarge;
  TextStyle? get primaryDisplayMedium => primaryTextStyles.displayMedium;
  TextStyle? get primaryDisplaySmall => primaryTextStyles.displaySmall;
  TextStyle? get primaryHeadlineLarge => primaryTextStyles.headlineLarge;
  TextStyle? get primaryHeadlineMedium => primaryTextStyles.headlineMedium;
  TextStyle? get primaryHeadlineSmall => primaryTextStyles.headlineSmall;
  TextStyle? get primaryTitleLarge => primaryTextStyles.titleLarge;
  TextStyle? get primaryTitleMedium => primaryTextStyles.titleMedium;
  TextStyle? get primaryTitleSmall => primaryTextStyles.titleSmall;
  TextStyle? get primaryLabelLarge => primaryTextStyles.labelLarge;
  TextStyle? get primaryLabelMedium => primaryTextStyles.labelMedium;
  TextStyle? get primaryLabelSmall => primaryTextStyles.labelSmall;
  TextStyle? get primaryBodyLarge => primaryTextStyles.bodyLarge;
  TextStyle? get primaryBodyMedium => primaryTextStyles.bodyMedium;
  TextStyle? get primaryBodySmall => primaryTextStyles.bodySmall;
}
