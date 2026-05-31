import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_payload_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/main.dart';

/// Repository for managing notification settings and applying changes to the notification scheduler
/// Uses the new unified notification system with BaseNotificationService
class SettingNotificationRepo {
  SettingNotificationRepo({
    required this.notificationService,
  });

  final NotificationService notificationService;
  final AthanAlarmPayloadService _athanPayloadService =
      AthanAlarmPayloadService();
  final DatabaseService _databaseService = DatabaseService();

  /// Get NotificationSettingModel by key
  Future<NotificationSettingModel?> getSetting(String key) async {
    try {
      return await DatabaseNotificationSettingService().getByKey(key);
    } catch (e) {
      logger.e('Error getting notification setting for key $key: $e');
      return null;
    }
  }

  /// Get enabled/disabled value for a notification setting
  Future<bool> getBool(String key) async {
    try {
      final setting = await DatabaseNotificationSettingService().getByKey(key);
      return setting?.enabled ?? false;
    } catch (e) {
      logger.e('Error getting boolean value for key $key: $e');
      return false;
    }
  }

  /// Update enabled/disabled value (toggle switch in settings UI)
  Future<void> toggle(String key, bool val) async {
    try {
      final setting = await DatabaseNotificationSettingService().getByKey(key);
      if (setting == null) {
        logger.w('Setting not found for key: $key');
        return;
      }

      final updated = setting.copyWith(enabled: val);
      await DatabaseNotificationSettingService().upsert(updated);
      BaseNotificationService.clearNotificationSettingsCache();
      await _applyNotificationChange(updated);

      logger.d('Toggled notification setting $key to $val');
    } catch (e) {
      logger.e('Error toggling notification setting $key: $e');
    }
  }

  /// Update full schedule (when user changes timing/mode in settings)
  Future<void> updateSchedule(
    String key,
    NotificationSettingModel newSchedule,
  ) async {
    try {
      await DatabaseNotificationSettingService().upsert(newSchedule);
      BaseNotificationService.clearNotificationSettingsCache();
      await _applyNotificationChange(newSchedule);

      logger.d('Updated schedule for notification setting: $key');
    } catch (e) {
      logger.e('Error updating schedule for key $key: $e');
    }
  }

  /// Apply notification changes using the new unified notification system
  Future<void> _applyNotificationChange(
    NotificationSettingModel setting,
  ) async {
    try {
      // Use the new NotificationIdManager for consistent ID generation
      final id = NotificationIdManager.generateNotificationId(setting.key);

      // Cancel any previous notifications for this setting
      await notificationService.cancelNotificationById(
        id: id,
        range: NotificationDataConst.resolveIdRange(setting),
      );

      if (!setting.enabled) {
        await _cancelFeatureOwnedNotifications(setting.key);
      }

      if (setting.key == NotificationKeys.isNotify && !setting.enabled) {
        await notificationService.cancelAll();
        return;
      }

      // Only schedule if enabled and not a settings-only notification
      if (setting.enabled && !setting.onlySetting) {
        final isAthan = _athanPayloadService.isAthanKey(setting.key);
        final prayerName = _athanPayloadService.prayerNameFromKey(setting.key);
        final title = isAthan
            ? _athanPayloadService.buildAthanTitle(prayerName: prayerName)
            : setting.label;
        final body = isAthan
            ? _athanPayloadService.buildAthanBody(prayerName: prayerName)
            : NotificationDataConst.resolveNotificationBody(setting.key);

        final success =
            await notificationService.scheduleNotificationCompatType(
          id: id,
          title: title,
          body: body,
          channel: NotificationDataConst.resolveChannel(setting.key),
          schedule: setting.schedule,
          settingKey: setting.key,
          payload: isAthan
              ? _athanPayloadService.buildPayload(
                  key: setting.key,
                  prayerName: prayerName,
                )
              : null,
          subText: isAthan
              ? _athanPayloadService.buildAthanSubText(prayerName: prayerName)
              : null,
          ticker: isAthan ? 'حان الآن أذان $prayerName' : null,
          iosSubtitle: isAthan
              ? _athanPayloadService.buildAthanSubText(prayerName: prayerName)
              : null,
          iosThreadIdentifier: isAthan ? 'athan_notifications' : null,
          iosCategoryIdentifier: isAthan ? 'islamic_notifications' : null,
          iosInterruptionLevel:
              isAthan ? InterruptionLevel.timeSensitive : null,
          iosSound: isAthan ? 'athan.caf' : null,
          bigText: isAthan
              ? _athanPayloadService.buildAthanExpandedBody(
                  prayerName: prayerName,
                )
              : null,
          category: isAthan ? AndroidNotificationCategory.alarm : null,
          visibility: isAthan ? NotificationVisibility.public : null,
          ongoing: false,
          autoCancel: true,
        );

        if (success) {
          logger.d('Successfully scheduled notification for: ${setting.key}');
        } else {
          logger.w('Failed to schedule notification for: ${setting.key}');
        }
      } else {
        logger.d('Notification disabled or settings-only for: ${setting.key}');
      }
    } catch (e) {
      logger.e('Error applying notification change for ${setting.key}: $e');
    }
  }

  /// Get all notification settings
  Future<List<NotificationSettingModel>> getAllSettings() async {
    try {
      return await DatabaseNotificationSettingService().getAll();
    } catch (e) {
      logger.e('Error getting all notification settings: $e');
      return [];
    }
  }

  /// Get all settings as a Map (useful for displaying all toggles in settings UI)
  Future<Map<String, NotificationSettingModel>> loadAll() async {
    try {
      final all = await DatabaseNotificationSettingService().getAll();
      return {for (final e in all) e.key: e};
    } catch (e) {
      logger.e('Error loading all notification settings: $e');
      return {};
    }
  }

  /// Cancel all notifications for a specific key using the new unified system
  Future<void> cancelNotificationsForKey(String key, {int count = 50}) async {
    try {
      await notificationService.cancelAllForKey(key, count: count);
      logger.d('Cancelled all notifications for key: $key');
    } catch (e) {
      logger.e('Error cancelling notifications for key $key: $e');
    }
  }

  Future<void> _cancelFeatureOwnedNotifications(String key) async {
    switch (key) {
      case NotificationKeys.isNotificationDailyWirdMorning:
        await notificationService.cancelNotificationById(
          id: NotificationIdManager.generateNotificationId(
            'daily_wird_morning_reminder',
          ),
        );
        return;
      case NotificationKeys.isNotificationDailyWirdEvening:
        await notificationService.cancelNotificationById(
          id: NotificationIdManager.generateNotificationId(
            'daily_wird_evening_reminder',
          ),
        );
        return;
      case NotificationKeys.isNotificationDailyWirdNight:
        await notificationService.cancelNotificationById(
          id: NotificationIdManager.generateNotificationId(
            'daily_wird_night_reminder',
          ),
        );
        return;
      case NotificationKeys.isNotificationDailyWirdSummary:
        await notificationService.cancelNotificationById(
          id: NotificationIdManager.generateNotificationId(
            'daily_wird_summary_reminder',
          ),
        );
        return;
      case NotificationKeys.isNotificationFloatingAdhkar:
        await notificationService.cancelNotificationById(
          id: 74200,
          range: 33,
        );
        return;
      case NotificationKeys.isNotificationPrayerSilentModeReminder:
        await notificationService.cancelNotificationById(
          id: 76800,
          range: 8,
        );
        return;
      case NotificationKeys.isNotificationQuranPlan:
        await _cancelQuranPlanNotifications();
        return;
      case NotificationKeys.isNotificationYoungMuslimResume:
        await _cancelYoungMuslimResumeNotifications();
        return;
    }
  }

  Future<void> _cancelQuranPlanNotifications() async {
    try {
      final rows = await _databaseService.query(
        DatabaseTables.quranPlan,
        columns: ['id'],
        where: 'reminder_time IS NOT NULL',
      );
      for (final row in rows) {
        final id = row['id'];
        if (id is int) {
          await notificationService.cancelNotificationById(id: id);
        }
      }
    } catch (e) {
      logger.e('Error cancelling Quran plan notifications: $e');
    }
  }

  Future<void> _cancelYoungMuslimResumeNotifications() async {
    try {
      final database = await _databaseService.database;
      final rows = await database.query(
        'ym_video_progress',
        columns: ['video_id'],
        where: 'reminder_scheduled_at IS NOT NULL',
      );
      for (final row in rows) {
        final videoId = row['video_id'];
        if (videoId is String) {
          await notificationService.cancelNotificationById(
            id: ('young_muslim_$videoId').hashCode.abs() % 100000,
          );
        }
      }
      await database.update(
        'ym_video_progress',
        {'reminder_scheduled_at': null},
        where: 'reminder_scheduled_at IS NOT NULL',
      );
    } catch (e) {
      logger.e('Error cancelling young muslim resume notifications: $e');
    }
  }

  /// Reschedule all enabled notifications using the new unified system
  Future<void> rescheduleAllNotifications() async {
    try {
      final settings = await getAllSettings();

      for (final setting in settings) {
        if (setting.enabled && !setting.onlySetting) {
          await _applyNotificationChange(setting);
        }
      }

      logger.d('Rescheduled all notification settings');
    } catch (e) {
      logger.e('Error rescheduling all notifications: $e');
    }
  }
}
