import 'package:flutter/material.dart';

Color _background = const Color(0xff1e1e1e);
Color _secondary = const Color(0xff353535);
Color _third = const Color(0xff2c2c2c);
Color _primary = const Color(0xff42796c);
Color _primarySecondary = const Color(0xff364945);

ThemeData getLightMode() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _secondary,
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
    shadowColor: _secondary,
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
}

TextStyle titleSmall(BuildContext context) {
  return Theme.of(context).textTheme.titleSmall!;
}

TextStyle titleMedium(BuildContext context) {
  return Theme.of(context).textTheme.titleMedium!;
}

TextStyle titleLarge(BuildContext context) {
  return Theme.of(context).textTheme.titleLarge!;
}

class FxColors {
  //custom

  //

  // gray colors
  static Color gray1 = const Color(0xff808080);
  static Color gray2 = const Color(0xffa9a9a9);
  static Color gray3 = const Color(0xffd3d3d3);
  static Color gray4 = const Color(0xffdcdcdc);
  static Color gray5 = const Color(0xffe0e0e0);
  static Color gray6 = const Color(0xffe8e8e8);

  static Color error = const Color(0xffe74c3c);
}
