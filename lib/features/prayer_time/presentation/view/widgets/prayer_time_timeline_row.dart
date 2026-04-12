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
    final rowColor = _rowBackgroundColor(context);
    final rowBorderColor = _rowBorderColor(context);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Container(
            decoration: BoxDecoration(
              color: rowColor,
              borderRadius: borderRadius,
              boxShadow: _isCurrent
                  ? [
                      BoxShadow(
                        color: _alpha(entry.accentColor, 0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
              border: Border.all(
                color: rowBorderColor,
                width: _isCurrent ? 1.2 : 0.8,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
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
                          ),
                          if (_isCurrent) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _alpha(entry.accentColor, 0.18),
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(
                                  color: _alpha(entry.accentColor, 0.38),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    size: 13.sp,
                                    color: entry.accentColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'الآن',
                                    style: TextStyle(
                                      color: entry.accentColor,
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
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
                _PrayerTimesColumn(entry: entry, isCurrent: _isCurrent),
              ],
            ),
          ),
          if (_isCurrent || _isNext)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: _isCurrent ? 3.w : 2.w,
                decoration: BoxDecoration(
                  color: _highlightColor(context),
                  borderRadius: BorderRadius.only(
                    topRight: isFirst ? Radius.circular(22.r) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(22.r) : Radius.zero,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String get _subtitle {
    if (_isCurrent) return 'الصلاة الحالية الآن';
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

  Color _rowBackgroundColor(BuildContext context) {
    if (_isCurrent) return _alpha(entry.accentColor, 0.08);
    if (_isNext) return _alpha(entry.accentColor, 0.045);
    return context.surfaceColor;
  }

  Color _rowBorderColor(BuildContext context) {
    if (_isCurrent) return _alpha(entry.accentColor, 0.35);
    if (_isNext) return _alpha(entry.accentColor, 0.2);
    return _alpha(context.outlineVariant, 0.16);
  }
}

class _PrayerIcon extends StatelessWidget {
  const _PrayerIcon({required this.entry});

  final PrayerTimelineEntry entry;
  bool get _isCurrent => entry.status == PrayerTimelineStatus.current;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: _isCurrent
            ? _alpha(entry.accentColor, 0.2)
            : _alpha(entry.accentColor, 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: _isCurrent
            ? Border.all(
                color: _alpha(entry.accentColor, 0.35),
              )
            : null,
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
  const _PrayerTimesColumn({
    required this.entry,
    required this.isCurrent,
  });

  final PrayerTimelineEntry entry;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final clock12 = DateFormat('hh:mm').format(entry.prayer.time);
    final period = entry.prayer.time.hour < 12 ? 'ص' : 'م';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clock12,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isCurrent ? entry.accentColor : context.onSurfaceColor,
              fontSize: 18.sp,
              fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w800,
              height: 1.05,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            period,
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
