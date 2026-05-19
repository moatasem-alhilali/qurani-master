part of '/quran.dart';

/// عرض السكرول التلقائي — ListView عمودي مع تمرير مستمر
///
/// [AutoScrollPageView] displays Quran pages in a vertical ListView
/// driven by [AutoScrollCtrl]'s ScrollController for automatic scrolling.
class AutoScrollPageView extends StatelessWidget {
  const AutoScrollPageView({
    super.key,
    required this.quranCtrl,
    required this.autoScrollCtrl,
    required this.isDark,
    required this.languageCode,
    required this.onPagePress,
    required this.circularProgressWidget,
    required this.bookmarkList,
    required this.ayahSelectedFontColor,
    required this.textColor,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.onAyahLongPress,
    required this.bookmarksColor,
    this.customBookmarksColor,
    required this.surahNameStyle,
    required this.bannerStyle,
    required this.basmalaStyle,
    required this.onSurahBannerPress,
    required this.surahNumber,
    required this.ayahSelectedBackgroundColor,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.isAyahBookmarked,
    required this.parentContext,
    required this.isFontsLocal,
  });

  final QuranCtrl quranCtrl;
  final AutoScrollCtrl autoScrollCtrl;
  final bool isDark;
  final String languageCode;
  final VoidCallback? onPagePress;
  final Widget? circularProgressWidget;
  final List<dynamic> bookmarkList;
  final Color? ayahSelectedFontColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final BasmalaStyle? basmalaStyle;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final int? surahNumber;
  final Color? ayahSelectedBackgroundColor;
  final String? fontsName;
  final List<int>? ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final BuildContext parentContext;
  final bool? isFontsLocal;

  @override
  Widget build(BuildContext context) {
    final startPage = autoScrollCtrl.state.startPage.value;
    // عدد الصفحات من الصفحة الحالية حتى نهاية المصحف — الكنترولر يتحكم بالتوقف
    final pageCount = (604 - startPage + 1).clamp(1, 604);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        controller: autoScrollCtrl.scrollController,
        physics: const ClampingScrollPhysics(),
        cacheExtent: screenHeight * 3,
        itemCount: pageCount,
        itemBuilder: (ctx, index) {
          final pageIndex = startPage - 1 + index; // 0-based
          return RepaintBoundary(
            key: ValueKey('auto_scroll_page_$pageIndex'),
            child: SingleChildScrollView(
              child: PageViewBuild(
                circularProgressWidget: circularProgressWidget,
                languageCode: languageCode,
                bookmarkList: bookmarkList,
                ayahSelectedFontColor: ayahSelectedFontColor,
                textColor: textColor,
                ayahIconColor: ayahIconColor,
                showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                onAyahLongPress: onAyahLongPress,
                bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
                surahNameStyle: surahNameStyle,
                bannerStyle: bannerStyle,
                basmalaStyle: basmalaStyle,
                onSurahBannerPress: onSurahBannerPress,
                surahNumber: surahNumber,
                ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                onPagePress: onPagePress,
                isDark: isDark,
                fontsName: fontsName,
                ayahBookmarked: ayahBookmarked,
                isAyahBookmarked: isAyahBookmarked,
                userContext: parentContext,
                pageIndex: pageIndex,
                quranCtrl: quranCtrl,
                isFontsLocal: isFontsLocal ?? false,
              ),
            ),
          );
        },
      ),
    );
  }
}
