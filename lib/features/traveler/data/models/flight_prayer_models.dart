import 'package:adhan/adhan.dart';

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

  String get prayerNameAr {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return 'غير محدد';
    }
  }

  String get shortName {
    switch (prayer) {
      case Prayer.fajr:
        return 'فجر';
      case Prayer.sunrise:
        return 'شروق';
      case Prayer.dhuhr:
        return 'ظهر';
      case Prayer.asr:
        return 'عصر';
      case Prayer.maghrib:
        return 'مغرب';
      case Prayer.isha:
        return 'عشاء';
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
