part of '/quran.dart';

class _DefaultFontsPage extends StatelessWidget {
  final BuildContext context;
  final int pageIndex;
  final int? surahNumber;
  final BannerStyle? bannerStyle;
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
  final List<String> newSurahs;
  final String? languageCode;
  final bool isDark;
  final List<int> ayahBookmarked;
  final Color ayahIconColor;
  final bool showAyahBookmarkedIcon;

  _DefaultFontsPage({
    required this.context,
    required this.pageIndex,
    this.surahNumber,
    this.bannerStyle,
    this.surahNameStyle,
    this.onSurahBannerPress,
    this.basmalaStyle,
    required this.deviceSize,
    this.onAyahLongPress,
    this.bookmarksColor,
    this.textColor,
    this.bookmarkList,
    this.ayahSelectedBackgroundColor,
    required this.newSurahs,
    this.languageCode,
    required this.isDark,
    required this.ayahBookmarked,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
  });

  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(
          horizontal: UiHelper.currentOrientation(16.0, 64.0, context)),
      child: pageIndex == 0 || pageIndex == 1

          /// This is for first 2 pages of Quran: Al-Fatihah and Al-Baqarah
          ? TopAndBottomWidget(
              pageIndex: pageIndex,
              languageCode: languageCode,
              isRight: pageIndex.isEven ? true : false,
              child: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                  ? isLandscape
                      ? SingleChildScrollView(
                          child: DefaultFirstTwoSurahs(
                            surahNumber: surahNumber,
                            quranCtrl: quranCtrl,
                            pageIndex: pageIndex,
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
                            ayahSelectedBackgroundColor:
                                ayahSelectedBackgroundColor,
                            ayahBookmarked: ayahBookmarked,
                            context: context,
                            ayahIconColor: ayahIconColor,
                            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                          ),
                        )
                      : DefaultFirstTwoSurahs(
                          surahNumber: surahNumber,
                          quranCtrl: quranCtrl,
                          pageIndex: pageIndex,
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
                          ayahSelectedBackgroundColor:
                              ayahSelectedBackgroundColor,
                          ayahBookmarked: ayahBookmarked,
                          context: context,
                          ayahIconColor: ayahIconColor,
                          showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                        )
                  : DefaultFirstTwoSurahs(
                      surahNumber: surahNumber,
                      quranCtrl: quranCtrl,
                      pageIndex: pageIndex,
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
                      ayahIconColor: ayahIconColor,
                      showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                    ),
            )
          : DefaultOtherSurahs(
              pageIndex: pageIndex,
              languageCode: languageCode,
              quranCtrl: quranCtrl,
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
              ayahIconColor: ayahIconColor,
              showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            ),
    );
  }
}
