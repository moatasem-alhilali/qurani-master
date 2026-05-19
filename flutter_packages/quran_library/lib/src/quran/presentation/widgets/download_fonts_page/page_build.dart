part of '/quran.dart';

class PageBuild extends StatelessWidget {
  const PageBuild({
    super.key,
    required this.pageIndex,
    required this.surahNumber,
    this.surahFilterNumber,
    required this.bannerStyle,
    required this.isDark,
    required this.surahNameStyle,
    required this.onSurahBannerPress,
    required this.basmalaStyle,
    required this.textColor,
    required this.bookmarks,
    required this.onAyahLongPress,
    required this.bookmarkList,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.bookmarksAyahs,
    required this.bookmarksColor,
    this.customBookmarksColor,
    required this.ayahSelectedBackgroundColor,
    required this.isFontsLocal,
    required this.fontsName,
    required this.ayahBookmarked,
    this.isAyahBookmarked,
    required this.context,
    required this.quranCtrl,
    this.onPagePress,
  });

  final int pageIndex;
  final int? surahNumber;
  final int? surahFilterNumber;
  final BannerStyle? bannerStyle;
  final bool isDark;
  final SurahNameStyle? surahNameStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final BasmalaStyle? basmalaStyle;
  final Color? textColor;
  final Map<int, List<BookmarkModel>> bookmarks;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final List? bookmarkList;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final List<int> bookmarksAyahs;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final bool? isFontsLocal;
  final String? fontsName;
  final List<int> ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final BuildContext context;
  final QuranCtrl quranCtrl;
  final VoidCallback? onPagePress;

  @override
  Widget build(BuildContext context) {
    if (!quranCtrl.isQpcLayoutEnabled) {
      return const SizedBox.shrink();
    }

    // التحميل الكسول: تأكد أن خط هذه الصفحة جاهز
    final int pageNumber = pageIndex + 1;
    if (!QuranFontsService.isPageReady(pageNumber)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuranFontsService.ensurePagesLoaded(pageNumber, radius: 10).then((_) {
          quranCtrl.update();
          quranCtrl.update(['_pageViewBuild']);
        });
      });
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final blocks = quranCtrl.getQpcLayoutBlocksForPageSync(pageNumber);
    if (blocks.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: blocks.map((b) {
            // عند عرض سورة واحدة: نتجاهل الهيدر/البسملة من الـ layout ونتركها للـ SurahPage.
            if (surahFilterNumber != null &&
                (b is QpcV4SurahHeaderBlock || b is QpcV4BasmallahBlock)) {
              return const SizedBox.shrink();
            }

            if (b is QpcV4SurahHeaderBlock) {
              return SurahHeaderWidget(
                b.surahNumber,
                bannerStyle: bannerStyle ??
                    BannerStyle.downloadFonts(isDark: isDark, context: context),
                surahNameStyle: surahNameStyle ??
                    SurahNameStyle.downloadFonts(
                        isDark: isDark, context: context),
                onSurahBannerPress: onSurahBannerPress,
                isDark: isDark,
              );
            }

            if (b is QpcV4BasmallahBlock) {
              return BasmallahWidget(
                surahNumber: b.surahNumber,
                basmalaStyle: basmalaStyle ??
                    BasmalaStyle.downloadFonts(
                        isDark: isDark, context: context),
              );
            }

            if (b is QpcV4AyahLineBlock) {
              final filteredSegments = (surahFilterNumber == null)
                  ? b.segments
                  : b.segments
                      .where((s) => s.surahNumber == surahFilterNumber)
                      .toList(growable: false);

              if (filteredSegments.isEmpty) {
                return const SizedBox.shrink();
              }

              return RepaintBoundary(
                child: QpcV4RichTextLine(
                  pageIndex: pageIndex,
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
                  context: context,
                  quranCtrl: quranCtrl,
                  segments: filteredSegments,
                  isFontsLocal: isFontsLocal ?? false,
                  fontsName: fontsName ?? '',
                  fontFamilyOverride: null,
                  fontPackageOverride: null,
                  usePaintColoring: true,
                  ayahBookmarked: ayahBookmarked,
                  isAyahBookmarked: isAyahBookmarked,
                  isCentered: b.isCentered,
                  onPagePress: onPagePress,
                ),
              );
            }

            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }
}
