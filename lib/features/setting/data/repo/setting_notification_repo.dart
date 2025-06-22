import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/advanced_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_ids.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/data/seed/notification_settings_seeder.dart';
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
    final id = _resolveNotificationId(setting.key);

    // Cancel any previous notifications for this setting
    await advancedNotificationService.cancelNotification(
      id: id,
      range: _resolveIdRange(setting),
    );

    if (setting.enabled) {
      // Only schedule if enabled
      await advancedNotificationService.scheduleNotification(
        id: id,
        title: setting.label,
        body: _resolveNotificationBody(setting),
        channel: _resolveChannel(setting.key),
        schedule: setting.schedule,
      );
    }
  }

  /// Example: Map key to notification channel
  NotificationChannel _resolveChannel(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return NotificationChannel.morning;
      case NotificationKeys.isNotificationThikrNight:
        return NotificationChannel.night;
      case NotificationKeys.isNotificationMiddleNight:
        return NotificationChannel.middleNight;
      case NotificationKeys.isNotificationMohammed:
        return NotificationChannel.mohammed;
      case NotificationKeys.isNotificationRandomThikr:
        return NotificationChannel.randomThikr;
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
      case NotificationKeys.isNotificationReadSurah:
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationWridSleep:
        return NotificationChannel.sleep;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationChannel.getUp;
      case NotificationKeys.isNotificationFasting:
      case NotificationKeys.isNotificationFastingMonday:
      case NotificationKeys.isNotificationFastingThursday:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
      case NotificationKeys.isNotificationAllAthan:
        return NotificationChannel.athan;
      default:
        return NotificationChannel.defaultChannel;
    }
  }

  /// Example: Map key to notification ID (use NotificationIds class)
  int _resolveNotificationId(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return NotificationIds.thikrMorning;
      case NotificationKeys.isNotificationThikrNight:
        return NotificationIds.thikrNight;
      case NotificationKeys.isNotificationMiddleNight:
        return NotificationIds.middleNight;
      case NotificationKeys.isNotificationMohammed:
        return NotificationIds.mohammedPrayer(
          0,
        ); // استخدم الساعة المطلوبة كـ parameter
      case NotificationKeys.isNotificationRandomThikr:
        return NotificationIds.randomThikr(0);
      case NotificationKeys.isNotificationReadQuran:
        return NotificationIds.readQuran;
      case NotificationKeys.isNotificationReadSurahMulk:
        return NotificationIds.readSurahMulk;
      case NotificationKeys.isNotificationWridSleep:
        return NotificationIds.thikrSleep;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationIds.thikrGetup;
      case NotificationKeys.isNotificationReadSurah:
        return NotificationIds.userScheduledThikr(
          1,
        ); // مثال، استخدم ID خاص بكل جدولة يحددها المستخدم
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return NotificationIds.userScheduledThikr(2);
      case NotificationKeys.isNotificationFasting:
        return NotificationIds.userScheduledThikr(3);
      case NotificationKeys.isNotificationFastingMonday:
        return NotificationIds.userScheduledThikr(4);
      case NotificationKeys.isNotificationFastingThursday:
        return NotificationIds.userScheduledThikr(5);
      case NotificationKeys.isNotificationAthanFagr:
        return NotificationIds.athanFajr;
      case NotificationKeys.isNotificationAthanDuhr:
        return NotificationIds.athanDhuhr;
      case NotificationKeys.isNotificationAthanAsr:
        return NotificationIds.athanAsr;
      case NotificationKeys.isNotificationAthanMagrib:
        return NotificationIds.athanMaghrib;
      case NotificationKeys.isNotificationAthanIsha:
        return NotificationIds.athanIsha;
      case NotificationKeys.isNotificationAllAthan:
        return 210; // مجموعة الأذان (للجدولة/الحذف الجماعي فقط)
      default:
        return 99999;
    }
  }

  /// Some notifications (like random thikr) might schedule multiple notifications, so you may want to cancel a range
  int? _resolveIdRange(NotificationSettingModel setting) {
    switch (setting.key) {
      case NotificationKeys.isNotificationRandomThikr:
        // Allow up to 100 random thikr notifications per day
        return 100;
      case NotificationKeys.isNotificationMohammed:
        // Allow up to 24 hourly notifications per day
        return 24;
      case NotificationKeys.isNotificationAllAthan:
        // Allow up to 5 athan notifications per day
        return 5;
      case NotificationKeys.isNotificationThikrMorning:
      case NotificationKeys.isNotificationThikrNight:
      case NotificationKeys.isNotificationMiddleNight:
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
      case NotificationKeys.isNotificationWridSleep:
      case NotificationKeys.isNotificationWridGetup:
      case NotificationKeys.isNotificationReadSurah:
      case NotificationKeys.isNotificationReadSurahAlkahf:
      case NotificationKeys.isNotificationFasting:
      case NotificationKeys.isNotificationFastingMonday:
      case NotificationKeys.isNotificationFastingThursday:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        // Single notification per day
        return 1;
      default:
        return null;
    }
  }

  /// You can customize notification body per key
  String _resolveNotificationBody(NotificationSettingModel setting) {
    switch (setting.key) {
      case NotificationKeys.isNotificationThikrMorning:
        return 'لا تنس أذكار الصباح!';
      case NotificationKeys.isNotificationThikrNight:
        return 'لا تنس أذكار المساء!';
      case NotificationKeys.isNotificationMiddleNight:
        return 'حان وقت قيام الليل، استغل الثلث الأخير من الليل.';
      case NotificationKeys.isNotificationMohammed:
        return 'صلِّ على النبي ﷺ تسعد في يومك.';
      case NotificationKeys.isNotificationRandomThikr:
        return 'اذكر الله يذكرك!';
      case NotificationKeys.isNotificationReadQuran:
        return 'خصص وقتًا لوردك القرآني اليومي.';
      case NotificationKeys.isNotificationReadSurahMulk:
        return 'لا تنس قراءة سورة الملك الليلة.';
      case NotificationKeys.isNotificationWridSleep:
        return 'اذكار النوم قبل أن تغفو.';
      case NotificationKeys.isNotificationWridGetup:
        return 'ابدأ يومك بذكر الله بعد الاستيقاظ.';
      case NotificationKeys.isNotificationReadSurah:
        return 'لا تنس قراءة السورة التي اخترتها اليوم.';
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return 'لا تنس قراءة سورة الكهف في يوم الجمعة.';
      case NotificationKeys.isNotificationFasting:
        return 'تذكير بصيام التطوع.';
      case NotificationKeys.isNotificationFastingMonday:
        return 'تذكير بصيام يوم الاثنين.';
      case NotificationKeys.isNotificationFastingThursday:
        return 'تذكير بصيام يوم الخميس.';
      case NotificationKeys.isNotificationAllAthan:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        return 'حان الآن موعد الأذان.';
      default:
        return setting.label; // fallback
    }
  }

  /// Get all settings
  Future<List<NotificationSettingModel>> getAllSettings() async {
    try {
      await NotificationSettingsSeeder().runIfNeeded();
      return await DatabaseNotificationSettingService().getAll();
    } catch (e) {
      logger.e('error getting all settings $e');
      return [];
    }
  }

  /// Get all settings as a Map (useful for displaying all toggles in settings UI)
  Future<Map<String, NotificationSettingModel>> loadAll() async {
    try {
      await NotificationSettingsSeeder().runIfNeeded();
      final all = await DatabaseNotificationSettingService().getAll();
      return {for (final e in all) e.key: e};
    } catch (e) {
      logger.e('error loading all settings $e');
      return {};
    }
  }

  /// UI utility: show time picker dialog and return (hour, minute)
  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    final res = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
      context: context,
      cancelText: 'رجوع',
      confirmText: 'اختيار',
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    return res;
  }

  /// Lock/unlock all notifications (master switch)
  Future<void> unlockAllNotifications(bool enable) async {
    final all = await DatabaseNotificationSettingService().getAll();
    for (final setting in all) {
      final updated = setting.copyWith(enabled: enable);
      await DatabaseNotificationSettingService().upsert(updated);
      await _applyNotificationChange(updated);
    }
    debugPrint(
      enable ? '🔔 Notifications enabled.' : '🔕 Notifications disabled.',
    );
  }
}
