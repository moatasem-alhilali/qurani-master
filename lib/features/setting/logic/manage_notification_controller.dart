import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/local/cash.dart';
import 'package:quran_app/core/services/tasks_notification.dart';

class ManageNotification {
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

    await CashHelper.setData(key: 'isNotificationAllAthan', value: val);
    ServicesNotification.cancelAllNotification();
    await ServicesNotification.sendNotification();
  }

  static Future<void> initNotification() async {
    isNotificationReadQuran =
        CashHelper.getBool(key: 'isNotificationReadQuran') ?? true;
    isNotificationReadSurahMulk =
        CashHelper.getBool(key: 'isNotificationReadSurahMulk') ?? true;
    isNotificationWridSleep =
        CashHelper.getBool(key: 'isNotificationWridSleep') ?? true;
    isNotificationWridGetup =
        CashHelper.getBool(key: 'isNotificationWridGetup') ?? true;

    //
    isNotificationAthanFagr =
        CashHelper.getBool(key: 'isNotificationAthanFagr') ?? true;
    isNotificationAthanDuhr =
        CashHelper.getBool(key: 'isNotificationAthanDuhr') ?? true;
    isNotificationAthanAsr =
        CashHelper.getBool(key: 'isNotificationAthanAsr') ?? true;
    isNotificationAthanMagrib =
        CashHelper.getBool(key: 'isNotificationAthanMagrib') ?? true;
    isNotificationAthanIsha =
        CashHelper.getBool(key: 'isNotificationAthanIsha') ?? true;

    //
    isNotificationMiddleNight =
        CashHelper.getBool(key: 'isNotificationMiddleNight') ?? true;

    //
    isNotificationThikrMorning =
        CashHelper.getBool(key: 'isNotificationThikrMorning') ?? true;
    isNotificationThikrNight =
        CashHelper.getBool(key: 'isNotificationThikrNight') ?? true;
    //
    isNotificationMohammed =
        CashHelper.getBool(key: 'isNotificationMohammed') ?? true;
    isNotificationRandomThikr =
        CashHelper.getBool(key: 'isNotificationRandomThikr') ?? true;
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
