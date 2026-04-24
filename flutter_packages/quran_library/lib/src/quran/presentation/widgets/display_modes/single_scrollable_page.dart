part of '/quran.dart';

/// وضع عرض صفحة واحدة قابلة للتمرير عموديًا مع تقليب أفقي
///
/// يعرض صفحة واحدة بعرض الشاشة كاملة مع إمكانية التمرير للأسفل
/// لقراءة باقي الصفحة، والتقليب بين الصفحات يمين ويسار.
///
/// [SingleScrollablePage] Displays a single page that fills screen width
/// and scrolls vertically, with left/right swipe to change pages.
class SingleScrollablePage extends StatelessWidget {
  const SingleScrollablePage({
    super.key,
    required this.quranCtrl,
    required this.isDark,
    required this.languageCode,
    required this.onPageChanged,
    required this.onPagePress,
    required this.circularProgressWidget,
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
    required this.fontsName,
    required this.ayahBookmarked,
    required this.isAyahBookmarked,
    required this.parentContext,
    required this.isFontsLocal,
  });

  final QuranCtrl quranCtrl;
  final bool isDark;
  final String languageCode;
  final Function(int pageNumber)? onPageChanged;
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PatchedPreloadPageView.builder(
        preloadPagesCount: 2,
        padEnds: false,
        itemCount: 604,
        controller: quranCtrl.getPageController(context),
        physics: quranCtrl.state.isScaling.value
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        onPageChanged: (pageIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            if (onPageChanged != null) onPageChanged!(pageIndex);
            quranCtrl.state.currentPageNumber.value = pageIndex + 1;
            quranCtrl.saveLastPage(pageIndex + 1);
            if (quranCtrl.state.fontsSelected.value == 0) {
              quranCtrl.scheduleQpcV4AllPagesPrebuild();
            }
          });
        },
        pageSnapping: true,
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {
            if (onPagePress != null) {
              onPagePress!();
            } else {
              quranCtrl.showControlToggle();
              QuranCtrl.instance.state.isShowMenu.value = false;
            }
          },
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: RepaintBoundary(
            key: ValueKey('scrollable_page_$index'),
            child: _KeepAlive(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final viewportHeight = constraints.maxHeight > 0
                      ? constraints.maxHeight
                      : MediaQuery.of(context).size.height;
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: viewportHeight),
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
                        surahNameStyle: surahNameStyle,
                        bannerStyle: bannerStyle,
                        basmalaStyle: basmalaStyle,
                        onSurahBannerPress: onSurahBannerPress,
                        surahNumber: surahNumber,
                        ayahSelectedBackgroundColor:
                            ayahSelectedBackgroundColor,
                        onPagePress: onPagePress,
                        isDark: isDark,
                        fontsName: fontsName,
                        ayahBookmarked: ayahBookmarked,
                        isAyahBookmarked: isAyahBookmarked,
                        userContext: parentContext,
                        pageIndex: index,
                        quranCtrl: quranCtrl,
                        isFontsLocal: isFontsLocal!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
