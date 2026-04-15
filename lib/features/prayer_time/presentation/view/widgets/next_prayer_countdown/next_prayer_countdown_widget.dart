import 'dart:async';
import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/setting/presentation/view/pages/setting_screen.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/main_thikr_screen.dart';

part 'next_prayer_countdown_card_logic_part.dart';
part 'next_prayer_countdown_card_part.dart';
part 'next_prayer_countdown_card_widgets_part.dart';
part 'next_prayer_countdown_models_part.dart';
part 'next_prayer_countdown_quick_actions_part.dart';

const _kHeroTop = AppColors.brandGoldLight;
const _kHeroBottom = AppColors.gold;
const _kHeroDeep = AppColors.brandBrown;
const _kAccentGold = AppColors.brandIvory;
const _kPanelText = AppColors.brandBrownDeep;
const _kPanelSurface = AppColors.brandIvory;
const _kPanelBorder = AppColors.brandMist;

/// ─── إعداد قابل للتعديل يدوياً ───────────────────────────────────────────────
/// عيّن [kShowSunrise] على [false] لإخفاء الشروق من صف أوقات الصلاة تماماً.
/// عيّنه على [true] لإظهاره بين الفجر والظهر.
/// ─────────────────────────────────────────────────────────────────────────────
const bool kShowSunrise = false;

class NextPrayerCountdownWidget extends StatelessWidget {
  const NextPrayerCountdownWidget({
    this.nextPrayer,
    this.remainingTime,
    this.prayerTimes,
    this.currentPrayerInfo,
    this.nextPrayerInfo,
    this.currentPrayerName,
    this.locationLabel,
    this.utcOffsetMinutes,
    this.useBlocFallback = true,
    super.key,
  }) : assert(
          (nextPrayer == null && remainingTime == null) ||
              (nextPrayer != null && remainingTime != null),
          'nextPrayer and remainingTime must be provided together.',
        );

  final TimePrayerModel? nextPrayer;
  final Duration? remainingTime;
  final List<PrayerInfoModel>? prayerTimes;
  final PrayerInfoModel? currentPrayerInfo;
  final PrayerInfoModel? nextPrayerInfo;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;
  final bool useBlocFallback;

  @override
  Widget build(BuildContext context) {
    final manualPrayer = nextPrayer;
    final manualRemainingTime = remainingTime;
    if (manualPrayer != null && manualRemainingTime != null) {
      return _NextPrayerCountdownCard(
        nextPrayer: manualPrayer,
        remainingTime: manualRemainingTime,
        prayerTimes: prayerTimes ?? const [],
        currentPrayerInfo: currentPrayerInfo,
        nextPrayerInfo: nextPrayerInfo,
        currentPrayerName: currentPrayerName,
        locationLabel: locationLabel,
        utcOffsetMinutes: utcOffsetMinutes,
      );
    }

    if (!useBlocFallback) {
      return _buildLoadingState();
    }

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        final notice = _buildNoticeConfig(context, state);

        if (state.prayerState == RequestState.loading ||
            (state.prayerState == RequestState.initial &&
                state.selectedLocation == null)) {
          return _buildLoadingState();
        }

        if (state.prayerState == RequestState.success &&
            state.nextPrayer != null) {
          final remainingTime =
              state.nextPrayer!.time.difference(_resolveLocationNow(state));
          final safeRemainingTime =
              remainingTime.isNegative ? Duration.zero : remainingTime;

          final nextPrayerModel = TimePrayerModel(
            id: 999,
            title: state.nextPrayer!.name,
            time: state.nextPrayer!.time12,
            type: state.nextPrayer!.type,
            image: state.nextPrayer!.type.imageAsset,
            content: state.nextPrayer!.description,
            color: AppColors.gold,
          );

          return _NextPrayerCountdownCard(
            nextPrayer: nextPrayerModel,
            remainingTime: safeRemainingTime,
            prayerTimes: state.prayerList,
            currentPrayerInfo: state.currentPrayer,
            nextPrayerInfo: state.nextPrayer,
            currentPrayerName: state.currentPrayer?.name,
            locationLabel: state.selectedLocation?.label,
            utcOffsetMinutes: state.selectedLocation?.utcOffsetMinutes,
            notice: notice,
          );
        }

        return _buildUnavailableState(
          context,
          state: state,
          notice: notice,
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ShimmerSkeletonizerWidget(
      child: _NextPrayerCountdownCard(
        nextPrayer: TimePrayerModel(
          id: -1,
          title: 'الفجر',
          time: '04:13',
          type: Prayer.fajr,
          image: Prayer.fajr.imageAsset,
          content: 'تحميل المواقيت',
          color: AppColors.gold,
        ),
        remainingTime: const Duration(hours: 1, minutes: 12),
        prayerTimes: const [],
        currentPrayerName: 'جاري تحميل المواقيت',
        locationLabel: 'جاري تحديد الموقع',
        utcOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
        prayerEntriesOverride: _placeholderPrayerEntries(),
      ),
    );
  }

  Widget _buildUnavailableState(
    BuildContext context, {
    required PrayerTimeState state,
    required _LocationNoticeConfig? notice,
  }) {
    return _NextPrayerCountdownCard(
      nextPrayer: TimePrayerModel(
        id: -2,
        title: '------',
        time: '------',
        type: Prayer.none,
        image: '',
        content: '------',
        color: AppColors.gold,
      ),
      remainingTime: Duration.zero,
      prayerTimes: const [],
      currentPrayerName: '------',
      locationLabel: state.selectedLocation?.label ?? '------',
      utcOffsetMinutes: state.selectedLocation?.utcOffsetMinutes,
      prayerEntriesOverride: _placeholderPrayerEntries(),
      notice: notice ??
          _LocationNoticeConfig(
            message: 'فعّل الموقع أو امنح الصلاحية لعرض مواقيت الصلاة بدقة.',
            primaryAction: _LocationNoticeAction(
              label: 'منح الصلاحية',
              onTap: () => _requestLocationPermission(context),
            ),
            secondaryAction: _LocationNoticeAction(
              label: 'تفعيل الموقع',
              onTap: () => _openLocationSettings(context),
            ),
          ),
    );
  }

  _LocationNoticeConfig? _buildNoticeConfig(
    BuildContext context,
    PrayerTimeState state,
  ) {
    switch (state.locationStatus) {
      case PrayerLocationStatus.serviceDisabled:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message:
                'الأوقات الحالية تستخدم آخر موقع محفوظ. فعّل الموقع لتحديثها تلقائيًا.',
            primaryAction: _LocationNoticeAction(
              label: 'تفعيل الموقع',
              onTap: () => _openLocationSettings(context),
            ),
            secondaryAction: _LocationNoticeAction(
              label: 'تحديث',
              onTap: () => _retryFetchPrayerTimes(context),
              isRefreshIcon: true,
            ),
          );
        }
        return _LocationNoticeConfig(
          message:
              'خدمة الموقع غير مفعلة. فعّلها لعرض مواقيت الصلاة حسب موقعك الحالي.',
          primaryAction: _LocationNoticeAction(
            label: 'تفعيل الموقع',
            onTap: () => _openLocationSettings(context),
          ),
          secondaryAction: _LocationNoticeAction(
            label: 'تحديث',
            onTap: () => _retryFetchPrayerTimes(context),
            isRefreshIcon: true,
          ),
        );
      case PrayerLocationStatus.permissionDenied:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message:
                'الأوقات الحالية تستخدم آخر موقع محفوظ. اسمح بالوصول للموقع لتحديثها الآن.',
            primaryAction: _LocationNoticeAction(
              label: 'منح الصلاحية',
              onTap: () => _requestLocationPermission(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message:
              'صلاحية الموقع غير ممنوحة. اسمح بها لعرض المواقيت حسب موقعك الحالي.',
          primaryAction: _LocationNoticeAction(
            label: 'منح الصلاحية',
            onTap: () => _requestLocationPermission(context),
          ),
        );
      case PrayerLocationStatus.permissionDeniedForever:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message:
                'الأوقات الحالية تستخدم آخر موقع محفوظ. افتح الإعدادات لإعادة تفعيل صلاحية الموقع.',
            primaryAction: _LocationNoticeAction(
              label: 'فتح الإعدادات',
              onTap: () => _openPermissionSettings(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message:
              'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات وفعّلها لعرض المواقيت بدقة.',
          primaryAction: _LocationNoticeAction(
            label: 'فتح الإعدادات',
            onTap: () => _openPermissionSettings(context),
          ),
        );
      case PrayerLocationStatus.error:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message:
                'تعذر تحديث الموقع الآن، لذلك يتم استخدام آخر موقع محفوظ للمستخدم.',
            primaryAction: _LocationNoticeAction(
              label: 'إعادة المحاولة',
              onTap: () => _requestLocationPermission(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message:
              'تعذر تحديد الموقع حاليًا. فعّل الموقع أو اسمح بالصلاحية لإظهار المواقيت.',
          primaryAction: _LocationNoticeAction(
            label: 'إعادة المحاولة',
            onTap: () => _requestLocationPermission(context),
          ),
        );
      case PrayerLocationStatus.initial:
      case PrayerLocationStatus.resolving:
      case PrayerLocationStatus.ready:
        return null;
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

  Future<void> _requestLocationPermission(BuildContext context) async {
    context.read<PrayerTimeBloc>().add(
          const PrayerTimeUseCurrentDeviceLocationRequested(),
        );
  }

  /// يُعيد محاولة جلب مواقيت الصلاة بعد أن يقوم المستخدم بتفعيل الموقع.
  void _retryFetchPrayerTimes(BuildContext context) {
    context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
  }

  List<_PrayerMiniEntry> _placeholderPrayerEntries() {
    return [
      const _PrayerMiniEntry(
        name: 'الفجر',
        time: '------',
        type: Prayer.fajr,
        isCurrent: false,
        isNext: false,
      ),
      if (kShowSunrise)
        const _PrayerMiniEntry(
          name: 'الشروق',
          time: '------',
          type: Prayer.sunrise,
          isCurrent: false,
          isNext: false,
        ),
      const _PrayerMiniEntry(
        name: 'الظهر',
        time: '------',
        type: Prayer.dhuhr,
        isCurrent: false,
        isNext: false,
      ),
      const _PrayerMiniEntry(
        name: 'العصر',
        time: '------',
        type: Prayer.asr,
        isCurrent: false,
        isNext: false,
      ),
      const _PrayerMiniEntry(
        name: 'المغرب',
        time: '------',
        type: Prayer.maghrib,
        isCurrent: false,
        isNext: false,
      ),
      const _PrayerMiniEntry(
        name: 'العشاء',
        time: '------',
        type: Prayer.isha,
        isCurrent: false,
        isNext: false,
      ),
    ];
  }

  DateTime _resolveLocationNow(PrayerTimeState state) {
    final offsetMinutes = state.selectedLocation?.utcOffsetMinutes;
    if (offsetMinutes == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
  }
}
