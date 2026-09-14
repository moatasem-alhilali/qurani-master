import 'dart:async';
import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_settings_screen.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_location_picker_sheet.dart';

/// جدول مواقيت الأسبوع.
///
/// صفوفه الصلوات الستّ وأعمدته أيام الأسبوع السبعة ابتداءً من اليوم، فيجيب
/// فورًا عن «متى فجر بكرة؟» — وهو سؤال لا تجيب عنه الشاشة الرئيسية. عمود
/// الأسماء مثبّت، وبقية الأعمدة تُسحب أفقيًا.
class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  /// عدد أيام الجدول ابتداءً من اليوم.
  static const int _weekLength = 7;

  /// اليوم المختار: يتحكّم في قسم قيام الليل تحت الجدول.
  int _selectedDay = 0;

  /// نبضة دقيقة تُبقي خليّة الصلاة الحالية في مكانها الصحيح.
  Timer? _ticker;

  /// ذاكرة أسبوع محسوب: الحساب يتكرّر مع كل إعادة بناء بلا داعٍ.
  String? _cacheKey;
  List<_DayTimes>? _cachedWeek;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

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
              final now = _locationNow(state);
              final week = _resolveWeek(state, now);
              final selected =
                  week == null || week.isEmpty ? 0 : _selectedDay % week.length;

              final content = _PrayerWeekView(
                state: state,
                week: week,
                now: now,
                selectedDay: selected,
                onSelectDay: (index) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _selectedDay = index);
                },
                onOpenCell: (day, prayer) => _showCellDetails(
                  context: context,
                  week: week!,
                  dayIndex: day,
                  prayerIndex: prayer,
                ),
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

  /// «الآن» بتوقيت الموقع المختار لا بتوقيت الجهاز.
  DateTime _locationNow(PrayerTimeState state) {
    final offset = state.selectedLocation?.utcOffsetMinutes;
    if (offset == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offset));
  }

  List<_DayTimes>? _resolveWeek(PrayerTimeState state, DateTime now) {
    final location = state.selectedLocation;
    final start = DateUtils.dateOnly(now);
    final stamp = state.prayerList.isEmpty
        ? ''
        : state.prayerList.first.time.toIso8601String();
    final key = '${location?.latitude},${location?.longitude},'
        '${location?.utcOffsetMinutes},${start.toIso8601String()},$stamp';

    if (key == _cacheKey) {
      return _cachedWeek;
    }

    final week = location != null
        ? _buildWeek(location: location, start: start)
        : _singleDayFrom(state.prayerList);

    _cacheKey = key;
    _cachedWeek = week;
    return week;
  }

  /// يحسب مواقيت سبعة أيام محليًا، فلا ينتظر دعمًا من المستودع.
  List<_DayTimes> _buildWeek({
    required PrayerLocationSelection location,
    required DateTime start,
  }) {
    final coordinates = Coordinates(location.latitude, location.longitude);
    final utcOffset = Duration(minutes: location.utcOffsetMinutes);
    // تُقرأ الإعدادات مرّة واحدة بدل قراءة التخزين لكل يوم.
    final settings = PrayerCalculationParams.load();

    PrayerTimes timesFor(DateTime date) => PrayerTimes.utcOffset(
          coordinates,
          DateComponents.from(date),
          PrayerCalculationParams.build(date: date, settings: settings),
          utcOffset,
        );

    final days = <_DayTimes>[];
    for (var i = 0; i < _weekLength; i++) {
      final date = start.add(Duration(days: i));
      final times = timesFor(date);
      // فجر الغد يغلق نافذة العشاء ويحدّد ليل هذا اليوم.
      final nextFajr = timesFor(date.add(const Duration(days: 1))).fajr;
      final sunnah = SunnahTimes(times);

      days.add(
        _DayTimes(
          date: date,
          slots: [
            times.fajr,
            times.sunrise,
            times.dhuhr,
            times.asr,
            times.maghrib,
            times.isha,
          ],
          nextFajr: nextFajr,
          middleOfTheNight: sunnah.middleOfTheNight,
          lastThirdOfTheNight: sunnah.lastThirdOfTheNight,
        ),
      );
    }
    return days;
  }

  /// بلا موقع محفوظ نعرض عمود اليوم وحده من قائمة المستودع.
  List<_DayTimes>? _singleDayFrom(List<PrayerInfoModel> list) {
    DateTime? timeOf(Prayer type) {
      for (final prayer in list) {
        if (prayer.type == type) return prayer.time;
      }
      return null;
    }

    final slots = <DateTime?>[
      timeOf(Prayer.fajr),
      timeOf(Prayer.sunrise),
      timeOf(Prayer.dhuhr),
      timeOf(Prayer.asr),
      timeOf(Prayer.maghrib),
      timeOf(Prayer.isha),
    ];
    if (slots.any((time) => time == null)) return null;

    final resolved = slots.cast<DateTime>();
    final nextFajr = resolved.first.add(const Duration(days: 1));
    final nightSeconds = nextFajr.difference(resolved[4]).inSeconds;

    return [
      _DayTimes(
        date: DateUtils.dateOnly(resolved.first),
        slots: resolved,
        nextFajr: nextFajr,
        middleOfTheNight: resolved[4].add(Duration(seconds: nightSeconds ~/ 2)),
        lastThirdOfTheNight:
            resolved[4].add(Duration(seconds: (nightSeconds * 2) ~/ 3)),
      ),
    ];
  }

  /// ورقة تفاصيل الخليّة: وقتها ومدّة نافذتها وفارقها عن اليوم.
  Future<void> _showCellDetails({
    required BuildContext context,
    required List<_DayTimes> week,
    required int dayIndex,
    required int prayerIndex,
  }) {
    final skin = AppSkin.of(context);
    final day = week[dayIndex];
    final time = day.slots[prayerIndex];
    final window = day.windowOf(prayerIndex);
    final todayTime = week.first.slots[prayerIndex];
    final shift = time.difference(todayTime);

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: skin.ground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 34.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: skin.hairline,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  _prayerNames[prayerIndex],
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                Text(
                  '${DateFormat('EEEE d MMMM yyyy', 'ar').format(day.date)}'
                  ' · ${HijriDate.fromDate(day.date).formatArabic()}',
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 10.h),
                _SheetRow(
                  label: 'وقت الأذان',
                  child: _ClockText(
                    time: time,
                    size: 12.5.sp,
                    weight: FontWeight.w700,
                  ),
                ),
                _SheetRow(
                  label: prayerIndex == 1 ? 'حتى الظهر' : 'مدّة النافذة',
                  value: _formatDuration(window),
                ),
                _SheetRow(
                  label: 'الفارق عن اليوم',
                  value: _shiftLabel(shift, isToday: dayIndex == 0),
                  isLast: true,
                ),
              ],
            ),
          ),
        );
      },
    );
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
}

class _PrayerWeekView extends StatelessWidget {
  const _PrayerWeekView({
    required this.state,
    required this.week,
    required this.now,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onOpenCell,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final PrayerTimeState state;
  final List<_DayTimes>? week;
  final DateTime now;
  final int selectedDay;
  final ValueChanged<int> onSelectDay;
  final void Function(int dayIndex, int prayerIndex) onOpenCell;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final days = week;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (days == null || days.isEmpty)
          _EmptyWeekState(onChangeLocation: onChangeLocation)
        else ...[
          _WeekTable(
            days: days,
            currentPrayer: _currentPrayerIndex(days.first),
            selectedDay: selectedDay,
            onSelectDay: onSelectDay,
            onOpenCell: onOpenCell,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: Text(
              days.length == 1
                  ? 'حدّد مدينتك لعرض مواقيت الأسبوع كاملًا'
                  : 'اسحب الجدول أفقيًا لبقية الأيام · المس أي وقت لتفاصيله',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          skin.divider(),
          HomeSectionHeader(title: 'قيام الليل · ${_selectedLabel(days)}'),
          Padding(
            padding: AppSkin.gutter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoRow(
                  icon: AppIcons.moon,
                  label: 'منتصف الليل',
                  hint: 'منتصف ما بين المغرب والفجر',
                  time: days[selectedDay].middleOfTheNight,
                ),
                _InfoRow(
                  icon: AppIcons.star,
                  label: 'الثلث الأخير',
                  hint: 'أفضل أوقات القيام والدعاء',
                  time: days[selectedDay].lastThirdOfTheNight,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
        skin.divider(),
        const HomeSectionHeader(title: 'الموقع'),
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
        SizedBox(height: 26.h),
      ],
    );
  }

  String _selectedLabel(List<_DayTimes> days) {
    if (selectedDay == 0) return 'اليوم';
    if (selectedDay == 1) return 'غدًا';
    return DateFormat('EEEE', 'ar').format(days[selectedDay].date);
  }

  /// الصلاة التي دخل وقتها اليوم ولم يدخل ما بعدها، أو ‎-1‎ قبل الفجر.
  int _currentPrayerIndex(_DayTimes today) {
    if (!DateUtils.isSameDay(today.date, now)) return -1;

    var index = -1;
    for (var i = 0; i < today.slots.length; i++) {
      if (!today.slots[i].isAfter(now)) index = i;
    }
    return index;
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

/// الجدول: عمود الأسماء مثبّت، وأعمدة الأيام تُسحب أفقيًا.
class _WeekTable extends StatelessWidget {
  const _WeekTable({
    required this.days,
    required this.currentPrayer,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onOpenCell,
  });

  final List<_DayTimes> days;

  /// صفّ الصلاة الجارية في عمود اليوم، أو ‎-1‎ حين لا صلاة جارية.
  final int currentPrayer;

  final int selectedDay;
  final ValueChanged<int> onSelectDay;
  final void Function(int dayIndex, int prayerIndex) onOpenCell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSkin.gutter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PrayerNameColumn(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var day = 0; day < days.length; day++)
                    _DayColumn(
                      day: days[day],
                      isToday: day == 0,
                      isSelected: day == selectedDay,
                      currentPrayer: day == 0 ? currentPrayer : -1,
                      onSelect: () => onSelectDay(day),
                      onOpenCell: (prayer) => onOpenCell(day, prayer),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// عمود أسماء الصلوات — مثبّت لا يتحرّك مع السحب.
class _PrayerNameColumn extends StatelessWidget {
  const _PrayerNameColumn();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: 58.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _tableHeaderHeight,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'الصلاة',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          for (var i = 0; i < _prayerNames.length; i++)
            Container(
              height: _tableRowHeight,
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
              child: Text(
                _prayerNames[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// عمود يوم واحد: ترويسته اسم اليوم ورقمه، وتحتها ستّ خلايا أوقات.
class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.currentPrayer,
    required this.onSelect,
    required this.onOpenCell,
  });

  final _DayTimes day;
  final bool isToday;
  final bool isSelected;
  final int currentPrayer;
  final VoidCallback onSelect;
  final ValueChanged<int> onOpenCell;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 50.w,
      decoration: isToday
          ? BoxDecoration(
              // تظليل ذهبي خفيف جدًا: يميّز عمود اليوم بلا أن يصير بطاقة.
              color: AppColors.gold.withValues(
                alpha: skin.isDark ? 0.12 : 0.07,
              ),
              borderRadius: BorderRadius.circular(10.r),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: _tableHeaderHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortWeekday(day.date),
                    maxLines: 1,
                    style: TextStyle(
                      color: isSelected ? skin.accent : skin.inkSoft,
                      fontSize: 9.5.sp,
                      fontWeight: isToday || isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${day.date.day}',
                      style: TextStyle(
                        color: isSelected ? skin.accent : skin.ink,
                        fontSize: 11.sp,
                        fontWeight: isToday || isSelected
                            ? FontWeight.w800
                            : FontWeight.w700,
                        height: 1.2,
                        fontFeatures: const [ui.FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < day.slots.length; i++)
            _TimeCell(
              time: day.slots[i],
              isRaised: i == currentPrayer,
              isPassed: isToday && currentPrayer >= 0 && i < currentPrayer,
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                onOpenCell(i);
              },
            ),
        ],
      ),
    );
  }
}

/// خليّة وقت واحدة. خليّة الصلاة الجارية وحدها ترتفع.
class _TimeCell extends StatelessWidget {
  const _TimeCell({
    required this.time,
    required this.isRaised,
    required this.isPassed,
    required this.onTap,
  });

  final DateTime time;
  final bool isRaised;
  final bool isPassed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final label = Text(
      _formatClock(time),
      maxLines: 1,
      style: TextStyle(
        color: skin.ink.withValues(alpha: isPassed ? 0.5 : 0.88),
        fontSize: isRaised ? 12.sp : 11.5.sp,
        fontWeight: isRaised ? FontWeight.w800 : FontWeight.w600,
        height: 1.2,
        fontFeatures: const [ui.FontFeature.tabularFigures()],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        height: _tableRowHeight,
        alignment: Alignment.center,
        decoration: isRaised
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: isRaised
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: skin.raised,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: skin.raisedBorder, width: 1.2),
                  boxShadow: skin.raisedShadow,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: label,
                ),
              )
            : Directionality(
                textDirection: TextDirection.ltr,
                child: label,
              ),
      ),
    );
  }
}

/// صفّ داخل ورقة التفاصيل.
class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    this.value,
    this.child,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final Widget? child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          child ??
              Text(
                value ?? '',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
        ],
      ),
    );
  }
}

/// صفّ معلومة: أيقونة وعنوان ووصف، والوقت عند الحافة.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.time,
    this.isLast = false,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final DateTime time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          _IconChip(icon: icon, skin: skin),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
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
                  hint,
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
          _ClockText(time: time, size: 12.5.sp, weight: FontWeight.w600),
        ],
      ),
    );
  }
}

/// وقت بصيغة ١٢ ساعة مع ص/م — الأرقام بخانات ثابتة واتجاه لاتيني.
class _ClockText extends StatelessWidget {
  const _ClockText({
    required this.time,
    required this.size,
    required this.weight,
  });

  final DateTime time;
  final double size;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            _formatClock(time),
            style: TextStyle(
              color: skin.ink.withValues(alpha: 0.88),
              fontSize: size,
              fontWeight: weight,
              height: 1.2,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          time.hour < 12 ? 'ص' : 'م',
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.8),
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
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
      child: Padding(
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

class _EmptyWeekState extends StatelessWidget {
  const _EmptyWeekState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 10.h),
      child: Column(
        children: [
          AppIcon(AppIcons.mapPin, color: skin.accent, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            'حدّد موقعك ليظهر جدول الأسبوع',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
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

/// مواقيت يوم واحد كما تُعرض في عمود الجدول.
class _DayTimes {
  const _DayTimes({
    required this.date,
    required this.slots,
    required this.nextFajr,
    required this.middleOfTheNight,
    required this.lastThirdOfTheNight,
  });

  final DateTime date;

  /// الفجر، الشروق، الظهر، العصر، المغرب، العشاء.
  final List<DateTime> slots;

  final DateTime nextFajr;
  final DateTime middleOfTheNight;
  final DateTime lastThirdOfTheNight;

  /// مدّة نافذة الوقت: حتى الذي يليه، والعشاء حتى فجر الغد.
  Duration windowOf(int index) {
    final end = index + 1 < slots.length ? slots[index + 1] : nextFajr;
    return end.difference(slots[index]);
  }
}

const List<String> _prayerNames = [
  'الفجر',
  'الشروق',
  'الظهر',
  'العصر',
  'المغرب',
  'العشاء',
];

double get _tableHeaderHeight => 38.h;

double get _tableRowHeight => 34.h;

/// اسم اليوم مختصرًا: الاثنين ← «إثن».
String _shortWeekday(DateTime date) {
  switch (date.weekday) {
    case DateTime.saturday:
      return 'سبت';
    case DateTime.sunday:
      return 'أحد';
    case DateTime.monday:
      return 'إثن';
    case DateTime.tuesday:
      return 'ثلا';
    case DateTime.wednesday:
      return 'أرب';
    case DateTime.thursday:
      return 'خمي';
    default:
      return 'جمع';
  }
}

String _formatClock(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDuration(Duration duration) {
  if (duration.inMinutes < 1) return 'أقل من دقيقة';
  if (duration.inMinutes < 60) return '${duration.inMinutes} د';

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (minutes == 0) return '$hours س';
  return '$hours س $minutes د';
}

/// «‎+3 د‎» أو «‎-2 د‎» مقارنةً بنفس الصلاة اليوم.
String _shiftLabel(Duration shift, {required bool isToday}) {
  if (isToday) return 'اليوم نفسه';

  final minutes = shift.inMinutes;
  if (minutes == 0) return 'بلا فارق';

  final sign = minutes > 0 ? 'متأخّر' : 'مبكّر';
  return '$sign ${minutes.abs()} د';
}
