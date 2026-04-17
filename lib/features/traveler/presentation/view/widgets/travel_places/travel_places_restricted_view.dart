import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class TravelPlacesRestrictedView extends StatelessWidget {
  const TravelPlacesRestrictedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, size: 48.sp, color: context.primaryColor),
            SizedBox(height: 16.h),
            Text(
              'لا يتوفر بحث المطاعم الحلال في الدول الإسلامية لأن كل مطاعمها حلال.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
