import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';

class NextPrayerCountdownWidget extends StatefulWidget {
  const NextPrayerCountdownWidget({
    required this.nextPrayer,
    required this.remainingTime,
    super.key,
  });

  final TimePrayerModel nextPrayer;
  final Duration remainingTime;

  @override
  State<NextPrayerCountdownWidget> createState() =>
      _NextPrayerCountdownWidgetState();
}

class _NextPrayerCountdownWidgetState extends State<NextPrayerCountdownWidget> {
  late Timer _timer;
  late Duration _currentRemainingTime;

  @override
  void initState() {
    super.initState();
    _currentRemainingTime = widget.remainingTime;
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant NextPrayerCountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextPrayerChanged = oldWidget.nextPrayer.id != widget.nextPrayer.id ||
        oldWidget.nextPrayer.type != widget.nextPrayer.type ||
        oldWidget.nextPrayer.time != widget.nextPrayer.time;
    if (oldWidget.remainingTime != widget.remainingTime || nextPrayerChanged) {
      _currentRemainingTime = widget.remainingTime;
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentRemainingTime.inSeconds > 0) {
          _currentRemainingTime =
              Duration(seconds: _currentRemainingTime.inSeconds - 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  IconData _iconForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.none:
        return Icons.access_time_rounded;
      case Prayer.fajr:
        return Icons.wb_twilight_rounded;
      case Prayer.sunrise:
        return Icons.wb_sunny_outlined;
      case Prayer.dhuhr:
        return Icons.light_mode_rounded;
      case Prayer.asr:
        return Icons.wb_sunny_rounded;
      case Prayer.maghrib:
        return Icons.brightness_5_rounded;
      case Prayer.isha:
        return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      border: Border.all(
        color: context.outlineVariant.withValues(alpha: 0.4),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Icon(
                _iconForPrayer(widget.nextPrayer.type),
                color: context.primaryColor,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: context.bodySmall?.copyWith(
                    color: context.onSurfaceColor.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  widget.nextPrayer.title,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.nextPrayer.time,
                  style: context.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'المتبقي',
                  style: context.bodySmall?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _formatDuration(_currentRemainingTime),
                  style: context.titleSmall?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
