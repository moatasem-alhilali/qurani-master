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

part 'prayer_time_screen_week_part.dart';
part 'prayer_time_screen_rows_part.dart';
part 'prayer_time_screen_atoms_part.dart';

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
