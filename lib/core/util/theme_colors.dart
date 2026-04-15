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
