import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/quran_themes.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get testStyles => theme.textTheme;

  TextStyle get headlineLarge => testStyles.headlineLarge!;
  TextStyle get bodyMedium => testStyles.bodyMedium!;
  TextStyle get titleSmall => testStyles.titleSmall!;
  TextStyle get titleMedium => testStyles.titleMedium!;
  
}

extension ThemeColorExtension on BuildContext {
  Color get primaryColor => theme.primaryColor;
  Color get splashColor => theme.splashColor;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  //
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondary => colorScheme.secondary;
  Color get background => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;
  Color get onPrimary => colorScheme.onPrimary;

  //
  Color get primaryScheme => colorScheme.primary;
  Color get primarySecondary => theme.primaryColorDark;

  //
  Color get error => colorScheme.error;

  //
  Color get divider => theme.dividerColor;

  //
  // gray colors
  Color get gray1 => const Color(0xff808080);
  Color get gray2 => const Color(0xffa9a9a9);
  Color get gray3 => const Color(0xffd3d3d3);
  Color get gray4 => const Color(0xffdcdcdc);
  Color get gray5 => const Color(0xffe0e0e0);
  Color get gray6 => const Color(0xffe8e8e8);

  // quran themes

  MyColorTheme get blueThemeColor => blueTheme;
  MyColorTheme get brownThemeColor => brownTheme;
  MyColorTheme get oldThemeColor => greenTheme;
  MyColorTheme get darkThemeColor => greenTheme;
}
