import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

final BoxController radioPlayerBoxController = BoxController();
bool _pendingRadioPlayerOpen = false;

void openRadioPlayerBox() {
  _pendingRadioPlayerOpen = true;
  if (radioPlayerBoxController.isAttached) {
    radioPlayerBoxController
      ..showBox()
      ..openBox();
  }
}

void closeRadioPlayerBox() {
  _pendingRadioPlayerOpen = false;
  if (radioPlayerBoxController.isAttached) {
    radioPlayerBoxController.closeBox();
  }
}

class RadioMiniPlayerWidget extends StatefulWidget {
  const RadioMiniPlayerWidget({super.key});

  @override
  State<RadioMiniPlayerWidget> createState() => _RadioMiniPlayerWidgetState();
}

class _RadioMiniPlayerWidgetState extends State<RadioMiniPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RadioBloc, RadioState>(
      listenWhen: (previous, current) =>
          previous.currentStation != current.currentStation ||
          previous.playbackStatus != current.playbackStatus,
      listener: (context, state) {
        if (!radioPlayerBoxController.isAttached) {
          return;
        }

        if (!state.hasActiveStation ||
            state.playbackStatus == RadioPlaybackStatus.idle ||
            state.playbackStatus == RadioPlaybackStatus.stopped) {
          _pendingRadioPlayerOpen = false;
          radioPlayerBoxController.hideBox();
          return;
        }

        radioPlayerBoxController.showBox();
        if (_pendingRadioPlayerOpen) {
          radioPlayerBoxController.openBox();
          _pendingRadioPlayerOpen = false;
        }
      },
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
            child: SizedBox(
              height: context.getScreenHeight() * 0.82,
              child: SlidingBox(
                controller: radioPlayerBoxController,
                minHeight: 86.h,
                maxHeight: context.getScreenHeight() * 0.82,
                color: context.surfaceColor,
                style: BoxStyle.shadow,
                draggableIconVisible: false,
                collapsed: true,
                borderRadius: BorderRadius.circular(28.r),
                collapsedBody: _CollapsedRadioPlayer(
                  station: station,
                  isPlaying: state.isPlaying,
                ),
                body: _ExpandedRadioPlayer(
                  station: station,
                  isPlaying: state.isPlaying,
                  isLoading: state.isLoadingPlayback,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CollapsedRadioPlayer extends StatelessWidget {
  const _CollapsedRadioPlayer({
    required this.station,
    required this.isPlaying,
  });

  final RadioStationModel station;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: openRadioPlayerBox,
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
                  isPlaying
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
    );
  }
}

class _ExpandedRadioPlayer extends StatelessWidget {
  const _ExpandedRadioPlayer({
    required this.station,
    required this.isPlaying,
    required this.isLoading,
  });

  final RadioStationModel station;
  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final secondaryAccent = context.secondaryColor;
    final artworkHeight = context.getScreenHeight() * 0.34;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: closeRadioPlayerBox,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: context.surfaceVariant.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.onSurfaceColor,
                      size: 26.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'الإذاعة',
                    textAlign: TextAlign.center,
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 44.w),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: artworkHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RadioStationArtwork(
                        imageUrl: station.imageUrl,
                        heroTag: 'radio_station_${station.id}',
                        borderRadius: 32.r,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.scrim.withValues(alpha: 0.10),
                              context.scrim.withValues(alpha: 0.70),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 18.w,
                      child: Container(
                        width: 76.w,
                        height: 76.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryAccent.withValues(alpha: 0.14),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      right: 20.w,
                      left: 20.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _GlassBadge(
                            label: 'إذاعة مباشرة',
                            icon: Icons.radio_rounded,
                          ),
                          _GlassBadge(
                            label: isPlaying ? 'يعمل الآن' : 'جاهزة',
                            icon: isPlaying
                                ? Icons.graphic_eq_rounded
                                : Icons.pause_circle_outline_rounded,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 28.h,
                      child: Column(
                        children: [
                          Text(
                            station.name,
                            textAlign: TextAlign.center,
                            style: context.headlineSmall?.copyWith(
                              color: context.onPrimaryColor,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            isPlaying
                                ? 'البث مستمر ويمكنك إغلاق المشغل دون إيقافه'
                                : isLoading
                                    ? 'جارٍ الاتصال بالمحطة المختارة'
                                    : 'المحطة جاهزة للتشغيل',
                            textAlign: TextAlign.center,
                            style: context.bodyMedium?.copyWith(
                              color: context.onPrimaryColor
                                  .withValues(alpha: 0.86),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.r),
                color: context.surfaceColor,
                border: Border.all(
                  color: context.outline.withValues(alpha: 0.10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.shadow.withValues(alpha: 0.08),
                    blurRadius: 18.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _RadioMetaChip(
                          icon: isPlaying
                              ? Icons.play_circle_rounded
                              : Icons.radio_button_checked_rounded,
                          label:
                              isPlaying ? 'على الهواء الآن' : 'المحطة المختارة',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      const Expanded(
                        child: _RadioMetaChip(
                          icon: Icons.notifications_active_rounded,
                          label: 'يدعم إشعار النظام',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<RadioBloc>().add(
                                  const RadioStopRequested(),
                                );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(52.h),
                          ),
                          icon: const Icon(Icons.stop_rounded),
                          label: const Text('إيقاف'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            context.read<RadioBloc>().add(
                                  const RadioTogglePlayPauseRequested(),
                                );
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: Size.fromHeight(52.h),
                            backgroundColor: accent,
                            foregroundColor: context.onPrimaryColor,
                          ),
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
                          ),
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

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.surfaceColor.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: context.onPrimaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: context.onPrimaryColor,
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: context.labelMedium?.copyWith(
              color: context.onPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioMetaChip extends StatelessWidget {
  const _RadioMetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: context.surfaceVariant.withValues(alpha: 0.44),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: context.primaryColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: context.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
