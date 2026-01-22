part of '/quran.dart';

class DefaultFontsPageBuild extends StatelessWidget {
  const DefaultFontsPageBuild({
    super.key,
    required this.quranCtrl,
    required this.pageIndex,
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
    required this.constraints,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
  });

  final QuranCtrl quranCtrl;
  final int pageIndex;
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
  final BoxConstraints constraints;
  final Color ayahIconColor;
  final bool showAyahBookmarkedIcon;

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = BookmarksCtrl.instance;

    // Set محلية لتتبع السور المعروضة في هذه الصفحة فقط
    final Set<String> displayedSurahsInThisPage = {};

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...quranCtrl.staticPages[pageIndex].lines.map(
              (line) {
                final surahNum = quranCtrl
                    .getSurahDataByAyahUQ(line.ayahs.first.ayahUQNumber)
                    .surahNumber;

                // تحديد ما إذا كانت هذه أول آية في سورة جديدة
                final bool isFirstAyahInSurah =
                    line.ayahs.first.ayahNumber == 1;
                final String? ayahSurahName = line.ayahs.first.arabicName;

                // الفحص: هل هذه أول مرة نرى هذه السورة في هذه الصفحة؟
                final bool isNewSurah = isFirstAyahInSurah &&
                    ayahSurahName != null &&
                    !displayedSurahsInThisPage.contains(ayahSurahName);

                // إضافة السورة للـ Set المحلية
                if (isNewSurah) {
                  displayedSurahsInThisPage.add(ayahSurahName);
                  // تحديث القائمة الخارجية أيضاً للحسابات الأخرى
                  if (!newSurahs.contains(ayahSurahName)) {
                    newSurahs.add(ayahSurahName);
                  }
                }

                return Obx(
                  () {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (isNewSurah)
                          SurahHeaderWidget(
                            surahNumber ?? line.ayahs.first.surahNumber!,
                            bannerStyle: bannerStyle ??
                                BannerStyle(
                                  isImage: false,
                                  bannerSvgPath:
                                      AssetsPath.assets.surahSvgBanner,
                                  bannerSvgHeight: Responsive.isDesktop(context)
                                      ? 50.0.h.clamp(70, 150)
                                      : 35.0.h.clamp(35, 90),
                                  bannerSvgWidth: 150.0.w.clamp(150, 250),
                                  bannerImagePath: '',
                                  bannerImageHeight: 50,
                                  bannerImageWidth: double.infinity,
                                ),
                            surahNameStyle: surahNameStyle ??
                                SurahNameStyle(
                                  surahNameSize: Responsive.isDesktop(context)
                                      ? 40.sp.clamp(40, 80)
                                      : 27.sp.clamp(27, 64),
                                  surahNameColor:
                                      AppColors.getTextColor(isDark),
                                ),
                            onSurahBannerPress: onSurahBannerPress,
                            isDark: isDark,
                          ),
                        if (isNewSurah && (line.ayahs[0].surahNumber != 9))
                          BasmallahWidget(
                            surahNumber: surahNum,
                            basmalaStyle: basmalaStyle ??
                                BasmalaStyle(
                                  basmalaColor: AppColors.getTextColor(isDark),
                                  basmalaFontSize: 22.0.sp.clamp(22, 50),
                                  verticalPadding: 0.0,
                                ),
                          ),
                        SizedBox(
                          width: Responsive.isDesktop(context)
                              ? deviceSize.width - 120.w
                              : deviceSize.width - 20,
                          height: (UiHelper.currentOrientation(
                                      constraints.maxHeight,
                                      MediaQuery.sizeOf(context).width * 1.6,
                                      context) -
                                  (quranCtrl.staticPages[pageIndex]
                                          .numberOfNewSurahs *
                                      (line.ayahs[0].surahNumber != 9
                                          ? 110
                                          : 80))) *
                              0.98 /
                              quranCtrl.staticPages[pageIndex].lines.length,
                          child: DefaultFontsBuild(
                            context,
                            line,
                            isDark: isDark,
                            bookmarkCtrl.bookmarksAyahs,
                            bookmarkCtrl.bookmarks,
                            boxFit: line.ayahs.last.centered!
                                ? BoxFit.contain
                                : BoxFit.fitWidth,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
