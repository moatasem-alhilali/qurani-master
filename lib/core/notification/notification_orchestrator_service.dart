import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_payload_service.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';
import 'package:quran_app/main.dart';

/// Orchestrates all notification scheduling using the new unified notification system
/// Manages Athan notifications, static reminders, and custom schedules
class NotificationOrchestratorService {
  NotificationOrchestratorService({
    required this.notificationService,
    required this.settingRepo,
    required this.notificationSchedulesRepo,
    required this.adhanPrayerTimeService,
    required this.athanPayloadService,
  });

  final NotificationService notificationService;
  final SettingNotificationRepo settingRepo;
  final NotificationSchedulesRepo notificationSchedulesRepo;
  final AdhanPrayerTimeService adhanPrayerTimeService;
  final AthanAlarmPayloadService athanPayloadService;

  /// Reschedule all notifications using the unified notification system
  Future<void> rescheduleAllNotifications() async {
    try {
      logger.d('Starting comprehensive notification rescheduling');

      await _rescheduleAthanNotifications();
      await _rescheduleStaticNotifications();
      // await _rescheduleCustomSchedules(); // Uncomment when ready

      // logger.d('Completed comprehensive notification rescheduling');
    } catch (e) {
      logger.e('Error in rescheduleAllNotifications: $e');
    }
  }

  /// Schedule Athan notifications based on accurate prayer times and location
  Future<void> _rescheduleAthanNotifications() async {
    try {
      final mainEnabled =
          await settingRepo.getBool(NotificationKeys.isNotificationAllAthan);

      if (!mainEnabled) {
        // Cancel all Athan notifications if main toggle is disabled
        for (final key in NotificationKeys.athanKeys) {
          final id = NotificationIdManager.generateNotificationId(key);
          await notificationService.cancelNotificationById(id: id);
        }
        logger.d('Cancelled all Athan notifications (main toggle disabled)');
        return;
      }

      final prayerTimes = await adhanPrayerTimeService.getTodayPrayerTimes();
      if (prayerTimes.isEmpty) {
        logger
            .w('No prayer times available for scheduling Athan notifications');
        return;
      }

      const athanKeys = NotificationKeys.athanKeys;
      for (var i = 0; i < athanKeys.length; i++) {
        final key = athanKeys[i];
        final enabled = await settingRepo.getBool(key);
        final info = _mapPrayerKeyToInfo(key, prayerTimes);

        if (info == null) {
          logger.w('No prayer info found for key: $key');
          continue;
        }

        // Use new NotificationIdManager for consistent ID generation
        final id = NotificationIdManager.generateNotificationId(key);

        if (enabled) {
          final prayerName = info.name.trim();
          final prayerTimeLabel = info.time12.trim();
          final success =
              await notificationService.scheduleNotificationCompatType(
            id: id,
            title: athanPayloadService.buildAthanTitle(
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            body: athanPayloadService.buildAthanBody(
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            channel: NotificationChannel.athan,
            schedule: NotificationScheduleModel.daily(
              hour: info.time.hour,
              minute: info.time.minute,
            ),
            payload: athanPayloadService.buildPayload(
              key: key,
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            subText: athanPayloadService.buildAthanSubText(
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            ticker: 'حان الآن أذان $prayerName',
            iosSubtitle: athanPayloadService.buildAthanSubText(
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            iosThreadIdentifier: 'athan_notifications',
            iosCategoryIdentifier: 'islamic_notifications',
            iosInterruptionLevel: InterruptionLevel.active,
            bigText: athanPayloadService.buildAthanExpandedBody(
              prayerName: prayerName,
              prayerTimeLabel: prayerTimeLabel,
            ),
            color: const Color(0xFF1F7A4D),
            colorized: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            ongoing: false,
            autoCancel: true,
          );

          if (success) {
            // logger.w(
            //   'Scheduled Athan notification: ${info.name} at ${info.time}',
            // );
          } else {
            // logger.w('Failed to schedule Athan notification: ${info.name}');
          }
        } else {
          await notificationService.cancelNotificationById(id: id);
          // logger.d('Cancelled Athan notification: ${info.name} (disabled)');
        }
      }

      logger.d('Completed Athan notification rescheduling');
    } catch (e) {
      logger.e('Error in _rescheduleAthanNotifications: $e');
    }
  }

  /// Map notification key to corresponding prayer info model
  PrayerInfoModel? _mapPrayerKeyToInfo(String key, List<PrayerInfoModel> list) {
    if (list.length < 6) {
      logger.w('Insufficient prayer times in list: ${list.length}');
      return null;
    }

    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
        return list[0]; // Fajr
      case NotificationKeys.isNotificationAthanDuhr:
        return list[2]; // Dhuhr
      case NotificationKeys.isNotificationAthanAsr:
        return list[3]; // Asr
      case NotificationKeys.isNotificationAthanMagrib:
        return list[4]; // Maghrib
      case NotificationKeys.isNotificationAthanIsha:
        return list[5]; // Isha
      default:
        logger.w('Unknown Athan notification key: $key');
        return null;
    }
  }

  /// Schedule all static notifications (single schedule per key)
  Future<void> _rescheduleStaticNotifications() async {
    try {
      final settings = await settingRepo.getAllSettings();
      logger.d('Processing ${settings.length} notification settings');

      for (final setting in settings) {
        // Skip Athan notifications as they have special handling above
        if (setting.key.startsWith('isNotificationAthan')) {
          continue;
        }

        // Use new NotificationIdManager for consistent ID generation
        final id = NotificationIdManager.generateNotificationId(setting.key);

        if (!setting.enabled || setting.onlySetting) {
          await notificationService.cancelNotificationById(id: id);

          // logger.d(
          //   'Cancelled notification: ${setting.key} setting.onlySetting ${setting.onlySetting} (disabled or settings-only)',
          // );
          continue;
        }

        final success =
            await notificationService.scheduleNotificationCompatType(
          id: id,
          title: setting.label,
          body: NotificationDataConst.resolveNotificationBody(setting.key),
          channel: NotificationDataConst.resolveChannel(setting.key),
          schedule: setting.schedule,
        );

        if (success) {
          // logger.w(
          //   'Scheduled static notification: ${setting.key} date: ${setting.schedule}',
          // );
        } else {
          // logger.i(
          //   'Failed to schedule static notification: ${setting.key} date: ${setting.schedule}',
          // );
        }
      }

      // logger.d('Completed static notification rescheduling');
    } catch (e, track) {
      logger.e('Error in _rescheduleStaticNotifications: $e');
      logger.e('Error in _rescheduleStaticNotifications: $track');
    }
  }

  /// Schedule custom multi-schedule notifications (for keys supporting sub-schedules)
  Future<void> _rescheduleCustomSchedules() async {
    try {
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
        try {
          final schedules = await notificationSchedulesRepo.getSchedules(key);
          // logger.d(
          //   'Processing ${schedules.length} custom schedules for key: $key',
          // );

          for (final schedule in schedules) {
            // Use new NotificationIdManager for consistent ID generation
            final id = NotificationIdManager.generateNotificationId(key);

            if (schedule.enabled) {
              final success =
                  await notificationService.scheduleNotificationCompatType(
                id: id,
                title:
                    schedule.label ?? NotificationDataConst.resolveTitle(key),
                body: schedule.label ??
                    NotificationDataConst.resolveNotificationBody(key),
                channel: NotificationDataConst.resolveChannel(key),
                schedule: schedule.toScheduleModel(),
              );

              if (success) {
                // logger.d('Scheduled custom notification for key: $key');
              } else {
                // logger
                //     .w('Failed to schedule custom notification for key: $key');
              }
            } else {
              await notificationService.cancelNotificationById(id: id);
              // logger
              //     .d('Cancelled custom notification for key: $key (disabled)');
            }
          }
        } catch (e) {
          logger.e('Error processing custom schedules for key $key: $e');
        }
      }

      logger.d('Completed custom schedule rescheduling');
    } catch (e) {
      logger.e('Error in _rescheduleCustomSchedules: $e');
    }
  }

  /// Cancel all notifications for a specific category
  Future<void> cancelNotificationCategory(String category) async {
    try {
      var keysToCancel = <String>[];

      switch (category) {
        case 'athan':
          keysToCancel = NotificationKeys.athanKeys;
        case 'thikr':
          keysToCancel = [
            NotificationKeys.isNotificationThikrMorning,
            NotificationKeys.isNotificationThikrNight,
            NotificationKeys.isNotificationMiddleNight,
          ];
        case 'quran':
          keysToCancel = [
            NotificationKeys.isNotificationReadQuran,
            NotificationKeys.isNotificationReadSurahMulk,
            NotificationKeys.isNotificationReadSurah,
            NotificationKeys.isNotificationReadSurahAlkahf,
          ];
        case 'fasting':
          keysToCancel = [
            NotificationKeys.isNotificationFasting,
            NotificationKeys.isNotificationFastingMonday,
            NotificationKeys.isNotificationFastingThursday,
          ];
      }

      for (final key in keysToCancel) {
        final id = NotificationIdManager.generateNotificationId(key);
        await notificationService.cancelNotificationById(id: id);
      }

      logger.d('Cancelled all notifications for category: $category');
    } catch (e) {
      logger.e('Error cancelling notification category $category: $e');
    }
  }
}
