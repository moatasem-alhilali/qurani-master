import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';

TextSpan ayahTextSpanHorizontalWidget({
  required String text,
  required int pageIndex,
  required bool isSelected,
  required int surahNum,
  required int ayahNum,
  required int ayahUQNum,
  required bool isFirstAyah,
  required BuildContext context,
  double? fontSize,
  VoidCallback? onTap,
}) {
  final hasBookmarkAyahSelect =
      context.read<BookmarkBloc>().hasBookmarkAyah(surahNum, ayahNum);
  // log('surahNum: $surahNum, ayahNum: $ayahNum, hasBookmarkAyahSelect: $hasBookmarkAyahSelect');

  final recognizer = TapGestureRecognizer()..onTap = onTap;

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
          fontSize: fontSize?.sp,
          height: 2,
          letterSpacing: 30,
          color: Colors.black,
          backgroundColor: Colors.transparent,
        ),
        recognizer: recognizer,
      );
      second = TextSpan(
        text: partTwo,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize?.sp,
          height: 2,
          letterSpacing: 5,
          // wordSpacing: wordSpacing + 10,
          color: Colors.black,
          backgroundColor: hasBookmarkAyahSelect
              ? context.primaryColor.withOpacity(.4)
              : isSelected
                  ? context.primaryColor
                  : Colors.transparent,
        ),
        recognizer: recognizer,
      );
    }

    final initialTextSpan = TextSpan(
      text: initialPart,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize?.sp,
        height: 2,
        letterSpacing: 5,
        color: Colors.black,
        backgroundColor: hasBookmarkAyahSelect
            ? context.primaryColor.withOpacity(.4)
            : isSelected
                ? context.primaryColor
                : Colors.transparent,
      ),
      recognizer: recognizer,
    );

    final lastCharacterSpan = TextSpan(
      text: lastCharacter,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize?.sp,
        height: 2,
        letterSpacing: 5,
        color: hasBookmarkAyahSelect ? Colors.black : context.primaryColor,
        backgroundColor: hasBookmarkAyahSelect
            ? context.primaryColor.withOpacity(.4)
            : isSelected
                ? context.primaryColor.withOpacity(.2)
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
