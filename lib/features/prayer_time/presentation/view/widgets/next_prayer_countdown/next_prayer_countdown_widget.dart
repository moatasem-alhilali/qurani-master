import 'dart:async';
import 'dart:math' as math;
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
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_mute_store.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/setting/presentation/view/pages/setting_screen.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/main_thikr_screen.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'next_prayer_countdown_card_logic_part.dart';
part 'next_prayer_countdown_card_part.dart';
part 'next_prayer_countdown_card_widgets_part.dart';
part 'next_prayer_countdown_models_part.dart';
part 'next_prayer_countdown_quick_actions_part.dart';
part 'next_prayer_countdown_sky_part.dart';

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
      return _buildLoadingState(context);
    }

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        final notice = _buildNoticeConfig(context, state);

        if (state.prayerState == RequestState.loading ||
            (state.prayerState == RequestState.initial &&
                state.selectedLocation == null)) {
          return _buildLoadingState(context);
        }

        if (state.prayerState == RequestState.success &&
            state.nextPrayer != null) {
          final remainingTime =
              state.nextPrayer!.time.difference(_resolveLocationNow(state));
          final safeRemainingTime =
              remainingTime.isNegative ? Duration.zero : remainingTime;

          final nextPrayerModel = TimePrayerModel(
            id: 999,
            title: state.nextPrayer!.localizedName(context.l10n),
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
            currentPrayerName: state.currentPrayer?.localizedName(context.l10n),
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

  Widget _buildLoadingState(BuildContext context) {
    final l10n = context.l10n;
    return ShimmerSkeletonizerWidget(
      child: _NextPrayerCountdownCard(
        nextPrayer: TimePrayerModel(
          id: -1,
          title: l10n.prayerFajr,
          time: '04:13',
          type: Prayer.fajr,
          image: Prayer.fajr.imageAsset,
          content: l10n.prayerTimeLoadingTimes,
          color: AppColors.gold,
        ),
        remainingTime: const Duration(hours: 1, minutes: 12),
        prayerTimes: const [],
        currentPrayerName: l10n.prayerTimeLoadingTimes,
        locationLabel: l10n.prayerTimeLocatingShort,
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
            message: context.l10n.prayerTimeNoticeUnavailable,
            primaryAction: _LocationNoticeAction(
              label: context.l10n.prayerTimeGrantPermission,
              onTap: () => _requestLocationPermission(context),
            ),
            secondaryAction: _LocationNoticeAction(
              label: context.l10n.prayerTimeEnableLocation,
              onTap: () => _openLocationSettings(context),
            ),
          ),
    );
  }

  _LocationNoticeConfig? _buildNoticeConfig(
    BuildContext context,
    PrayerTimeState state,
  ) {
    final l10n = context.l10n;
    switch (state.locationStatus) {
      case PrayerLocationStatus.serviceDisabled:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message: l10n.prayerTimeNoticeServiceOffSaved,
            primaryAction: _LocationNoticeAction(
              label: l10n.prayerTimeEnableLocation,
              onTap: () => _openLocationSettings(context),
            ),
            secondaryAction: _LocationNoticeAction(
              label: l10n.commonRefresh,
              onTap: () => _retryFetchPrayerTimes(context),
              isRefreshIcon: true,
            ),
          );
        }
        return _LocationNoticeConfig(
          message: l10n.prayerTimeNoticeServiceOff,
          primaryAction: _LocationNoticeAction(
            label: l10n.prayerTimeEnableLocation,
            onTap: () => _openLocationSettings(context),
          ),
          secondaryAction: _LocationNoticeAction(
            label: l10n.commonRefresh,
            onTap: () => _retryFetchPrayerTimes(context),
            isRefreshIcon: true,
          ),
        );
      case PrayerLocationStatus.permissionDenied:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message: l10n.prayerTimeNoticePermissionDeniedSaved,
            primaryAction: _LocationNoticeAction(
              label: l10n.prayerTimeGrantPermission,
              onTap: () => _requestLocationPermission(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message: l10n.prayerTimeNoticePermissionDenied,
          primaryAction: _LocationNoticeAction(
            label: l10n.prayerTimeGrantPermission,
            onTap: () => _requestLocationPermission(context),
          ),
        );
      case PrayerLocationStatus.permissionDeniedForever:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message: l10n.prayerTimeNoticeDeniedForeverSaved,
            primaryAction: _LocationNoticeAction(
              label: l10n.prayerTimeOpenSettings,
              onTap: () => _openPermissionSettings(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message: l10n.prayerTimeNoticeDeniedForever,
          primaryAction: _LocationNoticeAction(
            label: l10n.prayerTimeOpenSettings,
            onTap: () => _openPermissionSettings(context),
          ),
        );
      case PrayerLocationStatus.error:
        if (state.selectedLocation != null) {
          return _LocationNoticeConfig(
            message: l10n.prayerTimeNoticeErrorSaved,
            primaryAction: _LocationNoticeAction(
              label: l10n.commonRetry,
              onTap: () => _requestLocationPermission(context),
            ),
          );
        }
        return _LocationNoticeConfig(
          message: l10n.prayerTimeNoticeError,
          primaryAction: _LocationNoticeAction(
            label: l10n.commonRetry,
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
