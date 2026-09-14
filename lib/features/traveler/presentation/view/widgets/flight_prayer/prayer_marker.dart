import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// اسم الصلاة فوق موضعها على المسار.
class PrayerMarker extends StatelessWidget {
  const PrayerMarker({required this.text, required this.onTap, super.key});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: skin.ground.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: skin.raisedBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: skin.ink,
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
