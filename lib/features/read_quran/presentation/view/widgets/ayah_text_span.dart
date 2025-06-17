import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';

TextSpan ayahTextSpan({
  required String text,
  required int pageIndex,
  required bool isSelected,
  required int surahNum,
  required int ayahNum,
  required bool isFirstAyah,
  required BuildContext context,
  double? fontSize,
  LongPressStartDetailsFunction? onLongPressStart,
  VoidCallback? onTapUp,
}) {
  final recognizer =
      LongPressGestureRecognizer(duration: const Duration(milliseconds: 500))
        ..onLongPressStart = onLongPressStart
        ..onLongPressEnd = (_) {
          if (onTapUp != null) onTapUp();
        };

  if (text.isNotEmpty) {
    final partOne = text.length < 3 ? text[0] : text[0] + text[1];
    final partTwo = text.length > 2 ? text.substring(2, text.length - 1) : null;
    final initialPart = text.substring(0, text.length - 1);
    final lastCharacter = text.substring(text.length - 1);
    TextSpan? first;
    TextSpan? second;
    final fontFamily = 'page${pageIndex + 1}';
    if (isFirstAyah) {
      first = TextSpan(
        text: partOne,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: 2,
          letterSpacing: 30,
          color: context.currentThemeData.colorScheme.inversePrimary,
          backgroundColor: Colors.transparent,
        ),
        recognizer: recognizer,
      );
      second = TextSpan(
        text: partTwo,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: 2,
          letterSpacing: 5,
          // wordSpacing: wordSpacing + 10,
          color: context.currentThemeData.colorScheme.inversePrimary,
          backgroundColor: context
                  .read<BookmarkBloc>()
                  .hasBookmarkAyahSelect(surahNum, ayahNum)
              ? const Color(0xffCD9974).withOpacity(.4)
              : isSelected
                  ? FxColors.primary
                  : Colors.transparent,
        ),
        recognizer: recognizer,
      );
    }

    final initialTextSpan = TextSpan(
      text: initialPart,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: 2,
        letterSpacing: 5,
        color: context.currentThemeData.colorScheme.inversePrimary,
        backgroundColor: context
                .read<BookmarkBloc>()
                .hasBookmarkAyahSelect(surahNum, ayahNum)
            ? const Color(0xffCD9974).withOpacity(.4)
            : isSelected
                ? FxColors.primary
                : Colors.transparent,
      ),
      recognizer: recognizer,
    );

    final lastCharacterSpan = TextSpan(
      text: lastCharacter,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: 2,
        letterSpacing: 5,
        color: context
                .read<BookmarkBloc>()
                .hasBookmarkAyahSelect(surahNum, ayahNum)
            ? context.currentThemeData.colorScheme.inversePrimary
            : const Color(0xff77554B),
        backgroundColor: context
                .read<BookmarkBloc>()
                .hasBookmarkAyahSelect(surahNum, ayahNum)
            ? const Color(0xffCD9974).withOpacity(.4)
            : isSelected
                ? context.currentThemeData.highlightColor
                : Colors.transparent,
      ),
      recognizer: recognizer,
    );

    return TextSpan(
      children: isFirstAyah
          ? [first!, second!, lastCharacterSpan]
          : [initialTextSpan, lastCharacterSpan],
      recognizer: recognizer,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;
