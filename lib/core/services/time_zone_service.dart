import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneService {
  factory TimeZoneService() {
    return _instance;
  }

  TimeZoneService._internal();
  static final TimeZoneService _instance = TimeZoneService._internal();

  Future<void> setupTimezone() async {
    tz.initializeTimeZones();

    final localTimezone = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(localTimezone);

    tz.setLocalLocation(location);
  }
}
