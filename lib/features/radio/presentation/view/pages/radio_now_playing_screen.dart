import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class RadioNowPlayingScreen extends StatelessWidget {
  const RadioNowPlayingScreen({
    required this.station,
    super.key,
  });

  final RadioStationModel station;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'الآن يعمل',
      showLargeHeader: false,
      initialOffset: 0,
      body: BlocBuilder<RadioBloc, RadioState>(
        builder: (context, state) {
          final currentStation = state.currentStation ?? station;
          final accent = context.primaryColor;
          final secondaryAccent = context.secondaryColor;

          return Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 0.92,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: RadioStationArtwork(
                            imageUrl: currentStation.imageUrl,
                            heroTag: 'radio_station_${currentStation.id}',
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
                                  context.scrim.withValues(alpha: 0.68),
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
                          top: 22.h,
                          left: 22.w,
                          child: Container(
                            width: 78.w,
                            height: 78.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: secondaryAccent.withValues(alpha: 0.14),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 22.h,
                          right: 22.w,
                          left: 22.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: context.surfaceColor
                                      .withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(999.r),
                                  border: Border.all(
                                    color: context.onPrimaryColor
                                        .withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  'إذاعة مباشرة',
                                  style: context.labelMedium?.copyWith(
                                    color: context.onPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: context.surfaceColor
                                      .withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: Icon(
                                  state.isPlaying
                                      ? Icons.graphic_eq_rounded
                                      : Icons.radio_outlined,
                                  color: context.onPrimaryColor,
                                  size: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 26.w,
                          left: 26.w,
                          bottom: 28.h,
                          child: Column(
                            children: [
                              Text(
                                currentStation.name,
                                textAlign: TextAlign.center,
                                style: context.headlineSmall?.copyWith(
                                  color: context.onPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                state.isPlaying
                                    ? 'البث مستمر الآن ويمكنك المتابعة من '
                                        'الخلفية'
                                    : state.isLoadingPlayback
                                        ? 'جارٍ الاتصال بالمحطة المختارة'
                                        : 'المحطة محددة وجاهزة للتشغيل',
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
                SizedBox(height: 18.h),
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
                              icon: state.isPlaying
                                  ? Icons.play_circle_rounded
                                  : Icons.radio_button_checked_rounded,
                              label: state.isPlaying
                                  ? 'على الهواء الآن'
                                  : 'المحطة المختارة',
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
                                state.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              label: Text(
                                state.isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
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
          );
        },
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
