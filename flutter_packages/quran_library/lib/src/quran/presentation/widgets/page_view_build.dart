part of '/quran.dart';

/// ويدجت مساعدة للحفاظ على الصفحة حيّة ضمن PageView
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});
  final Widget child;
  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class PageViewBuild extends StatelessWidget {
  const PageViewBuild({
    super.key,
    required this.circularProgressWidget,
    required this.languageCode,
    required this.bookmarkList,
    required this.ayahSelectedFontColor,
    required this.textColor,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.onAyahLongPress,
    required this.bookmarksColor,
    required this.surahNameStyle,
    required this.bannerStyle,
    required this.basmalaStyle,
    required this.onSurahBannerPress,
    required this.surahNumber,
    required this.ayahSelectedBackgroundColor,
    required this.onPagePress,
    required this.isDark,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.userContext,
    required this.pageIndex,
    required this.quranCtrl,
    required this.isFontsLocal,
  });

  final Widget? circularProgressWidget;
  final String? languageCode;
  final List bookmarkList;
  final Color? ayahSelectedFontColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? bookmarksColor;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final BasmalaStyle? basmalaStyle;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final int? surahNumber;
  final Color? ayahSelectedBackgroundColor;
  final VoidCallback? onPagePress;
  final bool isDark;
  final String? fontsName;
  final List<int>? ayahBookmarked;
  final BuildContext userContext;
  final int pageIndex;
  final QuranCtrl quranCtrl;
  final bool isFontsLocal;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(userContext)
        .size; // استخدام سياق المستخدم / Using user context
    // تحضير مجموعات وبيانات ثابتة لتقليل الحسابات داخل البناء الداخلي
    final bookmarksCtrl = BookmarksCtrl.instance;
    final Map<int, List<BookmarkModel>> bookmarksMap = bookmarksCtrl.bookmarks;
    final Set<int> bookmarksAyahSet = bookmarksCtrl.bookmarksAyahs.toSet();
    List<String> newSurahs = [];
    // final bookmarkCtrl = BookmarksCtrl.instance;
    return GetBuilder<QuranCtrl>(
      id: '_pageViewBuild',
      init: QuranCtrl.instance,
      builder: (quranCtrl) => quranCtrl.textScale(
        (((quranCtrl.isDownloadFonts &&
                    quranCtrl.state.loadedFontPages.contains(pageIndex)) ||
                isFontsLocal)
            ? quranCtrl.state.allAyahs.isEmpty ||
                    quranCtrl.state.surahs.isEmpty ||
                    quranCtrl.state.pages.isEmpty
                ? Center(
                    child: circularProgressWidget ??
                        const CircularProgressIndicator())
                : Align(
                    alignment: Alignment.topCenter,
                    child: TopAndBottomWidget(
                      pageIndex: pageIndex,
                      languageCode: languageCode,
                      isRight: pageIndex.isEven ? true : false,
                      child: _QuranFontsPage(
                        context: userContext,
                        pageIndex: pageIndex,
                        bookmarkList: bookmarkList,
                        textColor: ayahSelectedFontColor ?? textColor,
                        ayahIconColor: ayahIconColor,
                        showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                        bookmarks: bookmarksMap,
                        onAyahLongPress: onAyahLongPress,
                        bookmarksColor: bookmarksColor,
                        surahNameStyle: surahNameStyle,
                        bannerStyle: bannerStyle,
                        basmalaStyle: basmalaStyle,
                        onSurahBannerPress: onSurahBannerPress,
                        surahNumber: surahNumber,
                        bookmarksAyahs: bookmarksAyahSet.toList(),
                        ayahSelectedBackgroundColor:
                            ayahSelectedBackgroundColor,
                        isDark: isDark,
                        circularProgressWidget: circularProgressWidget,
                        isFontsLocal: isFontsLocal,
                        fontsName: fontsName,
                        ayahBookmarked: ayahBookmarked!,
                      ),
                    ))
            : quranCtrl.staticPages.isEmpty || quranCtrl.isLoading.value
                ? Center(
                    child: circularProgressWidget ??
                        const CircularProgressIndicator())
                : _DefaultFontsPage(
                    context: userContext,
                    pageIndex: pageIndex,
                    bookmarkList: bookmarkList,
                    textColor: textColor,
                    languageCode: languageCode,
                    onAyahLongPress: onAyahLongPress,
                    bookmarksColor: bookmarksColor,
                    surahNameStyle: surahNameStyle,
                    bannerStyle: bannerStyle,
                    basmalaStyle: basmalaStyle,
                    onSurahBannerPress: onSurahBannerPress,
                    surahNumber: surahNumber,
                    newSurahs: newSurahs,
                    ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                    deviceSize: deviceSize,
                    isDark: isDark,
                    ayahBookmarked: ayahBookmarked!,
                    ayahIconColor:
                        ayahIconColor ?? Theme.of(context).colorScheme.primary,
                    showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                  )),
        quranCtrl.staticPages.isEmpty || quranCtrl.isLoading.value
            ? Center(
                child:
                    circularProgressWidget ?? const CircularProgressIndicator())
            : TopAndBottomWidget(
                pageIndex: pageIndex,
                languageCode: languageCode,
                isRight: pageIndex.isEven ? true : false,
                child: _QuranTextScale(
                  context: userContext,
                  pageIndex: pageIndex,
                  bookmarkList: bookmarkList,
                  textColor: ayahSelectedFontColor ?? textColor,
                  ayahIconColor: ayahIconColor,
                  showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                  bookmarks: bookmarksMap,
                  onAyahLongPress: onAyahLongPress,
                  bookmarksColor: bookmarksColor,
                  surahNameStyle: surahNameStyle,
                  bannerStyle: bannerStyle,
                  basmalaStyle: basmalaStyle,
                  onSurahBannerPress: onSurahBannerPress,
                  surahNumber: surahNumber,
                  bookmarksAyahs: bookmarksAyahSet.toList(),
                  ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                  onPagePress: onPagePress,
                  languageCode: languageCode,
                  isDark: isDark,
                  circularProgressWidget: circularProgressWidget,
                  ayahBookmarked: ayahBookmarked!,
                ),
              ),
      ),
    );
  }
}
