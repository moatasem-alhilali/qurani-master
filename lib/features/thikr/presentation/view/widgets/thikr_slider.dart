import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// وردُ هذا الوقت — العنصر الوحيد المسموح له بالارتفاع في شاشة الأذكار.
///
/// لم يعد سطرًا عامًّا يقول «الورد اليومي»: يسمّي الورد الذي دخل وقته
/// الآن، فيعرف المستخدم ما الذي سيفتحه قبل أن يضغط.
class ThikrSlider extends StatelessWidget {
  const ThikrSlider({super.key});

  static const String _ayah =
      'وَالذَّاكِرِينَ اللَّهَ كَثِيرًا وَالذَّاكِرَاتِ '
      'أَعَدَّ اللَّهُ لَهُم مَّغْفِرَةً وَأَجْرًا عَظِيمًا';

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isEvening = DateTime.now().hour >= 17;
    final title = isEvening ? 'أذكار المساء' : 'أذكار الصباح';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 2.h),
      child: InkWell(
        onTap: () => context.push(WirdScreen(isMorning: !isEvening)),
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          decoration: BoxDecoration(
            color: skin.raised,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: skin.raisedBorder.withValues(alpha: 0.55),
            ),
            boxShadow: skin.raisedShadow,
          ),
          padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: skin.iconChip,
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Center(
                      child: AppIcon(
                        isEvening ? AppIcons.sunset : AppIcons.sunrise,
                        color: skin.accent,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.ink,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'وردُ هذا الوقت، افتحه الآن',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.78),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIcon(
                    AppIcons.chevronLeft,
                    color: skin.accent,
                    size: 15.sp,
                  ),
                ],
              ),
              SizedBox(height: 9.h),
              Divider(height: 1, thickness: 1, color: skin.hairline),
              SizedBox(height: 9.h),
              Text(
                _ayah,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: FontFamily.scheherazade,
                  color: skin.ink,
                  fontSize: 16.sp,
                  height: 1.9,
                ),
              ),
              SizedBox(height: 2.h),
              Align(
                child: Text(
                  'الأحزاب · ٣٥',
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
