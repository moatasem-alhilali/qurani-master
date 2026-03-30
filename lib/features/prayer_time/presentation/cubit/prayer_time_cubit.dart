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
import 'package:quran_app/main.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit({
    required this.prayerTimeService,
    required this.coordinatesService,
  }) : super(PrayerTimeState());
  final AdhanPrayerTimeService prayerTimeService;
  final DatabaseCoordinatesService coordinatesService;

  static PrayerTimeCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> initPrayerTime() async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );
    try {
      final savedLocation = await coordinatesService.getSavedLocation();
      if (savedLocation != null && savedLocation.isManual) {
        await _loadPrayerTimesForSelection(savedLocation);
        return;
      }

      await _loadUsingDeviceLocation(fallbackLocation: savedLocation);
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

  Future<void> updateLocation() async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );
    final fallbackLocation = await coordinatesService.getSavedLocation();
    await _loadUsingDeviceLocation(fallbackLocation: fallbackLocation);
  }

  Future<void> selectManualLocation(PrayerLocationSelection selection) async {
    emit(
      state.copyWith(
        prayerState: RequestState.loading,
        locationStatus: PrayerLocationStatus.resolving,
        locationStatusMessage: null,
      ),
    );

    try {
      await coordinatesService.saveLocationSelection(selection);
      await _loadPrayerTimesForSelection(selection);
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

  Future<void> useCurrentDeviceLocation() async {
    await updateLocation();
  }

  Future<void> _loadUsingDeviceLocation({
    PrayerLocationSelection? fallbackLocation,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _handleDeviceLocationFailure(
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
          fallbackLocation: fallbackLocation,
          status: PrayerLocationStatus.permissionDenied,
          message: 'يلزم منح صلاحية الموقع أو اختيار مدينة يدويًا.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        await _handleDeviceLocationFailure(
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
      await _loadPrayerTimesForSelection(selection);
    } catch (e) {
      logger.e(e);
      await _handleDeviceLocationFailure(
        fallbackLocation: fallbackLocation,
        status: PrayerLocationStatus.error,
        message: 'تعذر تحديد موقع الجهاز حاليًا',
      );
    }
  }

  Future<void> _handleDeviceLocationFailure({
    required PrayerLocationStatus status,
    required String message,
    PrayerLocationSelection? fallbackLocation,
  }) async {
    if (fallbackLocation != null) {
      await _loadPrayerTimesForSelection(
        fallbackLocation,
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
    PrayerLocationStatus status = PrayerLocationStatus.ready,
    String? statusMessage,
  }) async {
    final list = await prayerTimeService.getPrayerTimesForCoordinates(
      latitude: selection.latitude,
      longitude: selection.longitude,
      utcOffsetMinutes: selection.utcOffsetMinutes,
    );
    final current = prayerTimeService.getCurrentPrayer();
    final next = prayerTimeService.getNextPrayer();
    final prayerModels = _buildPrayerModels(list);

    emit(
      state.copyWith(
        prayerList: list,
        currentPrayer: current,
        nextPrayer: next,
        prayerState: RequestState.success,
        selectedLocation: selection,
        locationStatus: status,
        locationStatusMessage: statusMessage,
        currentPrayerModel: prayerModels.firstWhereOrNull(
          (p) => p.type == current?.type,
        ),
        nextPrayerModel: prayerModels.firstWhereOrNull(
          (p) => p.type == next?.type,
        ),
      ),
    );
  }

  List<TimePrayerModel> _buildPrayerModels(List<PrayerInfoModel> list) {
    return list
        .map(
          (prayer) => TimePrayerModel(
            id: prayer.id,
            type: prayer.type,
            title: prayer.name,
            time: prayer.time12,
            image: prayer.type.imageAsset,
            content: prayer.type.description,
            color: Colors.white,
          ),
        )
        .toList();
  }
}
