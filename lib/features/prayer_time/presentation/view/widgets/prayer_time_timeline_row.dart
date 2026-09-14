part of 'prayer_time_timeline.dart';

/// صفّ صلاة واحد في الجدول.
///
/// الصفّ الجاري وحده يرتفع (تعبئة + حدّ + ظلّ)؛ بقيّة الصفوف تجلس على
/// الأرضية مباشرة ويفصلها خطّ شعرة.
class _PrayerScheduleRow extends StatelessWidget {
  const _PrayerScheduleRow({
    required this.entry,
    required this.isLast,
  });

  final PrayerTimelineEntry entry;
  final bool isLast;

  bool get _isCurrent => entry.status == PrayerTimelineStatus.current;
  bool get _isNext => entry.status == PrayerTimelineStatus.next;
  bool get _isCompleted => entry.status == PrayerTimelineStatus.completed;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    if (_isCurrent) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: skin.raisedBorder, width: 1.2),
          boxShadow: skin.raisedShadow,
        ),
        padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
        child: Row(
          children: [
            _TimelineIconChip(
              icon: _iconForPrayer(entry.prayer.type),
              skin: skin,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                entry.prayer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: skin.accent,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                'الآن',
                style: TextStyle(
                  color:
                      skin.isDark ? AppColors.brandNight : AppColors.brandIvory,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 7.w),
            _PrayerTimeText(time: entry.prayer.time, raised: true),
          ],
        ),
      );
    }

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          _TimelineIconChip(
            icon: _iconForPrayer(entry.prayer.type),
            skin: skin,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.prayer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        skin.ink.withValues(alpha: _isCompleted ? 0.62 : 0.88),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                Text(
                  _subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (_isNext) ...[
            Text(
              'التالية',
              style: TextStyle(
                color: skin.accent,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 7.w),
          ],
          _PrayerTimeText(time: entry.prayer.time, raised: false),
        ],
      ),
    );
  }

  String get _subtitle {
    if (_isNext) return 'الصلاة القادمة';
    if (_isCompleted) return 'انتهى وقتها';
    return 'الوقت المحلي';
  }

  HugeIconData _iconForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.none:
        return AppIcons.clock;
      case Prayer.fajr:
        return AppIcons.moon;
      case Prayer.sunrise:
        return AppIcons.sunrise;
      case Prayer.dhuhr:
        return AppIcons.sun;
      case Prayer.asr:
        return AppIcons.sun;
      case Prayer.maghrib:
        return AppIcons.sunset;
      case Prayer.isha:
        return AppIcons.moon;
    }
  }
}

class _PrayerTimeText extends StatelessWidget {
  const _PrayerTimeText({required this.time, required this.raised});

  final DateTime time;
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final clock = DateFormat('hh:mm').format(time);
    final period = time.hour < 12 ? 'ص' : 'م';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            clock,
            style: TextStyle(
              color: skin.ink.withValues(alpha: raised ? 1 : 0.88),
              fontSize: raised ? 15.sp : 12.5.sp,
              fontWeight: raised ? FontWeight.w800 : FontWeight.w600,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          period,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
