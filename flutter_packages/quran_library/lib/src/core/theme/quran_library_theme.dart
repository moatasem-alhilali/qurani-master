part of '/quran.dart';

/// غلاف مركزي يحقن مزوِّدات أنماط متعددة بشكل مستقل لتقليل إعادة البناء
class QuranLibraryTheme extends StatelessWidget {
  final SnackBarStyle snackBarStyle;
  final AyahMenuStyle ayahLongClickStyle;
  final IndexTabStyle indexTabStyle;
  final QuranTopBarStyle topBarStyle;
  final TajweedMenuStyle tajweedMenuStyle;
  final SearchTabStyle searchTabStyle;
  final SurahInfoStyle surahInfoStyle;
  final TafsirStyle tafsirStyle;
  final BookmarksTabStyle bookmarksTabStyle;
  final TopBottomQuranStyle topBottomQuranStyle;
  final AyahDownloadManagerStyle ayahDownloadManagerStyle;
  final Widget child;

  const QuranLibraryTheme({
    super.key,
    required this.snackBarStyle,
    required this.ayahLongClickStyle,
    required this.indexTabStyle,
    required this.topBarStyle,
    required this.tajweedMenuStyle,
    required this.searchTabStyle,
    required this.surahInfoStyle,
    required this.tafsirStyle,
    required this.bookmarksTabStyle,
    required this.topBottomQuranStyle,
    required this.ayahDownloadManagerStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // تركيب مزوِّدات الأنماط بشكل متداخل لضمان اعتماد دقيق لكل نمط على حدة
    return SnackBarTheme(
      style: snackBarStyle,
      child: AyahLongClickTheme(
        style: ayahLongClickStyle,
        child: IndexTabTheme(
          style: indexTabStyle,
          child: SearchTabTheme(
            style: searchTabStyle,
            child: SurahInfoTheme(
              style: surahInfoStyle,
              child: TafsirTheme(
                style: tafsirStyle,
                child: BookmarksTabTheme(
                  style: bookmarksTabStyle,
                  child: TopBottomTheme(
                    style: topBottomQuranStyle,
                    child: TajweedMenuTheme(
                      style: tajweedMenuStyle,
                      child: QuranTopBarTheme(
                        style: topBarStyle,
                        child: AyahDownloadManagerTheme(
                          style: ayahDownloadManagerStyle,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// مزود نمط SnackBar
class SnackBarTheme extends InheritedWidget {
  final SnackBarStyle style;
  const SnackBarTheme({super.key, required this.style, required super.child});

  static SnackBarTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SnackBarTheme>();

  @override
  bool updateShouldNotify(covariant SnackBarTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط حوار الضغط المطوّل على الآية
class AyahLongClickTheme extends InheritedWidget {
  final AyahMenuStyle style;
  const AyahLongClickTheme(
      {super.key, required this.style, required super.child});

  static AyahLongClickTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AyahLongClickTheme>();

  @override
  bool updateShouldNotify(covariant AyahLongClickTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط تبويب الفهرس
class IndexTabTheme extends InheritedWidget {
  final IndexTabStyle style;
  const IndexTabTheme({super.key, required this.style, required super.child});

  static IndexTabTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<IndexTabTheme>();

  @override
  bool updateShouldNotify(covariant IndexTabTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط الشريط العلوي للمصحف
class QuranTopBarTheme extends InheritedWidget {
  final QuranTopBarStyle style;
  const QuranTopBarTheme(
      {super.key, required this.style, required super.child});

  static QuranTopBarTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<QuranTopBarTheme>();

  @override
  bool updateShouldNotify(covariant QuranTopBarTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط قائمة أحكام التجويد
class TajweedMenuTheme extends InheritedWidget {
  final TajweedMenuStyle style;
  const TajweedMenuTheme({
    super.key,
    required this.style,
    required super.child,
  });

  static TajweedMenuTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TajweedMenuTheme>();

  @override
  bool updateShouldNotify(covariant TajweedMenuTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط تبويب البحث
class SearchTabTheme extends InheritedWidget {
  final SearchTabStyle style;
  const SearchTabTheme({super.key, required this.style, required super.child});

  static SearchTabTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SearchTabTheme>();

  @override
  bool updateShouldNotify(covariant SearchTabTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط معلومات السورة (الأسفلية)
class SurahInfoTheme extends InheritedWidget {
  final SurahInfoStyle style;
  const SurahInfoTheme({super.key, required this.style, required super.child});

  static SurahInfoTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SurahInfoTheme>();

  @override
  bool updateShouldNotify(covariant SurahInfoTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط التفسير
class TafsirTheme extends InheritedWidget {
  final TafsirStyle style;
  const TafsirTheme({super.key, required this.style, required super.child});

  static TafsirTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TafsirTheme>();

  @override
  bool updateShouldNotify(covariant TafsirTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط تبويب العلامات المرجعية (Bookmarks)
class BookmarksTabTheme extends InheritedWidget {
  final BookmarksTabStyle style;
  const BookmarksTabTheme(
      {super.key, required this.style, required super.child});

  static BookmarksTabTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BookmarksTabTheme>();

  @override
  bool updateShouldNotify(covariant BookmarksTabTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط قسمَي الأعلى/الأسفل (Top/Bottom)
class TopBottomTheme extends InheritedWidget {
  final TopBottomQuranStyle style;
  const TopBottomTheme({super.key, required this.style, required super.child});

  static TopBottomTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TopBottomTheme>();

  @override
  bool updateShouldNotify(covariant TopBottomTheme oldWidget) =>
      style != oldWidget.style;
}

/// مزود نمط قسمَي الأعلى/الأسفل (Top/Bottom)
class AyahDownloadManagerTheme extends InheritedWidget {
  final AyahDownloadManagerStyle style;
  const AyahDownloadManagerTheme(
      {super.key, required this.style, required super.child});

  static AyahDownloadManagerTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AyahDownloadManagerTheme>();

  @override
  bool updateShouldNotify(covariant AyahDownloadManagerTheme oldWidget) =>
      style != oldWidget.style;
}
