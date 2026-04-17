import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class RadioHeroCard extends StatelessWidget {
  const RadioHeroCard({
    super.key,
    required this.station,
    required this.isPlaying,
    required this.onOpenNowPlaying,
  });

  final RadioStationModel? station;
  final bool isPlaying;
  final VoidCallback? onOpenNowPlaying;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final secondaryAccent = context.secondaryColor;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.surfaceColor,
            Color.lerp(
                  context.surfaceVariant,
                  accent,
                  0.10,
                ) ??
                context.surfaceVariant,
          ],
        ),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -26.h,
            left: -20.w,
            child: Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryAccent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -18.h,
            right: -12.w,
            child: Container(
              width: 94.w,
              height: 94.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.07),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  station == null ? 'إذاعات مباشرة' : 'المحطة الحالية',
                  style: context.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (station != null)
                    RadioStationArtwork(
                      imageUrl: station!.imageUrl,
                      heroTag: 'radio_station_${station!.id}_hero',
                      size: 72.w,
                      borderRadius: 24.r,
                    )
                  else
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: accent.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: accent,
                        size: 28.sp,
                      ),
                    ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station?.name ?? 'اختر محطة وابدأ البث المباشر',
                          style: context.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          station == null
                              ? 'استمع إلى إذاعات قرآنية وإسلامية مع '
                                  'استمرار التشغيل في الخلفية.'
                              : (isPlaying
                                  ? 'يتم الآن تشغيل الإذاعة مع دعم الخلفية '
                                      'وإشعار النظام.'
                                  : 'المحطة محددة ويمكنك متابعة التشغيل من '
                                      'المشغل السفلي.'),
                          style: context.bodyMedium?.copyWith(
                            color: context.onSurfaceVariant
                                .withValues(alpha: 0.88),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (station != null) ...[
                SizedBox(height: 16.h),
                FilledButton(
                  onPressed: onOpenNowPlaying,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: context.onPrimaryColor,
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: Text(isPlaying ? 'فتح المشغل' : 'إكمال من المشغل'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
