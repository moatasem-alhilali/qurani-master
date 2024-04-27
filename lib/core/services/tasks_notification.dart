import 'dart:math';

import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/setting/logic/manage_notification_controller.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';

import 'notification_message.dart';

final prayerTimeList = sl.get<PrayerTimesProvider>().prayerTimeList;

//Services Notification
class ServicesNotification {
  static Future<void> sendNotification() async {
    //الصلاة على النبي
    if (ManageNotification.isNotificationMohammed) {
      await showScheduledNotificationMohummed();
    }

    //كل الاذكار اليوميه
    if (ManageNotification.isNotificationRandomThikr) {
      await showScheduledRandomThikrNotification();
    }

    //النوافل
    if (ManageNotification.isNotificationMiddleNight) {
      await showScheduledNotificationPrayMiddleNight();
    }
    //اذكار الصباح
    if (ManageNotification.isNotificationThikrMorning) {
      await showScheduledNotificationThikrMorning();
    }

    //اذكار المساء
    if (ManageNotification.isNotificationThikrNight) {
      await showScheduledNotificationThikrNight();
    }

    //الورد القرأني
    if (ManageNotification.isNotificationReadQuran) {
      await showScheduledDefaultNotification(
        hour: timesReadQuranRoutineNotification.hour,
        minute: timesReadQuranRoutineNotification.minute,
        title: timesReadQuranRoutineNotification.title,
        body: timesReadQuranRoutineNotification.body,
        id: timesReadQuranRoutineNotification.id,
      );
    }
    if (ManageNotification.isNotificationReadSurahMulk) {
      // سورة الملك
      await showScheduledDefaultNotification(
        hour: timesReadSurahAlMulkNotification.hour,
        minute: timesReadSurahAlMulkNotification.minute,
        title: timesReadSurahAlMulkNotification.title,
        body: timesReadSurahAlMulkNotification.body,
        id: timesReadSurahAlMulkNotification.id,
      );
    }
    if (ManageNotification.isNotificationWridSleep) {
      // أذكار النوم
      await showScheduledDefaultNotification(
        hour: timesThikrSleepNotification.hour,
        minute: timesThikrSleepNotification.minute,
        title: timesThikrSleepNotification.title,
        body: timesThikrSleepNotification.body,
        id: timesThikrSleepNotification.id,
      );
    }
    if (ManageNotification.isNotificationWridGetup) {
      // أذكار الاستيقاض
      await showScheduledDefaultNotification(
        hour: timesThikrGetUpNotification.hour,
        minute: timesThikrGetUpNotification.minute,
        title: timesThikrGetUpNotification.title,
        body: timesThikrGetUpNotification.body,
        id: timesThikrGetUpNotification.id,
      );
    }

    //اشعار كل الاذان
    if (ManageNotification.isNotificationAllAthan) {
      //  اذان الفجر
      if (ManageNotification.isNotificationAthanFagr) {
        await showScheduledNotificationAthan(
          id: prayerData[0].id,
          hour: int.parse(prayerTimeList[0].time24Hour.split(":")[0]),
          minute: int.parse(prayerTimeList[0].time24Hour.split(":")[1]),
          title: 'أذان الفجر',
          body: prayerData[0].content,
          summaryText: prayerData[0].content,
          contentTitle: 'أذان الفجر',
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
        );
      }

      // أذان الظهر
      if (ManageNotification.isNotificationAthanDuhr) {
        await showScheduledNotificationAthan(
          id: prayerData[2].id,
          hour: int.parse(prayerTimeList[2].time24Hour.split(":")[0]),
          minute: int.parse(prayerTimeList[2].time24Hour.split(":")[1]),
          title: 'أذان الظهر',
          contentTitle: 'أذان الظهر',
          body: prayerData[2].content,
          summaryText: prayerData[2].content,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
        );
      }

      //  اذان العصر
      if (ManageNotification.isNotificationAthanAsr) {
        await showScheduledNotificationAthan(
          id: prayerData[3].id,
          hour: int.parse(prayerTimeList[3].time24Hour.split(":")[0]),
          minute: int.parse(prayerTimeList[3].time24Hour.split(":")[1]),
          title: 'أذان العصر',
          contentTitle: 'أذان العصر',
          body: prayerData[3].content,
          summaryText: prayerData[3].content,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
        );
      }

      //  اذان المغرب
      if (ManageNotification.isNotificationAthanMagrib) {
        await showScheduledNotificationAthan(
          id: prayerData[4].id,
          hour: int.parse(prayerTimeList[4].time24Hour.split(":")[0]),
          minute: int.parse(prayerTimeList[4].time24Hour.split(":")[1]),
          title: ' أذان المغرب',
          contentTitle: ' أذان المغرب',
          body: prayerData[4].content,
          summaryText: prayerData[4].content,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
        );
      }
      //  اذان العشاء
      if (ManageNotification.isNotificationAthanIsha) {
        await showScheduledNotificationAthan(
          hour: int.parse(prayerTimeList[5].time24Hour.split(":")[0]),
          minute: int.parse(prayerTimeList[5].time24Hour.split(":")[1]),
          title: 'أذان العشاء',
          contentTitle: 'أذان العشاء',
          id: prayerData[5].id,
          body: prayerData[5].content,
          summaryText: prayerData[5].content,
          channelId: "athan_android_channel",
          channelName: "athan  Android Channel",
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
