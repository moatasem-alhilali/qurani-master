import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_image_widget.dart';

class SurahNameBannerImageWidget extends StatelessWidget {
  const SurahNameBannerImageWidget({
    required this.num,
    required this.child,
    super.key,
    this.height,
    this.width,
    this.color,
  });
  final String num;
  final double? height;
  final double? width;
  final Color? color;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          SizedBox(
            // height: 27.h,
            width: 120.w,
            child: SurahNameImageWidget(
              num: num,
              color: const Color(0xffd0d0d0),
            ),
          ),
        ],
      ),
    );
  }
}
