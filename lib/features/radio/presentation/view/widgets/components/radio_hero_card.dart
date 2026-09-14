import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';

/// سطر تعريفي واحد فوق قائمة المحطات.
///
/// كان هنا كارد كبير بتدرّج ودوائر وزرّ عريض يعيد عرض المحطة الجارية مرّة
/// ثانية. صار الصفّ المرتفع داخل القائمة هو مَن يمثّل المحطة الجارية، وبقي
/// هنا سطر واحد يشرح القسم أو يفتح المشغّل.
class RadioHeroCard extends StatelessWidget {
  const RadioHeroCard({
    required this.station,
    required this.isPlaying,
    required this.onOpenNowPlaying,
    super.key,
  });

  final RadioStationModel? station;
  final bool isPlaying;
  final VoidCallback? onOpenNowPlaying;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasStation = station != null;

    return InkWell(
      onTap: hasStation ? onOpenNowPlaying : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppIcon(AppIcons.radio, color: skin.accent, size: 15.sp),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasStation ? 'المشغّل' : 'إذاعات مباشرة',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    hasStation
                        ? (isPlaying
                            ? '${station!.name} · يعمل الآن'
                            : '${station!.name} · متوقّف')
                        : 'اختر محطة ويستمرّ البثّ في الخلفية',
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
            if (hasStation)
              AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}
