import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/gen/fonts.gen.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AppColors.darkBackground,
  canvasColor: AppColors.darkSurface,
  cardColor: AppColors.darkSurface,
  dividerColor: AppColors.darkOutline,
  shadowColor: AppColors.darkOutline,
  primaryColor: AppColors.gold,
  primaryColorLight: AppColors.gold.withOpacity(0.85),
  primaryColorDark: AppColors.gold,
  primarySwatch: MaterialColor(AppColors.gold.value, {
    50: AppColors.gold.withOpacity(.05),
    100: AppColors.gold.withOpacity(.1),
    200: AppColors.gold.withOpacity(.2),
    300: AppColors.gold.withOpacity(.3),
    400: AppColors.gold.withOpacity(.4),
    500: AppColors.gold,
    600: AppColors.gold.withOpacity(.6),
    700: AppColors.gold.withOpacity(.7),
    800: AppColors.gold.withOpacity(.8),
    900: AppColors.gold.withOpacity(.9),
  }),
  disabledColor: AppColors.darkDisabled,
  focusColor: AppColors.darkFocus,
  highlightColor: AppColors.darkHighlight,
  hintColor: AppColors.darkSecondaryText,
  hoverColor: AppColors.darkHover,
  splashColor: AppColors.darkSplash,
  unselectedWidgetColor: AppColors.darkDisabled,
  fontFamily: FontFamily.ios1,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.gold,
    onPrimary: Colors.white,
    secondary: AppColors.blue,
    onSecondary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    outline: AppColors.darkOutline,
    tertiary: AppColors.success,
  ),

  // APP BAR
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkOnBackground),
    titleTextStyle: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // ICONS
  iconTheme: const IconThemeData(color: AppColors.darkOnBackground),
  primaryIconTheme: const IconThemeData(color: AppColors.darkOnBackground),

  // TEXT THEME
  textTheme: TextTheme(
    // Display Styles (Largest)
    displayLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 57.sp,
      height: 1.12,
      letterSpacing: -0.25,
      color: AppColors.darkOnBackground,
    ),
    displayMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 45.sp,
      height: 1.16,
      color: AppColors.darkOnBackground,
    ),
    displaySmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 36.sp,
      height: 1.22,
      color: AppColors.darkOnBackground,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 32.sp,
      height: 1.25,
      color: AppColors.darkOnBackground,
    ),
    headlineMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 28.sp,
      height: 1.29,
      color: AppColors.darkOnBackground,
    ),
    headlineSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 24.sp,
      height: 1.33,
      color: AppColors.darkOnBackground,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 22.sp,
      height: 1.27,
      color: AppColors.darkOnBackground,
    ),
    titleMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.50,
      letterSpacing: 0.15,
      color: AppColors.darkOnBackground,
    ),
    titleSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.darkOnBackground,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.darkOnBackground,
    ),
    labelMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      height: 1.33,
      letterSpacing: 0.5,
      color: AppColors.darkOnBackground,
    ),
    labelSmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
      height: 1.45,
      letterSpacing: 0.5,
          color: AppColors.darkOnBackground,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
      height: 1.50,
      letterSpacing: 0.15,
      color: AppColors.darkOnBackground,
    ),
    bodyMedium: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      height: 1.43,
      letterSpacing: 0.25,
      color: AppColors.darkOnBackground,
    ),
    bodySmall: TextStyle(
      fontFamily: FontFamily.ios1,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      height: 1.33,
      letterSpacing: 0.4,
      color: AppColors.darkOnBackground,
    ),
  ),

  // INPUTS & FORMS
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    hintStyle: const TextStyle(color: AppColors.darkSecondaryText),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.darkOutline),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.darkOutline),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.gold),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  // BUTTONS
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.gold,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.darkDisabled,
      disabledForegroundColor: AppColors.darkSecondaryText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.gold,
      side: const BorderSide(color: AppColors.gold, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.gold,
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    buttonColor: AppColors.gold,
    disabledColor: AppColors.disabled,
    textTheme: ButtonTextTheme.primary,
  ),

  // BOTTOM NAVIGATION
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.gold,
    unselectedItemColor: AppColors.darkSecondaryText,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // TABS
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.gold,
    unselectedLabelColor: AppColors.darkSecondaryText,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.gold, width: 2),
    ),
  ),

  // SWITCH
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.gold
          : AppColors.darkDisabled,
    ),
    trackColor: WidgetStateProperty.resolveWith<Color>(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.gold.withOpacity(0.5)
          : AppColors.darkOutline,
    ),
  ),

  // CHECKBOX
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.all(AppColors.gold),
    checkColor: WidgetStateProperty.all(Colors.white),
  ),

  // RADIO
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.all(AppColors.gold),
  ),

  // SLIDER
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.gold,
    inactiveTrackColor: AppColors.darkDisabled,
    thumbColor: AppColors.gold,
    overlayColor: AppColors.gold.withOpacity(0.16),
  ),

  // PROGRESS INDICATOR
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.gold,
    circularTrackColor: AppColors.darkOutline,
    linearTrackColor: AppColors.darkOutline,
    refreshBackgroundColor: AppColors.darkSurface,
    linearMinHeight: 3,
  ),

  // SNACKBAR
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.gold,
    contentTextStyle: const TextStyle(color: Colors.white),
    actionTextColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // DIALOG
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkSurface,
    titleTextStyle: const TextStyle(
      color: AppColors.darkOnBackground,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(color: AppColors.darkOnBackground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // DRAWER
  drawerTheme: DrawerThemeData(
    backgroundColor: AppColors.darkSurface,
    scrimColor: AppColors.gold.withOpacity(0.05),
    elevation: 2,
  ),

  // LIST TILE
  listTileTheme: ListTileThemeData(
    iconColor: AppColors.darkSecondaryText,
    selectedColor: AppColors.gold,
    textColor: AppColors.darkOnBackground,
    tileColor: AppColors.darkSurface,
    selectedTileColor: AppColors.gold.withOpacity(0.09),
  ),

  // CARD
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    shadowColor: AppColors.darkShadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  ),

  // BOTTOM SHEET
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.darkSurface,
    modalBackgroundColor: AppColors.darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    elevation: 8,
  ),

  // TOOLTIP
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      color: AppColors.darkOnBackground,
      fontWeight: FontWeight.bold,
    ),
    waitDuration: const Duration(milliseconds: 350),
    showDuration: const Duration(seconds: 2),
    preferBelow: true,
    verticalOffset: 20,
  ),

  // BADGE
  badgeTheme: const BadgeThemeData(
    backgroundColor: AppColors.gold,
    textColor: Colors.white,
    largeSize: 18,
    smallSize: 10,
    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  ),

  // BANNER
  bannerTheme: const MaterialBannerThemeData(
    backgroundColor: AppColors.darkWarning,
    contentTextStyle: TextStyle(color: AppColors.darkOnBackground),
    padding: EdgeInsets.all(12),
  ),

  // MENU
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
      shadowColor: WidgetStateProperty.all(AppColors.darkShadow),
      surfaceTintColor:
          WidgetStateProperty.all(AppColors.gold.withOpacity(0.1)),
    ),
  ),

  // DATA TABLE
  dataTableTheme: DataTableThemeData(
    headingRowColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.12)),
    dataRowColor: WidgetStateProperty.all(AppColors.darkSurface),
    dividerThickness: 0.6,
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.darkOutline),
    ),
  ),

  // EXPANSION TILE
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: AppColors.darkSurface,
    collapsedBackgroundColor: AppColors.darkSurface,
    textColor: AppColors.darkOnBackground,
    iconColor: AppColors.gold,
    collapsedIconColor: AppColors.darkSecondaryText,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // POPUP MENU
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.darkSurface,
    textStyle: const TextStyle(color: AppColors.darkOnBackground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 10,
  ),

  // SCROLLBAR
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.65)),
    trackColor: WidgetStateProperty.all(AppColors.darkSurface),
    radius: const Radius.circular(10),
    thickness: WidgetStateProperty.all(6),
  ),

  // SEGMENTED BUTTON
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
      foregroundColor: WidgetStateProperty.all(AppColors.darkOnBackground),
      overlayColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.11)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  ),

  // DROPDOWN MENU
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
      elevation: WidgetStateProperty.all(8),
      shadowColor: WidgetStateProperty.all(AppColors.darkShadow),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textStyle: const TextStyle(color: AppColors.darkOnBackground),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.darkSurface,
      hintStyle: TextStyle(color: AppColors.darkSecondaryText),
    ),
  ),

  // SEARCH BAR (Material 3)
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
    hintStyle: WidgetStateProperty.all(
      const TextStyle(color: AppColors.darkSecondaryText),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(color: AppColors.darkOnBackground),
    ),
    elevation: WidgetStateProperty.all(1),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  // DRAWER
  navigationDrawerTheme: NavigationDrawerThemeData(
    backgroundColor: AppColors.darkSurface,
    elevation: 2,
    indicatorColor: AppColors.gold.withOpacity(0.13),
    iconTheme: WidgetStateProperty.all(
      const IconThemeData(color: AppColors.darkSecondaryText),
    ),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: AppColors.darkOnBackground),
    ),
  ),

  // NAVIGATION RAIL
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedIconTheme: const IconThemeData(color: AppColors.gold),
    unselectedIconTheme:
        const IconThemeData(color: AppColors.darkSecondaryText),
    selectedLabelTextStyle:
        const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
    unselectedLabelTextStyle:
        const TextStyle(color: AppColors.darkSecondaryText),
    indicatorColor: AppColors.gold.withOpacity(0.14),
  ),

  // NAVIGATION BAR
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    elevation: 1,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
    ),
    iconTheme:
        WidgetStateProperty.all(const IconThemeData(color: AppColors.gold)),
    indicatorColor: AppColors.gold.withOpacity(0.18),
  ),

  // TIME PICKER
  timePickerTheme: TimePickerThemeData(
    backgroundColor: AppColors.darkSurface,
    dialHandColor: AppColors.gold,
    dialBackgroundColor: AppColors.gold.withOpacity(0.11),
    hourMinuteColor: AppColors.gold.withOpacity(0.09),
    hourMinuteTextColor: AppColors.darkOnBackground,
    entryModeIconColor: AppColors.gold,
    helpTextStyle: const TextStyle(
      color: AppColors.darkOnBackground,
      fontWeight: FontWeight.bold,
    ),
  ),

  // DATE PICKER
  datePickerTheme: DatePickerThemeData(
    backgroundColor: AppColors.darkSurface,
    headerBackgroundColor: AppColors.gold.withOpacity(0.13),
    headerForegroundColor: AppColors.gold,
    dayForegroundColor: WidgetStateProperty.all(AppColors.darkOnBackground),
    dayOverlayColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.11)),
    yearForegroundColor: WidgetStateProperty.all(AppColors.darkSecondaryText),
  ),
  // ACTION ICONS (AppBar, menus)
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) =>
        const Icon(Icons.arrow_back, color: AppColors.onBackground),
    closeButtonIconBuilder: (context) =>
        const Icon(Icons.close, color: AppColors.onBackground),
    drawerButtonIconBuilder: (context) =>
        const Icon(Icons.menu, color: AppColors.onBackground),
    endDrawerButtonIconBuilder: (context) =>
        const Icon(Icons.menu_open, color: AppColors.onBackground),
    // يمكنك تخصيص style إذا احتجت
  ),

  // ADAPTATIONS (نادراً ما تستخدمها)
  // adaptations: [],

  // ELEVATION OVERLAY (للدعم الحقيقي للدارك مود فقط غالبًا)
  applyElevationOverlayColor: false,

  // BOTTOM APP BAR
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: AppColors.darkSurface,
    elevation: 6,
    shape: CircularNotchedRectangle(),
    shadowColor: AppColors.darkShadow,
  ),

  // CHIP THEME
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedColor: AppColors.gold.withOpacity(0.19),
    disabledColor: AppColors.darkDisabled,
    labelStyle: const TextStyle(color: AppColors.darkOnBackground),
    secondaryLabelStyle: const TextStyle(color: AppColors.gold),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    secondarySelectedColor: AppColors.gold,
    brightness: Brightness.light,
    deleteIconColor: AppColors.error,
  ),

  // COLOR SCHEME SEED (إذا تريد ColorScheme ديناميكي)
  // colorSchemeSeed: AppColors.gold,

  // DIVIDER THEME
  dividerTheme: const DividerThemeData(
    color: AppColors.darkOutline,
    space: 1,
    thickness: 0.7,
    indent: 0,
    endIndent: 0,
  ),

  // EXTENSIONS (لإضافة ThemeExtension مخصص لك، مثال):
  // extensions: <ThemeExtension<dynamic>>[MyCustomExtension(...)],

  // FILLED BUTTON THEME (Material 3)
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.darkOnBackground,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // FLOATING ACTION BUTTON THEME
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.gold,
    foregroundColor: AppColors.darkOnBackground,
    elevation: 7,
    shape: CircleBorder(),
  ),

  // FONT FAMILY FALLBACK
  fontFamilyFallback: const [FontFamily.ios1, FontFamily.ios2],

  // ICON BUTTON THEME (Material3)
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.gold),
      backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
      overlayColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.12)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      shadowColor: WidgetStateProperty.all(AppColors.gold.withOpacity(0.12)),
      surfaceTintColor:
          WidgetStateProperty.all(AppColors.gold.withOpacity(0.12)),
      iconColor: WidgetStateProperty.all(AppColors.darkOnSurface),
    ),
  ),

  // MATERIAL TAP TARGET SIZE
  materialTapTargetSize: MaterialTapTargetSize.padded,

  // MENU BAR/BUTTON (Material3)
  menuBarTheme: MenuBarThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
      elevation: WidgetStateProperty.all(8),
      shadowColor: WidgetStateProperty.all(AppColors.darkShadow),
    ),
  ),
  menuButtonTheme: MenuButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.gold),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  ),

  // PAGE TRANSITIONS
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    },
  ),

  // PLATFORM (لتحديد المنصة يدوياً لو لديك منطق خاص)
  // platform: TargetPlatform.android,

  // SEARCH VIEW THEME (Material3)
  searchViewTheme: SearchViewThemeData(
    backgroundColor: AppColors.darkSurface,
    headerHintStyle: const TextStyle(
      color: AppColors.darkSecondaryText,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    barPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    constraints: const BoxConstraints(
      minWidth: 200,
      maxWidth: 600,
      minHeight: 100,
      maxHeight: 400,
    ),
    dividerColor: AppColors.darkOutline,
    elevation: 1,
    headerHeight: 50,
    headerTextStyle: const TextStyle(
      color: AppColors.darkOnBackground,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shrinkWrap: true,
    side: const BorderSide(color: AppColors.darkOutline),
    surfaceTintColor: AppColors.darkSurface,
  ),

  // SECONDARY HEADER COLOR (نادراً تستخدمه)
  secondaryHeaderColor: AppColors.gold.withOpacity(0.12),

  // SPLASH FACTORY (تأثير الضغط)
  splashFactory: InkRipple.splashFactory,

  // TEXT SELECTION THEME (لون التحديد والمؤشر)
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.gold,
    selectionColor: AppColors.gold.withOpacity(0.16),
    selectionHandleColor: AppColors.gold,
  ),

  // TOGGLE BUTTONS
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: AppColors.darkSecondaryText,
    selectedColor: AppColors.darkOnBackground,
    fillColor: AppColors.gold,
    borderColor: AppColors.darkOutline,
    selectedBorderColor: AppColors.gold,
    borderRadius: BorderRadius.circular(8),
    textStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),

  // TYPOGRAPHY (تخصيص كامل لأنماط النصوص حسب المنصة)
  typography: Typography.material2021(),

  // USE SYSTEM COLORS (نادراً تحتاجها)
  useSystemColors: false,
);
