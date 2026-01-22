part of '../../quran.dart';

class GetSingleAyah extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final Color? textColor;
  final bool? isDark;
  final bool? isBold;
  final double? fontSize;
  final AyahModel? ayahs;
  final bool? isSingleAyah;
  final bool? islocalFont;
  final String? fontsName;
  final int? pageIndex;
  final bool? useDefaultFont;

  const GetSingleAyah({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.textColor,
    this.isDark = false,
    this.fontSize,
    this.isBold = true,
    this.ayahs,
    this.isSingleAyah = true,
    this.islocalFont = false,
    this.fontsName,
    this.pageIndex,
    this.useDefaultFont = false,
  });

  @override
  Widget build(BuildContext context) {
    if (surahNumber < 1 || surahNumber > 114) {
      return Text(
        'رقم السورة غير صحيح',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
      );
    }
    final ayah = ayahs ??
        QuranCtrl.instance
            .getSingleAyahByAyahAndSurahNumber(ayahNumber, surahNumber);
    final pageNumber = pageIndex ??
        QuranCtrl.instance
            .getPageNumberByAyahAndSurahNumber(ayahNumber, surahNumber);
    log('surahNumber: $surahNumber, ayahNumber: $ayahNumber, pageNumber: $pageNumber');
    final bool currentFontsSelected =
        QuranCtrl.instance.currentRecitation.requiresDownload;
    if (ayah.text.isEmpty) {
      return Text(
        'الآية غير موجودة',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
      );
    }
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(
        style: TextStyle(
          fontFamily: islocalFont == true
              ? fontsName
              : useDefaultFont!
                  ? 'hafs'
                  : (currentFontsSelected
                      ? QuranCtrl.instance.getFontPath(pageNumber - 1)
                      : 'hafs'),
          package: useDefaultFont!
              ? 'quran_library'
              : currentFontsSelected
                  ? null
                  : 'quran_library',
          fontSize: fontSize ?? 22,
          height: 2.0,
          // letterSpacing: currentFontsSelected ? 3 : null,
          fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        children: [
          TextSpan(
            text: useDefaultFont!
                ? '${ayah.text} '
                : currentFontsSelected || !useDefaultFont!
                    ? '${ayah.text.replaceAll('\n', '').split(' ').join(' ')} '
                    : '${ayah.text} ',
          ),
          useDefaultFont!
              ? TextSpan(
                  text: '${ayah.ayahNumber}'
                      .convertEnglishNumbersToArabic('${ayah.ayahNumber}'),
                )
              : currentFontsSelected
                  ? const TextSpan()
                  : TextSpan(
                      text: '${ayah.ayahNumber}'
                          .convertEnglishNumbersToArabic('${ayah.ayahNumber}'),
                    ),
        ],
      ),
    );
  }
}
