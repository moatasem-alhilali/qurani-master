import 'package:flutter/material.dart';
import 'package:quran_app/core/widgets/images/image_widget.dart';

class SurahNameImageWidget extends StatelessWidget {
  const SurahNameImageWidget({
    required this.num,
    super.key,
    this.height,
    this.width,
    this.color,
  });
  final String num;
  final double? height;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ImageWidget(
      'assets/svg/surah_name/00$num.svg',
      height: height ?? 30,
      width: width,
      color: color,
    );
  }
}
