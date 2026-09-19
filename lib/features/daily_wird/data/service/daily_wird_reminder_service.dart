import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_settings_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/l10n/l10n.dart';

class DailyWirdReminderService {
  DailyWirdReminderService({
    required this.notificationService,
  });

  final NotificationService notificationService;

  static const String _morningKey = 'daily_wird_morning_reminder';
  static const String _eveningKey = 'daily_wird_evening_reminder';
  static const String _nightKey = 'daily_wird_night_reminder';
  static const String _summaryKey = 'daily_wird_summary_reminder';

  Future<void> reschedule(DailyWirdSettings settings) async {
    await _cancelAll();
    final l10n = L10nService.current;

    if (!settings.onboardingCompleted ||
        settings.selectedPresetId == null ||
        settings.selectedPresetId!.trim().isEmpty) {
      return;
    }

    if (settings.morningReminderEnabled) {
      await _schedule(
        key: _morningKey,
        time: settings.morningReminderTime,
        title: l10n.dailyWirdReminderMorningTitle,
        body: l10n.dailyWirdReminderMorningBody,
        channel: NotificationChannel.morning,
        settingKey: NotificationKeys.isNotificationDailyWirdMorning,
      );
    }

    if (settings.eveningReminderEnabled) {
      await _schedule(
        key: _eveningKey,
        time: settings.eveningReminderTime,
        title: l10n.dailyWirdReminderEveningTitle,
        body: l10n.dailyWirdReminderEveningBody,
        channel: NotificationChannel.night,
        settingKey: NotificationKeys.isNotificationDailyWirdEvening,
      );
    }

    if (settings.nightReminderEnabled) {
      await _schedule(
        key: _nightKey,
        time: settings.nightReminderTime,
        title: l10n.dailyWirdReminderNightTitle,
        body: l10n.dailyWirdReminderNightBody,
        channel: NotificationChannel.sleep,
        settingKey: NotificationKeys.isNotificationDailyWirdNight,
      );
    }

    if (settings.endOfDaySummaryEnabled) {
      await _schedule(
        key: _summaryKey,
        time: settings.endOfDaySummaryTime,
        title: l10n.dailyWirdReminderSummaryTitle,
        body: l10n.dailyWirdReminderSummaryBody,
        channel: NotificationChannel.defaultChannel,
        settingKey: NotificationKeys.isNotificationDailyWirdSummary,
      );
    }
  }

  Future<void> _cancelAll() async {
    await notificationService.cancelNotificationById(
      id: _notificationId(_morningKey),
    );
    await notificationService.cancelNotificationById(
      id: _notificationId(_eveningKey),
    );
    await notificationService.cancelNotificationById(
      id: _notificationId(_nightKey),
    );
    await notificationService.cancelNotificationById(
      id: _notificationId(_summaryKey),
    );
  }

  Future<void> _schedule({
    required String key,
    required String time,
    required String title,
    required String body,
    required NotificationChannel channel,
    required String settingKey,
  }) async {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    await notificationService.scheduleNotificationCompatType(
      id: _notificationId(key),
      title: title,
      body: body,
      channel: channel,
      payload: key,
      settingKey: settingKey,
      schedule: NotificationScheduleModel.daily(
        hour: hour,
        minute: minute,
      ),
    );
  }

  int _notificationId(String key) =>
      NotificationIdManager.generateNotificationId(
        key,
      );
}
