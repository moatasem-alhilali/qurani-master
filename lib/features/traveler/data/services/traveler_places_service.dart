import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';

class TravelerLocationContext {
  const TravelerLocationContext({
    required this.latitude,
    required this.longitude,
    required this.countryName,
    required this.isoCountryCode,
    required this.label,
  });

  final double latitude;
  final double longitude;
  final String countryName;
  final String? isoCountryCode;
  final String label;
}

class TravelerPlacesService {
  static const String _overpassApiUrl =
      'https://overpass-api.de/api/interpreter';

  static const Distance _distance = Distance();

  static Future<TravelerLocationContext> resolveCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    Placemark? placemark;
    try {
      await setLocaleIdentifier('ar');
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        placemark = placemarks.first;
      }
    } catch (_) {}

    final locality = _cleanText(placemark?.locality);
    final administrativeArea = _cleanText(placemark?.administrativeArea);
    final country = _cleanText(placemark?.country);

    final labelCandidates = <String>[
      if (locality.isNotEmpty) locality,
      if (administrativeArea.isNotEmpty) administrativeArea,
      if (country.isNotEmpty) country,
    ];

    final label = labelCandidates.isEmpty
        ? '${position.latitude.toStringAsFixed(4)}، '
            '${position.longitude.toStringAsFixed(4)}'
        : labelCandidates.join('، ');

    return TravelerLocationContext(
      latitude: position.latitude,
      longitude: position.longitude,
      countryName: country,
      isoCountryCode: placemark?.isoCountryCode,
      label: label,
    );
  }

  static Future<List<TravelerPlace>> fetchNearbyPlaces({
    required TravelerPlaceType placeType,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    final query = _buildOverpassQuery(
      placeType: placeType,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
    );

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 18),
      ),
    );

    final response = await dio.post<dynamic>(
      _overpassApiUrl,
      data: query,
      options: Options(
        contentType: Headers.textPlainContentType,
        responseType: ResponseType.json,
      ),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return const [];
    }

    final elements = data['elements'];
    if (elements is! List<dynamic>) {
      return const [];
    }

    final origin = LatLng(latitude, longitude);
    final results = <TravelerPlace>[];
    final uniqueKeys = <String>{};

    for (final rawElement in elements) {
      if (rawElement is! Map<dynamic, dynamic>) {
        continue;
      }

      final element = Map<String, dynamic>.from(rawElement);
      final point = _extractPoint(element);
      if (point == null) {
        continue;
      }

      final tagsRaw = element['tags'];
      final tags = tagsRaw is Map<dynamic, dynamic>
          ? Map<String, dynamic>.from(tagsRaw)
          : <String, dynamic>{};

      final defaultName =
          placeType == TravelerPlaceType.mosque ? 'مسجد قريب' : 'مطعم حلال';
      final placeName = _cleanText(tags['name']);
      final finalName = placeName.isEmpty ? defaultName : placeName;

      final uniqueKey = '${point.latitude.toStringAsFixed(5)}:'
          '${point.longitude.toStringAsFixed(5)}:'
          '$finalName';
      if (!uniqueKeys.add(uniqueKey)) {
        continue;
      }

      final distanceMeters = _distance.as(
        LengthUnit.Meter,
        origin,
        point,
      );

      final elementType = _cleanText(element['type']);
      final elementId = _cleanText(element['id']);
      final id = '$elementType:$elementId:$uniqueKey';

      results.add(
        TravelerPlace(
          id: id,
          name: finalName,
          latitude: point.latitude,
          longitude: point.longitude,
          distanceMeters: distanceMeters,
          address: _buildAddress(tags),
          phone: _readPhone(tags),
          openingHours: _cleanText(tags['opening_hours']),
        ),
      );
    }

    results.sort(
      (first, second) => first.distanceMeters.compareTo(second.distanceMeters),
    );

    return results.take(80).toList();
  }

  static String _buildOverpassQuery({
    required TravelerPlaceType placeType,
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) {
    final lat = latitude.toStringAsFixed(6);
    final lon = longitude.toStringAsFixed(6);

    final mosqueFilter = '''
(
  nwr(around:$radiusMeters,$lat,$lon)["amenity"="mosque"];
  nwr(around:$radiusMeters,$lat,$lon)
    ["amenity"="place_of_worship"]["religion"="muslim"];
  nwr(around:$radiusMeters,$lat,$lon)["building"="mosque"];
);
''';

    final halalRestaurantsFilter = '''
(
  nwr(around:$radiusMeters,$lat,$lon)
    ["amenity"="restaurant"]["diet:halal"~"yes|only", i];
  nwr(around:$radiusMeters,$lat,$lon)
    ["amenity"~"restaurant|fast_food", i]["cuisine"~"halal", i];
  nwr(around:$radiusMeters,$lat,$lon)
    ["amenity"~"restaurant|fast_food", i]["name"~"halal|حلال", i];
);
''';

    final filter = placeType == TravelerPlaceType.mosque
        ? mosqueFilter
        : halalRestaurantsFilter;

    return '''
[out:json][timeout:25];
$filter
out center 120;
''';
  }

  static LatLng? _extractPoint(Map<String, dynamic> element) {
    final directLat = _toDouble(element['lat']);
    final directLon = _toDouble(element['lon']);
    if (directLat != null && directLon != null) {
      return LatLng(directLat, directLon);
    }

    final centerRaw = element['center'];
    if (centerRaw is! Map<dynamic, dynamic>) {
      return null;
    }

    final center = Map<String, dynamic>.from(centerRaw);
    final centerLat = _toDouble(center['lat']);
    final centerLon = _toDouble(center['lon']);
    if (centerLat == null || centerLon == null) {
      return null;
    }

    return LatLng(centerLat, centerLon);
  }

  static String _buildAddress(Map<String, dynamic> tags) {
    final fields = <String>[
      _cleanText(tags['addr:street']),
      _cleanText(tags['addr:housenumber']),
      _cleanText(tags['addr:suburb']),
      _cleanText(tags['addr:city']),
      _cleanText(tags['addr:state']),
      _cleanText(tags['addr:country']),
    ].where((item) => item.isNotEmpty).toList();

    if (fields.isEmpty) {
      return 'بدون عنوان تفصيلي';
    }

    return fields.join('، ');
  }

  static String _readPhone(Map<String, dynamic> tags) {
    final direct = _cleanText(tags['phone']);
    if (direct.isNotEmpty) {
      return direct;
    }
    return _cleanText(tags['contact:phone']);
  }

  static double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
  }

  static String _cleanText(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }
}
