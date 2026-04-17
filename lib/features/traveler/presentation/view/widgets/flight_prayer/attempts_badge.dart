import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class AttemptsBadge extends StatelessWidget {
  const AttemptsBadge({super.key, required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        'المحاولات: $value',
        style: TextStyle(
          color: context.primaryColor,
          fontSize: 11.2.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
