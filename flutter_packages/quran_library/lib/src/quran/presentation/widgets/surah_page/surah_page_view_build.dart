part of '/quran.dart';

/// ويدجت لعرض صفحة واحدة ضمن شاشة "سورة واحدة" فقط.
///
/// الهدف: عرض آيات السورة المحددة فقط حتى لو كانت صفحة المصحف تحتوي على أكثر من سورة.
class SurahPageViewBuild extends StatelessWidget {
  const SurahPageViewBuild({
    super.key,
    required this.userContext,
    required this.surahPage,
    required this.surahPageIndex,
    required this.globalPageIndex,
    required this.surahNumber,
    required this.isDark,
    required this.languageCode,
    this.circularProgressWidget,
    this.bookmarkList,
    this.bookmarksColor,
    this.textColor,
    this.ayahSelectedFontColor,
    this.ayahSelectedBackgroundColor,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = true,
    this.ayahBookmarked = const [],
    this.onAyahLongPress,
    this.onSurahBannerPress,
    this.bannerStyle,
    this.surahNameStyle,
    this.basmalaStyle,
  });

  final BuildContext userContext;
  final QuranPageModel surahPage;

  /// Index داخل قائمة صفحات السورة (surahCtrl.surahPages)
  final int surahPageIndex;

  /// Index عالمي (0-based) لصفحة المصحف الحقيقي لاستخدامه في Top/Bottom
  final int globalPageIndex;

  final int surahNumber;
  final bool isDark;
  final String? languageCode;

  final Widget? circularProgressWidget;
  final List? bookmarkList;
  final Color? bookmarksColor;
  final Color? textColor;
  final Color? ayahSelectedFontColor;
  final Color? ayahSelectedBackgroundColor;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final List<int> ayahBookmarked;

  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;

  final BannerStyle? bannerStyle;
  final SurahNameStyle? surahNameStyle;
  final BasmalaStyle? basmalaStyle;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(userContext).size;
    // final bookmarksCtrl = BookmarksCtrl.instance;

    // عرض البنر/البسملة مرة واحدة فقط في أول صفحة للسورة داخل هذا العرض.
    final bool showHeader = surahPage.numberOfNewSurahs > 0;
    final bool showBasmala = showHeader && surahNumber != 1 && surahNumber != 9;

    return LayoutBuilder(
      builder: (context, constraints) {
        final lineHeight = SurahCtrl.instance.calculateDynamicLineHeight(
          availableHeight: constraints.maxHeight,
          pageIndex: surahPageIndex,
          hasHeader: showHeader,
          hasBasmala: showBasmala,
        );

        Widget pageBody = RepaintBoundary(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showHeader)
                  SurahHeaderWidget(
                    surahNumber,
                    bannerStyle: bannerStyle ??
                        BannerStyle(
                          isImage: false,
                          bannerSvgPath: AssetsPath.assets.surahSvgBanner,
                          bannerSvgHeight: Responsive.isDesktop(context)
                              ? 50.0.h.clamp(70, 150)
                              : 35.0.h.clamp(35, 90),
                          bannerSvgWidth: 150.0.w.clamp(150, 250),
                          bannerImagePath: '',
                          bannerImageHeight: 50,
                          bannerImageWidth: double.infinity,
                        ),
                    surahNameStyle: surahNameStyle ??
                        SurahNameStyle(
                          surahNameSize: Responsive.isDesktop(context)
                              ? 40.sp.clamp(40, 80)
                              : 27.sp.clamp(27, 64),
                          surahNameColor: AppColors.getTextColor(isDark),
                        ),
                    onSurahBannerPress: onSurahBannerPress,
                    isDark: isDark,
                  ),
                if (showBasmala)
                  BasmallahWidget(
                    surahNumber: surahNumber,
                    basmalaStyle: basmalaStyle ??
                        BasmalaStyle(
                          basmalaColor: AppColors.getTextColor(isDark),
                          basmalaFontSize: 22.0.sp.clamp(22, 50),
                          verticalPadding: 0.0,
                        ),
                  ),
                ...surahPage.lines.map(
                  (line) => SizedBox(
                    width: Responsive.isDesktop(context)
                        ? deviceSize.width - 120.w
                        : deviceSize.width - 20,
                    height: lineHeight,
                    child: GetBuilder<BookmarksCtrl>(
                        id: 'bookmarks',
                        builder: (bookmarksCtrl) => DefaultFontsBuild(
                              context,
                              line,
                              bookmarksCtrl.bookmarksAyahs,
                              bookmarksCtrl.bookmarks,
                              isDark: isDark,
                              boxFit: line.ayahs.last.centered!
                                  ? BoxFit.contain
                                  : surahNumber == 1 ||
                                          (surahNumber == 2 &&
                                              globalPageIndex == 1)
                                      ? BoxFit.scaleDown
                                      : BoxFit.fitWidth,
                              onDefaultAyahLongPress: onAyahLongPress,
                              bookmarksColor: bookmarksColor,
                              textColor: ayahSelectedFontColor ??
                                  textColor ??
                                  AppColors.getTextColor(isDark),
                              bookmarkList: bookmarkList,
                              pageIndex: globalPageIndex,
                              ayahSelectedBackgroundColor:
                                  ayahSelectedBackgroundColor,
                              ayahBookmarked: ayahBookmarked,
                              ayahIconColor: ayahIconColor ??
                                  Theme.of(context).colorScheme.primary,
                              showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                              ayahSelectedFontColor:
                                  ayahSelectedBackgroundColor,
                            )),
                  ),
                ),
              ],
            ),
          ),
        );

        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        if (isLandscape &&
            (Responsive.isMobile(context) ||
                Responsive.isMobileLarge(context))) {
          pageBody = SingleChildScrollView(child: pageBody);
        }

        return TopAndBottomWidget(
          pageIndex: globalPageIndex,
          isRight: globalPageIndex.isEven,
          languageCode: languageCode,
          isSurah: true,
          surahNumber: surahNumber,
          child: pageBody,
        );
      },
    );
  }
}
