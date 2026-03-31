part of '../../audio.dart';

/// قائمة السور الصوتية مع دعم تمرير الألوان والأنماط
/// Audio Surah list with color and style passing support
class SurahAudioList extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool isDark;
  final String? languageCode;

  SurahAudioList(
      {super.key, this.style, required this.isDark, this.languageCode});

  final QuranCtrl quranCtrl = QuranCtrl.instance;
  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return ScaleKitBuilder(
      designWidth: 375,
      designHeight: 812,
      designType: DeviceType.mobile,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          // شرح: تدرج لوني جميل للخلفية
          // Explanation: Beautiful gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (style?.backgroundColor ?? AppColors.getBackgroundColor(isDark))
                  .withValues(alpha: 0.05),
              (style?.backgroundColor ?? AppColors.getBackgroundColor(isDark))
                  .withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(style?.borderRadius ?? 16.0),
          ),
          border: Border.all(
            width: 1.5,
            color:
                (style?.backgroundColor ?? AppColors.getBackgroundColor(isDark))
                    .withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: (style?.backgroundColor ??
                      AppColors.getBackgroundColor(isDark))
                  .withValues(alpha: 0.1),
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          controller: surahAudioCtrl.state.surahListController,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: quranCtrl.state.surahs.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, index) {
            final surah = quranCtrl.state.surahs[index];
            int surahNumber = index + 1;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: BuildEnhancedSurahItem(
                  surahAudioCtrl: surahAudioCtrl,
                  style: style,
                  languageCode: languageCode,
                  context: context,
                  surah: surah,
                  index: index,
                  surahNumber: surahNumber,
                  isDark: isDark),
            );
          },
        ),
      ),
    );
  }
}

class BuildEnhancedSurahItem extends StatelessWidget {
  const BuildEnhancedSurahItem({
    super.key,
    required this.surahAudioCtrl,
    required this.style,
    required this.languageCode,
    required this.context,
    required this.surah,
    required this.index,
    required this.surahNumber,
    required this.isDark,
  });

  final AudioCtrl surahAudioCtrl;
  final SurahAudioStyle? style;
  final String? languageCode;
  final BuildContext context;
  final SurahModel surah;
  final int index;
  final int surahNumber;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // اختيار السورة وضبط المصدر بأمان (من دون تشغيل تلقائي)
        await surahAudioCtrl.selectSurahFromList(context, index,
            autoPlay: false);
      },
      child: Obx(
        () {
          final isSelected =
              surahAudioCtrl.state.selectedSurahIndex.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              // شرح: تدرج متحرك للعنصر المحدد
              // Explanation: Animated gradient for selected item
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.15),
                        (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.08),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: !isSelected
                  ? (isDark
                      ? Colors.grey[800]?.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.6))
                  : null,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isSelected
                    ? (style?.primaryColor ??
                            Theme.of(context).colorScheme.primary)
                        .withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.2),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // شرح: رقم السورة مع تصميم دائري محسن
                // Explanation: Surah number with enhanced circular design
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: isSelected ? 0.8 : 0.6),
                        (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: isSelected ? 0.6 : 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: (style?.primaryColor ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      surahNumber.toString().convertNumbersAccordingToLang(
                          languageCode: languageCode ?? 'ar'),
                      style: QuranLibrary().cairoStyle.copyWith(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                const SizedBox(width: 16.0),

                // شرح: معلومات السورة محسنة
                // Explanation: Enhanced surah information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' surah${(index + 1).toString().padLeft(3, '0')} ',
                        style: TextStyle(
                          color: (style?.textColor ??
                              AppColors.getTextColor(isDark)),
                          fontFamily: "surah-name-v4",
                          fontSize: 32.sp.clamp(32, 40),
                          package: "quran_library",
                        ),
                      ),
                      // Text(
                      //   surah.surahNumber.toString(),
                      //   style: TextStyle(
                      //     color: (style?.textColor ??
                      //         AppColors.getTextColor(isDark)),
                      //     fontFamily: 'surahName',
                      //     fontSize: 32.sp.clamp(32, 40),
                      //     package: 'quran_library',
                      //   ),
                      // ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text(
                            surah.englishName,
                            style: QuranLibrary().cairoStyle.copyWith(
                                  fontSize: 12.0.sp.clamp(12, 20),
                                  height: 1.3,
                                  color: (style?.textColor ??
                                          AppColors.getTextColor(isDark))
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              color: (style?.primaryColor ??
                                      Theme.of(context).colorScheme.primary)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              '${surah.ayahs.length} ${surahAudioCtrl.getAyahOrAyat(surah.ayahs.length, style: style)}'
                                  .convertNumbersAccordingToLang(
                                      languageCode: languageCode ?? 'ar'),
                              style: QuranLibrary().cairoStyle.copyWith(
                                    fontSize: 10.0.sp.clamp(10, 14),
                                    color: style?.primaryColor ??
                                        AppColors.getTextColor(isDark),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "kufi",
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // شرح: أيقونة التشغيل المحسنة
                // Explanation: Enhanced play icon
                kIsWeb
                    ? const SizedBox.shrink()
                    : SurahDownloadPlayButton(
                        style: style, surahNumber: index + 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
