import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';

class ThikrSlider extends StatelessWidget {
  const ThikrSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            'الورد اليومي',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: context.primaryColor,
            ),
          ),
        ),
        const _Item(
          data: 'يقول تعالى: "وَالذَّاكِرِينَ اللَّهَ كَثِيرًا وَالذَّاكِرَاتِ أَعَدَّ اللَّهُ لَهُم مَّغْفِرَةً وَأَجْرًا عَظِيمًا"',
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.data,
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);
    final accent = context.primaryColor;
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.10);
    final titleColor = context.onSurfaceColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () {
          if (DateTime.now().hour >= 17) {
            context.push(const WirdScreen(isMorning: false));
          } else {
            context.push(const WirdScreen(isMorning: true));
          }
        },
        borderRadius: borderRadius,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardBackground,
                cardBackgroundSoft,
              ],
            ),
            border: Border.all(
              color: cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 14.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          accent,
                          accent.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30.h,
                  left: -30.w,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  top: -20.h,
                  right: 40.w,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 24.w, 20.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: accent,
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          data,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
