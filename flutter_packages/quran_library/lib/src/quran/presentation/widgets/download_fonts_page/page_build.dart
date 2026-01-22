part of '/quran.dart';

class PageBuild extends StatelessWidget {
  const PageBuild({
    super.key,
    required this.pageIndex,
    required this.surahNumber,
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
    required this.ayahSelectedBackgroundColor,
    required this.isFontsLocal,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.context,
    required this.quranCtrl,
  });

  final int pageIndex;
  final int? surahNumber;
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
  final Color? ayahSelectedBackgroundColor;
  final bool? isFontsLocal;
  final String? fontsName;
  final List<int> ayahBookmarked;
  final BuildContext context;
  final QuranCtrl quranCtrl;

  @override
  Widget build(BuildContext context) {
    if (!quranCtrl.isQpcV4Enabled) {
      // الخطوط المُحمّلة أصبحت تعتمد على QPC v4 فقط.
      // الخط الأساسي (0) سيتم التعامل معه في المرحلة القادمة.
      return const SizedBox.shrink();
    }

    final blocks = quranCtrl.getQpcV4BlocksForPageSync(pageIndex + 1);
    if (blocks.isEmpty) {
      // ابدأ التحضير الكامل مرة واحدة؛ أثناء ذلك نعرض مؤشر تحميل بدل بناء متزامن.
      Future(() => quranCtrl.ensureQpcV4AllPagesPrebuilt());
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: blocks.map((b) {
            if (b is QpcV4SurahHeaderBlock) {
              return SurahHeaderWidget(
                b.surahNumber,
                bannerStyle: bannerStyle ?? BannerStyle(),
                surahNameStyle: surahNameStyle ??
                    SurahNameStyle(
                      surahNameSize: 120,
                      surahNameColor: AppColors.getTextColor(isDark),
                    ),
                onSurahBannerPress: onSurahBannerPress,
                isDark: isDark,
              );
            }

            if (b is QpcV4BasmallahBlock) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: BasmallahWidget(
                  surahNumber: b.surahNumber,
                  basmalaStyle: basmalaStyle ??
                      BasmalaStyle(
                        basmalaColor: isDark ? Colors.white : Colors.black,
                        basmalaFontSize: 100.0,
                      ),
                ),
              );
            }

            if (b is QpcV4AyahLineBlock) {
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
                  ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                  context: context,
                  quranCtrl: quranCtrl,
                  segments: b.segments,
                  isFontsLocal: isFontsLocal!,
                  fontsName: fontsName!,
                  ayahBookmarked: ayahBookmarked,
                  isCentered: b.isCentered,
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
