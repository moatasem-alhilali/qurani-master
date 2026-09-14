import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// علامة «تمّ» بعد اكتمال تكرار الذكر.
///
/// شكل قبل لون: علامة صحّ ووزن خطّ ثقيل، حتى تُقرأ الحالة بلا اعتماد
/// على تمييز الألوان.
class DoneBadge extends StatelessWidget {
  const DoneBadge({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(AppIcons.check, color: skin.accent, size: 13.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: skin.accent,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
