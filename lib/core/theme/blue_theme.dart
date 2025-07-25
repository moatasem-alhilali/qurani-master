import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/gen/fonts.gen.dart';

Color _background = const Color(0xff1e1e1e);
Color _scaffoldBackgroundColor = const Color(0xff1e1e1e);
Color _secondary = const Color(0xff353535);
Color _third = const Color(0xff2c2c2c);
Color _primary = const Color(0xff404C6E);
Color _splashColor = const Color(0xff252525);
Color _primaryColorDark = const Color(0xff364945);
Color _onPrimary = Colors.white;
//
Color _surface = const Color(0xffCDAD80);
Color _onSurface = const Color(0xff404C6E);
Color textPrimary = Colors.white;
ThemeData blueThemeData = ThemeData(
  ///Colors
  //
  scaffoldBackgroundColor: _scaffoldBackgroundColor,
  splashColor: _splashColor,

  //primary
  primaryColor: _third,
  // primarySecondary
  primaryColorDark: _primaryColorDark,
  // error

  shadowColor: _secondary,
  brightness: Brightness.dark,

  //
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: _primary,
    onPrimary: _onPrimary,
    secondary: _secondary,
    onSecondary: _third,
    surface: _surface,
    onSurface: _onSurface,
    error: const Color(0xffe74c3c),
    onError: const Color(0xff404C6E),
    inversePrimary: const Color(0xffffffff),
    inverseSurface: const Color(0xffCD9974),
    //third
    onPrimaryContainer: _third,
    // secondary
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: _scaffoldBackgroundColor,
    hourMinuteColor: _primary,
    hourMinuteTextColor: Colors.white,
    dayPeriodColor: _primary,
    dayPeriodTextColor: Colors.white,
    dialHandColor: _primary,
    dialBackgroundColor: _scaffoldBackgroundColor,
    entryModeIconColor: _primary,
  ),

  ///dividerTheme
  dividerColor: Colors.grey.withOpacity(0.5),
  dividerTheme: DividerThemeData(
    thickness: 1,
    color: Colors.grey.withOpacity(0.5),
  ),
  useMaterial3: true,
  drawerTheme: DrawerThemeData(
    backgroundColor: _secondary,
  ),

  ///AppBarTheme
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.white,
    elevation: 0,
    color: Colors.white,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,

      // fontFamily: isDark ? AssetsEnFonts.medium : AssetsArFonts.medium,
      fontSize: 22,
    ),
  ),

  ///iconTheme
  iconTheme: const IconThemeData(
    color: Colors.white,
    size: 30,
  ),

  ///bottom AppBar Theme
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
    elevation: 2,
  ),

  ///tab Bar Theme
  tabBarTheme: TabBarThemeData(
    labelStyle: const TextStyle(
      color: Colors.white,
      fontFamily: FxFonts.ios1,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    labelColor: Colors.white,
    dividerColor: _background,
    indicatorColor: _background,
    unselectedLabelStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: FxFonts.ios1,
    ),
    unselectedLabelColor: Colors.grey,
    indicator: const UnderlineTabIndicator(),
    indicatorSize: TabBarIndicatorSize.tab,
  ),

  ///Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: FxFonts.ios1,
      color: Colors.red,
    ),

    labelStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontFamily: FxFonts.ios1,
    ),

    suffixStyle: const TextStyle(
      color: Colors.grey,
    ),
    prefixStyle: const TextStyle(
      color: Colors.grey,
    ),
    // fillColor: DarkColors.lapel,
    hintStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.grey,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: _third,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: _secondary,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  ),
  //text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      enableFeedback: false,
      elevation: 0,
      textStyle: TextStyle(
        color: _primary,
        fontSize: 16,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      enableFeedback: false,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: _primary,
        width: 2,
      ),
      padding: const EdgeInsets.all(4),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  //elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      enableFeedback: false,
      alignment: Alignment.center,
      backgroundColor: _primary,
      padding: const EdgeInsets.all(4),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),

  ///iconButtonTheme
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      enableFeedback: false,
      elevation: 0,
      iconSize: 35,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _primary,
    elevation: 0,
    iconSize: 35,
  ),

  //bottom Sheet Theme
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
  ),
  //dialog Theme
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xff1F222A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  progressIndicatorTheme:
      ProgressIndicatorThemeData(circularTrackColor: _primary),
  fontFamily: FontFamily.ios1,
  textTheme: TextTheme(
    // Display Styles (Largest)
    displayLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 57.sp,
      height: 1.12,
      letterSpacing: -0.25,
      color: textPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 45.sp,
      height: 1.16,
      color: textPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 36.sp,
      height: 1.22,
      color: textPrimary,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 32.sp,
      height: 1.25,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 28.sp,
      height: 1.29,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 24.sp,
      height: 1.33,
      color: textPrimary,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 22.sp,
      height: 1.27,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.50,
      letterSpacing: 0.15,
      color: textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.1,
      color: textPrimary,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.1,
      color: textPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      height: 1.33,
      letterSpacing: 0.5,
      color: textPrimary,
    ),
    labelSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
      height: 1.45,
      letterSpacing: 0.5,
      color: textPrimary,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
      height: 1.50,
      letterSpacing: 0.15,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.25,
      color: textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      height: 1.33,
      letterSpacing: 0.4,
      color: textPrimary,
    ),
  ),
);
