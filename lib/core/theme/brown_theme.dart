// 2. Brown Theme
import 'package:flutter/material.dart';

final ThemeData brownThemeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff77554B),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Color(0xffFFEEDC),
    background: Color(0xffFFFFFF),
    onBackground: Color(0xfff3efdf),
    surface: Color(0xffCDAD80),
    onSurface: Color(0xffE0E1E0),
    error: Color(0xffE0E1E0),
    onError: Color(0xffE0E1E0),
    inversePrimary: Color(0xff000000),
    inverseSurface: Color(0xffCD9974),
  ),
  primaryColor: const Color(0xFFFFFFFF),
  primaryColorLight: const Color(0xffFFEEDC),
  primaryColorDark: const Color(0xff77554B),
  dialogBackgroundColor: const Color(0xffFFFBF8),
  dividerColor: const Color(0xffFFEEDC),
  highlightColor: const Color(0xffCD9974).withOpacity(0.25),
  indicatorColor: const Color(0xffFFEEDC),
  scaffoldBackgroundColor: Colors.white,
  canvasColor: const Color(0xffF2E5D5),
  hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
  disabledColor: const Color(0xffffffff),
  hintColor: const Color(0xff000000),
  focusColor: const Color(0xff77554B),
  secondaryHeaderColor: const Color(0xff77554B),
  cardColor: const Color(0xff77554B),

  //
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      // backgroundColor: _primary,
      ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    // fillColor: _secondary,
    prefixStyle: TextStyle(
      color: Colors.white,
    ),
    prefixIconColor: Colors.white,
    iconColor: Colors.white,
  ),
  fontFamily: 'ios-1',

  progressIndicatorTheme: const ProgressIndicatorThemeData(
      // color: _primary,
      ),

  //
  splashColor: const Color(0xff252525), //customBackGroundBody

  //
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 25,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
    ),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: 'ios-3',
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontFamily: 'ios-1',
      // overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      color: Colors.black,
      // overflow: TextOverflow.ellipsis,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'ios-2',
      fontWeight: FontWeight.bold,
      // overflow: TextOverflow.ellipsis,
    ),
  ),
);
