import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/pages/radio_now_playing_screen.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class RadioMiniPlayerWidget extends StatelessWidget {
  const RadioMiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioBloc, RadioState>(
      buildWhen: (previous, current) =>
          previous.currentStation != current.currentStation ||
          previous.playbackStatus != current.playbackStatus,
      builder: (context, state) {
        final station = state.currentStation;
        if (station == null ||
            state.playbackStatus == RadioPlaybackStatus.idle ||
            state.playbackStatus == RadioPlaybackStatus.stopped) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(
                  BlocProvider.value(
                    value: context.read<RadioBloc>(),
                    child: RadioNowPlayingScreen(station: station),
                  ),
                ),
                borderRadius: BorderRadius.circular(22.r),
                child: Ink(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      context.primaryColor.withValues(alpha: 0.04),
                      context.surfaceColor,
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: context.primaryColor.withValues(alpha: 0.10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadow.withValues(alpha: 0.10),
                        blurRadius: 14.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      RadioStationArtwork(
                        imageUrl: station.imageUrl,
                        heroTag: 'radio_station_${station.id}',
                        size: 48.w,
                        borderRadius: 16.r,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إذاعة تعمل الآن',
                              style: context.labelSmall?.copyWith(
                                color: context.primaryColor,
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
                      Container(
                        width: 1,
                        height: 32.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        color: context.outline.withValues(alpha: 0.10),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<RadioBloc>().add(
                                const RadioTogglePlayPauseRequested(),
                              );
                        },
                        icon: Icon(
                          state.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: context.primaryColor,
                          size: 28.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<RadioBloc>().add(
                                const RadioStopRequested(),
                              );
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: context.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
