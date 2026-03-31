part of 'prayer_time_timeline.dart';

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
        color: context.surfaceColor,
        borderRadius: borderRadius,
        border: Border(
          right: BorderSide(
            color: _highlightColor(context),
            width: _isCurrent ? 3 : (_isNext ? 2 : 0.5),
          ),
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: _alpha(context.outlineVariant, 0.32),
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
    if (_isNext) return _alpha(entry.accentColor, 0.72);
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
