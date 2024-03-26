import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/core/theme/themeData.dart';

enum ToolAppThemeType { light, dark }

ThemeData getDarkTheme() => ThemeData(
      ///Colors
      //
      scaffoldBackgroundColor: const Color(0xff1e1e1e), //customScaffoldColor,
      splashColor: const Color(0xff252525), //customBackGroundBody
      primaryColor: const Color(0xff2f2f2f), //custom main
      shadowColor: FxColors.secondary,
      brightness: Brightness.dark,
      fontFamily: FxFonts.ios1,

      ///dividerTheme
      dividerColor: Colors.grey.withOpacity(0.5),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Colors.grey.withOpacity(0.5),
      ),
      useMaterial3: true,
      drawerTheme: DrawerThemeData(
        backgroundColor: FxColors.secondary,
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
      tabBarTheme: TabBarTheme(
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: FxFonts.ios1,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        labelColor: Colors.white,
        dividerColor: FxColors.background,
        indicatorColor: FxColors.background,
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
            color: FxColors.third,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: FxColors.secondary,
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
            color: FxColors.primary,
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
            color: FxColors.primary,
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
          backgroundColor: FxColors.primary,
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
        backgroundColor: FxColors.primary,
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
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xff1F222A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      progressIndicatorTheme:
          ProgressIndicatorThemeData(circularTrackColor: FxColors.primary),

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
