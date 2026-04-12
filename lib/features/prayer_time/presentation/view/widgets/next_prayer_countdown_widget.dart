import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';

class NextPrayerCountdownWidget extends StatelessWidget {
  const NextPrayerCountdownWidget({
    this.nextPrayer,
    this.remainingTime,
    this.currentPrayerName,
    this.locationLabel,
    this.utcOffsetMinutes,
    this.useBlocFallback = true,
    super.key,
  }) : assert(
          (nextPrayer == null && remainingTime == null) ||
              (nextPrayer != null && remainingTime != null),
          'nextPrayer and remainingTime must be provided together.',
        );

  final TimePrayerModel? nextPrayer;
  final Duration? remainingTime;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;
  final bool useBlocFallback;

  @override
  Widget build(BuildContext context) {
    final manualPrayer = nextPrayer;
    final manualRemainingTime = remainingTime;
    if (manualPrayer != null && manualRemainingTime != null) {
      return _NextPrayerCountdownCard(
        nextPrayer: manualPrayer,
        remainingTime: manualRemainingTime,
        currentPrayerName: currentPrayerName,
        locationLabel: locationLabel,
        utcOffsetMinutes: utcOffsetMinutes,
      );
    }

    if (!useBlocFallback) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        if (state.prayerState != RequestState.success ||
            state.nextPrayer == null) {
          return const SizedBox.shrink();
        }

        final remainingTime =
            state.nextPrayer!.time.difference(_resolveLocationNow(state));
        final safeRemainingTime =
            remainingTime.isNegative ? Duration.zero : remainingTime;

        final nextPrayerModel = TimePrayerModel(
          id: 999,
          title: state.nextPrayer!.name,
          time: state.nextPrayer!.time12,
          type: state.nextPrayer!.type,
          image: state.nextPrayer!.type.imageAsset,
          content: state.nextPrayer!.description,
          color: Colors.blue,
        );

        return _NextPrayerCountdownCard(
          nextPrayer: nextPrayerModel,
          remainingTime: safeRemainingTime,
          currentPrayerName: state.currentPrayer?.name,
          locationLabel: state.selectedLocation?.label,
          utcOffsetMinutes: state.selectedLocation?.utcOffsetMinutes,
        );
      },
    );
  }

  DateTime _resolveLocationNow(PrayerTimeState state) {
    final offsetMinutes = state.selectedLocation?.utcOffsetMinutes;
    if (offsetMinutes == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
  }
}

class _NextPrayerCountdownCard extends StatefulWidget {
  const _NextPrayerCountdownCard({
    required this.nextPrayer,
    required this.remainingTime,
    this.currentPrayerName,
    this.locationLabel,
    this.utcOffsetMinutes,
  });

  final TimePrayerModel nextPrayer;
  final Duration remainingTime;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;

  @override
  State<_NextPrayerCountdownCard> createState() =>
      _NextPrayerCountdownCardState();
}

class _NextPrayerCountdownCardState extends State<_NextPrayerCountdownCard> {
  late Timer _timer;
  late Duration _currentRemainingTime;

  @override
  void initState() {
    super.initState();
    _currentRemainingTime = widget.remainingTime;
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant _NextPrayerCountdownCard oldWidget) {
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

  String _formatClock12(DateTime date) => DateFormat('hh:mm').format(date);

  String _periodArabic(DateTime date) => date.hour < 12 ? 'ص' : 'م';

  DateTime _resolveLocationNow() {
    final offsetMinutes = widget.utcOffsetMinutes;
    if (offsetMinutes == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
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
    final locationNow = _resolveLocationNow();
    final hijri = _HijriDate.fromDate(locationNow).formatArabic();
    final currentPrayerLabel =
        widget.currentPrayerName ?? widget.nextPrayer.title;
    final locationLabel = widget.locationLabel ?? 'الموقع';
    final dateText = DateFormat('y/M/d').format(locationNow);
    final clockText =
        '${_formatClock12(locationNow)} ${_periodArabic(locationNow)}';
    final statusLine = '$dateText • $clockText • $currentPrayerLabel';

    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      border: Border.all(
        color: context.outlineVariant.withValues(alpha: 0.4),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.onSurfaceColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '$hijri • $locationLabel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(
                          color: context.onSurfaceColor.withValues(alpha: 0.64),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4E9D37),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/image/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Icon(
                    _iconForPrayer(widget.nextPrayer.type),
                    color: context.primaryColor,
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
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
                    SizedBox(height: 2.h),
                    Text(
                      '${widget.nextPrayer.title} • ${widget.nextPrayer.time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
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
        ],
      ),
    );
  }
}

class _HijriDate {
  _HijriDate(this.day, this.month, this.year);

  factory _HijriDate.fromDate(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    final julianDay = date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;

    var l = julianDay - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    return _HijriDate(day, month, year);
  }

  final int day;
  final int month;
  final int year;

  static const _months = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  String formatArabic() {
    final monthName = _months[(month - 1).clamp(0, _months.length - 1)];
    return '$day $monthName $year هـ';
  }
}
