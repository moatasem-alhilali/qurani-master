import 'package:quran_app/core/notification/advanced_notification_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting_notification/data/seed/notification_settings_seeder.dart';
import 'package:quran_app/main.dart';

// This class manages notification settings and applies changes to the advanced notification scheduler
class SettingNotificationRepo {
  SettingNotificationRepo({
    required this.advancedNotificationService,
  });

  final AdvancedNotificationService advancedNotificationService;

  /// Get NotificationSettingModel by key
  Future<NotificationSettingModel?> getSetting(String key) async {
    return DatabaseNotificationSettingService().getByKey(key);
  }

  /// Get enabled/disabled value
  Future<bool> getBool(String key) async {
    final setting = await DatabaseNotificationSettingService().getByKey(key);
    return setting?.enabled ?? false;
  }

  /// Update enabled/disabled value (toggle switch in settings)
  Future<void> toggle(String key, bool val) async {
    final setting = await DatabaseNotificationSettingService().getByKey(key);
    if (setting == null) return;
    final updated = setting.copyWith(enabled: val);
    await DatabaseNotificationSettingService().upsert(updated);
    await _applyNotificationChange(updated);
  }

  /// Update full schedule (when user changes timing/mode in settings)
  Future<void> updateSchedule(
    String key,
    NotificationSettingModel newSchedule,
  ) async {
    await DatabaseNotificationSettingService().upsert(newSchedule);
    await _applyNotificationChange(newSchedule);
  }

  /// Apply any notification change (enable/disable/schedule update)
  Future<void> _applyNotificationChange(
    NotificationSettingModel setting,
  ) async {
    final id = NotificationDataConst.resolveNotificationId(setting.key);

    // Cancel any previous notifications for this setting
    await advancedNotificationService.cancelNotification(
      id: id,
      range: NotificationDataConst.resolveIdRange(setting),
    );

    if (setting.enabled && !setting.onlySetting) {
      // Only schedule if enabled
      await advancedNotificationService.scheduleNotification(
        id: id,
        title: setting.label,
        body: NotificationDataConst.resolveNotificationBody(setting.key),
        channel: NotificationDataConst.resolveChannel(setting.key),
        schedule: setting.schedule,
      );
    }
  }

  /// Get all settings
  Future<List<NotificationSettingModel>> getAllSettings() async {
    try {
      return await DatabaseNotificationSettingService().getAll();
    } catch (e) {
      logger.e('error getting all settings $e');
      return [];
    }
  }

  /// Get all settings as a Map (useful for displaying all toggles in settings UI)
  Future<Map<String, NotificationSettingModel>> loadAll() async {
    try {
      final all = await DatabaseNotificationSettingService().getAll();
      return {for (final e in all) e.key: e};
    } catch (e) {
      logger.e('error loading all settings $e');
      return {};
    }
  }
}
