import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class CustomAutoSizeText extends StatelessWidget {
  const CustomAutoSizeText(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: const TextStyle(fontSize: 14),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension MyTextAuto on String {
  Widget autoSize(
    BuildContext context, {
    int? maxLines,
    Color? color,
    double fontSize = 18,
    double minFontSize = 12,
    TextAlign? textAlign,
    TextStyle? style,
    TextOverflow? overflow,
  }) {
    return AutoSizeText(
      this,
      style: style ??
          titleMedium(context).copyWith(
            fontSize: fontSize,
            color: color,
          ),
      minFontSize: minFontSize,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.right,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
