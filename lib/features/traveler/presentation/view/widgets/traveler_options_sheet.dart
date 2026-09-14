import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// خدمات المسافر: أربعة أبواب على أرضية واحدة تفصلها خطوط شعرة.
///
/// كانت أربع بطاقات بحدّ ونصف قطر ١٨، فبدت الورقة مكدّسة بالصناديق.
/// الآن صفوف نحيلة: مربّع الأيقونة وحده يميّز كل باب.
class TravelerOptionsSheet extends StatelessWidget {
  const TravelerOptionsSheet({
    required this.onOpenNearbyMosques,
    required this.onOpenTravelAzkar,
    required this.onOpenHalalRestaurants,
    required this.onOpenFlightPrayerTimes,
    super.key,
  });

  final VoidCallback onOpenNearbyMosques;
  final VoidCallback onOpenTravelAzkar;
  final VoidCallback onOpenHalalRestaurants;
  final VoidCallback onOpenFlightPrayerTimes;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: skin.ground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: skin.hairline,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'خدمات المسافر',
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'اختر ما تحتاجه الآن في طريقك',
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
                TravelerIconAction(
                  icon: AppIcons.close,
                  tooltip: 'إغلاق',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Divider(height: 1, thickness: 1, color: skin.hairline),
            TravelerListRow(
              icon: AppIcons.mosque,
              title: 'المساجد القريبة',
              subtitle: 'خريطة مباشرة مع أقرب المساجد والاتجاهات',
              onTap: onOpenNearbyMosques,
            ),
            TravelerListRow(
              icon: AppIcons.bookOpen,
              title: 'أذكار السفر',
              subtitle: 'أذكار موثقة مع عداد ونسخ ومشاركة',
              onTap: onOpenTravelAzkar,
            ),
            TravelerListRow(
              icon: AppIcons.restaurant,
              title: 'مطاعم حلال',
              subtitle: 'تظهر في الدول غير الإسلامية مع خريطة واضحة',
              onTap: onOpenHalalRestaurants,
            ),
            TravelerListRow(
              icon: AppIcons.flight,
              title: 'الصلاة أثناء الطيران',
              subtitle: 'رقم الرحلة يرسم مواقيت الصلاة على المسار',
              onTap: onOpenFlightPrayerTimes,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
