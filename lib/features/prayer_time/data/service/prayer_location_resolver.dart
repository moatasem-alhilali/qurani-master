import 'package:geocoding/geocoding.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

class PrayerLocationResolver {
  static Future<PrayerLocationSelection> fromCoordinates({
    required double latitude,
    required double longitude,
    PrayerLocationSource source = PrayerLocationSource.device,
    String? fallbackLabel,
    int? utcOffsetMinutes,
  }) async {
    Placemark? placemark;

    try {
      await setLocaleIdentifier('ar');
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        placemark = placemarks.first;
      }
    } catch (_) {}

    final locality = _clean(placemark?.locality);
    final administrativeArea = _clean(placemark?.administrativeArea);
    final country = _clean(placemark?.country);
    final label = locality ??
        administrativeArea ??
        country ??
        fallbackLabel ??
        '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';

    return PrayerLocationSelection(
      latitude: latitude,
      longitude: longitude,
      label: label,
      source: source,
      utcOffsetMinutes: utcOffsetMinutes ?? estimateUtcOffsetMinutes(longitude),
      locality: locality,
      administrativeArea: administrativeArea,
      country: country,
    );
  }

  static Future<List<PrayerLocationSelection>> searchByQuery(
    String query,
  ) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    try {
      await setLocaleIdentifier('ar');
      final locations = await locationFromAddress(trimmed);
      final unique = <String>{};
      final futures = locations.take(6).map((location) async {
        final selection = await fromCoordinates(
          latitude: location.latitude,
          longitude: location.longitude,
          source: PrayerLocationSource.manualSearch,
          fallbackLabel: trimmed,
        );

        final key = '${selection.latitude.toStringAsFixed(4)}:'
            '${selection.longitude.toStringAsFixed(4)}';
        if (!unique.add(key)) return null;
        return selection;
      });

      final results = await Future.wait(futures);
      return results.whereType<PrayerLocationSelection>().toList();
    } catch (_) {
      return const [];
    }
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  static int estimateUtcOffsetMinutes(double longitude) {
    final rawMinutes = (longitude / 15) * 60;
    final roundedToHalfHour = (rawMinutes / 30).round() * 30;
    return roundedToHalfHour.clamp(-720, 840);
  }
}
