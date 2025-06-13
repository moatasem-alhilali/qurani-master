import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/seed/notification_data_seeder.dart';
import 'package:quran_app/core/notification/tasks_notification.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/main.dart';

class ManageNotificationRepo {
  TasksNotification? tasksNotification;
  final DatabaseNotificationSettingService settingDb;

  ManageNotificationRepo({
    required this.settingDb,
    this.tasksNotification,
  });

  // ✅ دوال عامة لجلب الإعدادات
  Future<bool> getBool(String key) async {
    final setting = await settingDb.getByKey(key);
    return setting?.value ?? false;
  }

  Future<String?> getTime(String key) async {
    final setting = await settingDb.getByKey(key);
    return setting?.time;
  }

  // ✅ تبديل إعداد
  Future<Map<String, bool>> toggle(String key, bool val) async {
    try {
      await settingDb.updateValue(key, val);

      // ⬇️ حالة خاصة: مفتاح يشمل الآخرين
      if (key == NotificationKeys.isNotificationAllAthan) {
        final athanKeys = [
          NotificationKeys.isNotificationAthanFagr,
          NotificationKeys.isNotificationAthanDuhr,
          NotificationKeys.isNotificationAthanAsr,
          NotificationKeys.isNotificationAthanMagrib,
          NotificationKeys.isNotificationAthanIsha,
        ];

        for (final subKey in athanKeys) {
          await settingDb.updateValue(subKey, val);
          await _applyNotificationChange(subKey, val);
        }
      } else {
        // ⬇️ أي مفتاح عادي: طبّق عليه فقط
        await _applyNotificationChange(key, val);
      }

      return loadAll();
    } catch (e, stackTrace) {
      logger.e("Error toggling setting: $e");
      logger.e("Stack trace: $stackTrace");
      return {};
    }
  }

  Future<void> _applyNotificationChange(String key, bool enable) async {
    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        final prayerService = AdhanPrayerTimeService();
        final list = await prayerService.getTodayPrayerTimes();
        final map = {
          NotificationKeys.isNotificationAthanFagr: list[0],
          NotificationKeys.isNotificationAthanDuhr: list[2],
          NotificationKeys.isNotificationAthanAsr: list[3],
          NotificationKeys.isNotificationAthanMagrib: list[4],
          NotificationKeys.isNotificationAthanIsha: list[5],
        };
        final info = map[key]!;
        if (enable) {
          await tasksNotification!.sendAthanScheduleNotification(
            info: info,
          );
        } else {
          tasksNotification!.cancelNotification(id: info.id);
        }
        break;

      case NotificationKeys.isNotificationMiddleNight:
        return _handleSingleSeederNotification(
            enable, tasksNotification!.showScheduledNotificationPrayMiddleNight,
            id: 101);

      case NotificationKeys.isNotificationThikrMorning:
        return _handleSingleSeederNotification(
            enable, tasksNotification!.showScheduledNotificationThikrMorning,
            id: 102);

      case NotificationKeys.isNotificationThikrNight:
        return _handleSingleSeederNotification(
            enable, tasksNotification!.showScheduledNotificationThikrNight,
            id: 103);

      case NotificationKeys.isNotificationReadQuran:
        return _handleSingleSeederNotification(enable, () async {
          final notify = NotificationDataSeeder().readQuran;
          await tasksNotification!.showScheduledDefaultNotification(
            hour: notify.hour,
            minute: notify.minute,
            title: notify.title,
            body: notify.body,
            id: notify.id,
          );
        }, id: 104);

      case NotificationKeys.isNotificationReadSurahMulk:
        return _handleSingleSeederNotification(enable, () async {
          final notify = NotificationDataSeeder().readSurahMulk;
          await tasksNotification!.showScheduledDefaultNotification(
            hour: notify.hour,
            minute: notify.minute,
            title: notify.title,
            body: notify.body,
            id: notify.id,
          );
        }, id: 105);

      case NotificationKeys.isNotificationMohammed:
        if (enable) {
          await tasksNotification!.showScheduledNotificationMohummed();
        } else {
          for (int i = 1; i < 23; i++) {
            tasksNotification!.cancelNotification(id: 1000 + i);
          }
        }
        break;

      case NotificationKeys.isNotificationRandomThikr:
        if (enable) {
          await tasksNotification!.showScheduledRandomThikrNotification();
        } else {
          for (int i = 1; i < 23; i++) {
            tasksNotification!.cancelNotification(id: 108 + i);
          }
        }
        break;

      case NotificationKeys.isNotificationWridSleep:
        return _handleSingleSeederNotification(enable, () async {
          final notify = NotificationDataSeeder().thikrSleep;
          await tasksNotification!.showScheduledDefaultNotification(
            hour: notify.hour,
            minute: notify.minute,
            title: notify.title,
            body: notify.body,
            id: notify.id,
          );
        }, id: 106);

      case NotificationKeys.isNotificationWridGetup:
        return _handleSingleSeederNotification(enable, () async {
          final notify = NotificationDataSeeder().thikrGetup;
          await tasksNotification!.showScheduledDefaultNotification(
            hour: notify.hour,
            minute: notify.minute,
            title: notify.title,
            body: notify.body,
            id: notify.id,
          );
        }, id: 107);

      default:
        logger.w("Unhandled notification key: $key");
    }
  }

  Future<void> _handleSingleSeederNotification(
    bool enable,
    Future<void> Function() scheduleFn, {
    required int id,
  }) async {
    if (enable) {
      await scheduleFn();
    } else {
      tasksNotification!.cancelNotification(id: id);
    }
  }

  // ✅ تحميل كل الإعدادات كبول
  Future<Map<String, bool>> loadAll() async {
    final all = await settingDb.getAll();
    return {for (final e in all) e.key: e.value};
  }

  // ✅ اختيار وقت من الـ UI
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

  // ✅ تعطيل/تشغيل جميع الإشعارات
  Future<void> unLockNotification(bool newValue) async {
    // ISNOT_NOTIFY = newValue;
    await settingDb.updateValue(NotificationKeys.isNotify, newValue);

    if (newValue) {
      tasksNotification!.cancelAllNotification();
      debugPrint("🔕 تم إيقاف جميع الإشعارات.");
    } else {
      tasksNotification!.showScheduledNotificationMohummed();
      debugPrint("🔔 تم تفعيل الإشعارات من جديد.");
    }
  }
}
