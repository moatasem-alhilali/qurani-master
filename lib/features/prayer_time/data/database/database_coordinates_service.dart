import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

class DatabaseCoordinatesService {
  final _db = DatabaseService();
  final _cache = CacheService();

  static const _labelKey = 'prayer_location_label';
  static const _sourceKey = 'prayer_location_source';
  static const _localityKey = 'prayer_location_locality';
  static const _administrativeAreaKey = 'prayer_location_administrative_area';
  static const _countryKey = 'prayer_location_country';
  static const _utcOffsetKey = 'prayer_location_utc_offset_minutes';
  static const _hasInitKey = 'hasInitLocal';

  Future<void> setCoordinates(
    double latitude,
    double longitude, {
    String? label,
    PrayerLocationSource source = PrayerLocationSource.device,
    int? utcOffsetMinutes,
    String? locality,
    String? administrativeArea,
    String? country,
  }) async {
    await _db.delete(DatabaseTables.coordinates, 1); // remove old if exists
    await _db.insert(DatabaseTables.coordinates, {
      'latitude': latitude,
      'longitude': longitude,
    });

    await _cache.setBool(_hasInitKey, true);
    await _cache.setString(_sourceKey, source.name);
    if (utcOffsetMinutes != null) {
      await _cache.setInt(_utcOffsetKey, utcOffsetMinutes);
    }

    if (label != null) {
      await _cache.setString(_labelKey, label);
    }
    if (locality != null) {
      await _cache.setString(_localityKey, locality);
    }
    if (administrativeArea != null) {
      await _cache.setString(_administrativeAreaKey, administrativeArea);
    }
    if (country != null) {
      await _cache.setString(_countryKey, country);
    }
  }

  Future<void> saveLocationSelection(PrayerLocationSelection selection) async {
    await setCoordinates(
      selection.latitude,
      selection.longitude,
      label: selection.label,
      source: selection.source,
      utcOffsetMinutes: selection.utcOffsetMinutes,
      locality: selection.locality,
      administrativeArea: selection.administrativeArea,
      country: selection.country,
    );
  }

  Future<Map<String, dynamic>?> getCoordinates() async {
    final rows = await _db.get(DatabaseTables.coordinates);
    if (rows.isNotEmpty) {
      return rows.first;
    }
    return null;
  }

  Future<PrayerLocationSelection?> getSavedLocation() async {
    final coordinates = await getCoordinates();
    if (coordinates == null) return null;

    return PrayerLocationSelection(
      latitude: coordinates['latitude'] as double,
      longitude: coordinates['longitude'] as double,
      label: _cache.getString(_labelKey) ?? 'الموقع المحفوظ',
      source: PrayerLocationSelection.sourceFromStorage(
        _cache.getString(_sourceKey),
      ),
      utcOffsetMinutes: _cache.getInt(_utcOffsetKey) ??
          DateTime.now().timeZoneOffset.inMinutes,
      locality: _cache.getString(_localityKey),
      administrativeArea: _cache.getString(_administrativeAreaKey),
      country: _cache.getString(_countryKey),
    );
  }

  Future<void> clearCoordinates() async {
    await _db.delete(DatabaseTables.coordinates, 1);
    await _cache.remove(_labelKey);
    await _cache.remove(_sourceKey);
    await _cache.remove(_localityKey);
    await _cache.remove(_administrativeAreaKey);
    await _cache.remove(_countryKey);
    await _cache.remove(_utcOffsetKey);
    await _cache.setBool(_hasInitKey, false);
  }
}
