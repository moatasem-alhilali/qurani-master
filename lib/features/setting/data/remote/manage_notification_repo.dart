import 'package:flutter/material.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/services/tasks_notification.dart';

class ManageNotificationRepo {
//notification atahn remember
  static bool isNotificationAllAthan = true;

  //
  static bool isNotificationAthanFagr = true;
  static bool isNotificationAthanDuhr = true;
  static bool isNotificationAthanAsr = true;
  static bool isNotificationAthanMagrib = true;
  static bool isNotificationAthanIsha = true;

  //
  static bool isNotificationMiddleNight = false;

  //notification thikr remember
  static bool isNotificationThikrMorning = false;
  static bool isNotificationThikrNight = false;

  //
  static bool isNotificationMohammed = true;
  static bool isNotificationRandomThikr = true;

  //
  static bool isNotificationReadQuran = false;
  static bool isNotificationReadSurahMulk = false;
  static bool isNotificationWridSleep = false;
  static bool isNotificationWridGetup = false;

  //toggle all athan

  static Future<void> toggleAllAthan(bool val) async {
    isNotificationAllAthan = !isNotificationAllAthan;
    //
    isNotificationAthanFagr = isNotificationAllAthan;
    isNotificationAthanDuhr = isNotificationAllAthan;
    isNotificationAthanAsr = isNotificationAllAthan;
    isNotificationAthanMagrib = isNotificationAllAthan;
    isNotificationAthanIsha = isNotificationAllAthan;

    await CacheService().setBool('isNotificationAllAthan', val);
    ServicesNotification.cancelAllNotification();
    await ServicesNotification.sendNotification();
  }

  static Future<void> initNotification() async {
    isNotificationReadQuran =
        CacheService().getBool('isNotificationReadQuran') ?? true;
    isNotificationReadSurahMulk =
        CacheService().getBool('isNotificationReadSurahMulk') ?? true;
    isNotificationWridSleep =
        CacheService().getBool('isNotificationWridSleep') ?? true;
    isNotificationWridGetup =
        CacheService().getBool('isNotificationWridGetup') ?? true;

    //
    isNotificationAthanFagr =
        CacheService().getBool('isNotificationAthanFagr') ?? true;
    isNotificationAthanDuhr =
        CacheService().getBool('isNotificationAthanDuhr') ?? true;
    isNotificationAthanAsr =
        CacheService().getBool('isNotificationAthanAsr') ?? true;
    isNotificationAthanMagrib =
        CacheService().getBool('isNotificationAthanMagrib') ?? true;
    isNotificationAthanIsha =
        CacheService().getBool('isNotificationAthanIsha') ?? true;

    //
    isNotificationMiddleNight =
        CacheService().getBool('isNotificationMiddleNight') ?? true;

    //
    isNotificationThikrMorning =
        CacheService().getBool('isNotificationThikrMorning') ?? true;
    isNotificationThikrNight =
        CacheService().getBool('isNotificationThikrNight') ?? true;
    //
    isNotificationMohammed =
        CacheService().getBool('isNotificationMohammed') ?? true;
    isNotificationRandomThikr =
        CacheService().getBool('isNotificationRandomThikr') ?? true;
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

  //
}
