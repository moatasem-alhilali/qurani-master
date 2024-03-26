import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
import 'package:quran_app/main.dart';

String fajr = "";
String sunrise = "";
String dhuhr = "";
String asr = "";
String maghrib = "";
String isha = "";
Prayer currentPlayer = Prayer.none;
String sunset = "";
DateTime? nextDateTimePrayer;

class PrayerTime24Hour {
  static String prayFajr = "";
  static String sunrise = "";

  static String prayDuhr = "";

  //
  static String prayAsr = "";
  //
  static String prayMagrib = "";
  //
  static String prayIsha = "";
}

class PrayerTimeController {
  static Prayer? next;
  static String? nextPrayerTime;
  static bool isGetTheTimePrayer = false;

  static Future<void> initPrayerTimes() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      //
      final poss = await ServicesLocation.determinePosition();

      final myCoordinates = Coordinates(
        poss.latitude,
        poss.longitude,
      );

      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      final prayerTimes = PrayerTimes.today(myCoordinates, params);

      //12 hour
      fajr = DateFormat.jm().format(prayerTimes.fajr);
      sunrise = DateFormat.jm().format(prayerTimes.sunrise);
      dhuhr = DateFormat.jm().format(prayerTimes.dhuhr);
      asr = DateFormat.jm().format(prayerTimes.asr);
      maghrib = DateFormat.jm().format(prayerTimes.maghrib);
      isha = DateFormat.jm().format(prayerTimes.isha);

      //24 hour
      PrayerTime24Hour.prayFajr = DateFormat.Hm().format(prayerTimes.fajr);
      PrayerTime24Hour.sunrise = DateFormat.Hm().format(prayerTimes.sunrise);
      PrayerTime24Hour.prayDuhr = DateFormat.Hm().format(prayerTimes.dhuhr);
      PrayerTime24Hour.prayAsr = DateFormat.Hm().format(prayerTimes.asr);
      PrayerTime24Hour.prayMagrib = DateFormat.Hm().format(prayerTimes.maghrib);
      PrayerTime24Hour.prayIsha = DateFormat.Hm().format(prayerTimes.isha);
      //
      DateTime? currentPrayerTime = prayerTimes.timeForPrayer(currentPlayer);
      next = prayerTimes.nextPrayer();
      nextPrayerTime = DateFormat.jm().format(prayerTimes.timeForPrayer(next));
      nextDateTimePrayer = prayerTimes.timeForPrayer(next);
    } catch (e) {
      logger.e(e);
    }
  }

//get Current Prayer
  static getNextPrayer() {
    if (next == Prayer.fajr) {
      return fagr_data;
    }

    if (next == Prayer.dhuhr) {
      return zhur_data;
    }
    if (next == Prayer.asr) {
      return asr_data;
    }
    if (next == Prayer.maghrib) {
      return magrib_data;
    }
    if (next == Prayer.isha) {
      return iysh_data;
    }
    if (next == Prayer.sunrise) {
      return sunset_data;
    }
  }

//set Current Color Prayer
  static void setCurrentColorPrayer() {
    for (var element in prayerData) {
      if (PrayerTimeController.getNextPrayer().time == element.time) {
        nextCurrentPrayer = element.id;
      }
    }
  }

  //

  //check if have get the time
  void setCashPrayerTime() async {
    // await CashHelper.setData(key: "key", value: fajr);
    // await CashHelper.setData(key: "sunrise", value: sunrise);
    // await CashHelper.setData(key: "dhuhr", value: dhuhr);
    // await CashHelper.setData(key: "asr", value: asr);
    // await CashHelper.setData(key: "maghrib", value: maghrib);
    // await CashHelper.setData(key: "isha", value: isha);
    // await CashHelper.setData(key: "currentPlayer", value: currentPlayer);
  }
}
