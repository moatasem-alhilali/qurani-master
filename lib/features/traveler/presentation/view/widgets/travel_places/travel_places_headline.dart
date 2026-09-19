import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/l10n/l10n.dart';

/// صدارة الصفحة: أقرب مكان، وجوابٌ عن السؤال الذي جاء المسافر لأجله.
///
/// الصفحة كانت خريطةً عامّة كأي تطبيق خرائط. والمسافر الواقف أمام هاتفه قبل
/// الصلاة لا يريد جغرافيا — يريد قرارًا: **هل ألحق؟**
///
/// والجواب محسوب مجّانًا: زمن المشي موجود في `TravelerPlace`، ووقت الصلاة
/// القادمة في `PrayerTimeBloc`. لم يكن ينقص إلا طرحُهما.
class TravelPlacesHeadline extends StatelessWidget {
  const TravelPlacesHeadline({
    required this.place,
    required this.placeType,
    super.key,
  });

  final TravelerPlace place;
  final TravelerPlaceType placeType;

  Future<void> _openDirections(BuildContext context) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination='
        '${place.latitude},${place.longitude}';
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!context.mounted || launched) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.travelerOpenMapsFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: skin.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            placeType == TravelerPlaceType.mosque
                ? context.l10n.travelerNearestMosque
                : context.l10n.travelerNearestRestaurant,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.7),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            place.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              AppIcon(
                AppIcons.mapPin,
                color: skin.inkSoft.withValues(alpha: 0.6),
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '${place.distanceLabel(context.l10n)} · '
                '${place.walkingEtaLabel(context.l10n)}',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.85),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
          if (placeType == TravelerPlaceType.mosque) ...[
            SizedBox(height: 10.h),
            _PrayerRace(place: place),
          ],
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () => _openDirections(context),
              borderRadius: BorderRadius.circular(999.r),
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(
                      AppIcons.direction,
                      color: skin.isDark
                          ? AppColors.brandNight
                          : AppColors.brandIvory,
                      size: 15.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      context.l10n.travelerTakeMeThere,
                      style: TextStyle(
                        color: skin.isDark
                            ? AppColors.brandNight
                            : AppColors.brandIvory,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// السباق: زمن المشي مقابل ما بقي على الصلاة القادمة.
///
/// شريطان على مسار واحد يقولان الجواب قبل قراءة النصّ — وهذا ما لا يعطيه أي
/// تطبيق خرائط: هو يعرف الطريق ولا يعرف متى تُقام الصلاة.
class _PrayerRace extends StatelessWidget {
  const _PrayerRace({required this.place});

  final TravelerPlace place;

  /// زمن المشي بالدقائق — نفس معادلة `walkingEtaLabel` في النموذج.
  int get _walkMinutes => (place.distanceMeters / 80).round().clamp(1, 120);

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      buildWhen: (previous, current) =>
          previous.nextPrayer != current.nextPrayer ||
          previous.selectedLocation != current.selectedLocation,
      builder: (context, state) {
        final next = state.nextPrayer;
        final location = state.selectedLocation;
        if (next == null || location == null) return const SizedBox.shrink();

        // وقت الصلاة بتوقيت المدينة، فيُقارَن بـ«الآن» في المدينة نفسها لا
        // بساعة الجهاز — والفارق بينهما ساعات عند السفر.
        final now = DateTime.now().toUtc().add(
              Duration(minutes: location.utcOffsetMinutes),
            );
        final target = next.time;
        final remaining = target.difference(
          DateTime(
            target.year,
            target.month,
            target.day,
            now.hour,
            now.minute,
            now.second,
          ),
        );

        final minutesLeft = remaining.inMinutes;
        if (minutesLeft < 0 || minutesLeft > 600) {
          return const SizedBox.shrink();
        }

        final willMakeIt = _walkMinutes <= minutesLeft;
        final tone = willMakeIt ? skin.accent : AppColors.error;
        final ratio = minutesLeft == 0
            ? 1.0
            : (_walkMinutes / math.max(minutesLeft, 1)).clamp(0.05, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppIcon(
                  willMakeIt ? AppIcons.check : AppIcons.warning,
                  color: tone,
                  size: 13.sp,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    willMakeIt
                        ? context.l10n.travelerWillMakeIt(
                            minutesLeft,
                            next.localizedName(context.l10n),
                          )
                        : context.l10n.travelerMightMiss(
                            minutesLeft,
                            next.localizedName(context.l10n),
                          ),
                    maxLines: 2,
                    style: TextStyle(
                      color: tone,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h),
            // المسار كلّه هو الوقت المتبقّي، والجزء الملوّن هو زمن مشيك فيه.
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: SizedBox(
                height: 4.h,
                child: Stack(
                  children: [
                    Positioned.fill(child: ColoredBox(color: skin.hairline)),
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: ColoredBox(color: tone),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
