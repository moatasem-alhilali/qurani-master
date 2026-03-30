import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

Color _alpha(Color color, double value) => color.withValues(alpha: value);

enum PrayerTimelineStatus {
  completed,
  current,
  next,
  upcoming,
}

enum PrayerLocationNoticeType {
  serviceDisabled,
  permissionRequired,
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
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    super.key,
    this.selectedLocation,
    this.noticeType,
    this.noticeMessage,
    this.onResolveNotice,
    this.currentPrayer,
    this.nextPrayer,
  });

  final List<PrayerTimelineEntry> entries;
  final PrayerLocationSelection? selectedLocation;
  final PrayerLocationNoticeType? noticeType;
  final String? noticeMessage;
  final Future<void> Function()? onResolveNotice;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _PrayerTimesHeader(
            selectedLocation: selectedLocation,
            currentPrayer: currentPrayer,
            nextPrayer: nextPrayer,
            onChangeLocation: onChangeLocation,
            onUseCurrentLocation: onUseCurrentLocation,
          ),
          if (noticeType != null &&
              (noticeMessage ?? '').trim().isNotEmpty) ...[
            SizedBox(height: 14.h),
            _PrayerLocationNotice(
              type: noticeType!,
              message: noticeMessage!,
              onResolve: onResolveNotice,
            ),
          ],
          SizedBox(height: 16.h),
          if (entries.isEmpty)
            _PrayerEmptyState(onChangeLocation: onChangeLocation)
          else
            Container(
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: _alpha(context.outlineVariant, 0.4),
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
  const _PrayerTimesHeader({
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    this.selectedLocation,
    this.currentPrayer,
    this.nextPrayer,
  });

  final PrayerLocationSelection? selectedLocation;
  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final location = selectedLocation;

    return Container(
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: _alpha(context.outlineVariant, 0.42),
        ),
      ),
      child: StreamBuilder<int>(
        stream: Stream<int>.periodic(
          const Duration(seconds: 1),
          (count) => count,
        ),
        initialData: 0,
        builder: (context, _) {
          final offsetMinutes = location?.utcOffsetMinutes ??
              DateTime.now().timeZoneOffset.inMinutes;
          final locationNow =
              DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
          final hijri = _HijriDate.fromDate(locationNow);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE، d MMMM yyyy',
                            'ar',
                          ).format(locationNow),
                          style: TextStyle(
                            color: _alpha(context.onSurfaceColor, 0.72),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          hijri.formatArabic(),
                          style: TextStyle(
                            color: _alpha(context.onSurfaceColor, 0.52),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: _alpha(context.primaryColor, 0.1),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      _formatUtcOffset(offsetMinutes),
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('hh:mm:ss a', 'en').format(locationNow),
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'الوقت الحالي',
                        style: TextStyle(
                          color: _alpha(context.onSurfaceColor, 0.6),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        (location?.isManual ?? false)
                            ? 'اختيار يدوي'
                            : 'موقع الجهاز',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: _alpha(context.scaffoldBackgroundColor, 0.45),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: _alpha(context.outlineVariant, 0.28),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: _alpha(context.onSurfaceColor, 0.72),
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location?.label ?? 'لم يتم تحديد موقع بعد',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.onSurfaceColor,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            location == null
                                ? 'اختر مدينة أو استخدم موقع الجهاز'
                                    ' لعرض المواقيت'
                                : location.detailsLabel.isEmpty
                                    ? 'المواقيت معروضة حسب المنطقة المحددة'
                                    : location.detailsLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _alpha(context.onSurfaceColor, 0.54),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  FilledButton.icon(
                    onPressed: onChangeLocation,
                    icon: const Icon(Icons.travel_explore_rounded),
                    label: const Text('تغيير المنطقة'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onUseCurrentLocation,
                    icon: const Icon(Icons.my_location_rounded),
                    label: const Text('موقعي الحالي'),
                  ),
                ],
              ),
              if (currentPrayer != null || nextPrayer != null) ...[
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    if (currentPrayer != null)
                      _PrayerInfoChip(
                        label: 'الحالية',
                        value: currentPrayer!.name,
                        tone: currentPrayer!.type == Prayer.maghrib
                            ? Colors.red
                            : context.primaryColor,
                      ),
                    if (nextPrayer != null)
                      _PrayerInfoChip(
                        label: 'القادمة',
                        value: nextPrayer!.name,
                        tone: context.onSurfaceColor,
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _formatUtcOffset(int minutes) {
    final sign = minutes >= 0 ? '+' : '-';
    final absoluteMinutes = minutes.abs();
    final hours = (absoluteMinutes ~/ 60).toString().padLeft(2, '0');
    final mins = (absoluteMinutes % 60).toString().padLeft(2, '0');
    return 'UTC$sign$hours:$mins';
  }
}

class _PrayerLocationNotice extends StatelessWidget {
  const _PrayerLocationNotice({
    required this.type,
    required this.message,
    this.onResolve,
  });

  final PrayerLocationNoticeType type;
  final String message;
  final Future<void> Function()? onResolve;

  @override
  Widget build(BuildContext context) {
    final actionLabel = type == PrayerLocationNoticeType.serviceDisabled
        ? 'تفعيل الموقع'
        : 'منح الصلاحية';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: _alpha(context.primaryColor, 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _alpha(context.primaryColor, 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: _alpha(context.primaryColor, 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              type == PrayerLocationNoticeType.serviceDisabled
                  ? Icons.location_off_rounded
                  : Icons.lock_open_rounded,
              color: context.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          if (onResolve != null) ...[
            SizedBox(width: 12.w),
            TextButton(
              onPressed: () => onResolve!.call(),
              child: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrayerInfoChip extends StatelessWidget {
  const _PrayerInfoChip({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _alpha(tone, 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: _alpha(context.onSurfaceColor, 0.62),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: tone,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerEmptyState extends StatelessWidget {
  const _PrayerEmptyState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: _alpha(context.outlineVariant, 0.38),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 34.sp,
            color: _alpha(context.onSurfaceColor, 0.5),
          ),
          SizedBox(height: 10.h),
          Text(
            'لا يمكن عرض مواقيت الصلاة قبل تحديد المنطقة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'اختر مدينة يدويًا أو استخدم موقع الجهاز الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _alpha(context.onSurfaceColor, 0.54),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14.h),
          FilledButton.icon(
            onPressed: onChangeLocation,
            icon: const Icon(Icons.travel_explore_rounded),
            label: const Text('اختيار منطقة'),
          ),
        ],
      ),
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
