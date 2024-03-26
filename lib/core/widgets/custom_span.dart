import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';

TextSpan span({
  required String text,
  required int pageIndex,
  required bool isSelected,
  double? fontSize,
  required int surahNum,
  required int ayahNum,
  LongPressStartDetailsFunction? onLongPressStart,
  required bool isFirstAyah,
  required BuildContext context,
}) {
  if (text.isNotEmpty) {
    final String partOne = text.length < 3 ? text[0] : text[0] + text[1];
    final String? partTwo =
        text.length > 2 ? text.substring(2, text.length - 1) : null;
    final String initialPart = text.substring(0, text.length - 1);
    final String lastCharacter = text.substring(text.length - 1);
    TextSpan? first;
    TextSpan? second;
    if (isFirstAyah) {
      first = TextSpan(
        text: partOne,
        style: TextStyle(
          fontFamily: 'page${pageIndex + 1}',
          fontSize: fontSize,
          height: 2,
          letterSpacing: 30,
          color: currentThemeData.colorScheme.inversePrimary,
          backgroundColor: Colors.transparent,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
      );
      second = TextSpan(
        text: partTwo,
        style: TextStyle(
          fontFamily: 'page${pageIndex + 1}',
          fontSize: fontSize,
          height: 2,
          letterSpacing: 5,
          // wordSpacing: wordSpacing + 10,
          color: currentThemeData.colorScheme.inversePrimary,
          backgroundColor: context
                  .read<BookmarkBloc>()
                  .bookmarksController
                  .hasBookmarkSelect(surahNum, ayahNum, pageIndex)
              ? const Color(0xffCD9974).withOpacity(.4)
              : isSelected
                  ? FxColors.primary
                  : Colors.transparent,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressStart = onLongPressStart,
      );
    }

    final TextSpan initialTextSpan = TextSpan(
      text: initialPart,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        fontSize: fontSize,
        height: 2,
        letterSpacing: 5,
        color: currentThemeData.colorScheme.inversePrimary,
        backgroundColor: context
                .read<BookmarkBloc>()
                .bookmarksController
                .hasBookmarkSelect(surahNum, ayahNum, pageIndex)
            ? const Color(0xffCD9974).withOpacity(.4)
            : isSelected
                ? FxColors.primary
                : Colors.transparent,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );

    final TextSpan lastCharacterSpan = TextSpan(
      text: lastCharacter,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        fontSize: fontSize,
        height: 2,
        letterSpacing: 5,
        color: context
                .read<BookmarkBloc>()
                .bookmarksController
                .hasBookmarkSelect(surahNum, ayahNum, pageIndex)
            ? currentThemeData.colorScheme.inversePrimary
            : const Color(0xff77554B),
        backgroundColor: context
                .read<BookmarkBloc>()
                .bookmarksController
                .hasBookmarkSelect(surahNum, ayahNum, pageIndex)
            ? const Color(0xffCD9974).withOpacity(.4)
            : isSelected
                ? currentThemeData.highlightColor
                : Colors.transparent,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );

    return TextSpan(
      children: isFirstAyah
          ? [first!, second!, lastCharacterSpan]
          : [initialTextSpan, lastCharacterSpan],
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
