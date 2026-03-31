import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

part 'prayer_time_timeline_header.dart';
part 'prayer_time_timeline_notice.dart';
part 'prayer_time_timeline_row.dart';
part 'prayer_time_timeline_hijri_date.dart';

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
