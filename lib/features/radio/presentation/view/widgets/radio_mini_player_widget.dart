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
                minHeight: 92.h,
                maxHeight: context.getScreenHeight() * 0.82,
                color: Color.alphaBlend(
                  context.primaryContainer.withValues(alpha: 0.10),
                  context.surfaceColor,
                ),
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
    final barColor = Color.alphaBlend(
      context.primaryContainer.withValues(alpha: 0.18),
      context.surfaceColor,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: openRadioPlayerBox,
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
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor.withValues(alpha: 0.14),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: context.primaryColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
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
              const _MiniEqualizer(),
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
              IconButton(
                onPressed: () {
                  context.read<RadioBloc>().add(
                        const RadioStopRequested(),
                      );
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: context.onSurfaceVariant.withValues(alpha: 0.84),
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
    final artworkHeight = context.getScreenHeight() * 0.28;
    final panelSurface = Color.alphaBlend(
      context.primaryContainer.withValues(alpha: 0.12),
      context.surfaceColor,
    );
    final primaryText = context.onSurfaceColor;
    final secondaryText = context.onSurfaceVariant.withValues(alpha: 0.78);

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                panelSurface,
                Color.alphaBlend(
                  accent.withValues(alpha: 0.08),
                  panelSurface,
                ),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 54.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: context.outline.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _ActionCircleButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      onTap: closeRadioPlayerBox,
                    ),
                    Expanded(
                      child: Text(
                        'المشغل',
                        textAlign: TextAlign.center,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.surfaceVariant.withValues(alpha: 0.24),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: context.onSurfaceVariant,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: artworkHeight + 58.w,
                        height: artworkHeight + 58.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withValues(alpha: 0.22),
                              secondaryAccent.withValues(alpha: 0.06),
                              accent.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34.r),
                          border: Border.all(
                            color: context.outline.withValues(alpha: 0.18),
                          ),
                          color: Color.alphaBlend(
                            context.surfaceVariant.withValues(alpha: 0.40),
                            context.surfaceColor,
                          ),
                        ),
                        child: RadioStationArtwork(
                          imageUrl: station.imageUrl,
                          heroTag: 'radio_station_${station.id}',
                          size: artworkHeight,
                          borderRadius: 28.r,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  station.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.headlineSmall?.copyWith(
                    color: primaryText,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  isPlaying
                      ? 'بث مباشر مستمر'
                      : isLoading
                          ? 'جارٍ الاتصال بالمحطة'
                          : 'المحطة جاهزة الآن',
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                    color: secondaryText,
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _GlassBadge(
                      label: 'LIVE',
                      icon: Icons.fiber_manual_record_rounded,
                    ),
                    SizedBox(width: 8.w),
                    _GlassBadge(
                      label: isPlaying ? 'يعمل الآن' : 'في الانتظار',
                      icon: isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.pause_circle_outline_rounded,
                    ),
                  ],
                ),
                SizedBox(height: 26.h),
                Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: context.outlineVariant.withValues(alpha: 0.55),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 110.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        gradient: LinearGradient(
                          colors: [
                            accent,
                            secondaryAccent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      'مباشر',
                      style: context.labelSmall?.copyWith(
                        color: secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'إذاعة',
                      style: context.labelSmall?.copyWith(
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
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
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionCircleButton(
                      icon: Icons.stop_rounded,
                      onTap: () {
                        context.read<RadioBloc>().add(
                              const RadioStopRequested(),
                            );
                      },
                    ),
                    Container(
                      width: 86.w,
                      height: 86.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accent,
                            secondaryAccent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.34),
                            blurRadius: 24.r,
                            offset: Offset(0, 12.h),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<RadioBloc>().add(
                                const RadioTogglePlayPauseRequested(),
                              );
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: context.onPrimaryColor,
                          size: 34.sp,
                        ),
                      ),
                    ),
                    _ActionCircleButton(
                      icon: Icons.close_rounded,
                      onTap: () {
                        context.read<RadioBloc>().add(
                              const RadioStopRequested(),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        color: Color.alphaBlend(
          context.primaryContainer.withValues(alpha: 0.22),
          context.surfaceColor.withValues(alpha: 0.88),
        ),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: context.primaryColor,
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: context.labelMedium?.copyWith(
              color: context.onSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  const _ActionCircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.alphaBlend(
              context.surfaceVariant.withValues(alpha: 0.58),
              context.surfaceColor,
            ),
            border: Border.all(
              color: context.outline.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(
            icon,
            color: context.onSurfaceColor,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}

class _MiniEqualizer extends StatelessWidget {
  const _MiniEqualizer();

  @override
  Widget build(BuildContext context) {
    final bars = [10.h, 16.h, 12.h];

    return Row(
      children: bars
          .map(
            (height) => Container(
              width: 3.w,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: context.primaryColor.withValues(alpha: 0.82),
              ),
            ),
          )
          .toList(),
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
