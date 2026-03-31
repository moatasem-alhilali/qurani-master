part of '/quran.dart';

Color? _ayahBackgroundColor({
  required int ayahUQNum,
  required bool isSelected,
  required List<int> bookmarksAyahs,
  required List<int> ayahBookmarked,
  required Map<int, List<BookmarkModel>> bookmarks,
  Color? bookmarksColor,
  Color? ayahSelectedBackgroundColor,
}) {
  final allBookmarks = bookmarks.values.expand((list) => list).toList();
  if (ayahBookmarked.contains(ayahUQNum)) return bookmarksColor;
  if (bookmarksAyahs.contains(ayahUQNum)) {
    return bookmarksColor ??
        Color(
          allBookmarks
              .firstWhere(
                (b) => b.ayahId == ayahUQNum,
              )
              .colorCode,
        ).withValues(alpha: 0.3);
  }
  if (isSelected) {
    return ayahSelectedBackgroundColor ??
        const Color(0xffCDAD80).withValues(alpha: 0.25);
  }
  return null;
}

TextSpan _qpcV4SpanSegment({
  required BuildContext context,
  required int pageIndex,
  required bool isSelected,
  required bool showAyahBookmarkedIcon,
  required double fontSize,
  required int ayahUQNum,
  required int ayahNumber,
  required String glyphs,
  required bool showAyahNumber,
  _LongPressStartDetailsFunction? onLongPressStart,
  required Color? textColor,
  required Color? ayahIconColor,
  required Map<int, List<BookmarkModel>> bookmarks,
  required List<int> bookmarksAyahs,
  required List<int> ayahBookmarked,
  Color? bookmarksColor,
  Color? ayahSelectedBackgroundColor,
  required bool isFontsLocal,
  required String fontsName,
  required bool isDark,
}) {
  final quranCtrl = QuranCtrl.instance;
  final bg = _ayahBackgroundColor(
    ayahUQNum: ayahUQNum,
    isSelected: isSelected,
    bookmarksAyahs: bookmarksAyahs,
    ayahBookmarked: ayahBookmarked,
    bookmarks: bookmarks,
    bookmarksColor: bookmarksColor,
    ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
  );

  final baseTextStyle = TextStyle(
    fontFamily: isFontsLocal ? fontsName : quranCtrl.getFontPath(pageIndex),
    fontSize: fontSize,
    height: 2.0,
    color: isDark && quranCtrl.state.fontsSelected.value == 2
        ? null
        : textColor ?? AppColors.getTextColor(isDark),
    backgroundColor: bg,
    foreground: isDark && quranCtrl.state.fontsSelected.value == 2
        ? (Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..invertColors = true
          ..blendMode = BlendMode.plus)
        : null,
    // shadows: [
    //   Shadow(
    //     blurRadius: 0.5,
    //     color: quranCtrl.state.isBold.value == false
    //         ? (textColor ?? (isDark ? Colors.white : Colors.black))
    //             .withValues(alpha: 0.5)
    //         : Colors.transparent,
    //     offset: const Offset(0.5, 0.5),
    //   ),
    // ],
  );

  InlineSpan? tail;
  final hasBookmark =
      ayahBookmarked.contains(ayahUQNum) || bookmarksAyahs.contains(ayahUQNum);
  if (showAyahNumber) {
    tail = hasBookmark && showAyahBookmarkedIcon && !kIsWeb
        ? WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SvgPicture.asset(
                AssetsPath.assets.ayahBookmarked,
                height: 140,
                width: 140,
              ),
            ),
          )
        : TextSpan(
            text:
                '${'$ayahNumber'.convertEnglishNumbersToArabic(ayahNumber.toString())}\u202F\u202F',
            style: TextStyle(
              fontFamily: 'ayahNumber',
              fontSize: fontSize + 25,
              height: 1.5,
              package: 'quran_library',
              color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
              backgroundColor: bg,
            ),
            recognizer: LongPressGestureRecognizer(
                duration: const Duration(milliseconds: 500))
              ..onLongPressStart = onLongPressStart,
          );
  }

  return TextSpan(
    children: <InlineSpan>[
      TextSpan(
        text: glyphs,
        style: baseTextStyle,
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
      ),
      if (tail != null) tail,
    ],
    recognizer:
        LongPressGestureRecognizer(duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
  );
}

TextSpan _customSpan({
  required BuildContext context,
  required String text,
  required int pageIndex,
  required bool isSelected,
  required bool showAyahBookmarkedIcon,
  double? fontSize,
  required int surahNum,
  required int ayahUQNum,
  required int ayahNumber,
  _LongPressStartDetailsFunction? onLongPressStart,
  required List? bookmarkList,
  required Color? textColor,
  required Color? ayahIconColor,
  required Map<int, List<BookmarkModel>> bookmarks,
  required List<int> bookmarksAyahs,
  Color? bookmarksColor,
  Color? ayahSelectedBackgroundColor,
  String? languageCode,
  required bool hasBookmark,
  required bool isDark,
}) {
  final allBookmarks = bookmarks.values.expand((list) => list).toList();
  hasBookmark == false
      ? (bookmarksAyahs.contains(ayahUQNum) ? true : false)
      : hasBookmark;
  if (text.isNotEmpty) {
    return TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'hafs',
            fontSize: fontSize,
            height: 2.1,
            color: textColor ?? (AppColors.getTextColor(isDark)),
            backgroundColor: hasBookmark
                ? bookmarksColor
                : (bookmarksAyahs.contains(ayahUQNum)
                    ? bookmarksColor ??
                        Color(allBookmarks
                                .firstWhere(
                                  (b) => b.ayahId == ayahUQNum,
                                )
                                .colorCode)
                            .withValues(alpha: 0.3)
                    : isSelected
                        ? ayahSelectedBackgroundColor ??
                            const Color(0xffCDAD80).withValues(alpha: 0.25)
                        : null),
            package: "quran_library",
          ),
          recognizer: LongPressGestureRecognizer(
              duration: const Duration(milliseconds: 500))
            ..onLongPressStart = onLongPressStart,
        ),
        (hasBookmark || bookmarksAyahs.contains(ayahUQNum)) &&
                showAyahBookmarkedIcon
            ? WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(
                    AssetsPath.assets.ayahBookmarked,
                    height: fontSize,
                  ),
                ))
            : TextSpan(
                text: ' $ayahNumber '
                    .convertNumbersAccordingToLang(languageCode: languageCode),
                style: TextStyle(
                  fontFamily: 'ayahNumber',
                  fontSize: fontSize,
                  height: 2.1,
                  color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
                  backgroundColor: hasBookmark
                      ? bookmarksColor
                      : (bookmarksAyahs.contains(ayahUQNum)
                          ? bookmarksColor ??
                              Color(allBookmarks
                                      .firstWhere(
                                        (b) => b.ayahId == ayahUQNum,
                                      )
                                      .colorCode)
                                  .withValues(alpha: 0.3)
                          : isSelected
                              ? ayahSelectedBackgroundColor ??
                                  const Color(0xffCDAD80)
                                      .withValues(alpha: 0.25)
                              : null),
                  package: "quran_library",
                ),
                recognizer: LongPressGestureRecognizer(
                    duration: const Duration(milliseconds: 500))
                  ..onLongPressStart = onLongPressStart,
              ),
      ],
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef _LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
