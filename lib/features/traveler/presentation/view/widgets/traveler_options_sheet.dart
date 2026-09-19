import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/traveler/data/services/makkah_geo.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/hub/traveler_route_arc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';
import 'package:quran_app/l10n/l10n.dart';

/// خدمات المسافر.
///
/// كانت قائمةً صامتة: أربعة صفوف متطابقة بأربعة أسطر وصف ثابتة، لا تعرف أين
/// المسافر ولا متى — حتى سطر «تظهر في الدول غير الإسلامية» كان **يصف** شرطًا
/// بدل أن يطبّقه.
///
/// صارت تفتح بما يخصّ المسافر وحده: كم بينك وبين مكّة وفي أي جهة، مرسومًا
/// بلغة خرائط الطيران. ثم الأبواب الأربعة بلاطاتٍ يميّزها شكلها لا ترتيبها.
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
        padding: EdgeInsets.fromLTRB(0, 8.h, 0, 14.h),
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
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.travelerServicesTitle,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  TravelerIconAction(
                    icon: AppIcons.close,
                    tooltip: context.l10n.commonClose,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const _RouteToMakkah(),
            SizedBox(height: 14.h),
            skin.divider(),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TravelerServiceTile(
                          icon: AppIcons.mosque,
                          title: context.l10n.travelerNearbyMosques,
                          hint: context.l10n.travelerHintAroundYou,
                          onTap: onOpenNearbyMosques,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TravelerServiceTile(
                          icon: AppIcons.bookOpen,
                          title: context.l10n.travelerAthkarTitle,
                          hint: context.l10n.travelerHintWithCounter,
                          onTap: onOpenTravelAzkar,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: TravelerServiceTile(
                          icon: AppIcons.restaurant,
                          title: context.l10n.travelerHalalRestaurants,
                          hint: context.l10n.travelerHintByCountry,
                          onTap: onOpenHalalRestaurants,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TravelerServiceTile(
                          icon: AppIcons.flight,
                          title: context.l10n.travelerFlightPrayer,
                          hint: context.l10n.travelerHintByFlightNumber,
                          onTap: onOpenFlightPrayerTimes,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// القوس مربوطًا بموقع المستخدم المحفوظ في مواقيت الصلاة.
///
/// لا نداء شبكة ولا إذن موقع جديد: الإحداثيات موجودة أصلًا، فتظهر البطاقة
/// كاملةً في أوّل إطار. وإن لم يكن هناك موقع بعد، يُعرض سطر واحد بدل هيكل
/// فارغ يوهم بالتحميل.
class _RouteToMakkah extends StatelessWidget {
  const _RouteToMakkah();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      buildWhen: (previous, current) =>
          previous.selectedLocation != current.selectedLocation,
      builder: (context, state) {
        final location = state.selectedLocation;
        if (location == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 2.h),
            child: Text(
              context.l10n.travelerSetLocationForMakkah,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.72),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          );
        }

        final geo = MakkahGeo.from(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        if (geo.isAtDestination) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 2.h),
            child: Text(
              context.l10n.travelerInMakkah,
              style: TextStyle(
                color: skin.accent,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          );
        }

        return TravelerRouteArc(
          originLabel: location.locality?.trim().isNotEmpty ?? false
              ? location.locality!.trim()
              : location.label,
          distanceLabel: geo.distanceLabel,
          directionLabel: geo.directionLabel(context.l10n),
        );
      },
    );
  }
}

/// بلاطة خدمة: أيقونة كبيرة فوق اسم قصير.
///
/// البديل السابق كان أربعة صفوف متماثلة يفرّق بينها سطر وصف طويل — فيُقرأ
/// بالعين حرفًا حرفًا. البلاطة تُعرف من شكل أيقونتها قبل قراءة اسمها.
class TravelerServiceTile extends StatelessWidget {
  const TravelerServiceTile({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
    super.key,
  });

  final HugeIconData icon;
  final String title;

  /// كلمتان تقولان **متى** تُستعمل، لا ما هي.
  final String hint;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 11.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: skin.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: AppIcon(icon, color: skin.accent, size: 18.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.62),
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
