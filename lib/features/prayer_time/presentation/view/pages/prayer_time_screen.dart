import 'dart:async';
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
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_settings_screen.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_location_picker_sheet.dart';

/// شاشة مواقيت اليوم: تعرض **شكل اليوم** لا قائمة أوقات.
///
/// اليوم شريط رأسي متّصل من الفجر إلى فجر الغد، وكل نافذة صلاة شريحة
/// ارتفاعها بقدر مدّتها الحقيقية — فيرى المستخدم بعينه أن العشاء طويل
/// والمغرب قصير. خطّ «الآن» الذهبي يقطع الشريط عند اللحظة الحالية.
class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  /// إزاحة اليوم المعروض: ‎-1 أمس، ‎0 اليوم، ‎1 غدًا.
  int _dayOffset = 0;

  /// نبضة نصف دقيقة تُحرّك خطّ «الآن» على الشريط.
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
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
              final date = DateUtils.dateOnly(now).add(
                Duration(days: _dayOffset),
              );
              final plan = _buildPlan(state: state, date: date, now: now);

              final content = _PrayerDayView(
                state: state,
                plan: plan,
                date: date,
                now: now,
                dayOffset: _dayOffset,
                onPreviousDay: () => setState(() => _dayOffset -= 1),
                onNextDay: () => setState(() => _dayOffset += 1),
                onBackToToday: () => setState(() => _dayOffset = 0),
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

  /// يحسب نوافذ اليوم المطلوب محليًا، فلا ينتظر دعمًا من المستودع.
  _DayPlan? _buildPlan({
    required PrayerTimeState state,
    required DateTime date,
    required DateTime now,
  }) {
    final location = state.selectedLocation;

    if (location != null) {
      return _planFromCoordinates(location: location, date: date);
    }

    // بلا موقع محفوظ نعتمد قائمة اليوم القادمة من المستودع (إحداثيات
    // الجهاز)، وهي تخصّ اليوم الحالي فقط.
    if (_dayOffset != 0 || state.prayerList.isEmpty) {
      return null;
    }
    return _planFromPrayerList(state.prayerList);
  }

  _DayPlan _planFromCoordinates({
    required PrayerLocationSelection location,
    required DateTime date,
  }) {
    final coordinates = Coordinates(location.latitude, location.longitude);
    final utcOffset = Duration(minutes: location.utcOffsetMinutes);
    final nextDate = date.add(const Duration(days: 1));

    final today = PrayerTimes.utcOffset(
      coordinates,
      DateComponents.from(date),
      PrayerCalculationParams.build(date: date),
      utcOffset,
    );
    final tomorrow = PrayerTimes.utcOffset(
      coordinates,
      DateComponents.from(nextDate),
      PrayerCalculationParams.build(date: nextDate),
      utcOffset,
    );
    final sunnah = SunnahTimes(today);

    return _DayPlan(
      slices: _slicesFrom(
        fajr: today.fajr,
        sunrise: today.sunrise,
        dhuhr: today.dhuhr,
        asr: today.asr,
        maghrib: today.maghrib,
        isha: today.isha,
        nextFajr: tomorrow.fajr,
      ),
      middleOfTheNight: sunnah.middleOfTheNight,
      lastThirdOfTheNight: sunnah.lastThirdOfTheNight,
    );
  }

  _DayPlan? _planFromPrayerList(List<PrayerInfoModel> list) {
    DateTime? timeOf(Prayer type) {
      for (final prayer in list) {
        if (prayer.type == type) return prayer.time;
      }
      return null;
    }

    final fajr = timeOf(Prayer.fajr);
    final sunrise = timeOf(Prayer.sunrise);
    final dhuhr = timeOf(Prayer.dhuhr);
    final asr = timeOf(Prayer.asr);
    final maghrib = timeOf(Prayer.maghrib);
    final isha = timeOf(Prayer.isha);

    if (fajr == null ||
        sunrise == null ||
        dhuhr == null ||
        asr == null ||
        maghrib == null ||
        isha == null) {
      return null;
    }

    final nextFajr = fajr.add(const Duration(days: 1));
    final nightSeconds = nextFajr.difference(maghrib).inSeconds;

    return _DayPlan(
      slices: _slicesFrom(
        fajr: fajr,
        sunrise: sunrise,
        dhuhr: dhuhr,
        asr: asr,
        maghrib: maghrib,
        isha: isha,
        nextFajr: nextFajr,
      ),
      middleOfTheNight: maghrib.add(Duration(seconds: nightSeconds ~/ 2)),
      lastThirdOfTheNight:
          maghrib.add(Duration(seconds: (nightSeconds * 2) ~/ 3)),
    );
  }

  List<_DaySlice> _slicesFrom({
    required DateTime fajr,
    required DateTime sunrise,
    required DateTime dhuhr,
    required DateTime asr,
    required DateTime maghrib,
    required DateTime isha,
    required DateTime nextFajr,
  }) {
    return [
      _DaySlice(name: 'الفجر', start: fajr, end: sunrise, tone: _SkyTone.fajr),
      _DaySlice(
        name: 'الشروق',
        start: sunrise,
        end: dhuhr,
        tone: _SkyTone.duha,
      ),
      _DaySlice(name: 'الظهر', start: dhuhr, end: asr, tone: _SkyTone.dhuhr),
      _DaySlice(name: 'العصر', start: asr, end: maghrib, tone: _SkyTone.asr),
      _DaySlice(
        name: 'المغرب',
        start: maghrib,
        end: isha,
        tone: _SkyTone.maghrib,
      ),
      _DaySlice(
        name: 'العشاء',
        start: isha,
        end: nextFajr,
        tone: _SkyTone.isha,
      ),
    ];
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

class _PrayerDayView extends StatelessWidget {
  const _PrayerDayView({
    required this.state,
    required this.plan,
    required this.date,
    required this.now,
    required this.dayOffset,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onBackToToday,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final PrayerTimeState state;
  final _DayPlan? plan;
  final DateTime date;
  final DateTime now;
  final int dayOffset;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onBackToToday;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  bool get _isToday => dayOffset == 0;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final dayPlan = plan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DayNavRow(
          date: date,
          dayOffset: dayOffset,
          onPreviousDay: onPreviousDay,
          onNextDay: onNextDay,
          onBackToToday: onBackToToday,
        ),
        if (dayPlan == null)
          _EmptyDayState(
            canPickLocation: state.selectedLocation == null,
            onChangeLocation: onChangeLocation,
            onBackToToday: onBackToToday,
            isToday: _isToday,
          )
        else ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
            child: _DayRibbon(
              slices: dayPlan.slices,
              now: _isToday ? now : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
            child: Text(
              'ارتفاع كل شريحة بقدر طول وقتها',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          skin.divider(),
          const HomeSectionHeader(title: 'قيام الليل'),
          Padding(
            padding: AppSkin.gutter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoRow(
                  icon: AppIcons.moon,
                  label: 'منتصف الليل',
                  hint: 'منتصف ما بين المغرب والفجر',
                  time: dayPlan.middleOfTheNight,
                ),
                _InfoRow(
                  icon: AppIcons.star,
                  label: 'الثلث الأخير',
                  hint: 'أفضل أوقات القيام والدعاء',
                  time: dayPlan.lastThirdOfTheNight,
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

/// تنقّل الأيام: أمس · اليوم · غدًا، والتاريخ الميلادي والهجري تحته.
class _DayNavRow extends StatelessWidget {
  const _DayNavRow({
    required this.date,
    required this.dayOffset,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onBackToToday,
  });

  final DateTime date;
  final int dayOffset;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onBackToToday;

  String get _dayLabel {
    switch (dayOffset) {
      case -1:
        return 'أمس';
      case 0:
        return 'اليوم';
      case 1:
        return 'غدًا';
      default:
        return DateFormat('EEEE', 'ar').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hijri = HijriDate.fromDate(date);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _NavArrow(
            icon: AppIcons.chevronRight,
            tooltip: 'اليوم السابق',
            onTap: onPreviousDay,
          ),
          Expanded(
            child: InkWell(
              onTap: dayOffset == 0 ? null : onBackToToday,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayOffset == 0 ? _dayLabel : '$_dayLabel · عودة لليوم',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dayOffset == 0 ? skin.ink : skin.accent,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '${DateFormat('d MMMM yyyy', 'ar').format(date)}'
                      ' · ${hijri.formatArabic()}',
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
            ),
          ),
          _NavArrow(
            icon: AppIcons.chevronLeft,
            tooltip: 'اليوم التالي',
            onTap: onNextDay,
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
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
          padding: EdgeInsets.all(6.w),
          child: AppIcon(icon, color: skin.accent, size: 16.sp),
        ),
      ),
    );
  }
}

/// شريط اليوم: شرائح متّصلة ارتفاع كلٍّ منها بقدر مدّتها، يقطعها خطّ «الآن».
class _DayRibbon extends StatelessWidget {
  const _DayRibbon({required this.slices, this.now});

  final List<_DaySlice> slices;

  /// «الآن» بتوقيت الموقع، أو `null` حين يُعرض يوم غير اليوم.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final total = 480.h;
    final minHeight = 40.h;
    final expand = now == null ? 0.0 : 16.h;

    final seconds = [
      for (final slice in slices)
        slice.end.difference(slice.start).inSeconds.clamp(60, 86400),
    ];
    final totalSeconds = seconds.fold<int>(0, (sum, value) => sum + value);
    final current = _currentIndex();
    final free = total - minHeight * slices.length - expand;

    final heights = <double>[
      for (var i = 0; i < slices.length; i++)
        minHeight +
            (free > 0 ? free * seconds[i] / totalSeconds : 0) +
            (i == current ? expand : 0),
    ];

    final nowTop = _nowTop(heights: heights, current: current, total: total);

    // حدّ شعرة حول الشريط: يمسك حوافه في الوضع الفاتح حيث التعبئة خفيفة.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: skin.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: total,
        child: Stack(
          children: [
            Column(
              children: [
                for (var i = 0; i < slices.length; i++)
                  _RibbonSlice(
                    slice: slices[i],
                    height: heights[i],
                    isFirst: i == 0,
                    isCurrent: i == current,
                    remainingText: i == current ? _remainingText(i) : null,
                  ),
              ],
            ),
            if (nowTop != null) ...[
              Positioned(
                top: nowTop - 0.75,
                right: 0,
                left: 0,
                child: Container(height: 1.5, color: AppColors.gold),
              ),
              // شارة الوقت الحالي: العنصر المرتفع الوحيد في الشاشة.
              PositionedDirectional(
                top: nowTop - 10.h,
                end: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: skin.raised,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: skin.raisedBorder, width: 1.2),
                    boxShadow: skin.raisedShadow,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      _formatClock(now!),
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        fontFeatures: const [ui.FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// الشريحة التي تقع فيها اللحظة الحالية، أو ‎-1 حين يُعرض يوم آخر.
  int _currentIndex() {
    final moment = now;
    if (moment == null) return -1;

    for (var i = 0; i < slices.length; i++) {
      if (!moment.isBefore(slices[i].start) && moment.isBefore(slices[i].end)) {
        return i;
      }
    }
    // قبل فجر اليوم أو بعد فجر الغد: نلتصق بطرف الشريط بدل أن يختفي الخطّ.
    return moment.isBefore(slices.first.start) ? 0 : slices.length - 1;
  }

  double? _nowTop({
    required List<double> heights,
    required int current,
    required double total,
  }) {
    final moment = now;
    if (moment == null || current < 0) return null;

    var top = 0.0;
    for (var i = 0; i < current; i++) {
      top += heights[i];
    }

    final slice = slices[current];
    final span = slice.end.difference(slice.start).inSeconds;
    final passed = moment.difference(slice.start).inSeconds;
    final fraction = span <= 0 ? 0.0 : (passed / span).clamp(0.0, 1.0);

    return (top + heights[current] * fraction).clamp(0.0, total);
  }

  /// «بقي ٤٧ د للمغرب» — تظهر داخل الشريحة الجارية.
  String? _remainingText(int index) {
    final moment = now;
    if (moment == null) return null;

    final slice = slices[index];

    // ما قبل الفجر: اللحظة خارج الشريط، فالباقي هو ما بقي لبداية الشريحة.
    if (moment.isBefore(slice.start)) {
      final untilStart = slice.start.difference(moment);
      return 'بقي ${_formatDuration(untilStart)} ${_lam(slice.name)}';
    }

    final remaining = slice.end.difference(moment);
    if (remaining.isNegative) return null;

    final nextName =
        index + 1 < slices.length ? slices[index + 1].name : 'فجر غد';

    return 'بقي ${_formatDuration(remaining)} ${_lam(nextName)}';
  }

  /// «المغرب» ← «للمغرب»، و«فجر غد» ← «لفجر غد».
  String _lam(String name) =>
      name.startsWith('ال') ? 'ل${name.substring(1)}' : 'لـ$name';
}

/// شريحة نافذة واحدة: تعبئة سمائها، واسمها ووقتها ومدّتها.
class _RibbonSlice extends StatelessWidget {
  const _RibbonSlice({
    required this.slice,
    required this.height,
    required this.isFirst,
    required this.isCurrent,
    this.remainingText,
  });

  final _DaySlice slice;
  final double height;
  final bool isFirst;
  final bool isCurrent;
  final String? remainingText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final colors = slice.tone.colors;
    // في الفاتح تعبئة خفيفة، وفي الداكن أقوى — والحبر في الحالتين `skin.ink`.
    final alpha = skin.isDark ? 0.5 : 0.22;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.$1.withValues(alpha: alpha),
            colors.$2.withValues(alpha: alpha),
          ],
        ),
        border: isFirst ? null : Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                slice.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: isCurrent ? 14.sp : 12.5.sp,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(width: 8.w),
              _ClockText(
                time: slice.start,
                size: isCurrent ? 15.sp : 12.5.sp,
                weight: isCurrent ? FontWeight.w800 : FontWeight.w600,
              ),
              const Spacer(),
              Text(
                _formatDuration(slice.end.difference(slice.start)),
                maxLines: 1,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.86),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
          if (remainingText != null)
            Text(
              remainingText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.accent,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                height: 1.5,
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

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState({
    required this.canPickLocation,
    required this.onChangeLocation,
    required this.onBackToToday,
    required this.isToday,
  });

  final bool canPickLocation;
  final VoidCallback onChangeLocation;
  final VoidCallback onBackToToday;
  final bool isToday;

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
            canPickLocation
                ? 'حدّد موقعك ليُرسم لك شكل اليوم'
                : 'تعذّر حساب مواقيت هذا اليوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            canPickLocation
                ? 'ابحث عن مدينتك أو استخدم موقع الجهاز'
                : 'اختر مدينتك لتتصفّح أي يوم تشاء',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TextLink(label: 'تحديد الموقع', onTap: onChangeLocation),
              if (!isToday) ...[
                SizedBox(width: 14.w),
                _TextLink(label: 'عودة لليوم', onTap: onBackToToday),
              ],
            ],
          ),
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

/// ألوان سماء كل نافذة — نفس لوحة مشهد الشاشة الرئيسية.
enum _SkyTone {
  fajr,
  duha,
  dhuhr,
  asr,
  maghrib,
  isha;

  (Color, Color) get colors {
    switch (this) {
      case _SkyTone.fajr:
        return (AppColors.brandDusk, AppColors.brandBrown);
      case _SkyTone.duha:
        return (AppColors.brandSand, AppColors.brandMist);
      case _SkyTone.dhuhr:
        return (AppColors.brandGoldLight, AppColors.brandCream);
      case _SkyTone.asr:
        return (AppColors.brandGoldDeep, AppColors.brandGoldLight);
      case _SkyTone.maghrib:
        return (AppColors.brandBrownDeep, AppColors.brandGoldDeep);
      case _SkyTone.isha:
        return (AppColors.brandNight, AppColors.brandDusk);
    }
  }
}

class _DaySlice {
  const _DaySlice({
    required this.name,
    required this.start,
    required this.end,
    required this.tone,
  });

  final String name;
  final DateTime start;
  final DateTime end;
  final _SkyTone tone;
}

class _DayPlan {
  const _DayPlan({
    required this.slices,
    required this.middleOfTheNight,
    required this.lastThirdOfTheNight,
  });

  final List<_DaySlice> slices;
  final DateTime middleOfTheNight;
  final DateTime lastThirdOfTheNight;
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
