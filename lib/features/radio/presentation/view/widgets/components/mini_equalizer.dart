import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class MiniEqualizer extends StatelessWidget {
  const MiniEqualizer({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = [10.h, 16.h, 12.h];

    return Row(
      children: bars
          .map(
            (height) => Container(
              width: 3.w,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: context.primaryColor.withValues(alpha: 0.82),
              ),
            ),
          )
          .toList(),
    );
  }
}
