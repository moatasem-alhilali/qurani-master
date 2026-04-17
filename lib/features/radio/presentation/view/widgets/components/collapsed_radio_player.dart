import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class CollapsedRadioPlayer extends StatelessWidget {
  const CollapsedRadioPlayer({
    required this.station,
    required this.isPlaying,
    super.key,
  });

  final RadioStationModel station;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final barColor = Color.alphaBlend(
      context.primaryContainer.withValues(alpha: 0.18),
      context.surfaceColor,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: RadioPlayerUiManager.instance.openBox,
        borderRadius: BorderRadius.circular(28.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: context.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              // Container(
              //   width: 38.w,
              //   height: 38.w,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: context.primaryColor.withValues(alpha: 0.14),
              //   ),
              //   child: Icon(
              //     isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              //     color: context.primaryColor,
              //     size: 22.sp,
              //   ),
              // ),
              // SizedBox(width: 10.w),
              RadioStationArtwork(
                imageUrl: station.imageUrl,
                heroTag: 'radio_station_${station.id}',
                size: 44.w,
                borderRadius: 14.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الإذاعة الآن',
                      style: context.labelSmall?.copyWith(
                        color: context.primaryColor.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // const MiniEqualizer(),
              SizedBox(width: 4.w),
              IconButton(
                onPressed: () {
                  context.read<RadioBloc>().add(
                        const RadioTogglePlayPauseRequested(),
                      );
                },
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: context.primaryColor,
                  size: 30.sp,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     context.read<RadioBloc>().add(
              //           const RadioStopRequested(),
              //         );
              //   },
              //   icon: Icon(
              //     Icons.close_rounded,
              //     color: context.onSurfaceVariant.withValues(alpha: 0.84),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
