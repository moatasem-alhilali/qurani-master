import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';

Color _alpha(Color color, double value) => color.withValues(alpha: value);

enum PrayerTimelineStatus {
  completed,
  current,
  next,
  upcoming,
}

class PrayerTimelineEntry {
  const PrayerTimelineEntry({
    required this.prayer,
    required this.status,
    required this.accentColor,
  });

  final PrayerInfoModel prayer;
  final PrayerTimelineStatus status;
  final Color accentColor;
}

class PrayerTimeTimeline extends StatelessWidget {
  const PrayerTimeTimeline({
    required this.entries,
    super.key,
  });

  final List<PrayerTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          const _PrayerTimesHeader(),
          SizedBox(height: 14.h),
          Container(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: _alpha(context.outlineVariant, 0.45),
              ),
            ),
            child: Column(
              children: entries.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return _PrayerScheduleRow(
                  entry: item,
                  isFirst: index == 0,
                  isLast: index == entries.length - 1,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimesHeader extends StatelessWidget {
  const _PrayerTimesHeader();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final gregorian = DateFormat('EEEE، d MMMM yyyy', 'ar').format(now);
    final currentTime = DateFormat('jm', 'ar').format(now);

    return Column(
      children: [
        Text(
          gregorian,
          style: TextStyle(
            color: _alpha(context.onSurfaceColor, 0.78),
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          currentTime,
          style: TextStyle(
            color: context.onSurfaceColor,
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _alpha(context.surfaceColor, 0.92),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: _alpha(context.outlineVariant, 0.45),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: _alpha(context.onSurfaceColor, 0.7),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'الموقع الحالي',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'مواقيت اليوم',
                style: TextStyle(
                  color: _alpha(context.onSurfaceColor, 0.56),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrayerScheduleRow extends StatelessWidget {
  const _PrayerScheduleRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  final PrayerTimelineEntry entry;
  final bool isFirst;
  final bool isLast;

  bool get _isCurrent => entry.status == PrayerTimelineStatus.current;
  bool get _isNext => entry.status == PrayerTimelineStatus.next;
  bool get _isCompleted => entry.status == PrayerTimelineStatus.completed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: isFirst ? Radius.circular(22.r) : Radius.zero,
      bottom: isLast ? Radius.circular(22.r) : Radius.zero,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: _rowGradient(context),
        border: Border(
          right: BorderSide(
            color: _highlightColor(context),
            width: _isCurrent ? 3.4 : (_isNext ? 2.2 : 0.8),
          ),
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: _alpha(context.outlineVariant, 0.35),
                ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          _PrayerIcon(entry: entry),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.prayer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _titleColor(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _alpha(context.onSurfaceColor, 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _PrayerTimesColumn(entry: entry),
        ],
      ),
    );
  }

  Gradient _rowGradient(BuildContext context) {
    if (_isCurrent) {
      return LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          _alpha(entry.accentColor, 0.18),
          _alpha(entry.accentColor, 0.06),
          context.surfaceColor,
        ],
      );
    }

    if (_isNext) {
      return LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          _alpha(entry.accentColor, 0.1),
          context.surfaceColor,
          context.surfaceColor,
        ],
      );
    }

    return LinearGradient(
      colors: [
        context.surfaceColor,
        context.surfaceColor,
      ],
    );
  }

  String get _subtitle {
    if (_isCurrent) return 'الصلاة الحالية';
    if (_isNext) return 'الصلاة القادمة';
    if (_isCompleted) return 'انتهى وقتها';
    return 'الوقت المحلي';
  }

  Color _titleColor(BuildContext context) {
    if (_isCurrent) return entry.accentColor;
    if (_isCompleted) return _alpha(context.onSurfaceColor, 0.72);
    return context.onSurfaceColor;
  }

  Color _highlightColor(BuildContext context) {
    if (_isCurrent) return entry.accentColor;
    if (_isNext) return _alpha(entry.accentColor, 0.7);
    return Colors.transparent;
  }
}

class _PrayerIcon extends StatelessWidget {
  const _PrayerIcon({required this.entry});

  final PrayerTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: _alpha(entry.accentColor, 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _iconForPrayer(entry.prayer.type),
        color: entry.accentColor,
        size: 18.sp,
      ),
    );
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
}

class _PrayerTimesColumn extends StatelessWidget {
  const _PrayerTimesColumn({required this.entry});

  final PrayerTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.prayer.time12,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            entry.prayer.time24,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _alpha(context.onSurfaceColor, 0.52),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}
