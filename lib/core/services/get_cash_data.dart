import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/notification/controller/manage_notification_controller.dart';

void initCashValue() {
  //pdf read
  pdfSurah = CashHelper.getInt(key: 'pdfSurah') ?? 1;
  pdfPage = CashHelper.getInt(key: 'pdfPage') ?? 1;
  //type of font
  defaultNameQuran = CashHelper.getString(key: 'fontType') ?? 'quran2';
  masbahSize = CashHelper.getInt(key: 'subih') ?? masbahSize;
  //set the color
  String colorType = CashHelper.getString(key: 'color') ?? 'primaryClr';
  //lasSurahRead
  lasSurahRead = CashHelper.getString(key: 'lastSurah') ?? 'الفاتحة';
  //font size
  fontSizeAthkar = CashHelper.getDouble(key: 'fontSizeAthkar') ?? 16.0;
  fontSizeQuran = CashHelper.getDouble(key: 'fontSizeQuran') ?? 20.0;
  //get the date and time
  lastTimeCash = CashHelper.getString(key: 'last_time') ?? timeNow;
  lastDateCash = CashHelper.getString(key: 'last_date') ?? dateNow;
  //IS notification
  ISNOT_NOTIFY = CashHelper.getBool(key: 'ISNOTIFY') ?? false;

  //notification cash

//
  ManageNotificationController.isNotificationAllAthan =
      CashHelper.getBool(key: 'isNotificationAllAthan') ?? true;

  //
  ManageNotificationController.isNotificationAllThirk =
      CashHelper.getBool(key: 'isNotificationAllThirk') ?? true;

  //
  ManageNotificationController.isNotificationAllTimePrayer =
      CashHelper.getBool(key: 'isNotificationAllTimePrayer') ?? true;

  //
  ManageNotificationController.isNotificationAthanAsr =
      CashHelper.getBool(key: 'isNotificationAthanAsr') ?? true;
//
  ManageNotificationController.isNotificationAthanDuhr =
      CashHelper.getBool(key: 'isNotificationAthanDuhr') ?? true;

  //
  ManageNotificationController.isNotificationAthanFagr =
      CashHelper.getBool(key: 'isNotificationAthanFagr') ?? true;
  //
  ManageNotificationController.isNotificationAthanIsha =
      CashHelper.getBool(key: 'isNotificationAthanIsha') ?? true;
  //
  ManageNotificationController.isNotificationAthanMagrib =
      CashHelper.getBool(key: 'isNotificationAthanMagrib') ?? true;
  

  //
  ManageNotificationController.isNotificationMohummed =
      CashHelper.getBool(key: 'isNotificationMohummed') ?? true;
  //
  ManageNotificationController.isNotificationPrayMiddleNight =
      CashHelper.getBool(key: 'isNotificationPrayMiddleNight') ?? true;
  //
  ManageNotificationController.isNotificationReadQuranRoutine =
      CashHelper.getBool(key: 'isNotificationReadQuranRoutin') ?? true;
  //
  ManageNotificationController.isNotificationReadSurahAlMulk =
      CashHelper.getBool(key: 'isNotificationReadSurahAlMulk') ?? true;

  //
  ManageNotificationController.isNotificationThikrGetUp =
      CashHelper.getBool(key: 'isNotificationThikrGetUp') ?? true;
  //
  ManageNotificationController.isNotificationThikrMorning =
      CashHelper.getBool(key: 'isNotificationThikrMorning') ?? true;
  //
  ManageNotificationController.isNotificationThikrNight =
      CashHelper.getBool(key: 'isNotificationThikrNight') ?? true;
  //
  ManageNotificationController.isNotificationThikrSleep =
      CashHelper.getBool(key: 'isNotificationThikrSleep') ?? true;
  //
  ManageNotificationController.isNotificationTimeAsr =
      CashHelper.getBool(key: 'isNotificationTimeAsr') ?? true;
  //
  ManageNotificationController.isNotificationTimeDuhr =
      CashHelper.getBool(key: 'isNotificationTimeDuhr') ?? true;
  //
  ManageNotificationController.isNotificationTimeFagr =
      CashHelper.getBool(key: 'isNotificationTimeFagr') ?? true;
  //
  ManageNotificationController.isNotificationTimeIsha =
      CashHelper.getBool(key: 'isNotificationTimeIsha') ?? true;
  //
  ManageNotificationController.isNotificationTimeMagrib =
      CashHelper.getBool(key: 'isNotificationTimeMagrib') ?? true;

  //cash time

  //
  ManageNotificationController.timeRememberMohummed =
      CashHelper.getString(key: 'timeRememberMohummed') ??
          ManageNotificationController.timeRememberMohummed;
  //
  ManageNotificationController.timeRememberPrayerMiddleNight =
      CashHelper.getString(key: 'timeRememberPrayerMiddleNight') ??
          ManageNotificationController.timeRememberPrayerMiddleNight;
  //
  ManageNotificationController.timeRememberReadQuranRoutine =
      CashHelper.getString(key: 'timeRememberReadQuranRoutine') ??   ManageNotificationController.timeRememberReadQuranRoutine;
  //
  ManageNotificationController.timeRememberReadSurah =
      CashHelper.getString(key: 'timeRememberReadSurah') ??   ManageNotificationController.timeRememberReadSurah;
  //
  ManageNotificationController.timeRememberReadSurhAlMulk =
      CashHelper.getString(key: 'timeRememberReadSurhAlMulk') ??  ManageNotificationController.timeRememberReadSurhAlMulk;
  //
  ManageNotificationController.timeRememberThikrGetUp =
      CashHelper.getString(key: 'timeRememberThikrGetUp') ??  ManageNotificationController.timeRememberThikrGetUp;
  //
  ManageNotificationController.timeRememberThikrMorning =
      CashHelper.getString(key: 'timeRememberThikrMorning') ?? ManageNotificationController.timeRememberThikrMorning;
  //
  ManageNotificationController.timeRememberThikrNight =
      CashHelper.getString(key: 'timeRememberThikrNight') ??
          ManageNotificationController.timeRememberThikrNight;
  //
  ManageNotificationController.timeRememberThikrSleep =
      CashHelper.getString(key: 'timeRememberThikrSleep') ??   ManageNotificationController.timeRememberThikrSleep;
  //
}
