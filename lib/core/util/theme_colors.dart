import 'package:flutter/material.dart';

class AppColors {
  // BASE COLORS (used for both light and dark themes)
  // Main brand color - used for primary buttons, FAB, active icons,
  // accent highlights
  static const Color gold = Color(0xFFC3A46B);
  static const Color brandGoldLight = Color(0xFFD9BE8F);
  static const Color brandGoldDeep = Color(0xFFB18C55);
  static const Color brandSand = Color(0xFFCBB08B);
  static const Color brandCream = Color(0xFFF8EDD2);
  static const Color brandIvory = Color(0xFFFFF7E7);
  static const Color brandMist = Color(0xFFF2E1BD);
  static const Color brandBrown = Color(0xFF6F5636);
  static const Color brandBrownDeep = Color(0xFF5A452A);

  // Night tones of the same brand browns. Used only by the adaptive prayer
  // sky, so Fajr and Isha stay inside the brand family instead of reaching
  // for a neutral black.
  static const Color brandDusk = Color(0xFF3A2C1C);
  static const Color brandNight = Color(0xFF1E1811);

  // ----------------- PRAYER SKY TONES -----------------
  // The adaptive prayer sky is the ONE surface in the app that has to change
  // hue, so it is the one place that does NOT draw from the brand browns.
  // Built from them, all six prayers came out the same amber and the sky
  // stopped telling the time, which is its whole job.
  //
  // Each set is read off the real thing: the blue hour and the anti-twilight
  // arch at Fajr, clean zenith blue at noon, the violet-to-ember collapse at
  // Maghrib. Nothing else in the app uses these — the brand palette above
  // still owns every button, tile and piece of type outside the sky.

  // الفجر: الساعة الزرقاء، وقوس الشفق المضادّ الورديّ فوق الأفق.
  static const Color skyFajr1 = Color(0xFF0E1631);
  static const Color skyFajr2 = Color(0xFF2B2C57);
  static const Color skyFajr3 = Color(0xFF6E4C6B);
  static const Color skyFajr4 = Color(0xFFBE7F69);
  static const Color skyFajrInk = Color(0xFFF7EDE4);
  static const Color skyFajrInkSoft = Color(0xFFCFBCC3);
  static const Color skyFajrOrb = Color(0xFFF6E9D4);
  static const Color skyFajrGlow = Color(0xFFDDA28C);
  static const Color skyFajrHorizon = Color(0xFF0A1020);

  // الشروق: زرقة صافية أعلى، وشريط ورديّ ثم خوخيّ عند الأفق.
  static const Color skySunrise1 = Color(0xFF8FC0DC);
  static const Color skySunrise2 = Color(0xFFD9C3C3);
  static const Color skySunrise3 = Color(0xFFF7C79B);
  static const Color skySunrise4 = Color(0xFFFFEDD3);
  static const Color skySunriseInk = Color(0xFF3A322A);
  static const Color skySunriseInkSoft = Color(0xFF6E6153);
  static const Color skySunriseVeil = Color(0xFF2E2820);
  static const Color skySunriseGlow = Color(0xFFFFC978);
  static const Color skySunriseHorizon = Color(0xFF2F2E36);

  // الظهر: ذروة الزرقة، تشحب إلى ضباب فاتح عند خطّ الأفق.
  static const Color skyNoon1 = Color(0xFF5B9FCE);
  static const Color skyNoon2 = Color(0xFF8FC0DE);
  static const Color skyNoon3 = Color(0xFFC6DCE9);
  static const Color skyNoon4 = Color(0xFFF2F0E6);
  static const Color skyNoonInk = Color(0xFF233240);
  static const Color skyNoonInkSoft = Color(0xFF566B7A);
  static const Color skyNoonVeil = Color(0xFF1E2A33);
  static const Color skyNoonGlow = Color(0xFFFFD98F);
  static const Color skyNoonHorizon = Color(0xFF2C3A44);

  // العصر: زرقة تخفت ويعلوها ضباب قمحيّ ثم ذهب ما قبل الغروب.
  static const Color skyAsr1 = Color(0xFF7CA3BC);
  static const Color skyAsr2 = Color(0xFFB6B79E);
  static const Color skyAsr3 = Color(0xFFE3C287);
  static const Color skyAsr4 = Color(0xFFF6D99C);
  static const Color skyAsrInk = Color(0xFF3B342A);
  static const Color skyAsrInkSoft = Color(0xFF6E6355);
  static const Color skyAsrVeil = Color(0xFF332C22);
  static const Color skyAsrGlow = Color(0xFFF8C77E);
  static const Color skyAsrHorizon = Color(0xFF3A342A);

  // المغرب: بنفسجيّ عميق ينهار إلى قرمزيّ ثم جمر برتقاليّ.
  static const Color skyMaghrib1 = Color(0xFF241D47);
  static const Color skyMaghrib2 = Color(0xFF6B3560);
  static const Color skyMaghrib3 = Color(0xFFC74B31);
  static const Color skyMaghrib4 = Color(0xFFFBB25C);
  static const Color skyMaghribInk = Color(0xFFFFF4E6);
  static const Color skyMaghribInkSoft = Color(0xFFF1D7C3);
  static const Color skyMaghribOrb = Color(0xFFFFE9C4);
  static const Color skyMaghribGlow = Color(0xFFFF7A3D);
  static const Color skyMaghribHorizon = Color(0xFF170F22);

  // العشاء: ليل كحليّ عميق يفتح على بنفسجيّ خافت عند الأفق.
  static const Color skyIsha1 = Color(0xFF060A1A);
  static const Color skyIsha2 = Color(0xFF101836);
  static const Color skyIsha3 = Color(0xFF22284E);
  static const Color skyIsha4 = Color(0xFF3E3752);
  static const Color skyIshaInk = Color(0xFFF2EFE8);
  static const Color skyIshaInkSoft = Color(0xFFB5B2C4);
  // ضوء القمر أبيض بارد، لا رمليّ — وهذا ما يميّز ليل العشاء عن فجر وردي.
  static const Color skyIshaOrb = Color(0xFFFDFAF0);
  static const Color skyIshaGlow = Color(0xFFB9C4E0);
  static const Color skyIshaHorizon = Color(0xFF05070F);

  // مصابيح المسجد: دافئة دائمًا، مهما برد لون السماء حولها.
  static const Color skyLampDawn = Color(0xFFEFA95A);
  static const Color skyLampDusk = Color(0xFFFFC46B);
  static const Color skyLampNight = Color(0xFFE9A94F);

  static const Color skyVeilLight = Color(0xFFFFFFFF);
  static const Color skyOrbWhite = Color(0xFFFFFFFF);
  static const Color skyOrbWarmWhite = Color(0xFFFFFDF5);

  // Accent color - used for secondary actions, switches, accent elements
  static const Color blue = Color(0xFF4083FF);

  // Error color - used for error states, alerts, error borders/text/icons
  static const Color error = Color(0xFFDC4C3E);

  // Success color - used for success messages, icons, success indicators
  static const Color success = Color(0xFF22B07D);

  // ----------------- LIGHT MODE COLORS -----------------

  // Main background color - used for Scaffold, screens, drawers
  static const Color background = Color(0xFFF9F9F9);

  // Surface color - used for cards, dialogs, bottom sheets, app bars
  static const Color surface = Color(0xFFFFFFFF);

  // Main text/icon color - used on background, primary for headings and main content
  static const Color onBackground = Color(0xFF1A1A1A);

  // Main text/icon color on surfaces - used on cards, dialogs, sheets
  static const Color onSurface = Color(0xFF1A1A1A);

  // Secondary text/icon color - used for secondary/disabled text, subtitles, inactive icons
  static const Color secondaryText = Color(0xFF717171);

  // Outline/border color - used for input borders, dividers, outlines
  static const Color outline = Color(0xFFE5E5E5);

  // Disabled color - used for disabled buttons, switches, sliders, etc.
  static const Color disabled = Color(0xFFCDCDCD);

  // Shadow color - used for card shadows, elevation overlays
  static const Color shadow = Color(0x1A000000);

  // Divider color - used for Divider, ListTile separators, table borders
  static const Color divider = Color(0xFFE5E5E5);

  // Focus color - used for focused input borders, focus highlights
  static const Color focus = Color(0xFF92C7FF);

  // Highlight color - used for pressed states, highlight overlays
  static const Color highlight = Color(0x33C3A46B);

  // Hover color - used for hover state on web/desktop, button hover
  static const Color hover = Color(0x1AC3A46B);

  // Splash color - used for ripple/tap effects
  static const Color splash = Color(0x29C3A46B);

  // Warning color - used for warning alerts, banners, etc.
  static const Color warning = Color(0xFFF8BB86);

  // Info color - used for informational banners, tags, icons
  static const Color info = Color(0xFF1976D2);

  // ----------------- DARK MODE COLORS -----------------

  // Main background color (dark) - used for Scaffold, screens, drawers
  static const Color darkBackground = Color(0xFF121212);

  // Surface color (dark) - used for cards, dialogs, bottom sheets, app bars
  static const Color darkSurface = Color(0xFF222326);

  // Main text/icon color on background (dark) - used for headings and main content
  static const Color darkOnBackground = Color(0xFFFFFFFF);

  // Main text/icon color on surfaces (dark) - used on cards, dialogs, sheets
  static const Color darkOnSurface = Color(0xFFFFFFFF);

  // Secondary text/icon color (dark) - used for secondary/disabled text, subtitles, inactive icons
  static const Color darkSecondaryText = Color(0xFFB2B2B2);

  // Outline/border color (dark) - used for input borders, dividers, outlines
  static const Color darkOutline = Color(0xFF353535);

  // Disabled color (dark) - used for disabled buttons, switches, sliders, etc.
  static const Color darkDisabled = Color(0xFF555555);

  // Shadow color (dark) - used for card shadows, elevation overlays
  static const Color darkShadow = Color(0x80000000);

  // Divider color (dark) - used for Divider, ListTile separators, table borders
  static const Color darkDivider = Color(0xFF353535);

  // Focus color (dark) - used for focused input borders, focus highlights
  static const Color darkFocus = Color(0xFF3886DD);

  // Highlight color (dark) - used for pressed states, highlight overlays
  static const Color darkHighlight = Color(0x33C3A46B);

  // Hover color (dark) - used for hover state on web/desktop, button hover
  static const Color darkHover = Color(0x1AC3A46B);

  // Splash color (dark) - used for ripple/tap effects
  static const Color darkSplash = Color(0x29C3A46B);

  // Warning color (dark) - used for warning alerts, banners, etc.
  static const Color darkWarning = Color(0xFFF8BB86);

  // Info color (dark) - used for informational banners, tags, icons
  static const Color darkInfo = Color(0xFF90CAF9);

  // Used as background for circular icon buttons (inactive/normal)
  // Example: Quick settings icon backgrounds in light mode
  static const Color iconBgLight =
      Color(0xFFE8E8E8); // Very light gray, ~8% opacity

  // Used as background for circular icon buttons (inactive/normal) in dark mode
  // Example: Quick settings icon backgrounds in dark mode
  static const Color iconBgDark = Color(
    0x1AFFFFFF,
  ); // White 10% opacity (or Color(0xFF23272B).withOpacity(0.26))

  // Used as background for circular icon buttons when selected/active (both themes)
  // Example: Quick settings icon backgrounds when toggled on
  static const Color iconBgActive = gold; // Your primary gold color
}
