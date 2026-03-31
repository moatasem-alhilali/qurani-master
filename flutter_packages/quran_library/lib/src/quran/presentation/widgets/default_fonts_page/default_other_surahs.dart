part of '/quran.dart';

class DefaultOtherSurahs extends StatelessWidget {
  const DefaultOtherSurahs({
    super.key,
    required this.pageIndex,
    required this.languageCode,
    required this.quranCtrl,
    required this.newSurahs,
    required this.surahNumber,
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

  final int pageIndex;
  final String? languageCode;
  final QuranCtrl quranCtrl;
  final List<String> newSurahs;
  final int? surahNumber;
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return LayoutBuilder(
      builder: (context, constraints) {
        return TopAndBottomWidget(
          pageIndex: pageIndex,
          isRight: pageIndex.isEven ? true : false,
          languageCode: languageCode,
          child: isLandscape &&
                  (Responsive.isMobile(context) ||
                      Responsive.isMobileLarge(context))
              ? SingleChildScrollView(
                  child: DefaultFontsPageBuild(
                    quranCtrl: quranCtrl,
                    pageIndex: pageIndex,
                    newSurahs: newSurahs,
                    surahNumber: surahNumber,
                    bannerStyle: bannerStyle,
                    isDark: isDark,
                    surahNameStyle: surahNameStyle,
                    onSurahBannerPress: onSurahBannerPress,
                    basmalaStyle: basmalaStyle,
                    deviceSize: deviceSize,
                    onAyahLongPress: onAyahLongPress,
                    bookmarksColor: bookmarksColor,
                    textColor: textColor,
                    bookmarkList: bookmarkList,
                    ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                    ayahBookmarked: ayahBookmarked,
                    context: context,
                    constraints: constraints,
                    ayahIconColor: ayahIconColor,
                    showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                  ),
                )
              : DefaultFontsPageBuild(
                  quranCtrl: quranCtrl,
                  pageIndex: pageIndex,
                  newSurahs: newSurahs,
                  surahNumber: surahNumber,
                  bannerStyle: bannerStyle,
                  isDark: isDark,
                  surahNameStyle: surahNameStyle,
                  onSurahBannerPress: onSurahBannerPress,
                  basmalaStyle: basmalaStyle,
                  deviceSize: deviceSize,
                  onAyahLongPress: onAyahLongPress,
                  bookmarksColor: bookmarksColor,
                  textColor: textColor,
                  bookmarkList: bookmarkList,
                  ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                  ayahBookmarked: ayahBookmarked,
                  context: context,
                  constraints: constraints,
                  ayahIconColor: ayahIconColor,
                  showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                ),
        );
      },
    );
  }
}
