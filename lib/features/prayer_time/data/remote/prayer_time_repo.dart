import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/extensions/list_extension.dart';
import 'package:quran_app/core/notification/data/notification_data_const.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/main.dart';

abstract class PrayerTimeService {
  Future<List<PrayerInfoModel>> getTodayPrayerTimes({Coordinates? coordinates});
  Future<List<PrayerInfoModel>> getPrayerTimesForCoordinates({
    required double latitude,
    required double longitude,
    int? utcOffsetMinutes,
  });
  PrayerInfoModel? getCurrentPrayer();

  PrayerInfoModel? getNextPrayer();
}

class AdhanPrayerTimeService implements PrayerTimeService {
  AdhanPrayerTimeService({
    DatabaseCoordinatesService? coordinatesService,
  }) : _coordinatesService = coordinatesService ?? DatabaseCoordinatesService();

  final DatabaseCoordinatesService _coordinatesService;
  late PrayerTimes _prayerTimes;
  late List<PrayerInfoModel> _prayerInfoList;

  @override
  Future<List<PrayerInfoModel>> getTodayPrayerTimes({
    Coordinates? coordinates,
  }) async {
    final savedLocation = await _coordinatesService.getSavedLocation();
    final resolvedCoordinates = coordinates ??
        (savedLocation != null
            ? Coordinates(savedLocation.latitude, savedLocation.longitude)
            : await _resolveCoordinates());
    final utcOffset = savedLocation == null
        ? null
        : Duration(minutes: savedLocation.utcOffsetMinutes);
    return _buildPrayerInfoListForOffset(resolvedCoordinates, utcOffset);
  }

  @override
  Future<List<PrayerInfoModel>> getPrayerTimesForCoordinates({
    required double latitude,
    required double longitude,
    int? utcOffsetMinutes,
  }) async {
    return _buildPrayerInfoListForOffset(
      Coordinates(latitude, longitude),
      utcOffsetMinutes == null ? null : Duration(minutes: utcOffsetMinutes),
    );
  }

  List<PrayerInfoModel> _buildPrayerInfoListForOffset(
    Coordinates coordinates,
    Duration? utcOffset,
  ) {
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi;

    if (utcOffset != null) {
      final locationDate = DateTime.now().toUtc().add(utcOffset);
      _prayerTimes = PrayerTimes.utcOffset(
        coordinates,
        DateComponents.from(locationDate),
        params,
        utcOffset,
      );
    } else {
      _prayerTimes = PrayerTimes.today(coordinates, params);
    }
    return _prayerInfoList =
        NotificationDataConstSeed().prayerInfoListSeed(_prayerTimes);
  }

  @override
  PrayerInfoModel? getCurrentPrayer() {
    final current = _prayerTimes.currentPrayer();
    return _prayerInfoList.firstWhereOrNull((p) => p.type == current);
  }

  @override
  PrayerInfoModel? getNextPrayer() {
    final next = _prayerTimes.nextPrayer();
    return _prayerInfoList.firstWhereOrNull((p) => p.type == next);
  }

  Future<Coordinates> _resolveCoordinates() async {
    try {
      final savedLocation = await _coordinatesService.getSavedLocation();
      if (savedLocation != null) {
        return Coordinates(savedLocation.latitude, savedLocation.longitude);
      }

      if (!CacheConfig.hasInitLocal) {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      }

      if (CacheConfig.hasInitLocal) {
        final coordsMap = await _coordinatesService.getCoordinates();
        if (coordsMap != null) {
          return Coordinates(
            coordsMap['latitude'] as double,
            coordsMap['longitude'] as double,
          );
        }
      }

      final pos = await ServicesLocation.determinePosition();
      final coords = Coordinates(pos.latitude, pos.longitude);

      await CacheService().setBool('hasInitLocal', true);
      await _coordinatesService.setCoordinates(
        coords.latitude,
        coords.longitude,
      );
      return coords;
    } catch (e) {
      logger.e('Failed to resolve coordinates: $e');
      rethrow;
    }
  }
}
