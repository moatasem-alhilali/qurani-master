part of '/quran.dart';

TextSpan _qpcV4SpanSegment({
  required BuildContext context,
  required int pageIndex,
  required bool isSelected,
  required bool showAyahBookmarkedIcon,
  required double fontSize,
  required int ayahUQNum,
  required int ayahNumber,
  required WordRef wordRef,
  required bool isWordKhilaf,
  required String glyphs,
  required bool showAyahNumber,
  _LongPressStartDetailsFunction? onLongPressStart,
  required Color? textColor,
  required Color? ayahIconColor,
  required List<int> bookmarksAyahs,
  required List<int> ayahBookmarked,
  required List<BookmarkModel> allBookmarksList,
  Color? bookmarksColor,
  Color? ayahSelectedBackgroundColor,
  bool Function(AyahModel ayah)? isAyahBookmarked,
  required bool isFontsLocal,
  required String fontsName,
  String? fontFamilyOverride,
  String? fontPackageOverride,
  bool usePaintColoring = true,
  required bool isDark,
  VoidCallback? onPagePress,
}) {
  final quranCtrl = QuranCtrl.instance;
  final wordInfoCtrl = WordInfoCtrl.instance;
  final AyahModel ayahModel = quranCtrl.getAyahByUq(ayahUQNum);

  final withTajweed = QuranCtrl.instance.state.isTajweedEnabled.value;
  final isTenRecitations = WordInfoCtrl.instance.isTenRecitations;
  final bool forceRed = isWordKhilaf && !withTajweed && isTenRecitations;

  // اختيار الخط: كلمات الخلاف تستخدم خط CPAL أحمر بدلاً من foreground Paint
  final String fontFamily;
  if (fontFamilyOverride != null) {
    fontFamily = fontFamilyOverride;
  } else if (isFontsLocal) {
    fontFamily = fontsName;
  } else if (forceRed) {
    fontFamily = quranCtrl.getRedFontPath(pageIndex);
  } else {
    fontFamily = quranCtrl.getFontPath(pageIndex, isDark: isDark);
  }

  final baseTextStyle = TextStyle(
    fontFamily: fontFamily,
    package: fontPackageOverride,
    fontSize: fontSize,
    height: 2,
    // wordSpacing: 50,
    color: textColor ?? AppColors.getTextColor(isDark),
  );

  InlineSpan? tail;
  final hasBookmark = isAyahBookmarked != null
      ? isAyahBookmarked(ayahModel)
      : (ayahBookmarked.contains(ayahUQNum) ||
          bookmarksAyahs.contains(ayahUQNum));
  if (showAyahNumber) {
    tail = hasBookmark && showAyahBookmarkedIcon && !kIsWeb
        ? WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: quranCtrl.isQpcV4Enabled
                  ? const EdgeInsets.symmetric(horizontal: 4.0)
                  : const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 16.0),
              child: SvgPicture.asset(
                AssetsPath.assets.ayahBookmarked,
                height: UiHelper.currentOrientation(30.0.h, 130.0.h, context),
                width: UiHelper.currentOrientation(30.0.w, 130.0.w, context),
              ),
            ),
          )
        : TextSpan(
            text: usePaintColoring
                ? '${'$ayahNumber'.convertEnglishNumbersToArabic(ayahNumber.toString())}\u202F\u202F'
                : '\u202F${'$ayahNumber'.convertEnglishNumbersToArabic(ayahNumber.toString())}\u202F',
            style: TextStyle(
              fontFamily: 'ayahNumber',
              fontSize: usePaintColoring ? (fontSize + 5) : (fontSize + 5),
              height: 1.5,
              package: 'quran_library',
              color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
            ),
            recognizer: LongPressGestureRecognizer(
                duration: const Duration(milliseconds: 500))
              ..onLongPressStart = onLongPressStart,
          );
  }

  final GestureRecognizer recognizer;
  if (!wordInfoCtrl.isWordSelectionEnabled) {
    // تحديد الكلمة معطّل: الضغط القصير لا يفعل شيئاً، الضغط المطوّل يفتح قائمة الآية
    recognizer = TapLongPressRecognizer(
      shortHoldDuration: const Duration(milliseconds: 150),
      longHoldDuration: const Duration(milliseconds: 500),
    )
      ..onQuickTapCallback = onPagePress
      ..onShortHoldStartCallback = () {
        // فارغ عمداً — لإبقاء الحدث حياً حتى يصل للضغط المطوّل
      }
      ..onShortHoldCompleteCallback = null
      ..onLongHoldStartCallback = (details) {
        onLongPressStart?.call(details);
      };
  } else {
    recognizer = TapLongPressRecognizer(
      shortHoldDuration: const Duration(milliseconds: 150),
      longHoldDuration: const Duration(milliseconds: 500),
    )
      ..onQuickTapCallback = onPagePress
      ..onShortHoldStartCallback = () {
        wordInfoCtrl.setSelectedWord(wordRef);
      }
      ..onShortHoldCompleteCallback = () {
        () async {
          if (!context.mounted) return;
          await showWordInfoBottomSheet(
              context: context, ref: wordRef, isDark: isDark);
          if (!context.mounted) return;
          wordInfoCtrl.clearSelectedWord();
        }();
      }
      ..onLongHoldStartCallback = (details) {
        wordInfoCtrl.clearSelectedWord();
        onLongPressStart?.call(details);
      };
  }

  return TextSpan(
    children: <InlineSpan>[
      TextSpan(
        text: glyphs,
        style: baseTextStyle,
        recognizer: recognizer,
      ),
      if (tail != null) tail,
    ],
  );
}

typedef _LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
