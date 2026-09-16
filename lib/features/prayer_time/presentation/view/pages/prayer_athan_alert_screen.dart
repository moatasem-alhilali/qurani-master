import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';

/// شاشة نداء الأذان: لحظة واحدة، فلا شيء فيها يزاحم اسم الصلاة.
///
/// اسم الصلاة هو العنصر المرتفع الوحيد، وما حوله سطور نحيلة على أرضية
/// الصفحة، وفعلٌ واحد ذهبي في الأسفل.
class PrayerAthanAlertScreen extends StatelessWidget {
  const PrayerAthanAlertScreen({
    required this.prayerName,
    this.prayerTimeLabel,
    super.key,
  });

  final String prayerName;
  final String? prayerTimeLabel;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final timeLabel = (prayerTimeLabel ?? '').trim();

    return Scaffold(
      backgroundColor: skin.ground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: AppIcon(
                      AppIcons.close,
                      color: skin.inkSoft,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // العنصر المرتفع الوحيد في الشاشة.
              Container(
                decoration: BoxDecoration(
                  color: skin.raised,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: skin.raisedBorder, width: 1.2),
                  boxShadow: skin.raisedShadow,
                ),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Column(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: skin.iconChip,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: AppIcon(
                          AppIcons.mosque,
                          color: skin.accent,
                          size: 22.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'حان الآن وقت الصلاة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      prayerName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    if (timeLabel.isNotEmpty)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          timeLabel,
                          style: TextStyle(
                            color: skin.accent,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [
                              ui.FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 10.h),
                    Divider(height: 1, thickness: 1, color: skin.hairline),
                    SizedBox(height: 10.h),
                    Text(
                      'أقم صلاتك بخشوع، فهي نور القلب وسكينة الروح.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.86),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                borderRadius: BorderRadius.circular(12.r),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppIcon(
                          AppIcons.check,
                          color: AppColors.brandIvory,
                          size: 15,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'تم الاستعداد للصلاة',
                          style: TextStyle(
                            color: AppColors.brandIvory,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      settings: const RouteSettings(
                        name: 'PrayerTimeScreen',
                      ),
                      builder: (_) => const PrayerTimeScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'فتح صفحة أوقات الصلاة',
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AppIcon(
                        AppIcons.chevronLeft,
                        color: skin.accent,
                        size: 13.sp,
                      ),
                    ],
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
