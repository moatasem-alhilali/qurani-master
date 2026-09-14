import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// عدّاد المحاولات المتبقّية للبحث عن رحلة.
class AttemptsBadge extends StatelessWidget {
  const AttemptsBadge({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    // نفدت المحاولات: يُقرأ بوزن الخطّ أيضًا لا باللون وحده.
    final exhausted = value <= 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'محاولات متبقّية ',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '$value',
              style: TextStyle(
                color: skin.accent,
                fontSize: 9.5.sp,
                fontWeight: exhausted ? FontWeight.w500 : FontWeight.w800,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
