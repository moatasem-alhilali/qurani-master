import 'package:flutter/material.dart';

ThemeData getDarkMode() {
  return ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: FxColors.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FxColors.secondary,
      prefixStyle: const TextStyle(
        color: Colors.white,
      ),
      prefixIconColor: Colors.white,
      iconColor: Colors.white,
    ),
    fontFamily: 'ios-1',

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: FxColors.primary,
    ),

    //
    scaffoldBackgroundColor: const Color(0xff1e1e1e), //customScaffoldColor,
    splashColor: const Color(0xff252525), //customBackGroundBody
    primaryColor: const Color(0xff2f2f2f), //custom main
    shadowColor: FxColors.secondary,

    //
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'ios-3',
        overflow: TextOverflow.ellipsis,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'ios-1',
        // overflow: TextOverflow.ellipsis,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w500,
        color: Colors.white,
        // overflow: TextOverflow.ellipsis,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontFamily: 'ios-2',
        fontWeight: FontWeight.bold,
        // overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

ThemeData getLightMode() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FxColors.secondary,
      prefixStyle: const TextStyle(
        color: Colors.white,
      ),
      prefixIconColor: Colors.black,
      iconColor: Colors.black,
    ),
    fontFamily: 'ios-1',

    scaffoldBackgroundColor:
        const Color.fromARGB(255, 89, 88, 88), //customScaffoldColor,
    splashColor: Colors.white, //customBackGroundBody
    primaryColor: const Color.fromARGB(255, 206, 205, 205), //custom main
    shadowColor: FxColors.secondary,
    //

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
        fontSize: 16,
        fontFamily: 'ios-1',
        // overflow: TextOverflow.ellipsis,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontFamily: 'ios-1',
        fontWeight: FontWeight.w500,
        color: Colors.black,
        // overflow: TextOverflow.ellipsis,
      ),
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontFamily: 'ios-2',
        fontWeight: FontWeight.bold,
        // overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

TextStyle titleSmall(context) {
  return Theme.of(context).textTheme.titleSmall!;
}

TextStyle titleMedium(context) {
  return Theme.of(context).textTheme.titleMedium!;
}

TextStyle titleLarge(context) {
  return Theme.of(context).textTheme.titleLarge!;
}

class FxColors {
  //custom

  static Color background = const Color(0xff1e1e1e);
  static Color secondary = const Color(0xff353535);
  static Color third = const Color(0xff2c2c2c);
  //
  static Color primary = const Color(0xff42796c);
  static Color primarySecondary = const Color(0xff364945);
}
