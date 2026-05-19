import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/extensions/list_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_location_resolver.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_native_service.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_settings_store.dart';
import 'package:quran_app/main.dart';

part 'prayer_time_event.dart';
part 'prayer_time_state.dart';

class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  PrayerTimeBloc({
    required this.prayerTimeService,
    required this.coordinatesService,
  }) : super(PrayerTimeState()) {
    on<PrayerTimeInitRequested>(_onInitPrayerTimeRequested);
    on<PrayerTimeUpdateLocationRequested>(_onUpdateLocationRequested);
    on<PrayerTimeManualLocationSelected>(_onManualLocationSelected);
    on<PrayerTimeUseCurrentDeviceLocationRequested>(
      _onUseCurrentDeviceLocationRequested,
    );
    on<PrayerTimeRefreshOnAppResumeRequested>(_onRefreshOnAppResumeRequested);
    on<PrayerTimeRefreshFromDeviceLocationInBackgroundRequested>(
      _onRefreshFromDeviceLocationInBackgroundRequested,
    );
    on<_PrayerTimeProgressTicked>(_onPrayerTimeProgressTicked);
  }

  final AdhanPrayerTimeService prayerTimeService;
  final DatabaseCoordinatesService coordinatesService;
  final PrayerSilentModeSettingsStore _silentModeSettingsStore =
      PrayerSilentModeSettingsStore();
  final PrayerSilentModeNativeService _silentModeNativeService =
      PrayerSilentModeNativeService();

  Timer? _prayerProgressTimer;
  bool _isBackgroundRefreshInProgress = false;
  bool _isDayRolloverRefreshInProgress = false;
  static const double _locationChangeThresholdInMeters = 2000;

  static PrayerTimeBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Future<void> close() {
    _prayerProgressTimer?.cancel();
    return super.close();
  }

  Future<void> _onInitPrayerTimeRequested(
    PrayerTimeInitRequested event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );

    try {
      final savedLocation = await coordinatesService.getSavedLocation();
      if (savedLocation != null) {
        await _loadPrayerTimesForSelection(
          savedLocation,
          emit: emit,
        );
        if (!savedLocation.isManual) {
          add(const PrayerTimeRefreshFromDeviceLocationInBackgroundRequested());
        }
        return;
      }

      await _loadUsingDeviceLocation(
        emit: emit,
        fallbackLocation: savedLocation,
      );
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(
          prayerState: RequestState.error,
          locationStatus: PrayerLocationStatus.error,
          locationStatusMessage: 'تعذر تحميل مواقيت الصلاة حاليًا',
        ),
      );
    }
  }

  Future<void> _onUpdateLocationRequested(
    PrayerTimeUpdateLocationRequested event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );

    final fallbackLocation = await coordinatesService.getSavedLocation();
    await _loadUsingDeviceLocation(
      emit: emit,
      fallbackLocation: fallbackLocation,
    );
  }

  Future<void> _onManualLocationSelected(
    PrayerTimeManualLocationSelected event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );

    try {
      await coordinatesService.saveLocationSelection(event.selection);
      await _loadPrayerTimesForSelection(
        event.selection,
        emit: emit,
      );
    } catch (e) {
      logger.e(e);
      emit(
        state.copyWith(
          prayerState: RequestState.error,
          locationStatus: PrayerLocationStatus.error,
          locationStatusMessage: 'تعذر تحديث المنطقة المختارة',
        ),
      );
    }
  }

  Future<void> _onUseCurrentDeviceLocationRequested(
    PrayerTimeUseCurrentDeviceLocationRequested event,
    Emitter<PrayerTimeState> emit,
  ) async {
    add(const PrayerTimeUpdateLocationRequested());
  }

  Future<void> _onRefreshOnAppResumeRequested(
    PrayerTimeRefreshOnAppResumeRequested event,
    Emitter<PrayerTimeState> emit,
  ) async {
    _refreshPrayerProgressFromState(emit);
    await _refreshForDayRolloverIfNeeded(emit);
    add(const PrayerTimeRefreshFromDeviceLocationInBackgroundRequested());
  }

  Future<void> _onRefreshFromDeviceLocationInBackgroundRequested(
    PrayerTimeRefreshFromDeviceLocationInBackgroundRequested event,
    Emitter<PrayerTimeState> emit,
  ) async {
    if (_isBackgroundRefreshInProgress) return;
    final selectedLocation = state.selectedLocation;
    if (selectedLocation == null || selectedLocation.isManual) return;

    _isBackgroundRefreshInProgress = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      final permission = await Geolocator.checkPermission();
      final hasPermission = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      if (!hasPermission) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      final liveSelection = await PrayerLocationResolver.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        utcOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
      );

      final cachedSelection =
          await coordinatesService.getSavedLocation() ?? selectedLocation;
      if (!_hasMeaningfulLocationChange(cachedSelection, liveSelection)) return;

      await coordinatesService.saveLocationSelection(liveSelection);
      await _loadPrayerTimesForSelection(
        liveSelection,
        emit: emit,
      );
    } catch (e) {
      logger.w('Silent device location refresh failed: $e');
    } finally {
      _isBackgroundRefreshInProgress = false;
    }
  }

  Future<void> _onPrayerTimeProgressTicked(
    _PrayerTimeProgressTicked event,
    Emitter<PrayerTimeState> emit,
  ) async {
    _refreshPrayerProgressFromState(emit);
    await _refreshForDayRolloverIfNeeded(emit);
  }

  Future<void> _loadUsingDeviceLocation({
    required Emitter<PrayerTimeState> emit,
    PrayerLocationSelection? fallbackLocation,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _handleDeviceLocationFailure(
          emit: emit,
          fallbackLocation: fallbackLocation,
          status: PrayerLocationStatus.serviceDisabled,
          message: 'خدمة الموقع غير مفعلة. فعّلها أو اختر مدينة يدويًا.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        await _handleDeviceLocationFailure(
          emit: emit,
          fallbackLocation: fallbackLocation,
          status: PrayerLocationStatus.permissionDenied,
          message: 'يلزم منح صلاحية الموقع أو اختيار مدينة يدويًا.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        await _handleDeviceLocationFailure(
          emit: emit,
          fallbackLocation: fallbackLocation,
          status: PrayerLocationStatus.permissionDeniedForever,
          message:
              'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات أو اختر مدينة.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final selection = await PrayerLocationResolver.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        utcOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
      );

      await coordinatesService.saveLocationSelection(selection);
      await _loadPrayerTimesForSelection(
        selection,
        emit: emit,
      );
    } catch (e) {
      logger.e(e);
      await _handleDeviceLocationFailure(
        emit: emit,
        fallbackLocation: fallbackLocation,
        status: PrayerLocationStatus.error,
        message: 'تعذر تحديد موقع الجهاز حاليًا',
      );
    }
  }

  Future<void> _handleDeviceLocationFailure({
    required Emitter<PrayerTimeState> emit,
    required PrayerLocationStatus status,
    required String message,
    PrayerLocationSelection? fallbackLocation,
  }) async {
    if (fallbackLocation != null) {
      await _loadPrayerTimesForSelection(
        fallbackLocation,
        emit: emit,
        status: status,
        statusMessage: message,
      );
      return;
    }

    emit(
      state.copyWith(
        prayerState: RequestState.error,
        prayerList: const [],
        currentPrayer: null,
        nextPrayer: null,
        currentPrayerModel: null,
        nextPrayerModel: null,
        selectedLocation: null,
        locationStatus: status,
        locationStatusMessage: message,
      ),
    );
  }

  Future<void> _loadPrayerTimesForSelection(
    PrayerLocationSelection selection, {
    required Emitter<PrayerTimeState> emit,
    PrayerLocationStatus status = PrayerLocationStatus.ready,
    String? statusMessage,
  }) async {
    final list = await prayerTimeService.getPrayerTimesForCoordinates(
      latitude: selection.latitude,
      longitude: selection.longitude,
      utcOffsetMinutes: selection.utcOffsetMinutes,
    );
    final resolvedPrayerState = _resolvePrayerState(
      prayers: list,
      utcOffsetMinutes: selection.utcOffsetMinutes,
    );

    emit(
      state.copyWith(
        prayerList: list,
        currentPrayer: resolvedPrayerState.currentPrayer,
        nextPrayer: resolvedPrayerState.nextPrayer,
        prayerState: RequestState.success,
        selectedLocation: selection,
        locationStatus: status,
        locationStatusMessage: statusMessage,
        currentPrayerModel: resolvedPrayerState.currentPrayer == null
            ? null
            : _buildPrayerModel(resolvedPrayerState.currentPrayer!),
        nextPrayerModel: resolvedPrayerState.nextPrayer == null
            ? null
            : _buildPrayerModel(resolvedPrayerState.nextPrayer!),
      ),
    );
    unawaited(_syncPrayerSilentModeSchedule(list));
    _startPrayerProgressTicker();
  }

  Future<void> _syncPrayerSilentModeSchedule(
    List<PrayerInfoModel> prayers,
  ) async {
    try {
      final settings = _silentModeSettingsStore.load();
      await _silentModeNativeService.applySchedule(
        settings: settings,
        prayers: prayers,
      );
    } catch (e) {
      logger.w('Failed to sync prayer silent mode schedule: $e');
    }
  }

  TimePrayerModel _buildPrayerModel(PrayerInfoModel prayer) {
    return TimePrayerModel(
      id: prayer.id,
      type: prayer.type,
      title: prayer.name,
      time: prayer.time12,
      image: prayer.type.imageAsset,
      content: prayer.type.description,
      color: Colors.white,
    );
  }

  void _startPrayerProgressTicker() {
    _prayerProgressTimer?.cancel();
    _prayerProgressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      add(const _PrayerTimeProgressTicked());
    });
  }

  void _refreshPrayerProgressFromState(Emitter<PrayerTimeState> emit) {
    final selectedLocation = state.selectedLocation;
    if (selectedLocation == null || state.prayerList.isEmpty) return;

    final resolvedPrayerState = _resolvePrayerState(
      prayers: state.prayerList,
      utcOffsetMinutes: selectedLocation.utcOffsetMinutes,
    );

    final currentChanged = _hasPrayerOccurrenceChanged(
      state.currentPrayer,
      resolvedPrayerState.currentPrayer,
    );
    final nextChanged = _hasPrayerOccurrenceChanged(
      state.nextPrayer,
      resolvedPrayerState.nextPrayer,
    );
    if (!currentChanged && !nextChanged) return;

    emit(
      state.copyWith(
        currentPrayer: resolvedPrayerState.currentPrayer,
        nextPrayer: resolvedPrayerState.nextPrayer,
        currentPrayerModel: resolvedPrayerState.currentPrayer == null
            ? null
            : _buildPrayerModel(resolvedPrayerState.currentPrayer!),
        nextPrayerModel: resolvedPrayerState.nextPrayer == null
            ? null
            : _buildPrayerModel(resolvedPrayerState.nextPrayer!),
      ),
    );
  }

  Future<void> _refreshForDayRolloverIfNeeded(
    Emitter<PrayerTimeState> emit,
  ) async {
    if (_isDayRolloverRefreshInProgress) return;
    final selectedLocation = state.selectedLocation;
    if (selectedLocation == null || state.prayerList.isEmpty) return;

    final now = _resolveLocationNow(selectedLocation.utcOffsetMinutes);
    final sourceDate = state.prayerList.first.time;
    if (_isSameDate(now, sourceDate)) return;

    _isDayRolloverRefreshInProgress = true;
    try {
      await _loadPrayerTimesForSelection(
        selectedLocation,
        emit: emit,
        status: state.locationStatus,
        statusMessage: state.locationStatusMessage,
      );
    } finally {
      _isDayRolloverRefreshInProgress = false;
    }
  }

  _ResolvedPrayerState _resolvePrayerState({
    required List<PrayerInfoModel> prayers,
    required int utcOffsetMinutes,
  }) {
    if (prayers.isEmpty) {
      return const _ResolvedPrayerState();
    }

    final now = _resolveLocationNow(utcOffsetMinutes);

    PrayerInfoModel? currentPrayer;
    PrayerInfoModel? nextPrayer;

    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        nextPrayer ??= prayer;
      } else {
        currentPrayer = prayer;
      }
    }

    if (nextPrayer == null) {
      final fajr = prayers.firstWhereOrNull((p) => p.type == Prayer.fajr);
      if (fajr != null) {
        nextPrayer = PrayerInfoModel(
          id: fajr.id,
          type: fajr.type,
          name: fajr.name,
          description: fajr.description,
          time: fajr.time.add(const Duration(days: 1)),
        );
      }
    }

    return _ResolvedPrayerState(
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
    );
  }

  DateTime _resolveLocationNow(int utcOffsetMinutes) {
    return DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes));
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasPrayerOccurrenceChanged(
    PrayerInfoModel? previous,
    PrayerInfoModel? next,
  ) {
    if (previous == null || next == null) {
      return previous != next;
    }

    return previous.type != next.type || previous.time != next.time;
  }

  bool _hasMeaningfulLocationChange(
    PrayerLocationSelection oldLocation,
    PrayerLocationSelection newLocation,
  ) {
    if (oldLocation.utcOffsetMinutes != newLocation.utcOffsetMinutes) {
      return true;
    }

    final distance = Geolocator.distanceBetween(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    return distance >= _locationChangeThresholdInMeters;
  }
}

class _ResolvedPrayerState {
  const _ResolvedPrayerState({
    this.currentPrayer,
    this.nextPrayer,
  });

  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
}
