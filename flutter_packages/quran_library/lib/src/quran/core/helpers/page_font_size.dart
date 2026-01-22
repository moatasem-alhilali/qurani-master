part of '/quran.dart';

/// Helpers to compute dynamic font sizes for Quran pages across devices.
class PageFontSizeHelper {
  // Design width used in ScreenUtilInit
  static const double _designWidth = 392.72727272727275;

  /// Compute dynamic font size for QCF (downloaded fonts) pages.
  /// - Uses Layout constraints width when available, else MediaQuery width.
  /// - Adjusts for orientation and clamps to reasonable bounds.
  static double qcfFontSize({
    required BuildContext context,
    required int pageIndex,
    double? maxWidth,
  }) {
    final media = MediaQuery.of(context);
    final width =
        (maxWidth != null && maxWidth > 0) ? maxWidth : media.size.width;
    final orientation = media.orientation;

    double ratio = (width / _designWidth).clamp(0.6, 1.6);
    double size = 100.0 * ratio;

    // In landscape we usually need a smaller size to avoid overflow
    if (orientation == Orientation.landscape) {
      size *= 0.82;
    }

    // Minor adjustment for the first two pages (Fatihah/Baqarah start)
    if (pageIndex == 0 || pageIndex == 1) {
      size *= 0.96;
    }

    // Clamp to safe bounds
    return size.clamp(78.0, 120.0);
  }

  /// Compute dynamic base font size for Hafs (text-scale mode).
  static double hafsFontSize({
    required BuildContext context,
    double? maxWidth,
  }) {
    final media = MediaQuery.of(context);
    final width =
        (maxWidth != null && maxWidth > 0) ? maxWidth : media.size.width;
    final orientation = media.orientation;

    double ratio = (width / _designWidth).clamp(0.6, 1.6);
    double base = 22.0 * ratio;
    if (orientation == Orientation.landscape) base *= 0.9;
    return base.clamp(16.0, 28.0);
  }
}
