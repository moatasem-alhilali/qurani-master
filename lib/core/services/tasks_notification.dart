import 'dart:math';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/notification/controller/manage_notification_controller.dart';

import 'notification_message.dart';

//Services Notification
class ServicesNotification {
  static Future<void> sendNotification() async {
    //الصلاة على النبي
    // if (ManageNotificationController.isNotificationMohummed) {
    await showScheduledNotificationMohummed();
    await showScheduledRandomThikrNotification();
    // }

    //كل الاذكار اليوميه
    // if (ManageNotificationController.isNotificationAllThirk) {
    if (true) {
      //النوافل
      if (ManageNotificationController.isNotificationPrayMiddleNight) {
        await showScheduledNotificationPrayMiddleNight();
      }
      //اذكار الصباح
      if (ManageNotificationController.isNotificationThikrMorning) {
        await showScheduledNotificationThikrMorning();
      }

      //اذكار المساء
      if (ManageNotificationController.isNotificationThikrNight) {
        await showScheduledNotificationThikrNight();
      }

      //الورد القرأني
      if (ManageNotificationController.isNotificationReadQuranRoutine) {
        await showScheduledDefaultNotification(
          hour: timesReadQuranRoutineNotification.hour,
          minute: timesReadQuranRoutineNotification.minute,
          title: timesReadQuranRoutineNotification.title,
          body: timesReadQuranRoutineNotification.body,
          id: timesReadQuranRoutineNotification.id,
        );
      }

      // سورة الملك
      if (ManageNotificationController.isNotificationReadSurahAlMulk) {
        await showScheduledDefaultNotification(
          hour: timesReadSurahAlMulkNotification.hour,
          minute: timesReadSurahAlMulkNotification.minute,
          title: timesReadSurahAlMulkNotification.title,
          body: timesReadSurahAlMulkNotification.body,
          id: timesReadSurahAlMulkNotification.id,
        );
      }

      // أذكار النوم
      if (ManageNotificationController.isNotificationThikrSleep) {
        await showScheduledDefaultNotification(
          hour: timesThikrSleepNotification.hour,
          minute: timesThikrSleepNotification.minute,
          title: timesThikrSleepNotification.title,
          body: timesThikrSleepNotification.body,
          id: timesThikrSleepNotification.id,
        );
      }

      // أذكار الاستيقاض
      if (ManageNotificationController.isNotificationThikrGetUp) {
        await showScheduledDefaultNotification(
          hour: timesThikrGetUpNotification.hour,
          minute: timesThikrGetUpNotification.minute,
          title: timesThikrGetUpNotification.title,
          body: timesThikrGetUpNotification.body,
          id: timesThikrGetUpNotification.id,
        );
      }
    }

    //اشعار كل الاذان
    if (ManageNotificationController.isNotificationAllAthan) {
      //  اذان الفجر
      if (ManageNotificationController.isNotificationAthanFagr) {
        await showScheduledNotificationAthan(
          hour: timesAthanAlfagarNotification.hour,
          minute: timesAthanAlfagarNotification.minute,
          title: timesAthanAlfagarNotification.title,
          body: timesAthanAlfagarNotification.body,
          contentTitle: timesAthanAlfagarNotification.title,
          summaryText: timesAthanAlfagarNotification.body,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
          id: timesAthanAlfagarNotification.id,
        );
      }

      // أذان الظهر
      if (ManageNotificationController.isNotificationAthanDuhr) {
        await showScheduledNotificationAthan(
          hour: timesAthanDuhrNotification.hour,
          minute: timesAthanDuhrNotification.minute,
          title: timesAthanDuhrNotification.title,
          body: timesAthanDuhrNotification.body,
          contentTitle: timesAthanDuhrNotification.title,
          summaryText: timesAthanDuhrNotification.body,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
          id: timesAthanDuhrNotification.id,
        );
      }

      //  اذان العصر
      if (ManageNotificationController.isNotificationAthanAsr) {
        await showScheduledNotificationAthan(
          hour: timesAthanAsrNotification.hour,
          minute: timesAthanAsrNotification.minute,
          title: timesAthanAsrNotification.title,
          body: timesAthanAsrNotification.body,
          contentTitle: timesAthanAsrNotification.title,
          summaryText: timesAthanAsrNotification.body,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
          id: timesAthanAsrNotification.id,
        );
      }

      //  اذان المغرب
      if (ManageNotificationController.isNotificationAthanMagrib) {
        await showScheduledNotificationAthan(
          hour: timesAthanMugribNotification.hour,
          minute: timesAthanMugribNotification.minute,
          title: timesAthanMugribNotification.title,
          body: timesAthanMugribNotification.body,
          contentTitle: timesAthanMugribNotification.title,
          summaryText: timesAthanMugribNotification.body,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
          id: timesAthanMugribNotification.id,
        );
      }
      //  اذان العشاء
      if (ManageNotificationController.isNotificationAthanIsha) {
        await showScheduledNotificationAthan(
          hour: timesAthanIshaNotification.hour,
          minute: timesAthanIshaNotification.minute,
          title: timesAthanIshaNotification.title,
          body: timesAthanIshaNotification.body,
          contentTitle: timesAthanIshaNotification.title,
          summaryText: timesAthanIshaNotification.body,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
          id: timesAthanIshaNotification.id,
        );
      }
    }

    //تنبيه كل الصلوات
    if (ManageNotificationController.isNotificationAllTimePrayer) {
      //  صلاة الفجر
      if (ManageNotificationController.isNotificationTimeFagr) {
        await showScheduledDefaultNotification(
          hour: timesPrayFagrNotification.hour,
          minute: timesPrayFagrNotification.minute,
          title: timesPrayFagrNotification.title,
          body: timesPrayFagrNotification.body,
          id: timesPrayFagrNotification.id,
        );
      }
      //  صلاة الظهر
      if (ManageNotificationController.isNotificationTimeDuhr) {
        await showScheduledDefaultNotification(
          hour: timesPrayDohurNotification.hour,
          minute: timesPrayDohurNotification.minute,
          title: timesPrayDohurNotification.title,
          body: timesPrayDohurNotification.body,
          id: timesPrayDohurNotification.id,
        );
      }
      //  صلاة العصر
      if (ManageNotificationController.isNotificationTimeAsr) {
        await showScheduledDefaultNotification(
          hour: timesPrayAsrNotification.hour,
          minute: timesPrayAsrNotification.minute,
          title: timesPrayAsrNotification.title,
          body: timesPrayAsrNotification.body,
          id: timesPrayAsrNotification.id,
        );
      }
      //  صلاة المغرب
      if (ManageNotificationController.isNotificationTimeMagrib) {
        await showScheduledDefaultNotification(
          hour: timesPrayMagribNotification.hour,
          minute: timesPrayMagribNotification.minute,
          title: timesPrayMagribNotification.title,
          body: timesPrayMagribNotification.body,
          id: timesPrayMagribNotification.id,
        );
      }
      //  صلاة العشاء
      if (ManageNotificationController.isNotificationTimeIsha) {
        await showScheduledDefaultNotification(
          hour: timesPrayIshaNotification.hour,
          minute: timesPrayIshaNotification.minute,
          title: timesPrayIshaNotification.title,
          body: timesPrayIshaNotification.body,
          id: timesPrayIshaNotification.id,
        );
      }
    }
  }

  //------------------------الصلاة على النبي------------------------

  static Future<void> showScheduledNotificationMohummed() async {
    for (int i = 1; i < 23; i++) {
      await notifyHelper.customScheduledNotification(
        channelId: "sound_mohamed_android_channel",
        channelName: "Sound Mohamed Android Channel",
        contentTitle: "الصلاة على النبي",
        summaryText:
            "عن أنس بن مالك رضي الله عنه، قال: قال رسول الله صلى الله عليه وسلم: «من صلَّى عليَّ صلاة واحدة صلَّى الله عليه عشر صلوات وحط عنه عشر خطيئات",
        id: 6,
        title: "الصلاة على النبي",
        body:
            "عن أنس بن مالك رضي الله عنه، قال: قال رسول الله صلى الله عليه وسلم: «من صلَّى عليَّ صلاة واحدة صلَّى الله عليه عشر صلوات وحط عنه عشر خطيئات",
        hour: i,
        minute: 10,
      );
    }
  }
//------------------------الورد المسائي------------------------

  static Future<void> showScheduledNotificationThikrNight() async {
    await notifyHelper.customScheduledNotification(
      channelId: "sound_night_android_channel",
      channelName: "Sound Night Android Channel",
      contentTitle: timesThikrNightNotification.title,
      summaryText: timesThikrNightNotification.body,
      id: timesThikrNightNotification.id,
      title: timesThikrNightNotification.title,
      body: timesThikrNightNotification.body,
      hour: timesThikrNightNotification.hour,
      minute: timesThikrNightNotification.minute,
    );
  }

  //-------------------------الورد الصباحي------------------------

  static Future<void> showScheduledNotificationThikrMorning() async {
    await notifyHelper.customScheduledNotification(
      channelId: "sound_morning_android_channel",
      channelName: "Sound Morning Android Channel",
      contentTitle: timesThikrMorningNotification.title,
      summaryText: timesThikrMorningNotification.body,
      id: timesThikrMorningNotification.id,
      title: timesThikrMorningNotification.title,
      body: timesThikrMorningNotification.body,
      hour: timesThikrMorningNotification.hour,
      minute: timesThikrMorningNotification.minute,
    );
  }

  //-------------------------النوافل------------------------

  static Future<void> showScheduledNotificationPrayMiddleNight() async {
    await notifyHelper.customScheduledNotification(
      channelId: "sound_middle_night_android_channel",
      channelName: "Sound Middle Night Android Channel",
      contentTitle: timesPrayMiddleNightNotification.title,
      summaryText: timesPrayMiddleNightNotification.body,
      id: timesPrayMiddleNightNotification.id,
      title: timesPrayMiddleNightNotification.title,
      body: timesPrayMiddleNightNotification.body,
      hour: timesPrayMiddleNightNotification.hour,
      minute: timesPrayMiddleNightNotification.minute,
    );
  }

  //-------------------------الاذان------------------------

  static Future<void> showScheduledNotificationAthan({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String contentTitle,
    required String summaryText,
    required String channelId,
    required String channelName,
    required int id,
  }) async {
    await notifyHelper.customScheduledNotification(
      channelId: "athan_android_channel",
      channelName: 'default  Android Channel',
      contentTitle: contentTitle,
      summaryText: summaryText,
      id: id,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
    );
  }

//!-------------------------------------------default------------------------------------------------------
  static Future<void> showScheduledDefaultNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required int id,
  }) async {
    await notifyHelper.defaultScheduledNotification(
      hour: hour,
      minute: minute,
      title: title,
      body: body,
      id: id,
    );
  }

  //سبحان الله
  static Future<void> showScheduledRandomThikrNotification() async {
    Random random = Random();

    for (int i = 1; i < 23; i++) {
      await notifyHelper.customScheduledNotification(
        hour: i,
        minute: 15,
        title: randomThikrNotification[random.nextInt(4)].title,
        body: randomThikrNotification[random.nextInt(4)].body,
        id: randomThikrNotification[random.nextInt(4)].id,
        channelId: randomThikrNotification[random.nextInt(4)].channelId,
        channelName: randomThikrNotification[random.nextInt(4)].channelName,
        contentTitle: randomThikrNotification[random.nextInt(4)].title,
        summaryText: randomThikrNotification[random.nextInt(4)].body,
      );
      print("اشعار سبحان الله");
    }
  }

//=============================function================================
  static void cancelAllNotification() async {
    notifyHelper.cancelAll();
  }

  static void cancelNotification({required int id}) async {
    notifyHelper.cancel(id: id);
  }
}
