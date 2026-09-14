import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/hijri_date.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

part 'prayer_time_timeline_header.dart';
part 'prayer_time_timeline_notice.dart';
part 'prayer_time_timeline_row.dart';

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
  });

  final PrayerInfoModel prayer;
  final PrayerTimelineStatus status;
}

/// جدول مواقيت اليوم: ترويسة اليوم ثم صفوف نحيلة تفصلها خطوط شعرة.
///
/// لا بطاقة حول القائمة ولا حول كل صفّ؛ الارتفاع محجوز لصفّ الصلاة الجارية
/// وحده، فيقع عليه النظر أولًا.
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
    final skin = AppSkin.of(context);
    final hasNotice =
        noticeType != null && (noticeMessage ?? '').trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrayerTimesHeader(
          selectedLocation: selectedLocation,
          currentPrayer: currentPrayer,
          nextPrayer: nextPrayer,
          onChangeLocation: onChangeLocation,
          onUseCurrentLocation: onUseCurrentLocation,
        ),
        if (hasNotice)
          _PrayerLocationNotice(
            type: noticeType!,
            message: noticeMessage!,
            onResolve: onResolveNotice,
          ),
        skin.divider(),
        if (entries.isEmpty)
          _PrayerEmptyState(onChangeLocation: onChangeLocation)
        else
          Padding(
            padding: AppSkin.gutter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < entries.length; index++)
                  _PrayerScheduleRow(
                    entry: entries[index],
                    isLast: index == entries.length - 1,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
