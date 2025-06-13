import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/extensions/list_extension.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/main.dart';

abstract class PrayerTimeService {
  Future<List<PrayerInfoModel>> getTodayPrayerTimes();
  PrayerInfoModel? getCurrentPrayer();
  PrayerInfoModel? getNextPrayer();
}

class AdhanPrayerTimeService implements PrayerTimeService {
  late PrayerTimes _prayerTimes;
  late List<PrayerInfoModel> _prayerInfoList;

  @override
  Future<List<PrayerInfoModel>> getTodayPrayerTimes() async {
    final coordinates = await _resolveCoordinates();
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi;

    _prayerTimes = PrayerTimes.today(coordinates, params);
    _prayerInfoList = _mapToPrayerInfoList(_prayerTimes);
    return _prayerInfoList;
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

  List<PrayerInfoModel> _mapToPrayerInfoList(PrayerTimes times) {
    return [
      PrayerInfoModel(
        id: 200,
        type: Prayer.fajr,
        name: 'الفجر',
        description: 'اذان الفجر',
        time: times.fajr,
      ),
      PrayerInfoModel(
        id: 201,
        type: Prayer.sunrise,
        name: 'الشروق',
        description: 'اذان الشروق',
        time: times.sunrise,
      ),
      PrayerInfoModel(
        id: 202,
        type: Prayer.dhuhr,
        name: 'الظهر',
        description: 'اذان الظهر',
        time: times.dhuhr,
      ),
      PrayerInfoModel(
        id: 203,
        type: Prayer.asr,
        name: 'العصر',
        description: 'اذان العصر',
        time: times.asr,
      ),
      PrayerInfoModel(
        id: 204,
        type: Prayer.maghrib,
        name: 'المغرب',
        description: 'اذان المغرب',
        time: times.maghrib,
      ),
      PrayerInfoModel(
        id: 205,
        type: Prayer.isha,
        name: 'العشاء',
        description: 'اذان العشاء',
        time: times.isha,
      ),
    ];
  }

  Future<Coordinates> _resolveCoordinates() async {
    try {
      if (!CacheConfig.hasInitLocal) {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      }

      if (CacheConfig.hasInitLocal) {
        final coordsMap = await DatabaseCoordinatesService().getCoordinates();
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
      await DatabaseCoordinatesService()
          .setCoordinates(coords.latitude, coords.longitude);
      return coords;
    } catch (e) {
      logger.e("Failed to resolve coordinates: $e");
      rethrow;
    }
  }
}
