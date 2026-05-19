import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

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
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.outlineVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'خدمات المسافر',
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const AppIcon(AppIcons.close, size: 18),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'اختر الخدمة التي تحتاجها الآن أثناء السفر',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.62),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 14.h),
            _TravelerOptionTile(
              icon: AppIcons.mosque,
              title: 'المساجد القريبة',
              subtitle: 'خريطة مباشرة مع أقرب المساجد والاتجاهات',
              onTap: onOpenNearbyMosques,
            ),
            _TravelerOptionTile(
              icon: AppIcons.bookOpen,
              title: 'أذكار السفر',
              subtitle: 'أذكار موثقة مع عداد ونسخ ومشاركة ومفضلة',
              onTap: onOpenTravelAzkar,
            ),
            _TravelerOptionTile(
              icon: AppIcons.restaurant,
              title: 'مطاعم حلال',
              subtitle: 'تظهر في الدول غير الإسلامية مع خريطة واضحة',
              onTap: onOpenHalalRestaurants,
            ),
            _TravelerOptionTile(
              icon: AppIcons.flight,
              title: 'الصلاة أثناء الطيران',
              subtitle: 'إدخال رقم الرحلة لعرض مواقيت الصلاة على المسار',
              onTap: onOpenFlightPrayerTimes,
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelerOptionTile extends StatelessWidget {
  const _TravelerOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: context.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppIcon(
                  icon,
                  color: context.primaryColor,
                  size: 17.sp,
                  strokeWidth: 1.6,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: context.onSurfaceColor.withValues(alpha: 0.6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              AppIcon(
                AppIcons.chevronLeft,
                color: context.onSurfaceColor.withValues(alpha: 0.45),
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
