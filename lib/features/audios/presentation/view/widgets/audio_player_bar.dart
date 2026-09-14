import 'dart:async';
import 'dart:ui' as ui;

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:rxdart/rxdart.dart';

/// موضع التشغيل الحالي: الموضع، والمخزّن مسبقًا، والمدّة الكاملة.
typedef _Position = ({Duration position, Duration buffered, Duration total});

/// شريط المشغّل: التقدّم وأزرار التحكّم هما البطل.
///
/// لا بطاقة حولهما ولا خلفية — يجلسان على أرضية الصفحة، وزرّ التشغيل وحده
/// يرتفع بتعبئة ذهبية.
class AudioPlayerBar extends StatelessWidget {
  const AudioPlayerBar({
    required this.player,
    required this.trackTitleOf,
    super.key,
  });

  final AudioPlayer player;

  /// عنوان المقطع رقم `index` — يأتي من الشاشة لأنها تملك البيانات.
  final String Function(int index) trackTitleOf;

  Stream<_Position> get _positionStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, _Position>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, buffered, total) => (
          position: position,
          buffered: buffered,
          total: total ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<int?>(
            stream: player.currentIndexStream,
            builder: (context, snapshot) {
              final index = snapshot.data ?? player.currentIndex ?? 0;
              return Text(
                trackTitleOf(index),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          StreamBuilder<_Position>(
            stream: _positionStream,
            builder: (context, snapshot) {
              final data = snapshot.data;
              return ProgressBar(
                progress: data?.position ?? Duration.zero,
                buffered: data?.buffered ?? Duration.zero,
                total: data?.total ?? Duration.zero,
                onSeek: (value) => unawaited(player.seek(value)),
                barHeight: 3.h,
                thumbRadius: 5.r,
                progressBarColor: AppColors.gold,
                baseBarColor: skin.hairline,
                bufferedBarColor: skin.hairline,
                thumbColor: AppColors.gold,
                thumbGlowColor: AppColors.gold.withValues(alpha: 0.18),
                timeLabelPadding: 6.h,
                timeLabelTextStyle: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SecondaryControl(
                icon: AppIcons.chevronRight,
                label: 'السابق',
                onTap: () {
                  HapticFeedback.selectionClick();
                  unawaited(player.seekToPrevious());
                },
              ),
              SizedBox(width: 24.w),
              _MainControl(player: player),
              SizedBox(width: 24.w),
              _SecondaryControl(
                icon: AppIcons.chevronLeft,
                label: 'التالي',
                onTap: () {
                  HapticFeedback.selectionClick();
                  unawaited(player.seekToNext());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// زرّ التشغيل الرئيسي — العنصر المرتفع الوحيد في الشاشة.
class _MainControl extends StatelessWidget {
  const _MainControl({required this.player});

  final AudioPlayer player;

  void _onTap(bool playing, ProcessingState? processing) {
    HapticFeedback.selectionClick();
    if (processing == ProcessingState.completed) {
      unawaited(player.seek(Duration.zero, index: 0));
      unawaited(player.play());
      return;
    }
    if (playing) {
      unawaited(player.pause());
    } else {
      unawaited(player.play());
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final onGold = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processing = playerState?.processingState;
        final playing = playerState?.playing ?? false;
        final isBuffering = processing == ProcessingState.loading ||
            processing == ProcessingState.buffering;

        return Semantics(
          button: true,
          label: playing ? 'إيقاف مؤقّت' : 'تشغيل',
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: () => _onTap(playing, processing),
            child: Ink(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: skin.raisedShadow,
              ),
              child: Center(
                child: isBuffering
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(onGold),
                        ),
                      )
                    : AppIcon(
                        playing ? AppIcons.pause : AppIcons.play,
                        color: onGold,
                        size: 26.sp,
                        strokeWidth: 2.2,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// زرّ ثانوي: أيقونة على الأرضية بلا تعبئة ولا حدّ.
class _SecondaryControl extends StatelessWidget {
  const _SecondaryControl({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 38.w,
          height: 38.w,
          child: Center(
            child: AppIcon(
              icon,
              color: skin.ink.withValues(alpha: 0.72),
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
