import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/blue_theme.dart';
import 'package:quran_app/core/theme/brown_theme.dart';
import 'package:quran_app/core/theme/dark_theme.dart';
import 'package:quran_app/core/theme/green_theme.dart';
import 'package:quran_app/core/theme/quran_themes.dart';

class ThemeColorsManager {
//
  static const String dark = 'dark';
  static const String blue = 'blue';
  static const String brown = 'brown';
  static const String green = 'green';

  // cache key
  static const String cacheKey = 'cache_theme_type_key';

  //
  static MyColorTheme getThemeByType(String type) {
    switch (type) {
      case blue:
        return blueTheme;
      case brown:
        return brownTheme;
      case green:
        return greenTheme;
      case dark:
        return darkTheme;
      default:
        return blueTheme;
    }
  }

  static ThemeData getThemeApp(String type) {
    switch (type) {
      case blue:
        return blueThemeData;
      case brown:
        return brownThemeData;
      case green:
        return greenThemeData;
      case dark:
        return darkXThemeData;
      default:
        return blueThemeData;
    }
  }
}


class ThemeModeManager {
//
  static const String dark = 'dark';
  static const String light = 'light';

  // cache key

  static const String cacheKey = 'cache_theme_mode_key';

 

}