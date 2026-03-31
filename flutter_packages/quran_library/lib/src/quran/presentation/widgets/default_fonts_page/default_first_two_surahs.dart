part of '/quran.dart';

class DefaultFirstTwoSurahs extends StatelessWidget {
  const DefaultFirstTwoSurahs({
    super.key,
    required this.surahNumber,
    required this.quranCtrl,
    required this.pageIndex,
    required this.bannerStyle,
    required this.isDark,
    required this.surahNameStyle,
    required this.onSurahBannerPress,
    required this.basmalaStyle,
    required this.deviceSize,
    required this.onAyahLongPress,
    required this.bookmarksColor,
    required this.textColor,
    required this.bookmarkList,
    required this.ayahSelectedBackgroundColor,
    required this.ayahBookmarked,
    required this.context,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
  });

  final int? surahNumber;
  final QuranCtrl quranCtrl;
  final int pageIndex;
  final BannerStyle? bannerStyle;
  final bool isDark;
  final SurahNameStyle? surahNameStyle;
  final Function(SurahNamesModel surah)? onSurahBannerPress;
  final BasmalaStyle? basmalaStyle;
  final Size deviceSize;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? bookmarksColor;
  final Color? textColor;
  final List? bookmarkList;
  final Color? ayahSelectedBackgroundColor;
  final List<int> ayahBookmarked;
  final BuildContext context;
  final Color ayahIconColor;
  final bool showAyahBookmarkedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(
        vertical: UiHelper.currentOrientation(
            MediaQuery.sizeOf(context).width * .01,
            MediaQuery.sizeOf(context).height * .01,
            context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SurahHeaderWidget(
            surahNumber ??
                quranCtrl.staticPages[pageIndex].ayahs[0].surahNumber!,
            bannerStyle: bannerStyle ?? BannerStyle.defaults(isDark: isDark),
            surahNameStyle: surahNameStyle ??
                SurahNameStyle(
                  surahNameSize: 27,
                  surahNameColor: AppColors.getTextColor(isDark),
                ),
            onSurahBannerPress: onSurahBannerPress,
            isDark: isDark,
          ),
          if (pageIndex == 1)
            BasmallahWidget(
              surahNumber:
                  quranCtrl.staticPages[pageIndex].ayahs[0].surahNumber!,
              basmalaStyle: basmalaStyle ??
                  BasmalaStyle(
                    basmalaColor: AppColors.getTextColor(isDark),
                    basmalaFontSize: 25.0,
                    verticalPadding: 0.0,
                  ),
            ),
          ...quranCtrl.staticPages[pageIndex].lines.map((line) {
            return RepaintBoundary(
              child: GetBuilder<BookmarksCtrl>(
                id: 'bookmarks',
                builder: (bookmarkCtrl) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:
                            // Responsive.isDesktop(context)
                            //     ? deviceSize.width - 800
                            //     :
                            deviceSize.width,
                        // width: deviceSize.width - 32,
                        child: DefaultFontsBuild(
                          context,
                          line,
                          isDark: isDark,
                          bookmarkCtrl.bookmarksAyahs,
                          bookmarkCtrl.bookmarks,
                          boxFit: BoxFit.scaleDown,
                          onDefaultAyahLongPress: onAyahLongPress,
                          bookmarksColor: bookmarksColor,
                          textColor:
                              textColor ?? (AppColors.getTextColor(isDark)),
                          bookmarkList: bookmarkList,
                          pageIndex: pageIndex,
                          ayahSelectedBackgroundColor:
                              ayahSelectedBackgroundColor,
                          ayahBookmarked: ayahBookmarked,
                          ayahIconColor: ayahIconColor,
                          showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
