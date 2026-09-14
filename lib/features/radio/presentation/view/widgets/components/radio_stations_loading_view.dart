import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// هيكل انتظار بشكل الصفوف نفسها: مربّع صورة وسطران باهتان، بلا بطاقات.
class RadioStationsLoadingView extends StatelessWidget {
  const RadioStationsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: index == 5
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: skin.hairline)),
                ),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 9.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                        color: skin.hairline,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 7.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: skin.hairline.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
