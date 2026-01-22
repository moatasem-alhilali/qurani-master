part of '/quran.dart';

/// شرح: صفحة عرض القرآن بالخطوط المحسنة مع تحسينات الأداء
/// Explanation: Optimized Quran page display with fonts and performance improvements
class _QuranFontsPage extends StatelessWidget {
  final BuildContext context;
  final int pageIndex;
  final List? bookmarkList;
  final BasmalaStyle? basmalaStyle;
  final int? surahNumber;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;

  final Color? bookmarksColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final Map<int, List<BookmarkModel>> bookmarks;
  final List<int> bookmarksAyahs;
  final Color? ayahSelectedBackgroundColor;
  final bool isDark;
  final bool showAyahBookmarkedIcon;
  final Widget? circularProgressWidget;
  final bool? isFontsLocal;
  final String? fontsName;
  final List<int> ayahBookmarked;

  const _QuranFontsPage({
    required this.context,
    required this.pageIndex,
    this.bookmarkList,
    this.basmalaStyle,
    this.surahNumber,
    this.surahNameStyle,
    this.bannerStyle,
    this.onSurahBannerPress,
    this.onAyahLongPress,
    this.bookmarksColor,
    this.textColor,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = true,
    required this.bookmarks,
    required this.bookmarksAyahs,
    this.ayahSelectedBackgroundColor,
    this.isDark = false,
    this.circularProgressWidget,
    this.isFontsLocal,
    this.fontsName,
    required this.ayahBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return GetBuilder<QuranCtrl>(
      builder: (quranCtrl) {
        if (quranCtrl.isQpcV4Enabled && !quranCtrl.isQpcV4AllPagesPrebuilt) {
          Future(() => quranCtrl.ensureQpcV4AllPagesPrebuilt());
          return Center(
            child: SizedBox(
              width: 220,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: quranCtrl.qpcV4PrebuildProgress,
                    minHeight: 6,
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          padding: pageIndex == 0 || pageIndex == 1
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * .08)
              : const EdgeInsets.symmetric(horizontal: 8.0),
          margin: pageIndex == 0 || pageIndex == 1
              ? EdgeInsets.symmetric(
                  vertical: UiHelper.currentOrientation(
                      MediaQuery.sizeOf(context).width * .16,
                      MediaQuery.sizeOf(context).height * .01,
                      context))
              : EdgeInsets.zero,
          child: quranCtrl.state.pages.isEmpty
              ? circularProgressWidget ??
                  const CircularProgressIndicator.adaptive()
              : (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                  ? isLandscape &&
                          (Responsive.isMobile(context) ||
                              Responsive.isMobileLarge(context))
                      ? SingleChildScrollView(
                          child: PageBuild(
                            pageIndex: pageIndex,
                            surahNumber: surahNumber,
                            bannerStyle: bannerStyle,
                            isDark: isDark,
                            surahNameStyle: surahNameStyle,
                            onSurahBannerPress: onSurahBannerPress,
                            basmalaStyle: basmalaStyle,
                            textColor: textColor,
                            bookmarks: bookmarks,
                            onAyahLongPress: onAyahLongPress,
                            bookmarkList: bookmarkList,
                            ayahIconColor: ayahIconColor,
                            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                            bookmarksAyahs: bookmarksAyahs,
                            bookmarksColor: bookmarksColor,
                            ayahSelectedBackgroundColor:
                                ayahSelectedBackgroundColor,
                            isFontsLocal: isFontsLocal,
                            fontsName: fontsName,
                            ayahBookmarked: ayahBookmarked,
                            context: context,
                            quranCtrl: quranCtrl,
                          ),
                        )
                      : PageBuild(
                          pageIndex: pageIndex,
                          surahNumber: surahNumber,
                          bannerStyle: bannerStyle,
                          isDark: isDark,
                          surahNameStyle: surahNameStyle,
                          onSurahBannerPress: onSurahBannerPress,
                          basmalaStyle: basmalaStyle,
                          textColor: textColor,
                          bookmarks: bookmarks,
                          onAyahLongPress: onAyahLongPress,
                          bookmarkList: bookmarkList,
                          ayahIconColor: ayahIconColor,
                          showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                          bookmarksAyahs: bookmarksAyahs,
                          bookmarksColor: bookmarksColor,
                          ayahSelectedBackgroundColor:
                              ayahSelectedBackgroundColor,
                          isFontsLocal: isFontsLocal,
                          fontsName: fontsName,
                          ayahBookmarked: ayahBookmarked,
                          context: context,
                          quranCtrl: quranCtrl,
                        )
                  : PageBuild(
                      pageIndex: pageIndex,
                      surahNumber: surahNumber,
                      bannerStyle: bannerStyle,
                      isDark: isDark,
                      surahNameStyle: surahNameStyle,
                      onSurahBannerPress: onSurahBannerPress,
                      basmalaStyle: basmalaStyle,
                      textColor: textColor,
                      bookmarks: bookmarks,
                      onAyahLongPress: onAyahLongPress,
                      bookmarkList: bookmarkList,
                      ayahIconColor: ayahIconColor,
                      showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                      bookmarksAyahs: bookmarksAyahs,
                      bookmarksColor: bookmarksColor,
                      ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                      isFontsLocal: isFontsLocal,
                      fontsName: fontsName,
                      ayahBookmarked: ayahBookmarked,
                      context: context,
                      quranCtrl: quranCtrl,
                    ),
        );
      },
    );
  }
}
