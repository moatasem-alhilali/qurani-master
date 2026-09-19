import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_location_resolver.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/l10n/l10n.dart';

class FlightTrackProvider {
  const FlightTrackProvider();

  Future<FlightTrackResult> fetchTrack({
    required String flightNumber,
  }) {
    throw UnimplementedError();
  }
}

class FlightPrayerService {
  FlightPrayerService({
    FlightTrackProvider? trackProvider,
  }) : _trackProvider = trackProvider ?? MockFlightTrackProvider();

  final FlightTrackProvider _trackProvider;

  static final List<Prayer> _trackedPrayers = <Prayer>[
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  Future<FlightPrayerTimelineResult> buildTimeline({
    required String flightNumber,
  }) async {
    final normalized = _normalizeFlightNumber(flightNumber);
    _validateFlightNumberOrThrow(normalized);

    final track = await _trackProvider.fetchTrack(flightNumber: normalized);
    final prayerEvents = _computePrayerEvents(track);

    return FlightPrayerTimelineResult(
      track: track,
      prayerEvents: prayerEvents,
    );
  }

  static String normalizeFlightNumber(String value) {
    return _normalizeFlightNumber(value);
  }

  static void validateFlightNumberOrThrow(String value) {
    _validateFlightNumberOrThrow(value);
  }

  static String _normalizeFlightNumber(String value) {
    final trimmed = value.trim().toUpperCase();
    return trimmed.replaceAll(RegExp(r'\s+'), '');
  }

  static void _validateFlightNumberOrThrow(String value) {
    final regex = RegExp(r'^[A-Z]{2,3}[0-9]{1,4}[A-Z]?$');
    if (!regex.hasMatch(value)) {
      throw const FormatException('رقم الرحلة غير صحيح');
    }
  }

  List<FlightPrayerEvent> _computePrayerEvents(FlightTrackResult track) {
    final events = <FlightPrayerEvent>[];
    final flightStart = track.departureUtc;
    final flightEnd = track.arrivalUtc;
    final calculationSettings = PrayerCalculationParams.load();

    for (final point in track.trackPoints) {
      final offsetMinutes =
          PrayerLocationResolver.estimateUtcOffsetMinutes(point.longitude);
      final offset = Duration(minutes: offsetMinutes);
      final localTime = point.timestampUtc.add(offset);

      final prayerTimes = PrayerTimes.utcOffset(
        Coordinates(point.latitude, point.longitude),
        DateComponents.from(localTime),
        PrayerCalculationParams.build(
          date: localTime,
          settings: calculationSettings,
        ),
        offset,
      );

      final byPrayer = <Prayer, DateTime>{
        Prayer.fajr: prayerTimes.fajr,
        Prayer.dhuhr: prayerTimes.dhuhr,
        Prayer.asr: prayerTimes.asr,
        Prayer.maghrib: prayerTimes.maghrib,
        Prayer.isha: prayerTimes.isha,
      };

      for (final prayer in _trackedPrayers) {
        final localEvent = byPrayer[prayer];
        if (localEvent == null) {
          continue;
        }

        final eventUtc = localEvent.subtract(offset);
        if (eventUtc.isBefore(flightStart) || eventUtc.isAfter(flightEnd)) {
          continue;
        }

        events.add(
          FlightPrayerEvent(
            prayer: prayer,
            eventUtc: eventUtc,
            eventLocal: localEvent,
            utcOffsetMinutes: offsetMinutes,
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      }
    }

    events.sort(
      (first, second) => first.eventUtc.compareTo(second.eventUtc),
    );

    return _deduplicateEvents(events);
  }

  List<FlightPrayerEvent> _deduplicateEvents(List<FlightPrayerEvent> events) {
    final filtered = <FlightPrayerEvent>[];

    for (final event in events) {
      final duplicateIndex = filtered.indexWhere(
        (existing) =>
            existing.prayer == event.prayer &&
            existing.eventUtc.difference(event.eventUtc).inMinutes.abs() <= 35,
      );

      if (duplicateIndex == -1) {
        filtered.add(event);
        continue;
      }

      final existing = filtered[duplicateIndex];
      if (event.eventUtc.isBefore(existing.eventUtc)) {
        filtered[duplicateIndex] = event;
      }
    }

    filtered.sort(
      (first, second) => first.eventUtc.compareTo(second.eventUtc),
    );
    return filtered;
  }
}

class MockFlightTrackProvider implements FlightTrackProvider {
  static const List<_AirportSeed> _seeds = <_AirportSeed>[
    _AirportSeed(code: 'RUH', lat: 24.9576, lon: 46.6988),
    _AirportSeed(code: 'JED', lat: 21.6702, lon: 39.1525),
    _AirportSeed(code: 'DXB', lat: 25.2528, lon: 55.3644),
    _AirportSeed(code: 'DOH', lat: 25.2731, lon: 51.6081),
    _AirportSeed(code: 'IST', lat: 41.2753, lon: 28.7519),
    _AirportSeed(code: 'CAI', lat: 30.1219, lon: 31.4056),
    _AirportSeed(code: 'KUL', lat: 2.7456, lon: 101.7072),
    _AirportSeed(code: 'LHR', lat: 51.4700, lon: -0.4543),
    _AirportSeed(code: 'CDG', lat: 49.0097, lon: 2.5479),
    _AirportSeed(code: 'JFK', lat: 40.6413, lon: -73.7781),
  ];

  @override
  Future<FlightTrackResult> fetchTrack({
    required String flightNumber,
  }) async {
    final seed = _seedFromFlight(flightNumber);

    final startIndex = seed % _seeds.length;
    var endIndex = (seed * 7 + 3) % _seeds.length;
    if (endIndex == startIndex) {
      endIndex = (endIndex + 1) % _seeds.length;
    }

    final origin = _seeds[startIndex];
    final destination = _seeds[endIndex];

    final now = DateTime.now().toUtc();
    final departureUtc = now.subtract(const Duration(minutes: 35));
    final durationHours = 3 + (seed % 6);
    final arrivalUtc = departureUtc.add(Duration(hours: durationHours));

    final points = _buildInterpolatedTrack(
      origin: origin,
      destination: destination,
      seed: seed,
      departureUtc: departureUtc,
      arrivalUtc: arrivalUtc,
    );

    final l10n = L10nService.current;

    return FlightTrackResult(
      flightNumber: flightNumber,
      sourceLabel: l10n.travelerSourceMock,
      departureUtc: departureUtc,
      arrivalUtc: arrivalUtc,
      originLabel: '${_cityName(l10n, origin.code)} (${origin.code})',
      destinationLabel:
          '${_cityName(l10n, destination.code)} (${destination.code})',
      trackPoints: points,
    );
  }

  static String _cityName(L10n l10n, String code) {
    switch (code) {
      case 'RUH':
        return l10n.travelerCityRiyadh;
      case 'JED':
        return l10n.travelerCityJeddah;
      case 'DXB':
        return l10n.travelerCityDubai;
      case 'DOH':
        return l10n.travelerCityDoha;
      case 'IST':
        return l10n.travelerCityIstanbul;
      case 'CAI':
        return l10n.travelerCityCairo;
      case 'KUL':
        return l10n.travelerCityKualaLumpur;
      case 'LHR':
        return l10n.travelerCityLondon;
      case 'CDG':
        return l10n.travelerCityParis;
      case 'JFK':
        return l10n.travelerCityNewYork;
      default:
        return code;
    }
  }

  int _seedFromFlight(String flightNumber) {
    final units = flightNumber.codeUnits;
    var total = 0;
    for (final item in units) {
      total = total + item;
    }
    return total;
  }

  List<FlightTrackPoint> _buildInterpolatedTrack({
    required _AirportSeed origin,
    required _AirportSeed destination,
    required int seed,
    required DateTime departureUtc,
    required DateTime arrivalUtc,
  }) {
    const pointsCount = 64;
    final points = <FlightTrackPoint>[];

    final totalDuration = arrivalUtc.difference(departureUtc);
    final latCurve = ((seed % 17) - 8) / 100;
    final lonCurve = ((seed % 19) - 9) / 100;

    for (var i = 0; i < pointsCount; i++) {
      final progress = i / (pointsCount - 1);
      final wobble = math.sin(progress * math.pi) * 0.12;

      final baseLat = _lerp(origin.lat, destination.lat, progress);
      final baseLon = _lerp(origin.lon, destination.lon, progress);

      final lat = baseLat + wobble * latCurve;
      final lon = baseLon + wobble * lonCurve;

      final time = departureUtc.add(
        Duration(
          milliseconds: (totalDuration.inMilliseconds * progress).round(),
        ),
      );

      final altitude = 10500 + math.sin(progress * math.pi) * 700;

      points.add(
        FlightTrackPoint(
          latitude: lat,
          longitude: lon,
          timestampUtc: time,
          altitudeMeters: altitude,
        ),
      );
    }

    return points;
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class _AirportSeed {
  const _AirportSeed({
    required this.code,
    required this.lat,
    required this.lon,
  });

  final String code;
  final double lat;
  final double lon;
}
