import 'package:flutter/material.dart';

/// Extension to easily access theme colors from BuildContext
/// Usage: context.colors.primary, context.colors.surface, etc.
extension ThemeColorsExtension on BuildContext {
  Color get background$10 => const Color(0x1AFFFFFF);
  Color get background$30 => const Color(0x4CE4E4E4);

  /// Access to ColorScheme colors
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Access to legacy theme colors for backward compatibility
  ThemeData get theme => Theme.of(this);

  // Quick access to commonly used colors
  Color get primaryColor => colors.primary;
  Color get secondaryColor => colors.secondary;
  Color get backgroundColor => colors.surface;
  Color get surfaceColor => colors.surface;
  Color get errorColor => colors.error;
  Color get onPrimaryColor => colors.onPrimary;
  Color get onSecondaryColor => colors.onSecondary;
  Color get onBackgroundColor => colors.onSurface;
  Color get onSurfaceColor => colors.onSurface;
  Color get onErrorColor => colors.onError;

  // Additional surface variations
  Color get surfaceVariant => colors.surfaceContainerHighest;
  Color get onSurfaceVariant => colors.onSurfaceVariant;
  Color get inverseSurface => colors.inverseSurface;
  Color get onInverseSurface => colors.onInverseSurface;

  // Container colors
  Color get primaryContainer => colors.primaryContainer;
  Color get onPrimaryContainer => colors.onPrimaryContainer;
  Color get secondaryContainer => colors.secondaryContainer;
  Color get onSecondaryContainer => colors.onSecondaryContainer;
  Color get errorContainer => colors.errorContainer;
  Color get onErrorContainer => colors.onErrorContainer;

  // Outline colors
  Color get outline => colors.outline;
  Color get outlineVariant => colors.outlineVariant;

  // Utility colors
  Color get shadow => colors.shadow;
  Color get scrim => colors.scrim;
  Color get surfaceTint => colors.surfaceTint;

  // Legacy theme colors
  Color get cardColor => theme.cardColor;
  Color get dividerColor => theme.dividerColor;
  Color get focusColor => theme.focusColor;
  Color get hoverColor => theme.hoverColor;
  Color get highlightColor => theme.highlightColor;
  Color get splashColor => theme.splashColor;
  Color get disabledColor => theme.disabledColor;
  Color get unselectedWidgetColor => theme.unselectedWidgetColor;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  Color get gray1 => const Color(0xFF808080);
  Color get gray2 => const Color(0xFF666666);
  Color get gray3 => const Color(0xFF4D4D4D);
  Color get gray4 => const Color(0xFF333333);
  Color get gray5 => const Color(0xFF1A1A1A);
  Color get gray6 => const Color(0xFF000000);
}
