import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// ثلاثة أعمدة صغيرة تدلّ على أن البثّ يعمل.
class MiniEqualizer extends StatelessWidget {
  const MiniEqualizer({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final bars = [7.h, 12.h, 9.h];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bars
          .map(
            (height) => Container(
              width: 2.w,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: skin.accent,
              ),
            ),
          )
          .toList(),
    );
  }
}
