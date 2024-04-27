// import 'package:adhan/adhan.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:quran_app/core/services/services_location.dart';
// import 'package:quran_app/core/shared/export/export-shared.dart';
// import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
// import 'package:quran_app/main.dart';

// String fajr = "";
// String sunrise = "";
// String dhuhr = "";
// String asr = "";
// String maghrib = "";
// String isha = "";
// Prayer currentPlayer = Prayer.none;
// String sunset = "";
// DateTime? nextDateTimePrayer;

// class PrayerTime24Hour {
//   static String prayFajr = "";
//   static String sunrise = "";

//   static String prayDuhr = "";

//   //
//   static String prayAsr = "";
//   //
//   static String prayMagrib = "";
//   //
//   static String prayIsha = "";
// }

// class PrayerTimeController {
//   static Prayer? next;
//   static String? nextPrayerTime;
//   static bool isGetTheTimePrayer = false;

//   static Future<void> initPrayerTimes() async {
//     try {
//       final permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         await Geolocator.requestPermission();
//       }
//       //
//       final poss = await ServicesLocation.determinePosition();

//       final myCoordinates = Coordinates(
//         poss.latitude,
//         poss.longitude,
//       );

//       final params = CalculationMethod.muslim_world_league.getParameters();
//       params.madhab = Madhab.shafi;
//       final prayerTimes = PrayerTimes.today(myCoordinates, params);

//       //12 hour
//       fajr = DateFormat.jm().format(prayerTimes.fajr);
//       sunrise = DateFormat.jm().format(prayerTimes.sunrise);
//       dhuhr = DateFormat.jm().format(prayerTimes.dhuhr);
//       asr = DateFormat.jm().format(prayerTimes.asr);
//       maghrib = DateFormat.jm().format(prayerTimes.maghrib);
//       isha = DateFormat.jm().format(prayerTimes.isha);

//       //24 hour
//       PrayerTime24Hour.prayFajr = DateFormat.Hm().format(prayerTimes.fajr);
//       PrayerTime24Hour.sunrise = DateFormat.Hm().format(prayerTimes.sunrise);
//       PrayerTime24Hour.prayDuhr = DateFormat.Hm().format(prayerTimes.dhuhr);
//       PrayerTime24Hour.prayAsr = DateFormat.Hm().format(prayerTimes.asr);
//       PrayerTime24Hour.prayMagrib = DateFormat.Hm().format(prayerTimes.maghrib);
//       PrayerTime24Hour.prayIsha = DateFormat.Hm().format(prayerTimes.isha);
//       //
//       DateTime? currentPrayerTime = prayerTimes.timeForPrayer(currentPlayer);
//       next = prayerTimes.nextPrayer();
//       if (next != null && prayerTimes.timeForPrayer(next!) != null) {
//         nextPrayerTime =
//             DateFormat.jm().format(prayerTimes.timeForPrayer(next!)!);
//         nextDateTimePrayer = prayerTimes.timeForPrayer(next!);
//       }
//     } catch (e) {
//       logger.e(e);
//     }
//   }

// //get Current Prayer
//   static getNextPrayer() {
//     if (next == Prayer.fajr) {
//       return fagr_data;
//     }

//     if (next == Prayer.dhuhr) {
//       return zhur_data;
//     }
//     if (next == Prayer.asr) {
//       return asr_data;
//     }
//     if (next == Prayer.maghrib) {
//       return magrib_data;
//     }
//     if (next == Prayer.isha) {
//       return iysh_data;
//     }
//     if (next == Prayer.sunrise) {
//       return sunset_data;
//     }
//   }

// //set Current Color Prayer
//   static void setCurrentColorPrayer() {
//     for (var element in prayerData) {
//       if (PrayerTimeController.getNextPrayer().time == element.time) {
//         nextCurrentPrayer = element.id;
//       }
//     }
//   }

//   //

// }

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
import 'package:quran_app/main.dart';

class PrayerTime {
  String time12Hour;
  String time24Hour;

  PrayerTime(this.time12Hour, this.time24Hour);
}

class PrayerTimesProvider {
  late PrayerTimes prayerTimes;
  late List<PrayerTime> prayerTimeList;
  late Prayer currentPrayer;
  late Prayer? nextPrayer;
  late DateTime? nextPrayerTime;

  Future<void> initialize() async {
    try {
      Coordinates coordinates = await getCoordinates();
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      prayerTimes = PrayerTimes.today(coordinates, params);

      prayerTimeList = [
        //0
        PrayerTime(DateFormat.jm().format(prayerTimes.fajr),
            DateFormat.Hm().format(prayerTimes.fajr)),

        //1
        PrayerTime(DateFormat.jm().format(prayerTimes.sunrise),
            DateFormat.Hm().format(prayerTimes.sunrise)),

        //2
        PrayerTime(DateFormat.jm().format(prayerTimes.dhuhr),
            DateFormat.Hm().format(prayerTimes.dhuhr)),

        //3
        PrayerTime(DateFormat.jm().format(prayerTimes.asr),
            DateFormat.Hm().format(prayerTimes.asr)),

        //4
        PrayerTime(DateFormat.jm().format(prayerTimes.maghrib),
            DateFormat.Hm().format(prayerTimes.maghrib)),

        //5
        PrayerTime(DateFormat.jm().format(prayerTimes.isha),
            DateFormat.Hm().format(prayerTimes.isha)),
      ];

      currentPrayer = prayerTimes.currentPrayer();
      nextPrayer = prayerTimes.nextPrayer();
      nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer!);
    } catch (e) {
      logger.e(e);
    }
  }

  Map<String, dynamic> getNextPrayerName() {
    if (nextPrayer != null) {
      switch (nextPrayer) {
        case Prayer.fajr:
          return {
            "title": 'الشروق',
            "time": prayerTimeList[1].time12Hour,
          };

        case Prayer.dhuhr:
          return {
            "title": 'العصر',
            "time": prayerTimeList[3].time12Hour,
          };
        case Prayer.asr:
          return {
            "title": 'المغرب',
            "time": prayerTimeList[4].time12Hour,
          };
        case Prayer.maghrib:
          return {
            "title": 'العشاء',
            "time": prayerTimeList[5].time12Hour,
          };
        case Prayer.isha:
          return {
            "title": 'الفجر',
            "time": prayerTimeList[0].time12Hour,
          };
        case Prayer.sunrise:
          return {
            "title": 'الظهر',
            "time": prayerTimeList[2].time12Hour,
          };
        default:
          return {
            "title": "",
            "time": "",
          };
      }
    } else {
      return {
        "title": "",
        "time": "",
      };
    }
  }

  Future<Coordinates> getCoordinates() async {
    late Coordinates coordinates;
    if (!CashConfig.hasInitLocal) {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    }

    if (CashConfig.hasInitLocal) {
      logger.v('get coordinates from local');
      final coordinatesLocal = (await DBHelper.get('coordinates')).first;
      coordinates = Coordinates(
          coordinatesLocal['latitude'], coordinatesLocal['longitude']);
    } else {
      logger.v('get coordinates from Location device');

      final position = await ServicesLocation.determinePosition();

      coordinates = Coordinates(position.latitude, position.longitude);
      await CashHelper.setData(key: 'hasInitLocal', value: true);
      await DBHelper.insert('coordinates', {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      });
    }
    return coordinates;
  }
}
