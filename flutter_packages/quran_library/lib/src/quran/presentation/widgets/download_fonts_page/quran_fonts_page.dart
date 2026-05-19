part of '/quran.dart';

/// صفحة عرض القرآن بخطوط QPC V4 — تدعم الوضع العادي (FittedBox per-line)
/// ووضع التكبير (flowing text بتمرير عمودي).
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
  final Color? Function(AyahModel)? customBookmarksColor;
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
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final VoidCallback? onPagePress;

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
    this.customBookmarksColor,
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
    this.isAyahBookmarked,
    this.onPagePress,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GetBuilder<QuranCtrl>(
      id: 'qpc_page_$pageIndex',
      builder: (quranCtrl) {
        if (quranCtrl.isQpcV4Enabled && !quranCtrl.isQpcV4AllPagesPrebuilt) {
          quranCtrl.scheduleQpcV4AllPagesPrebuild();
        }

        if (quranCtrl.state.pages.isEmpty) {
          return circularProgressWidget ??
              const CircularProgressIndicator.adaptive();
        }

        final isScaled = quranCtrl.state.scaleFactor.value > 1.3;

        return Container(
          padding: pageIndex == 0 || pageIndex == 1
              ? EdgeInsets.symmetric(horizontal: size.width * .08)
              : const EdgeInsets.symmetric(horizontal: 8.0),
          margin: pageIndex == 0 || pageIndex == 1
              ? EdgeInsets.symmetric(
                  vertical: UiHelper.currentOrientation(
                      size.width * .16, size.height * .01, context))
              : EdgeInsets.zero,
          child: isScaled
              ? _buildFlowingLayout(quranCtrl)
              : _buildPageLayout(context, quranCtrl),
        );
      },
    );
  }

  /// الوضع العادي: PageBuild مع FittedBox per-line
  Widget _buildPageLayout(BuildContext context, QuranCtrl quranCtrl) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isMobile =
        Responsive.isMobile(context) || Responsive.isMobileLarge(context);

    final pageBuild = PageBuild(
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
                                  customBookmarksColor: customBookmarksColor,
      ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
      isFontsLocal: isFontsLocal,
      fontsName: fontsName,
      ayahBookmarked: ayahBookmarked,
      isAyahBookmarked: isAyahBookmarked,
      context: context,
      quranCtrl: quranCtrl,
      onPagePress: onPagePress,
    );

    final needsScroll = !kIsWeb &&
        (Platform.isAndroid || Platform.isIOS) &&
        isLandscape &&
        isMobile;

    return needsScroll ? SingleChildScrollView(child: pageBuild) : pageBuild;
  }

  /// وضع التكبير: عرض متدفق بخط QPC V4 مع تمرير عمودي
  Widget _buildFlowingLayout(QuranCtrl quranCtrl) {
    final int pageNumber = pageIndex + 1;
    if (!QuranFontsService.isPageReady(pageNumber)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuranFontsService.ensurePagesLoaded(pageNumber, radius: 10).then((_) {
          quranCtrl.update();
          quranCtrl.update(['_pageViewBuild']);
        });
      });
      return circularProgressWidget ??
          const Center(child: CircularProgressIndicator.adaptive());
    }

    final blocks = quranCtrl.getQpcFlowBlocksForPage(pageNumber);
    if (blocks.isEmpty) {
      return circularProgressWidget ??
          const Center(child: CircularProgressIndicator.adaptive());
    }

    // تجميع الآيات المتتالية في مجموعات — كل مجموعة تُعرض في RichText واحد
    final children = <Widget>[];
    var pendingSegments = <QpcV4WordSegment>[];

    void flushPending() {
      if (pendingSegments.isEmpty) return;
      children.add(
        QpcV4FlowingText(
          pageIndex: pageIndex,
          segments: List.of(pendingSegments),
          textColor: textColor,
          isDark: isDark,
          bookmarks: bookmarks,
          onAyahLongPress: onAyahLongPress,
          bookmarkList: bookmarkList,
          ayahIconColor: ayahIconColor,
          showAyahBookmarkedIcon: showAyahBookmarkedIcon,
          bookmarksAyahs: bookmarksAyahs,
          bookmarksColor: bookmarksColor,
                                  customBookmarksColor: customBookmarksColor,
          ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
          isFontsLocal: isFontsLocal ?? false,
          fontsName: fontsName ?? '',
          ayahBookmarked: ayahBookmarked,
          isAyahBookmarked: isAyahBookmarked,
          onPagePress: onPagePress,
        ),
      );
      pendingSegments = [];
    }

    for (final block in blocks) {
      if (block is QpcV4SurahHeaderBlock) {
        flushPending();
        children.add(
          SurahHeaderWidget(
            block.surahNumber,
            bannerStyle: bannerStyle ?? BannerStyle.textScale(isDark: isDark),
            surahNameStyle: surahNameStyle ??
                SurahNameStyle(
                  surahNameSize: 24.sp,
                  surahNameColor: isDark ? Colors.white : Colors.black,
                ),
            onSurahBannerPress: onSurahBannerPress,
            isDark: isDark,
          ),
        );
      } else if (block is QpcV4BasmallahBlock) {
        flushPending();
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: BasmallahWidget(
              surahNumber: block.surahNumber,
              basmalaStyle: basmalaStyle ??
                  BasmalaStyle(
                    basmalaColor: isDark ? Colors.white : Colors.black,
                    basmalaFontSize: 50.0,
                  ),
            ),
          ),
        );
      } else if (block is QpcV4AyahFlowBlock) {
        pendingSegments.addAll(block.segments);
      }
    }
    flushPending();

    return GestureDetector(
      onTap: () {
        // أثناء السكرول التلقائي: إيقاف/استئناف مع إظهار/إخفاء عناصر التحكم
        final autoScroll = AutoScrollCtrl.instance;
        if (autoScroll.state.isActive.value) {
          autoScroll.togglePause();
          return;
        }
        if (onPagePress != null) onPagePress!();
        quranCtrl.showControlToggle();
        quranCtrl.clearSelection();
        quranCtrl.state.isShowMenu.value = false;
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
