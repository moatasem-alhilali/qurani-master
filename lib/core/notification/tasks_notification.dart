import 'dart:math';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/remote/manage_notification_repo.dart';
import 'seed/notification_data_seeder.dart';

class TasksNotification {
  final NotificationService notifyHelper = sl.get<NotificationService>();
  final ManageNotificationRepo repo = sl.get<ManageNotificationRepo>();
  final NotificationDataSeeder seeder = NotificationDataSeeder();

  Future<void> sendNotification() async {
    if (await repo.getBool(NotificationKeys.isNotificationMohammed)) {
      await showScheduledNotificationMohummed();
    }

    if (await repo.getBool(NotificationKeys.isNotificationRandomThikr)) {
      await showScheduledRandomThikrNotification();
    }

    if (await repo.getBool(NotificationKeys.isNotificationMiddleNight)) {
      await showScheduledNotificationPrayMiddleNight();
    }

    if (await repo.getBool(NotificationKeys.isNotificationThikrMorning)) {
      await showScheduledNotificationThikrMorning();
    }

    if (await repo.getBool(NotificationKeys.isNotificationThikrNight)) {
      await showScheduledNotificationThikrNight();
    }

    if (await repo.getBool(NotificationKeys.isNotificationReadQuran)) {
      final notify = seeder.readQuran;
      await showScheduledDefaultNotification(
        hour: notify.hour,
        minute: notify.minute,
        title: notify.title,
        body: notify.body,
        id: notify.id,
      );
    }

    if (await repo.getBool(NotificationKeys.isNotificationReadSurahMulk)) {
      final notify = seeder.readSurahMulk;
      await showScheduledDefaultNotification(
        hour: notify.hour,
        minute: notify.minute,
        title: notify.title,
        body: notify.body,
        id: notify.id,
      );
    }

    if (await repo.getBool(NotificationKeys.isNotificationWridSleep)) {
      final notify = seeder.thikrSleep;
      await showScheduledDefaultNotification(
        hour: notify.hour,
        minute: notify.minute,
        title: notify.title,
        body: notify.body,
        id: notify.id,
      );
    }

    if (await repo.getBool(NotificationKeys.isNotificationWridGetup)) {
      final notify = seeder.thikrGetup;
      await showScheduledDefaultNotification(
        hour: notify.hour,
        minute: notify.minute,
        title: notify.title,
        body: notify.body,
        id: notify.id,
      );
    }

    if (await repo.getBool(NotificationKeys.isNotificationAllAthan)) {
      final prayerService = AdhanPrayerTimeService();
      final prayerList = await prayerService.getTodayPrayerTimes();

      if (await repo.getBool(NotificationKeys.isNotificationAthanFagr)) {
        await _scheduleAthan(
          info: prayerList[0],
        );
      }

      if (await repo.getBool(NotificationKeys.isNotificationAthanDuhr)) {
        await _scheduleAthan(
          info: prayerList[2],
        );
      }

      if (await repo.getBool(NotificationKeys.isNotificationAthanAsr)) {
        await _scheduleAthan(
          info: prayerList[3],
        );
      }

      if (await repo.getBool(NotificationKeys.isNotificationAthanMagrib)) {
        await _scheduleAthan(
          info: prayerList[4],
        );
      }

      if (await repo.getBool(NotificationKeys.isNotificationAthanIsha)) {
        await _scheduleAthan(
          info: prayerList[5],
        );
      }
    }
  }

  Future<void> _scheduleAthan({
    required PrayerInfoModel info,
  }) async {
    await notifyHelper.scheduleNotification(
      id: info.id,
      hour: info.time.hour,
      minute: info.time.minute,
      title: info.description,
      body: info.type.description,
      channel: NotificationChannel.athan,
    );
  }

  Future<void> showScheduledNotificationMohummed() async {
    for (int i = 1; i < 23; i++) {
      await notifyHelper.scheduleNotification(
        id: 1000 + i,
        hour: i,
        minute: 10,
        title: "الصلاة على النبي",
        body:
            "عن أنس بن مالك رضي الله عنه، قال: قال رسول الله صلى الله عليه وسلم: «من صلى عليّ صلاة واحدة صلى الله عليه بها عشرًا»",
        channel: NotificationChannel.mohammed,
      );
    }
  }

  Future<void> showScheduledNotificationThikrNight() async {
    final notify = seeder.thikrNight;
    await notifyHelper.scheduleNotification(
      id: notify.id,
      hour: notify.hour,
      minute: notify.minute,
      title: notify.title,
      body: notify.body,
      channel: NotificationChannel.night,
    );
  }

  Future<void> showScheduledNotificationThikrMorning() async {
    final notify = seeder.thikrMorning;
    await notifyHelper.scheduleNotification(
      id: notify.id,
      hour: notify.hour,
      minute: notify.minute,
      title: notify.title,
      body: notify.body,
      channel: NotificationChannel.morning,
    );
  }

  Future<void> showScheduledNotificationPrayMiddleNight() async {
    final notify = seeder.middleNight;
    await notifyHelper.scheduleNotification(
      id: notify.id,
      hour: notify.hour,
      minute: notify.minute,
      title: notify.title,
      body: notify.body,
      channel: NotificationChannel.middleNight,
    );
  }

  Future<void> showScheduledDefaultNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required int id,
  }) async {
    await notifyHelper.scheduleNotification(
      id: id,
      hour: hour,
      minute: minute,
      title: title,
      body: body,
      channel: NotificationChannel.defaultChannel,
    );
  }

  Future<void> showScheduledRandomThikrNotification() async {
    final items = seeder.getRandomThikrNotifications();
    final random = Random();

    for (int i = 1; i < 23; i++) {
      final item = items[random.nextInt(items.length)];

      await notifyHelper.scheduleNotification(
        id: item.id + i,
        hour: i,
        minute: 15,
        title: item.title,
        body: item.body,
        channel: NotificationChannel.randomThikr,
      );
    }
  }

  Future<void> sendAthanScheduleNotification({
    required PrayerInfoModel info,
  }) async {
    await notifyHelper.scheduleNotification(
      id: info.id,
      hour: info.time.hour,
      minute: info.time.minute,
      title: info.description,
      body: info.type.description,
      channel: NotificationChannel.athan,
    );
  }

  void cancelAllNotification() async {
    notifyHelper.cancelAll();
  }

  void cancelNotification({required int id}) async {
    notifyHelper.cancel(id: id);
  }
}
