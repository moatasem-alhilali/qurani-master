part of '/quran.dart';

/// أوضاع عرض صفحات المصحف المتاحة
///
/// [QuranDisplayMode] defines the available display modes for Quran pages.
enum QuranDisplayMode {
  /// الوضع الافتراضي — صفحة واحدة أو صفحتين في سطح المكتب
  /// Default mode — single page or dual on desktop (current behavior)
  defaultMode,

  /// صفحة واحدة قابلة للتمرير عموديًا مع تقليب أفقي
  /// Single page that scrolls vertically, swipe left/right to change page
  singleScrollable,

  /// صفحتان جنبًا إلى جنب بدون تمرير (شاشات كبيرة أفقي فقط)
  /// Two full pages side-by-side without scrolling (large screens, landscape only)
  dualPage,

  /// مصحف + تفسير جنبًا إلى جنب (أفقي فقط)
  /// Quran page + tafsir panel side-by-side (landscape only)
  quranWithTafsirSide,

  /// آيات الصفحة مع تفسير كل آية (عمودي وأفقي)
  /// Page ayahs with inline tafsir for each ayah (portrait & landscape)
  ayahWithTafsirInline,
}

/// Extension لتسهيل الوصول إلى خصائص كل وضع عرض
extension QuranDisplayModeExtension on QuranDisplayMode {
  /// المفتاح المستخدم للتخزين في GetStorage
  int get storageIndex => index;

  /// إنشاء وضع من رقم الفهرس المخزّن
  static QuranDisplayMode fromStorageIndex(int idx) {
    if (idx >= 0 && idx < QuranDisplayMode.values.length) {
      return QuranDisplayMode.values[idx];
    }
    return QuranDisplayMode.defaultMode;
  }

  /// الأيقونة الافتراضية لكل وضع
  IconData get icon {
    switch (this) {
      case QuranDisplayMode.defaultMode:
        return Icons.menu_book_rounded;
      case QuranDisplayMode.singleScrollable:
        return Icons.view_day_rounded;
      case QuranDisplayMode.dualPage:
        return Icons.auto_stories_rounded;
      case QuranDisplayMode.quranWithTafsirSide:
        return Icons.chrome_reader_mode_rounded;
      case QuranDisplayMode.ayahWithTafsirInline:
        return Icons.article_rounded;
    }
  }

  /// التسمية العربية لكل وضع
  String get labelAr {
    switch (this) {
      case QuranDisplayMode.defaultMode:
        return 'افتراضي';
      case QuranDisplayMode.singleScrollable:
        return 'صفحة قابلة للتمرير';
      case QuranDisplayMode.dualPage:
        return 'صفحتان';
      case QuranDisplayMode.quranWithTafsirSide:
        return 'مصحف وتفسير';
      case QuranDisplayMode.ayahWithTafsirInline:
        return 'آية مع تفسير';
    }
  }

  /// التسمية الإنجليزية لكل وضع
  String get labelEn {
    switch (this) {
      case QuranDisplayMode.defaultMode:
        return 'Default';
      case QuranDisplayMode.singleScrollable:
        return 'Scrollable Page';
      case QuranDisplayMode.dualPage:
        return 'Dual Page';
      case QuranDisplayMode.quranWithTafsirSide:
        return 'Quran & Tafsir';
      case QuranDisplayMode.ayahWithTafsirInline:
        return 'Ayah with Tafsir';
    }
  }

  /// هل يتوفر هذا الوضع في الاتجاه العمودي؟
  bool get isAvailableInPortrait {
    switch (this) {
      case QuranDisplayMode.defaultMode:
      case QuranDisplayMode.ayahWithTafsirInline:
        return true;
      case QuranDisplayMode.singleScrollable:
      case QuranDisplayMode.dualPage:
      case QuranDisplayMode.quranWithTafsirSide:
        return false;
    }
  }

  /// هل يتطلب هذا الوضع شاشة كبيرة؟
  bool get requiresLargeScreen {
    switch (this) {
      case QuranDisplayMode.dualPage:
        return true;
      default:
        return false;
    }
  }

  /// إرجاع الأوضاع المتاحة بناءً على الاتجاه وحجم الشاشة
  static List<QuranDisplayMode> availableModes(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final isLargeScreen =
        Responsive.isDesktop(context) || Responsive.isTablet(context);
    final isPortrait = orientation == Orientation.portrait;

    return QuranDisplayMode.values.where((mode) {
      if (isPortrait && !mode.isAvailableInPortrait) return false;
      if (mode.requiresLargeScreen && !isLargeScreen) return false;
      return true;
    }).toList();
  }
}
