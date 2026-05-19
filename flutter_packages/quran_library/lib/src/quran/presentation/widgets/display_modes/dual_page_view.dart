part of '/quran.dart';

/// وضع عرض صفحتين كاملتين جنبًا إلى جنب (شاشات كبيرة + أفقي)
///
/// يعرض صفحتين من المصحف جنبًا إلى جنب بدون تمرير عمودي.
/// يُقيّد بالشاشات الكبيرة (تابلت/ديسكتوب) في الوضع الأفقي.
///
/// [DualPageView] Displays two Quran pages side-by-side without vertical
/// scrolling. Restricted to large screens in landscape orientation.
class DualPageView extends StatelessWidget {
  const DualPageView({
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Focus(
        focusNode: quranCtrl.state.quranPageRLFocusNode,
        autofocus: kIsWeb ? false : true,
        onKeyEvent: (node, event) => quranCtrl.controlRLByKeyboard(node, event),
        child: PatchedPreloadPageView.builder(
          preloadPagesCount: 2,
          padEnds: false,
          itemCount: 604,
          controller: _getDualPageController(context),
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
              key: ValueKey('dual_page_$index'),
              child: _KeepAlive(
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: SizedBox(
                    // عرض وارتفاع افتراضيان يُعاد تحجيمهما بواسطة FittedBox
                    width: 375,
                    height: 752,
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
                      pageIndex: index,
                      quranCtrl: quranCtrl,
                      isFontsLocal: isFontsLocal!,
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

  /// إنشاء PageController بـ viewportFraction = 0.5 لعرض صفحتين
  PreloadPageController _getDualPageController(BuildContext context) {
    var currentIndex =
        (quranCtrl.state.currentPageNumber.value - 1).clamp(0, 603);
    // محاذاة الفهرس إلى رقم زوجي لعرض الزوج الصحيح من صفحات المصحف
    currentIndex = currentIndex - (currentIndex % 2);

    // تحقق مما إذا كان الـ controller الحالي يستخدم viewportFraction 0.5
    if (quranCtrl.quranPagesController.hasClients &&
        quranCtrl.quranPagesController.viewportFraction == 0.5) {
      return quranCtrl.quranPagesController;
    }

    // إنشاء controller جديد بنسبة 0.5
    quranCtrl.quranPagesController = PreloadPageController(
      initialPage: currentIndex,
      keepPage: true,
      viewportFraction: 0.5,
    );
    return quranCtrl.quranPagesController;
  }
}
