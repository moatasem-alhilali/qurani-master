part of '/quran.dart';

class _QuranTextScale extends StatelessWidget {
  _QuranTextScale({
    required this.context,
    required this.pageIndex,
    this.bookmarkList,
    this.basmalaStyle,
    this.surahNumber,
    this.surahNameStyle,
    this.bannerStyle,
    this.onSurahBannerPress,
    this.onAyahLongPress,
    this.onPagePress,
    this.bookmarksColor,
    this.textColor,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = true,
    required this.bookmarks,
    required this.bookmarksAyahs,
    this.ayahSelectedBackgroundColor,
    this.languageCode,
    this.circularProgressWidget,
    required this.isDark,
    required this.ayahBookmarked,
  });

  final quranCtrl = QuranCtrl.instance;
  final BuildContext context;
  final int pageIndex;
  final List? bookmarkList;
  final BasmalaStyle? basmalaStyle;
  final int? surahNumber;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final List<int> ayahBookmarked;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final VoidCallback? onPagePress;
  final Color? bookmarksColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final Map<int, List<BookmarkModel>> bookmarks;
  final List<int> bookmarksAyahs;
  final Color? ayahSelectedBackgroundColor;
  final String? languageCode;
  final Widget? circularProgressWidget;
  final bool isDark;
  final bool showAyahBookmarkedIcon;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      builder: (quranCtrl) => GestureDetector(
        onTap: () {
          if (onPagePress != null) {
            onPagePress!();
          }

          quranCtrl.showControlToggle();
          quranCtrl.clearSelection();
          quranCtrl.state.isShowMenu.value = false;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: quranCtrl.state.pages.isEmpty
              ? circularProgressWidget ??
                  const CircularProgressIndicator.adaptive()
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                      PointerDeviceKind.unknown
                    },
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: () {
                        final separated = quranCtrl
                            .getCurrentPageAyahsSeparatedForBasmalah(pageIndex);
                        return List.generate(separated.length, (i) {
                          final ayahs = separated[i];
                          final surahNum = quranCtrl
                              .getSurahDataByAyah(ayahs.first)
                              .surahNumber;
                          return Column(
                            children: [
                              ayahs.first.ayahNumber == 1 &&
                                      (!quranCtrl._topOfThePageIndex
                                              .contains(pageIndex) ||
                                          quranCtrl.state.fontsSelected.value ==
                                              0)
                                  ? SurahHeaderWidget(
                                      surahNumber ?? surahNum,
                                      bannerStyle: bannerStyle ??
                                          BannerStyle.textScale(isDark: isDark),
                                      surahNameStyle: surahNameStyle ??
                                          SurahNameStyle(
                                            surahNameSize: 24.sp,
                                            surahNameColor: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                      onSurahBannerPress: onSurahBannerPress,
                                      isDark: isDark,
                                    )
                                  : const SizedBox.shrink(),
                              surahNum == 9 || surahNum == 1
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ayahs.first.ayahNumber == 1
                                          ? BasmallahWidget(
                                              surahNumber: surahNum,
                                              basmalaStyle: basmalaStyle ??
                                                  BasmalaStyle(
                                                    basmalaColor: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    basmalaFontSize: 50.0,
                                                  ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                              TextScaleRichTextBuild(
                                textColor: textColor,
                                isDark: isDark,
                                ayahs: ayahs,
                                bookmarks: bookmarks,
                                pageIndex: pageIndex,
                                ayahBookmarked: ayahBookmarked,
                                onAyahLongPress: onAyahLongPress,
                                bookmarkList: bookmarkList,
                                ayahIconColor: ayahIconColor,
                                showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                                bookmarksAyahs: bookmarksAyahs,
                                bookmarksColor: bookmarksColor,
                                ayahSelectedBackgroundColor:
                                    ayahSelectedBackgroundColor,
                                languageCode: languageCode,
                                // ayahLongClickStyle: ayahLongClickStyle,
                                // tafsirStyle: tafsirStyle,
                              ),

                              // context.surahBannerLastPlace(pageIndex, i),
                            ],
                          );
                        });
                      }(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
