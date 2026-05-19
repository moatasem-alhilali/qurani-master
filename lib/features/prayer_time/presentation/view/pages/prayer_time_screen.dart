import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_location_picker_sheet.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'أوقات الصلاة',
      body: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
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
            onResolveNotice: () => _resolveLocationNotice(context, state),
          );

          if (state.prayerState == RequestState.loading) {
            return ShimmerSkeletonizerWidget(child: content);
          }

          return content;
        },
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
        accentColor: _getPrayerColor(prayer),
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

  Future<void> _resolveLocationNotice(
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

  Color _getPrayerColor(PrayerInfoModel data) {
    switch (data.type) {
      case Prayer.none:
        return Colors.grey;
      case Prayer.fajr:
        return const Color(0xFF5E86C8);
      case Prayer.sunrise:
        return const Color(0xFFC99C43);
      case Prayer.dhuhr:
        return const Color(0xFFC6AD67);
      case Prayer.asr:
        return const Color(0xFFB9824C);
      case Prayer.maghrib:
        return const Color(0xFFC26B58);
      case Prayer.isha:
        return const Color(0xFF6F72B8);
    }
  }
}

class _PrayerTimesTodayView extends StatelessWidget {
  const _PrayerTimesTodayView({
    required this.state,
    required this.entries,
    required this.locationNow,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    required this.onResolveNotice,
  });

  final PrayerTimeState state;
  final List<_PrayerDayEntry> entries;
  final DateTime locationNow;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final Future<void> Function() onResolveNotice;

  @override
  Widget build(BuildContext context) {
    final nextEntry = _findEntry(state.nextPrayer) ??
        entries
            .where((entry) => entry.status == _PrayerDayStatus.next)
            .firstOrNull;
    final currentEntry = _findEntry(state.currentPrayer) ??
        entries
            .where((entry) => entry.status == _PrayerDayStatus.current)
            .firstOrNull;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PrayerFocusCard(
            nextEntry: nextEntry,
            currentEntry: currentEntry,
            locationNow: locationNow,
            selectedLocation: state.selectedLocation,
            onChangeLocation: onChangeLocation,
            onUseCurrentLocation: onUseCurrentLocation,
          ),
          if (_shouldShowNotice(state)) ...[
            SizedBox(height: 10.h),
            _LocationNoticeCard(
              state: state,
              onResolveNotice: onResolveNotice,
            ),
          ],
          SizedBox(height: 12.h),
          _DayPulseStrip(
            entries: entries,
            locationNow: locationNow,
          ),
          SizedBox(height: 14.h),
          const _SectionHeader(
            title: 'جدول اليوم',
            subtitle: 'كل وقت بحالته الحالية بدون ازدحام',
          ),
          SizedBox(height: 10.h),
          if (entries.isEmpty)
            _EmptyPrayerState(onChangeLocation: onChangeLocation)
          else
            _PrayerScheduleBoard(entries: entries),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  _PrayerDayEntry? _findEntry(PrayerInfoModel? prayer) {
    if (prayer == null) return null;
    for (final entry in entries) {
      final item = entry.prayer;
      if (item.type == prayer.type &&
          item.time.year == prayer.time.year &&
          item.time.month == prayer.time.month &&
          item.time.day == prayer.time.day) {
        return entry;
      }
    }
    return null;
  }

  bool _shouldShowNotice(PrayerTimeState state) {
    return state.locationStatus == PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever ||
        state.locationStatus == PrayerLocationStatus.error;
  }
}

class _PrayerFocusCard extends StatelessWidget {
  const _PrayerFocusCard({
    required this.nextEntry,
    required this.currentEntry,
    required this.locationNow,
    required this.selectedLocation,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
  });

  final _PrayerDayEntry? nextEntry;
  final _PrayerDayEntry? currentEntry;
  final DateTime locationNow;
  final PrayerLocationSelection? selectedLocation;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final nextPrayer = nextEntry?.prayer;
    final currentPrayer = currentEntry?.prayer;
    final remaining = nextPrayer == null
        ? Duration.zero
        : nextPrayer.time.difference(locationNow);
    final progress = _dayProgress(locationNow: locationNow);

    return _SoftPanel(
      padding: EdgeInsets.all(14.w),
      borderColor: context.primaryColor.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBubble(
                icon: nextPrayer == null
                    ? AppIcons.clock
                    : _iconForPrayer(nextPrayer.type),
                color: context.primaryColor,
                size: 40.w,
                iconSize: 18.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextPrayer == null ? 'مواقيت الصلاة' : 'الصلاة القادمة',
                      style: TextStyle(
                        color: context.onSurfaceVariant,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      nextPrayer == null
                          ? 'اختر موقعك لعرض الأوقات'
                          : _prayerName(nextPrayer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressDial(
                value: progress,
                label: _formatClock(locationNow),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _FocusMetric(
                  label: nextPrayer == null ? 'الحالة' : 'الوقت',
                  value: nextPrayer == null
                      ? 'غير جاهز'
                      : _formatPrayerTime(nextPrayer.time),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _FocusMetric(
                  label: currentPrayer == null ? 'الآن' : 'الصلاة الحالية',
                  value: currentPrayer == null
                      ? 'انتظار'
                      : _prayerName(currentPrayer),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _FocusMetric(
                  label: 'المتبقي',
                  value: _remainingText(remaining),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _LocationRow(
            selectedLocation: selectedLocation,
            onChangeLocation: onChangeLocation,
            onUseCurrentLocation: onUseCurrentLocation,
          ),
        ],
      ),
    );
  }

  double _dayProgress({required DateTime locationNow}) {
    final start =
        DateTime(locationNow.year, locationNow.month, locationNow.day);
    final end = start.add(const Duration(days: 1));
    final total = end.difference(start).inSeconds;
    final passed = locationNow.difference(start).inSeconds.clamp(0, total);
    return passed / total;
  }
}

class _ProgressDial extends StatelessWidget {
  const _ProgressDial({
    required this.value,
    required this.label,
  });

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 52.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: 3.w,
              backgroundColor: context.outlineVariant.withValues(alpha: 0.18),
              color: context.primaryColor,
            ),
          ),
          Text(
            label,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusMetric extends StatelessWidget {
  const _FocusMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

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
    final locationLabel = selectedLocation?.label.trim();
    final details = selectedLocation?.detailsLabel.trim();

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(13.r),
            onTap: onChangeLocation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(
                  color: context.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  AppIcon(
                    AppIcons.mapPin,
                    size: 13.sp,
                    color: context.primaryColor,
                    strokeWidth: 1.55,
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      (locationLabel == null || locationLabel.isEmpty)
                          ? 'تحديد الموقع'
                          : locationLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (details != null && details.isNotEmpty) ...[
                    SizedBox(width: 6.w),
                    Text(
                      details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.onSurfaceVariant,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _TinyActionButton(
          icon: AppIcons.location,
          onTap: onUseCurrentLocation,
        ),
        SizedBox(width: 7.w),
        _TinyActionButton(
          icon: AppIcons.edit,
          onTap: onChangeLocation,
        ),
      ],
    );
  }
}

class _TinyActionButton extends StatelessWidget {
  const _TinyActionButton({
    required this.icon,
    required this.onTap,
  });

  final HugeIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.surfaceVariant.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: context.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: AppIcon(
          icon,
          size: 15.sp,
          color: context.primaryColor,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}

class _LocationNoticeCard extends StatelessWidget {
  const _LocationNoticeCard({
    required this.state,
    required this.onResolveNotice,
  });

  final PrayerTimeState state;
  final Future<void> Function() onResolveNotice;

  @override
  Widget build(BuildContext context) {
    final needsAction = state.locationStatus ==
            PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever;

    return _SoftPanel(
      padding: EdgeInsets.all(12.w),
      backgroundColor: context.errorContainer.withValues(alpha: 0.16),
      borderColor: context.errorColor.withValues(alpha: 0.22),
      child: Row(
        children: [
          _IconBubble(
            icon: needsAction ? AppIcons.warning : AppIcons.error,
            color: context.errorColor,
            size: 34.w,
            iconSize: 15.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              (state.locationStatusMessage ?? '').trim().isEmpty
                  ? 'تعذر تحديث الموقع الحالي.'
                  : state.locationStatusMessage!.trim(),
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 11.sp,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (needsAction) ...[
            SizedBox(width: 8.w),
            InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onResolveNotice,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: context.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'فتح',
                  style: TextStyle(
                    color: context.errorColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayPulseStrip extends StatelessWidget {
  const _DayPulseStrip({
    required this.entries,
    required this.locationNow,
  });

  final List<_PrayerDayEntry> entries;
  final DateTime locationNow;

  @override
  Widget build(BuildContext context) {
    final passed = entries
        .where((entry) => entry.status == _PrayerDayStatus.passed)
        .length;
    final upcoming = entries
        .where((entry) => entry.status == _PrayerDayStatus.upcoming)
        .length;
    final next = entries
        .where((entry) => entry.status == _PrayerDayStatus.next)
        .firstOrNull;

    return Row(
      children: [
        Expanded(
          child: _PulseChip(
            icon: AppIcons.checkSmall,
            label: 'انتهى',
            value: '$passed',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PulseChip(
            icon: AppIcons.clock,
            label: 'متبقي',
            value: '$upcoming',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PulseChip(
            icon: AppIcons.calendar,
            label: DateFormat('EEEE', 'ar').format(locationNow),
            value: next == null ? '--:--' : _formatPrayerTime(next.prayer.time),
          ),
        ),
      ],
    );
  }
}

class _PulseChip extends StatelessWidget {
  const _PulseChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final HugeIconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
      child: Row(
        children: [
          AppIcon(
            icon,
            size: 13.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.sp,
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

class _PrayerScheduleBoard extends StatelessWidget {
  const _PrayerScheduleBoard({required this.entries});

  final List<_PrayerDayEntry> entries;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: entries.asMap().entries.map((item) {
          final index = item.key;
          return _PrayerScheduleTile(
            entry: item.value,
            showDivider: index != entries.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

class _PrayerScheduleTile extends StatelessWidget {
  const _PrayerScheduleTile({
    required this.entry,
    required this.showDivider,
  });

  final _PrayerDayEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final prayer = entry.prayer;
    final isActive = entry.status == _PrayerDayStatus.current ||
        entry.status == _PrayerDayStatus.next;
    final statusText = switch (entry.status) {
      _PrayerDayStatus.passed => 'تم',
      _PrayerDayStatus.current => 'الآن',
      _PrayerDayStatus.next => 'القادمة',
      _PrayerDayStatus.upcoming => 'لاحقاً',
    };

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive
                ? entry.accentColor.withValues(alpha: 0.11)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Row(
            children: [
              _IconBubble(
                icon: _iconForPrayer(prayer.type),
                color: isActive ? entry.accentColor : context.onSurfaceVariant,
                size: 34.w,
                iconSize: 15.sp,
                opacity: isActive ? 0.16 : 0.08,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _prayerName(prayer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _prayerDescription(prayer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.onSurfaceVariant,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPrayerTime(prayer.time),
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? entry.accentColor.withValues(alpha: 0.15)
                          : context.surfaceVariant.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: isActive
                            ? entry.accentColor
                            : context.onSurfaceVariant,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Divider(
              height: 1.h,
              color: context.outlineVariant.withValues(alpha: 0.18),
            ),
          ),
      ],
    );
  }
}

class _EmptyPrayerState extends StatelessWidget {
  const _EmptyPrayerState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _IconBubble(
            icon: AppIcons.mapPin,
            color: context.primaryColor,
            size: 42.w,
            iconSize: 18.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            'اختر موقعك لعرض مواقيت الصلاة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onChangeLocation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'تحديد الموقع',
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.onSurfaceVariant,
                  fontSize: 9.5.sp,
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

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    this.opacity = 0.12,
  });

  final HugeIconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AppIcon(
        icon,
        size: iconSize,
        color: color,
        strokeWidth: 1.55,
      ),
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({
    required this.child,
    required this.padding,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: borderColor ?? context.outlineVariant.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.035),
            blurRadius: 14.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: child,
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
    required this.accentColor,
  });

  final PrayerInfoModel prayer;
  final _PrayerDayStatus status;
  final Color accentColor;
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
  if (remaining.inMinutes < 60) return '${remaining.inMinutes} د';

  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  if (minutes == 0) return '$hours س';
  return '$hours س $minutes د';
}
