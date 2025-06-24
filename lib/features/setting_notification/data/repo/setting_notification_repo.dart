import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
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

      // Only schedule if enabled and not a settings-only notification
      if (setting.enabled && !setting.onlySetting) {
        final success =
            await notificationService.scheduleNotificationCompatType(
          id: id,
          title: setting.label,
          body: NotificationDataConst.resolveNotificationBody(setting.key),
          channel: NotificationDataConst.resolveChannel(setting.key),
          schedule: setting.schedule,
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
