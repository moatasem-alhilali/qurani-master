part of '/quran.dart';

class SurahHeaderWidget extends StatelessWidget {
  SurahHeaderWidget(
    this.surahNumber, {
    super.key,
    this.bannerStyle,
    this.surahNameStyle,
    this.onSurahBannerPress,
    required this.isDark,
  });

  final int surahNumber;
  final BannerStyle? bannerStyle;
  final SurahNameStyle? surahNameStyle;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final bool isDark;

  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // حلّ النمط: استخدام النمط الممرّر إن وجد، وإلا القراءة من الـ Theme، ثم الافتراضي
    final SurahInfoStyle resolvedInfoStyle =
        (SurahInfoTheme.of(context)?.style ??
            SurahInfoStyle.defaults(isDark: isDark, context: context));
    final deviceWidth = MediaQuery.sizeOf(context);
    if (bannerStyle?.isImage ?? false) {
      return GestureDetector(
        onTap: () {
          if (onSurahBannerPress != null) {
            onSurahBannerPress!(quranCtrl.surahsList[surahNumber - 1]);
          } else {
            surahInfoBottomSheetWidget(context, surahNumber - 1,
                surahStyle: resolvedInfoStyle,
                deviceWidth: deviceWidth,
                isDark: isDark);
          }
        },
        child: Container(
          height: bannerStyle?.bannerImageHeight ?? 50.0,
          width: bannerStyle?.bannerImageWidth ?? double.infinity,
          margin: EdgeInsets.symmetric(
              vertical: quranCtrl.isQpcV4Enabled ? 0.0 : 8.0),
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(bannerStyle!.bannerImagePath!),
                fit: BoxFit.fill),
          ),
          alignment: Alignment.center,
          child: Text(
            surahNumber.toString(),
            style: TextStyle(
              color: surahNameStyle?.surahNameColor ?? Colors.black,
              fontFamily: "surahName",
              fontSize: surahNameStyle?.surahNameSize,
              package: "quran_library",
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: quranCtrl.isQpcV4Enabled ? 24.0 : 8.0,
          ),
          child: GestureDetector(
            onTap: () {
              if (onSurahBannerPress != null) {
                onSurahBannerPress!(quranCtrl.surahsList[surahNumber - 1]);
              } else {
                surahInfoBottomSheetWidget(context, surahNumber - 1,
                    surahStyle: resolvedInfoStyle,
                    deviceWidth: deviceWidth,
                    isDark: isDark);
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  bannerStyle?.bannerSvgPath ??
                      AssetsPath.assets.surahSvgBanner,
                  width: bannerStyle?.bannerSvgWidth ?? 250.0,
                  height: bannerStyle?.bannerSvgHeight ?? 160.0,
                  colorFilter: bannerStyle?.svgBannerColor != null
                      ? ColorFilter.mode(
                          bannerStyle!.svgBannerColor!,
                          BlendMode.modulate,
                        )
                      : ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.modulate,
                        ),
                ),
                // Text(
                //   ' surah${(surahNumber).toString().padLeft(3, '0')} surah-icon',
                //   style: TextStyle(
                //     color: surahNameStyle?.surahNameColor ??
                //         AppColors.getTextColor(isDark),
                //     letterSpacing: surahNumber == 113 ? 3 : 0,
                //     fontFamily: "surah-name-v4",
                //     fontSize: surahNameStyle?.surahNameSize ?? 120.0,
                //     package: "quran_library",
                //   ),
                // ),
                Text(
                  surahNumber.toString(),
                  style: TextStyle(
                    color: surahNameStyle?.surahNameColor ??
                        (AppColors.getTextColor(isDark)),
                    fontFamily: "surahName",
                    fontSize: surahNameStyle?.surahNameSize ?? 120.0,
                    height: 1.3,
                    package: "quran_library",
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
