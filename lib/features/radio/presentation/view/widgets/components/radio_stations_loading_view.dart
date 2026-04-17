import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class RadioStationsLoadingView extends StatelessWidget {
  const RadioStationsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 152.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            color: context.surfaceVariant.withValues(alpha: 0.46),
          ),
        ),
        SizedBox(height: 16.h),
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                color: context.surfaceVariant.withValues(alpha: 0.38),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
