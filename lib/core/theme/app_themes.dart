import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class MyColorTheme {
  MyColorTheme({
    required this.colorScheme,
    this.primaryColor,
    this.primaryColorLight,
    this.primaryColorDark,
    this.dialogBackgroundColor,
    this.dividerColor,
    this.highlightColor,
    this.hintColor,
    this.hoverColor,
    this.indicatorColor,
    this.scaffoldBackgroundColor,
    this.canvasColor,
    this.disabledColor,
    this.focusColor,
    this.secondaryHeaderColor,
    this.cardColor,
  });

  ColorScheme colorScheme;
  Color? primaryColor;
  Color? primaryColorLight;
  Color? primaryColorDark;
  Color? dialogBackgroundColor;
  Color? dividerColor;
  Color? highlightColor;
  Color? hintColor;
  Color? hoverColor;
  Color? indicatorColor;
  Color? scaffoldBackgroundColor;
  Color? canvasColor;
  Color? focusColor;
  Color? secondaryHeaderColor;
  Color? disabledColor;
  Color? cardColor;
}

final MyColorTheme blueTheme = MyColorTheme(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff404C6E),
    onPrimary: Color(0xff404C6E),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xffCDAD80),
    error: Color(0xffE0E1E0),
    onError: Color(0xffE0E1E0),
    background: Color(0xffFFFFFF),
    onBackground: Color(0xfff3efdf),
    surface: Color(0xffCDAD80),
    onSurface: Color(0xffE0E1E0),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffCD9974),
  ),
  primaryColor: const Color(0xff404C6E),
  primaryColorLight: const Color(0xff53618c),
  primaryColorDark: const Color(0xff404C6E),
  dialogBackgroundColor: const Color(0xffFFFFFF),
  dividerColor: const Color(0xffCDAD80),
  highlightColor: const Color(0xffCDAD80).withOpacity(0.25),
  indicatorColor: const Color(0xffCDAD80),
  scaffoldBackgroundColor: const Color(0xff404C6E),
  canvasColor: const Color(0xffFFFFFF),
  hoverColor: const Color(0xffFFFFFF).withOpacity(0.3),
  disabledColor: const Color(0Xffffffff),
  hintColor: const Color(0xff404C6E),
  focusColor: const Color(0xffE0E1E0),
  secondaryHeaderColor: const Color(0xff53618c),
  cardColor: const Color(0xff404C6E),
);

final MyColorTheme brownTheme = MyColorTheme(
  // useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff77554B),
    onPrimary: Color(0xff77554B),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xffFFEEDC),
    error: Color(0xffCD9974),
    onError: Color(0xffCD9974),
    background: Color(0xffFFFBF8),
    onBackground: Color(0xffFFFBF8),
    surface: Color(0xffCD9974),
    onSurface: Color(0xffCD9974),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffCD9974),
  ),
  primaryColor: const Color(0xff77554B),
  primaryColorLight: const Color(0xffFFEEDC),
  primaryColorDark: const Color(0xff77554B),
  dialogBackgroundColor: const Color(0xffFFFBF8),
  dividerColor: const Color(0xffFFEEDC),
  highlightColor: const Color(0xffCD9974).withOpacity(0.25),
  indicatorColor: const Color(0xffFFEEDC),
  scaffoldBackgroundColor: const Color(0xff77554B),
  canvasColor: const Color(0xffF2E5D5),
  hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
  disabledColor: const Color(0Xffffffff),
  hintColor: const Color(0xff000000),
  focusColor: const Color(0xff77554B),
  secondaryHeaderColor: const Color(0xff77554B),
  cardColor: const Color(0xff77554B),
);

final MyColorTheme oldTheme = MyColorTheme(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff232c13),
    onPrimary: Color(0xff161f07),
    secondary: Color(0xfff3efdf),
    onSecondary: Color(0xff91a57d),
    error: Color(0xffE0E1E0),
    onError: Color(0xffE0E1E0),
    background: Color(0xfff3efdf),
    onBackground: Color(0xfff3efdf),
    surface: Color(0xff91a57d),
    onSurface: Color(0xffE0E1E0),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffCD9974),
  ),
  primaryColor: const Color(0xff232c13),
  primaryColorLight: const Color(0xff53618c),
  primaryColorDark: const Color(0xff161f07),
  dialogBackgroundColor: const Color(0xfff3efdf),
  dividerColor: const Color(0xff91a57d),
  highlightColor: const Color(0xff91a57d).withOpacity(0.25),
  indicatorColor: const Color(0xff91a57d),
  scaffoldBackgroundColor: const Color(0xff232c13),
  canvasColor: const Color(0xfff3efdf),
  hoverColor: const Color(0xfff3efdf).withOpacity(0.3),
  disabledColor: const Color(0xfff3efdf),
  hintColor: const Color(0xff232c13),
  focusColor: const Color(0xffE0E1E0),
  secondaryHeaderColor: const Color(0xff53618c),
  cardColor: const Color(0xff232c13),
);

final MyColorTheme darkTheme = MyColorTheme(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff404C6E),
    onPrimary: Color(0xff000000),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xff373737),
    error: Color(0xff404C6E),
    onError: Color(0xff404C6E),
    background: Color(0xff1E1E1E),
    onBackground: Color(0xff1E1E1E),
    surface: Color(0xffCDAD80),
    onSurface: Color(0xff404C6E),
    inversePrimary: Color(0xffffffff),
    inverseSurface: Color(0xffCD9974),
  ),
  primaryColor: const Color(0xff1E1E1E),
  primaryColorLight: const Color(0xff373737),
  primaryColorDark: const Color(0xff010101),
  dialogBackgroundColor: const Color(0xff1E1E1E),
  dividerColor: const Color(0xff404C6E),
  highlightColor: const Color(0xff404C6E).withOpacity(0.25),
  indicatorColor: const Color(0xff404C6E),
  scaffoldBackgroundColor: const Color(0xff000000),
  canvasColor: const Color(0xffF6F6EE),
  hoverColor: const Color(0xffF6F6EE).withOpacity(0.3),
  disabledColor: const Color(0Xffffffff),
  hintColor: const Color(0xffffffff),
  focusColor: const Color(0xff404C6E),
  secondaryHeaderColor: const Color(0xff404C6E),
  cardColor: const Color(0xffF6F6EE),
);

class ThemeManager {
  static MyColorTheme getThemeByType(int type) {
    switch (type) {
      case 1:
        return blueTheme;
      case 2:
        return brownTheme;
      case 3:
        return oldTheme;
      case 4:
        return darkTheme;
      default:
        return blueTheme;
    }
  }
}
