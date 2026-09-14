import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/hijri_date.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_settings_screen.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_location_picker_sheet.dart';

/// شاشة مواقيت اليوم كاملة.
///
/// الصفحة سطح واحد على `skin.ground`: ترويسة اليوم، ثم صفّ الموقع، ثم
/// المواقيت صفوفًا نحيلة تفصلها خطوط شعرة. الارتفاع محجوز لصفّ واحد فقط:
/// الصلاة الجارية (أو القادمة إن لم تدخل بعد).
class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // الهيكل نفسه يأخذ لون الأرضية، فلا يبقى خطّ قطع بين الترويسة والمحتوى.
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'أوقات الصلاة',
        trailing: IconButton(
          tooltip: 'إعدادات أوقات الصلاة',
          onPressed: () {
            context.push(
              BlocProvider.value(
                value: context.read<PrayerTimeBloc>(),
                child: const PrayerTimeSettingsScreen(),
              ),
            );
          },
          icon: AppIcon(AppIcons.settings, size: 16.sp, color: skin.accent),
        ),
        body: ColoredBox(
          color: skin.ground,
          child: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
            builder: (context, state) {
              final list = state.prayerState == RequestState.loading
                  ? PrayerInfoModel.dummy()
                  : state.prayerList;
              final locationNow = _resolveLocationNow(
                state.selectedLocation?.utcOffsetMinutes,
              );
              final entries = _buildEntries(
                list: list,
                currentPrayer: state.currentPrayer,
                nextPrayer: state.nextPrayer,
                locationNow: locationNow,
              );
              final content = _PrayerTimesTodayView(
                state: state,
                entries: entries,
                locationNow: locationNow,
                onChangeLocation: () => _openLocationPicker(context, state),
                onUseCurrentLocation: () {
                  context.read<PrayerTimeBloc>().add(
                        const PrayerTimeUseCurrentDeviceLocationRequested(),
                      );
                },
                onOpenSettings: () => _openSettingsForLocationStatus(
                  context,
                  state,
                ),
                onRetry: () {
                  context
                      .read<PrayerTimeBloc>()
                      .add(const PrayerTimeInitRequested());
                },
              );

              if (state.prayerState == RequestState.loading &&
                  state.locationStatus == PrayerLocationStatus.resolving) {
                return ShimmerSkeletonizerWidget(child: content);
              }

              return content;
            },
          ),
        ),
      ),
    );
  }

  List<_PrayerDayEntry> _buildEntries({
    required List<PrayerInfoModel> list,
    required PrayerInfoModel? currentPrayer,
    required PrayerInfoModel? nextPrayer,
    required DateTime locationNow,
  }) {
    return list.map((prayer) {
      final isCurrent = _isSamePrayerOccurrence(prayer, currentPrayer);
      final isNext = _isSamePrayerOccurrence(prayer, nextPrayer);
      final isPassed = _isPrayerPassed(
        prayer: prayer,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        locationNow: locationNow,
      );

      return _PrayerDayEntry(
        prayer: prayer,
        status: isCurrent
            ? _PrayerDayStatus.current
            : isNext
                ? _PrayerDayStatus.next
                : isPassed
                    ? _PrayerDayStatus.passed
                    : _PrayerDayStatus.upcoming,
      );
    }).toList();
  }

  Future<void> _openLocationPicker(
    BuildContext context,
    PrayerTimeState state,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return PrayerLocationPickerSheet(
          initialLocation: state.selectedLocation,
          onUseCurrentLocation: () async {
            context.read<PrayerTimeBloc>().add(
                  const PrayerTimeUseCurrentDeviceLocationRequested(),
                );
          },
          onLocationSelected: (selection) async {
            context.read<PrayerTimeBloc>().add(
                  PrayerTimeManualLocationSelected(selection),
                );
          },
        );
      },
    );
  }

  Future<void> _openSettingsForLocationStatus(
    BuildContext context,
    PrayerTimeState state,
  ) async {
    switch (state.locationStatus) {
      case PrayerLocationStatus.serviceDisabled:
        await _openLocationSettings(context);
      case PrayerLocationStatus.permissionDenied:
      case PrayerLocationStatus.permissionDeniedForever:
        await _openPermissionSettings(context);
      case PrayerLocationStatus.initial:
      case PrayerLocationStatus.resolving:
      case PrayerLocationStatus.ready:
      case PrayerLocationStatus.error:
        return;
    }
  }

  Future<void> _openLocationSettings(BuildContext context) async {
    await Geolocator.openLocationSettings();
    if (!context.mounted) return;
    context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
  }

  Future<void> _openPermissionSettings(BuildContext context) async {
    await openAppSettings();
    if (!context.mounted) return;
    context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
  }

  DateTime _resolveLocationNow(int? utcOffsetMinutes) {
    if (utcOffsetMinutes == null) {
      return DateTime.now();
    }

    return DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes));
  }

  bool _isSamePrayerOccurrence(
    PrayerInfoModel prayer,
    PrayerInfoModel? target,
  ) {
    if (target == null) return false;

    return prayer.type == target.type &&
        prayer.time.year == target.time.year &&
        prayer.time.month == target.time.month &&
        prayer.time.day == target.time.day;
  }

  bool _isPrayerPassed({
    required PrayerInfoModel prayer,
    required PrayerInfoModel? currentPrayer,
    required PrayerInfoModel? nextPrayer,
    required DateTime locationNow,
  }) {
    if (_isSamePrayerOccurrence(prayer, currentPrayer)) return false;
    if (_isSamePrayerOccurrence(prayer, nextPrayer)) return false;

    return prayer.time.isBefore(locationNow);
  }
}

class _PrayerTimesTodayView extends StatelessWidget {
  const _PrayerTimesTodayView({
    required this.state,
    required this.entries,
    required this.locationNow,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final PrayerTimeState state;
  final List<_PrayerDayEntry> entries;
  final DateTime locationNow;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final highlight = _highlightIndex;
    final passed = entries
        .where((entry) => entry.status == _PrayerDayStatus.passed)
        .length;
    final upcoming = entries
        .where((entry) => entry.status == _PrayerDayStatus.upcoming)
        .length;
    final next = entries
        .where((entry) => entry.status == _PrayerDayStatus.next)
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DayHeader(
          locationNow: locationNow,
          progress: _dayProgress(locationNow),
        ),
        _LocationRow(
          selectedLocation: state.selectedLocation,
          onChangeLocation: onChangeLocation,
          onUseCurrentLocation: onUseCurrentLocation,
        ),
        if (_shouldShowNotice(state))
          _LocationNoticeRow(
            message: (state.locationStatusMessage ?? '').trim().isEmpty
                ? 'تعذر تحديث الموقع الحالي.'
                : state.locationStatusMessage!.trim(),
            needsAction: _noticeNeedsAction(state),
            onGrantPermission: onUseCurrentLocation,
            onOpenSettings: onOpenSettings,
            onRetry: onRetry,
          ),
        skin.divider(),
        const HomeSectionHeader(title: 'مواقيت اليوم'),
        _DaySummaryLine(
          passed: passed,
          upcoming: upcoming,
          nextTime: next == null ? null : _formatPrayerTime(next.prayer.time),
        ),
        if (entries.isEmpty)
          _EmptyPrayerState(onChangeLocation: onChangeLocation)
        else
          _PrayerScheduleList(
            entries: entries,
            highlightIndex: highlight,
            windowProgress: _windowProgress,
            remainingText: _remainingText(_remainingToNext),
          ),
        SizedBox(height: 26.h),
      ],
    );
  }

  /// الصفّ الوحيد المسموح له بالارتفاع: الجارية، فإن غابت فالقادمة.
  int get _highlightIndex {
    final current =
        entries.indexWhere((e) => e.status == _PrayerDayStatus.current);
    if (current != -1) return current;
    return entries.indexWhere((e) => e.status == _PrayerDayStatus.next);
  }

  Duration get _remainingToNext {
    final next = state.nextPrayer;
    if (next == null) return Duration.zero;
    return next.time.difference(locationNow);
  }

  /// ما مضى من وقت الصلاة الجارية إلى التي بعدها، من ٠ إلى ١.
  double get _windowProgress {
    final current = state.currentPrayer;
    final next = state.nextPrayer;
    if (current == null || next == null) return 0;

    final total = next.time.difference(current.time).inSeconds;
    if (total <= 0) return 0;

    final passed = locationNow.difference(current.time).inSeconds;
    return (passed / total).clamp(0.0, 1.0);
  }

  double _dayProgress(DateTime locationNow) {
    final start =
        DateTime(locationNow.year, locationNow.month, locationNow.day);
    final end = start.add(const Duration(days: 1));
    final total = end.difference(start).inSeconds;
    final passed = locationNow.difference(start).inSeconds.clamp(0, total);
    return passed / total;
  }

  bool _shouldShowNotice(PrayerTimeState state) {
    return state.locationStatus == PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever ||
        state.locationStatus == PrayerLocationStatus.error;
  }

  bool _noticeNeedsAction(PrayerTimeState state) {
    return state.locationStatus == PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever;
  }
}

/// ترويسة اليوم: التاريخ الميلادي والهجري، والساعة، وخيط تقدّم اليوم.
class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.locationNow, required this.progress});

  final DateTime locationNow;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hijri = HijriDate.fromDate(locationNow);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('EEEE، d MMMM yyyy', 'ar').format(locationNow),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      hijri.formatArabic(),
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
              SizedBox(width: 8.w),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  _formatClock(locationNow),
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // خيط رفيع يقيس ما مضى من اليوم — بديل القرص الدوّار.
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 2.h,
              backgroundColor: skin.hairline,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

/// صفّ الموقع: ضغطة على الصفّ تفتح المنتقي، والزرّ الصغير يأخذ موقع الجهاز.
class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.selectedLocation,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
  });

  final PrayerLocationSelection? selectedLocation;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final label = selectedLocation?.label.trim();
    final details = selectedLocation?.detailsLabel.trim();
    final isManual = selectedLocation?.isManual ?? false;
    final sourceLabel = isManual ? 'اختيار يدوي' : 'موقع الجهاز';
    final subtitle = (details == null || details.isEmpty)
        ? (label == null || label.isEmpty
            ? 'اختر مدينة أو استخدم موقع الجهاز'
            : sourceLabel)
        : '$details · $sourceLabel';

    return InkWell(
      onTap: onChangeLocation,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: skin.hairline)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
        child: Row(
          children: [
            _IconChip(icon: AppIcons.mapPin, skin: skin),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (label == null || label.isEmpty)
                        ? 'لم يتم تحديد موقع بعد'
                        : label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
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
            SizedBox(width: 8.w),
            _MiniIconButton(
              icon: AppIcons.location,
              tooltip: 'موقعي الحالي',
              onTap: onUseCurrentLocation,
            ),
            SizedBox(width: 4.w),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

/// تنبيه الموقع: سطر واحد ثم روابط الإجراءات — بلا صندوق ملوّن.
class _LocationNoticeRow extends StatelessWidget {
  const _LocationNoticeRow({
    required this.message,
    required this.needsAction,
    required this.onGrantPermission,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final String message;
  final bool needsAction;
  final VoidCallback onGrantPermission;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconChip(icon: AppIcons.warning, skin: skin),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  spacing: 14.w,
                  runSpacing: 2.h,
                  children: [
                    if (needsAction)
                      _TextLink(
                        label: 'منح الصلاحية',
                        onTap: onGrantPermission,
                      ),
                    if (needsAction)
                      _TextLink(label: 'الإعدادات', onTap: onOpenSettings),
                    _TextLink(label: 'تحديث', onTap: onRetry),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// سطر موجز تحت عنوان القسم: كم انتهى، وكم بقي، ومتى التالية.
class _DaySummaryLine extends StatelessWidget {
  const _DaySummaryLine({
    required this.passed,
    required this.upcoming,
    required this.nextTime,
  });

  final int passed;
  final int upcoming;
  final String? nextTime;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final parts = <String>[
      'انتهى $passed',
      'بقي $upcoming',
      if (nextTime != null) 'التالية $nextTime',
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
      child: Text(
        parts.join('  ·  '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.78),
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
      ),
    );
  }
}

class _PrayerScheduleList extends StatelessWidget {
  const _PrayerScheduleList({
    required this.entries,
    required this.highlightIndex,
    required this.windowProgress,
    required this.remainingText,
  });

  final List<_PrayerDayEntry> entries;
  final int highlightIndex;
  final double windowProgress;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSkin.gutter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++)
            if (i == highlightIndex)
              _RaisedPrayerRow(
                entry: entries[i],
                progress: windowProgress,
                remainingText: remainingText,
              )
            else
              _PlainPrayerRow(
                entry: entries[i],
                isLast: i == entries.length - 1,
              ),
        ],
      ),
    );
  }
}

/// صفّ صلاة عادي: نحيل، بفاصل شعرة واحدة.
class _PlainPrayerRow extends StatelessWidget {
  const _PlainPrayerRow({required this.entry, required this.isLast});

  final _PrayerDayEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final prayer = entry.prayer;
    final isPassed = entry.status == _PrayerDayStatus.passed;
    final inkAlpha = isPassed ? 0.62 : 0.88;

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          _IconChip(icon: _iconForPrayer(prayer.type), skin: skin),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _prayerName(prayer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink.withValues(alpha: inkAlpha),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                Text(
                  _prayerDescription(prayer),
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
          if (isPassed) ...[
            Text(
              'انتهى',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 7.w),
          ],
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              _formatPrayerTime(prayer.time),
              style: TextStyle(
                color: skin.ink.withValues(alpha: inkAlpha),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// الصفّ المرتفع الوحيد في الشاشة: الصلاة الجارية وما بقي من وقتها.
class _RaisedPrayerRow extends StatelessWidget {
  const _RaisedPrayerRow({
    required this.entry,
    required this.progress,
    required this.remainingText,
  });

  final _PrayerDayEntry entry;
  final double progress;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final prayer = entry.prayer;
    final isCurrent = entry.status == _PrayerDayStatus.current;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
      ),
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _IconChip(icon: _iconForPrayer(prayer.type), skin: skin),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _prayerName(prayer),
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
                  isCurrent ? 'الآن' : 'التالية',
                  style: TextStyle(
                    color: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  _formatPrayerTime(prayer.time),
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 3.h,
                    backgroundColor: skin.hairline,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                remainingText,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.86),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyPrayerState extends StatelessWidget {
  const _EmptyPrayerState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
      child: Column(
        children: [
          AppIcon(AppIcons.mapPin, color: skin.accent, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            'اختر موقعك لعرض مواقيت الصلاة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'ابحث عن مدينتك أو استخدم موقع الجهاز',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h),
          _TextLink(label: 'تحديد الموقع', onTap: onChangeLocation),
        ],
      ),
    );
  }
}

/// مربّع الأيقونة الصغير — بديل البطاقة حول كل صفّ.
class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.skin});

  final HugeIconData icon;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final HugeIconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: AppIcon(icon, color: skin.accent, size: 16.sp),
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Text(
          label,
          style: TextStyle(
            color: skin.accent,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

enum _PrayerDayStatus {
  passed,
  current,
  next,
  upcoming,
}

class _PrayerDayEntry {
  const _PrayerDayEntry({
    required this.prayer,
    required this.status,
  });

  final PrayerInfoModel prayer;
  final _PrayerDayStatus status;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
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

String _prayerName(PrayerInfoModel prayer) {
  switch (prayer.type) {
    case Prayer.none:
      return prayer.name;
    case Prayer.fajr:
      return 'الفجر';
    case Prayer.sunrise:
      return 'الشروق';
    case Prayer.dhuhr:
      return 'الظهر';
    case Prayer.asr:
      return 'العصر';
    case Prayer.maghrib:
      return 'المغرب';
    case Prayer.isha:
      return 'العشاء';
  }
}

String _prayerDescription(PrayerInfoModel prayer) {
  switch (prayer.type) {
    case Prayer.none:
      return prayer.description;
    case Prayer.fajr:
      return 'بداية اليوم وسكينة الفجر';
    case Prayer.sunrise:
      return 'وقت الشروق وبداية الضياء';
    case Prayer.dhuhr:
      return 'استراحة اليوم ووسطه';
    case Prayer.asr:
      return 'حافظ عليها فهي صلاة الوسطى';
    case Prayer.maghrib:
      return 'ختام النهار وبداية المساء';
    case Prayer.isha:
      return 'سكون الليل وخاتمة اليوم';
  }
}

String _formatPrayerTime(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
}

String _formatClock(DateTime date) {
  return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _remainingText(Duration remaining) {
  if (remaining.inSeconds <= 0) return 'الآن';
  if (remaining.inMinutes < 1) return 'أقل من دقيقة';
  if (remaining.inMinutes < 60) return 'بقي ${remaining.inMinutes} د';

  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  if (minutes == 0) return 'بقي $hours س';
  return 'بقي $hours س $minutes د';
}
