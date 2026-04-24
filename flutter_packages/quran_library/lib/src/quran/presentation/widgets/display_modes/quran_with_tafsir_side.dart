part of '/quran.dart';

/// وضع عرض المصحف مع التفسير الجانبي (أفقي فقط)
///
/// يعرض صفحة المصحف على الجانب الأيمن (RTL) والتفسير على الجانب الأيسر.
/// يدعم تغيير مصدر التفسير وحجم الخط.
///
/// [QuranWithTafsirSide] Displays the Quran page on one side and tafsir
/// on the other side. Supports switching tafsir source and font size.
class QuranWithTafsirSide extends StatelessWidget {
  const QuranWithTafsirSide({
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
    this.style,
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
  final QuranTafsirSideStyle? style;

  @override
  Widget build(BuildContext context) {
    final s = style ??
        (QuranTafsirSideTheme.of(context)?.style ??
            QuranTafsirSideStyle.defaults(isDark: isDark, context: context));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          // قسم المصحف
          Expanded(
            flex: ((s.quranWidthFraction ?? 0.5) * 10).round(),
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
                  key: ValueKey('tafsir_side_quran_$index'),
                  child: _KeepAlive(
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
          // الفاصل العمودي
          Container(
            width: s.verticalDividerWidth ?? 1.0,
            color: s.verticalDividerColor ??
                (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          ),
          // قسم التفسير
          Expanded(
            flex: (((1 - (s.quranWidthFraction ?? 0.5)) * 10).round()),
            child: _TafsirSidePanel(
              isDark: isDark,
              style: s,
              languageCode: languageCode,
            ),
          ),
        ],
      ),
    );
  }
}

/// لوحة التفسير الجانبية
class _TafsirSidePanel extends StatelessWidget {
  const _TafsirSidePanel({
    required this.isDark,
    required this.style,
    required this.languageCode,
  });

  final bool isDark;
  final QuranTafsirSideStyle style;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final quranCtrl = QuranCtrl.instance;

    return Container(
      color: style.tafsirPanelBackgroundColor ??
          (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
      child: AyahWithTafsirInline(
        quranCtrl: quranCtrl,
        isDark: isDark,
        languageCode: languageCode,
        onPageChanged: (_) {},
        onPagePress: () {},
        parentContext: context,
        ayahBookmarked: const [],
        usePageView: false,
        withOptionsBar: false,
        showAyahNumber: true,
      ),
    );
  }
}
