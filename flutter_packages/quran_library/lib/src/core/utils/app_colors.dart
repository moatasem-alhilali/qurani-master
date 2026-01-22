import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xfffaf7f3);
  static const Color darkBackground = Color(0xff1E1E1E);
  static const Color textColor = Colors.black;
  static const Color darkTextColor = Colors.white;

  // Getter theme colors
  static Color getTextColor(bool isDarkMode) =>
      isDarkMode ? darkTextColor : textColor;
  static Color getBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkBackground : background;
}
