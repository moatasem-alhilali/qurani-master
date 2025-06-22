import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';

enum ToolAppThemeType { light, dark }

Color _background = const Color(0xff1e1e1e);
Color _secondary = const Color(0xff353535);
Color _third = const Color(0xff2c2c2c);
Color _primary = const Color(0xff42796c);
Color _primarySecondary = const Color(0xff364945);
ThemeData darkThemeData = ThemeData(
  ///Colors
  //
  scaffoldBackgroundColor: const Color(0xff1e1e1e),
  splashColor: const Color(0xff252525),

  //primary
  primaryColor: const Color(0xff2c2c2c),
  // primarySecondary
  primaryColorDark: const Color(0xff364945),
  // error

  shadowColor: const Color(0xff353535),
  brightness: Brightness.dark,
  fontFamily: FxFonts.ios1,

  //
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff42796c),
    onPrimary: Colors.white,
    secondary: Color(0xff353535),
    onSecondary: Color(0xff2c2c2c),
    surface: Color(0xffCDAD80),
    onSurface: Color(0xff404C6E),
    error: Color(0xffe74c3c),
    onError: Color(0xff404C6E),
    inversePrimary: Color(0xffffffff),
    inverseSurface: Color(0xffCD9974),
    //third
    onPrimaryContainer: Color(0xff2c2c2c),
    // secondary
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

  textTheme: TextTheme(
    displaySmall: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    ),
    displayMedium: const TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    ),
    displayLarge: const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    headlineSmall: const TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
    ),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
    ),
    headlineLarge: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: 'ios-3',
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
      fontFamily: 'ios-1',
      // overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      fontSize: 14.sp,
      fontFamily: 'ios-1',
      fontWeight: FontWeight.w500,
      color: Colors.white,
      // overflow: TextOverflow.ellipsis,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
      fontFamily: 'ios-2',
      fontWeight: FontWeight.bold,
      // overflow: TextOverflow.ellipsis,
    ),
  ),
);
