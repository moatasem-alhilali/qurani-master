import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class PrayerMarker extends StatelessWidget {
  const PrayerMarker({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: context.primaryColor.withValues(alpha: 0.7)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
