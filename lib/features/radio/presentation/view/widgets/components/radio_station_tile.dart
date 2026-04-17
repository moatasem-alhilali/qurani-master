import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class RadioStationTile extends StatelessWidget {
  const RadioStationTile({
    required this.station,
    required this.isCurrent,
    required this.isPlayingCurrent,
    super.key,
  });

  final RadioStationModel station;
  final bool isCurrent;
  final bool isPlayingCurrent;

  @override
  Widget build(BuildContext context) {
    final accent = isCurrent ? context.primaryColor : context.secondaryColor;
    return InkWell(
      onTap: () {
        context.read<RadioBloc>().add(RadioStationPlayRequested(station));
        // RadioPlayerUiManager.instance.openBox();
      },
      borderRadius: BorderRadius.circular(22.r),
      child: Ink(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: context.surfaceColor,
          border: Border.all(
            color: isCurrent
                ? accent.withValues(alpha: 0.26)
                : context.outline.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.06),
              blurRadius: 12.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          children: [
            RadioStationArtwork(
              imageUrl: station.imageUrl,
              heroTag: 'radio_station_${station.id}',
              size: 62.w,
              borderRadius: 20.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            isPlayingCurrent ? 'مباشر' : 'آخر محطة',
                            style: context.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'بث مباشر مستمر مع دعم التشغيل في الخلفية',
                    style: context.bodySmall?.copyWith(
                      color: context.onSurfaceVariant.withValues(alpha: 0.86),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: accent.withValues(alpha: 0.10),
              ),
              child: Icon(
                isPlayingCurrent
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
