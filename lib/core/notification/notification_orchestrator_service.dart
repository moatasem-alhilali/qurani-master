import 'package:quran_app/core/notification/advanced_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';

class NotificationOrchestratorService {
  NotificationOrchestratorService({
    required this.advancedNotificationService,
    required this.settingRepo,
    required this.notificationSchedulesRepo,
    required this.adhanPrayerTimeService,
  });

  final AdvancedNotificationService advancedNotificationService;
  final SettingNotificationRepo settingRepo;
  final NotificationSchedulesRepo notificationSchedulesRepo;
  final AdhanPrayerTimeService adhanPrayerTimeService;

  Future<void> rescheduleAllNotifications() async {
    await _rescheduleAthanNotifications();
    await _rescheduleStaticNotifications();
    // await _rescheduleCustomSchedules();
  }

  /// 1. جدولة إشعارات الأذان بدقة بناءً على أوقات اليوم والموقع
  Future<void> _rescheduleAthanNotifications() async {
    final mainEnabled =
        await settingRepo.getBool(NotificationKeys.isNotificationAllAthan);

    if (!mainEnabled) {
      for (final id in NotificationIds.athanIds) {
        await advancedNotificationService.cancelNotification(id: id);
      }
      return;
    }

    final prayerTimes = await adhanPrayerTimeService.getTodayPrayerTimes();

    const athanKeys = NotificationKeys.athanKeys;
    for (var i = 0; i < athanKeys.length; i++) {
      final key = athanKeys[i];
      final enabled = await settingRepo.getBool(key);
      final info = _mapPrayerKeyToInfo(key, prayerTimes);
      if (info == null) continue;
      final id = info.id; // ID = ثابت لكل نوع أذان

      if (enabled) {
        await advancedNotificationService.scheduleNotification(
          id: id,
          title: info.name,
          body: info.description,
          channel: NotificationChannel.athan,
          schedule: NotificationScheduleModel.daily(
            hour: info.time.hour,
            minute: info.time.minute,
          ),
        );
      } else {
        await advancedNotificationService.cancelNotification(id: id);
      }
    }
  }

  /// خريطة المفتاح إلى PrayerInfoModel المناسب حسب التسلسل
  PrayerInfoModel? _mapPrayerKeyToInfo(String key, List<PrayerInfoModel> list) {
    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
        return list[0];
      case NotificationKeys.isNotificationAthanDuhr:
        return list[2];
      case NotificationKeys.isNotificationAthanAsr:
        return list[3];
      case NotificationKeys.isNotificationAthanMagrib:
        return list[4];
      case NotificationKeys.isNotificationAthanIsha:
        return list[5];
      default:
        return null;
    }
  }

  /// 2. جدولة جميع الإشعارات الثابتة (single schedule per key)
  Future<void> _rescheduleStaticNotifications() async {
    final settings = await settingRepo.getAllSettings();
    for (final setting in settings) {
      // تجاهل مفاتيح الأذان لأن لديهم منطق خاص أعلاه
      if (setting.key.startsWith('isNotificationAthan')) continue;

      // يمكن هنا أيضاً تجاهل المفاتيح التي تعتمد على multi-schedule لو تريد الفصل التام

      final id = NotificationDataConst.resolveNotificationId(setting.key);

      if (!setting.enabled || setting.onlySetting) {
        await advancedNotificationService.cancelNotification(id: id);
        continue;
      }

      await advancedNotificationService.scheduleNotification(
        id: id,
        title: setting.label,
        body: NotificationDataConst.resolveNotificationBody(setting.key),
        channel: NotificationDataConst.resolveChannel(setting.key),
        schedule: setting.schedule,
      );
    }
  }

  /// 3. جدولة كل جداول multi-schedule (لكل مفتاح يدعم جداول فرعية)
  Future<void> _rescheduleCustomSchedules() async {
    final multiScheduleKeys = [
      NotificationKeys.isNotificationThikrMorning,
      NotificationKeys.isNotificationThikrNight,
      NotificationKeys.isNotificationMiddleNight,
      NotificationKeys.isNotificationMohammed,
      NotificationKeys.isNotificationRandomThikr,
      NotificationKeys.isNotificationReadQuran,
      NotificationKeys.isNotificationReadSurahMulk,
      NotificationKeys.isNotificationWridSleep,
      NotificationKeys.isNotificationWridGetup,
    ];
    for (final key in multiScheduleKeys) {
      final schedules = await notificationSchedulesRepo.getSchedules(key);
      for (final schedule in schedules) {
        if (schedule.enabled) {
          final id = NotificationDataConst.resolveNotificationId(key);
          await advancedNotificationService.scheduleNotification(
            id: id,
            title: schedule.label ?? NotificationDataConst.resolveTitle(key),
            body: schedule.label ??
                NotificationDataConst.resolveNotificationBody(key),
            channel: NotificationDataConst.resolveChannel(key),
            schedule: schedule.toScheduleModel(),
          );
        } else {
          await advancedNotificationService.cancelNotification(
            id: NotificationDataConst.resolveNotificationId(key),
          );
        }
      }
    }
  }
}
