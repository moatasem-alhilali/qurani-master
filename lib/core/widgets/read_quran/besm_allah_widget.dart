import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';

class BesmAllahWidget extends StatelessWidget {
  const BesmAllahWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/besmAllah.svg',
      width: 150.0.w,
      // height: 100,

      color: context.quranTheme.cardColor?.withOpacity(.8),
      // colorFilter:
      //     ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
    );
  }
}

class BesmAllah2Widget extends StatelessWidget {
  const BesmAllah2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/besmAllah2.svg',
      width: 150.0.w,
      // height: 100,

      color: context.quranTheme.cardColor?.withOpacity(.8),
      // colorFilter:
      //     ColorFilter.mode(Get.theme.cardColor.withOpacity(.8), BlendMode.srcIn),
    );
  }
}
