import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageNotificationController {
//notification atahn remember
  static bool isNotificationAllAthan = true;
  static bool isNotificationAthanFagr = true;
  static bool isNotificationAthanDuhr = true;
  static bool isNotificationAthanAsr = true;
  static bool isNotificationAthanMagrib = true;
  static bool isNotificationAthanIsha = true;

  //notification mohummed remember
  static bool isNotificationMohummed = true;

  //notification time Prayer remember
  static bool isNotificationAllTimePrayer = true;
  static bool isNotificationTimeFagr = true;
  static bool isNotificationTimeDuhr = true;
  static bool isNotificationTimeAsr = true;
  static bool isNotificationTimeMagrib = true;
  static bool isNotificationTimeIsha = true;

  //notification thikr remember
  static bool isNotificationAllThirk = true;
  static bool isNotificationThikrMorning = true;
  static bool isNotificationThikrNight = true;
  static bool isNotificationThikrGetUp = true;
  static bool isNotificationThikrSleep = true;
  static bool isNotificationPrayMiddleNight = true;
  static bool isNotificationReadSurahAlMulk = true;
  static bool isNotificationReadQuranRoutine = true;

  static void setValThirk() {
    if (isNotificationAllThirk) {
      isNotificationThikrMorning = true;
      isNotificationThikrNight = true;
      isNotificationThikrGetUp = true;
      isNotificationThikrSleep = true;
      isNotificationPrayMiddleNight = true;
      isNotificationReadSurahAlMulk = true;
      isNotificationReadQuranRoutine = true;
    } else {
      isNotificationThikrMorning = false;
      isNotificationThikrNight = false;
      isNotificationThikrGetUp = false;
      isNotificationThikrSleep = false;
      isNotificationPrayMiddleNight = false;
      isNotificationReadSurahAlMulk = false;
      isNotificationReadQuranRoutine = false;
    }
  }

  static void setValAthan() {
    if (isNotificationAllAthan) {
      isNotificationAllTimePrayer = true;
      isNotificationTimeFagr = true;
      isNotificationTimeDuhr = true;
      isNotificationTimeAsr = true;
      isNotificationTimeMagrib = true;
      isNotificationTimeIsha = true;
    } else {
      isNotificationAllTimePrayer = false;
      isNotificationTimeFagr = false;
      isNotificationTimeDuhr = false;
      isNotificationTimeAsr = false;
      isNotificationTimeMagrib = false;
      isNotificationTimeIsha = false;
    }
  }


  //time picker
  static Future<String?> showTimePikerNotification({
    required BuildContext context,
  }) async {
    final res = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
      context: context,
      cancelText: "رجوع",
      confirmText: "اختيار",
      initialTime: TimeOfDay.now(),
    );
    var split = res.toString().split("(")[1].split(")")[0];

    return split;
  }

  //====================var data time of every notification===================
  //thikr detail
  static String timeRememberPrayerMiddleNight = "22:00";
  static String timeRememberThikrMorning = "7:00";
  static String timeRememberThikrNight = "18:00";
  static String timeRememberThikrGetUp = "7:30";
  static String timeRememberThikrSleep = "20:00";
  static String timeRememberReadSurhAlMulk = "20:10";
  static String timeRememberReadQuranRoutine = "18:30";

  //
  static String timeRememberMohummed = "14:00";

  static String timeRememberFasting = "20:30";
  static String timeRememberReadSurah = "";
  static String timeRememberReadSurahAlkahf = "10:30";
  static String timeRememberFastingMonday = "20:30";
  static String timeRememberFastingThursday = "20:30";
}
