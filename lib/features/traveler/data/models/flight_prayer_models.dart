import 'package:adhan/adhan.dart';
import 'package:quran_app/l10n/l10n.dart';

class FlightTrackPoint {
  const FlightTrackPoint({
    required this.latitude,
    required this.longitude,
    required this.timestampUtc,
    this.altitudeMeters,
  });

  final double latitude;
  final double longitude;
  final DateTime timestampUtc;
  final double? altitudeMeters;
}

class FlightTrackResult {
  const FlightTrackResult({
    required this.flightNumber,
    required this.sourceLabel,
    required this.departureUtc,
    required this.arrivalUtc,
    required this.originLabel,
    required this.destinationLabel,
    required this.trackPoints,
    this.isLiveSource = false,
  });

  final String flightNumber;
  final String sourceLabel;
  final DateTime departureUtc;
  final DateTime arrivalUtc;
  final String originLabel;
  final String destinationLabel;
  final List<FlightTrackPoint> trackPoints;
  final bool isLiveSource;
}

class FlightPrayerEvent {
  const FlightPrayerEvent({
    required this.prayer,
    required this.eventUtc,
    required this.eventLocal,
    required this.utcOffsetMinutes,
    required this.latitude,
    required this.longitude,
  });

  final Prayer prayer;
  final DateTime eventUtc;
  final DateTime eventLocal;
  final int utcOffsetMinutes;
  final double latitude;
  final double longitude;

  /// اسم الصلاة بلغة الواجهة.
  String prayerName(L10n l10n) => prayer == Prayer.none
      ? l10n.travelerPrayerUnknown
      : l10n.prayerName(prayer.name);

  /// اسم مختصر لعلامات الخريطة الصغيرة.
  String shortName(L10n l10n) {
    switch (prayer) {
      case Prayer.fajr:
        return l10n.travelerPrayerShortFajr;
      case Prayer.sunrise:
        return l10n.travelerPrayerShortSunrise;
      case Prayer.dhuhr:
        return l10n.travelerPrayerShortDhuhr;
      case Prayer.asr:
        return l10n.travelerPrayerShortAsr;
      case Prayer.maghrib:
        return l10n.travelerPrayerShortMaghrib;
      case Prayer.isha:
        return l10n.travelerPrayerShortIsha;
      case Prayer.none:
        return '---';
    }
  }
}

class FlightPrayerTimelineResult {
  const FlightPrayerTimelineResult({
    required this.track,
    required this.prayerEvents,
  });

  final FlightTrackResult track;
  final List<FlightPrayerEvent> prayerEvents;
}
