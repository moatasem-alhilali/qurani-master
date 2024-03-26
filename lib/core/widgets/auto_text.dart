import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class CustomAutoSizeText extends StatelessWidget {
  const CustomAutoSizeText(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: const TextStyle(fontSize: 14),
      minFontSize: 12,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension MyTextAuto on String {
  Widget autoSize(
    context, {
    int? maxLines,
    Color? color,
    double fontSize = 18,
    double minFontSize = 12,
    TextAlign? textAlign,
  }) {
    return AutoSizeText(
      this,
      style: titleMedium(context).copyWith(
        fontSize: fontSize,
        color: color,
      ),
      minFontSize: minFontSize,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.right,
      overflow: TextOverflow.ellipsis,
    ).animate().fade();
  }
}
