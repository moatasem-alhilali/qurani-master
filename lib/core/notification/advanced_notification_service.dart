import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

class AdvancedNotificationService extends BaseNotificationService {
  AdvancedNotificationService(super.plugin);

  /// Schedule a notification based on a flexible schedule model
  /// This method provides backward compatibility while using the unified base class
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    required NotificationScheduleModel schedule,
    String? payload,
    String? largeIcon,
    String? groupKey,
    bool setAsGroupSummary = false,
  }) async {
    try {
      final details = await buildNotificationDetails(
        channel,
        largeIcon: largeIcon,
        groupKey: groupKey,
        setAsGroupSummary: setAsGroupSummary,
      );

      switch (schedule.type) {
        case ScheduleType.daily:
          return await _scheduleDailyNotification(
            id,
            title,
            body,
            details,
            schedule,
            payload,
          );

        case ScheduleType.hourly:
          return await _scheduleHourlyNotification(
            id,
            title,
            body,
            details,
            payload,
          );

        case ScheduleType.everyNMinutes:
          if (schedule.intervalMinutes == 1) {
            return await _scheduleMinutelyNotification(
              id,
              title,
              body,
              details,
              payload,
            );
          } else {
            return await _scheduleCustomIntervalNotification(
              id,
              title,
              body,
              details,
              schedule,
              payload,
            );
          }

        case ScheduleType.weekly:
          return await _scheduleWeeklyNotifications(
            id,
            title,
            body,
            details,
            schedule,
            payload,
          );

        case ScheduleType.customDates:
          return await _scheduleCustomDateNotifications(
            id,
            title,
            body,
            details,
            schedule,
            payload,
          );
      }
    } catch (e) {
      logger.e('Error in scheduleNotification: $e');
      return false;
    }
  }

  /// Show an instant notification with enhanced features
  /// This method provides backward compatibility while using the unified base class
  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
    String? largeIcon,
    String? groupKey,
    bool setAsGroupSummary = false,
    AndroidNotificationCategory? category,
    NotificationVisibility? visibility,
  }) async {
    return showNotificationWithId(
      id: id,
      title: title,
      body: body,
      channel: channel,
      payload: payload,
      largeIcon: largeIcon,
      groupKey: groupKey,
      setAsGroupSummary: setAsGroupSummary,
      category: category,
      visibility: visibility,
    );
  }

  /// Show a big text notification
  /// This method provides backward compatibility while using the unified base class
  Future<bool> showBigTextNotificationAdvanced({
    required int id,
    required String title,
    required String body,
    required String bigText,
    required NotificationChannel channel,
    String? payload,
    String? summaryText,
  }) async {
    return super.showBigTextNotification(
      id: id,
      title: title,
      body: body,
      bigText: bigText,
      channel: channel,
      payload: payload,
      summaryText: summaryText,
    );
  }

  /// Show a progress notification
  /// This method provides backward compatibility while using the unified base class
  Future<bool> showProgressNotificationAdvanced({
    required int id,
    required String title,
    required int progress,
    required int maxProgress,
    String? body,
    bool indeterminate = false,
  }) async {
    return super.showProgressNotification(
      id: id,
      title: title,
      progress: progress,
      maxProgress: maxProgress,
      body: body,
      indeterminate: indeterminate,
    );
  }

  /// Cancel a notification by id, or cancel a range (for repeated notifications)
  /// This method provides backward compatibility while using the unified base class
  Future<void> cancelNotification({required int id, int? range}) async {
    await cancelNotificationById(id: id, range: range);
  }

  /// Cancel notifications for a specific key
  /// This method provides backward compatibility while using the unified base class
  @override
  Future<void> cancelAllForKey(String notifKey, {int count = 50}) async {
    await super.cancelAllForKey(notifKey, count: count);
  }

  // ================== Private Methods (moved to base class) ==================
  // These methods now delegate to the base class implementation

  Future<bool> _scheduleDailyNotification(
    int id,
    String title,
    String body,
    NotificationDetails details,
    NotificationScheduleModel schedule,
    String? payload,
  ) async {
    try {
      final nextInstanceOf = this.nextInstanceOf(
        hour: schedule.hour!,
        minute: schedule.minute!,
      );

      await plugin.zonedSchedule(
        id,
        title,
        body,
        nextInstanceOf,
        details,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      return true;
    } catch (e) {
      logger.e('Error scheduling daily notification: $e');
      return false;
    }
  }

  Future<bool> _scheduleHourlyNotification(
    int id,
    String title,
    String body,
    NotificationDetails details,
    String? payload,
  ) async {
    try {
      await plugin.periodicallyShow(
        id,
        title,
        body,
        RepeatInterval.hourly,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (e) {
      logger.e('Error scheduling hourly notification: $e');
      return false;
    }
  }

  Future<bool> _scheduleCustomIntervalNotification(
    int id,
    String title,
    String body,
    NotificationDetails details,
    NotificationScheduleModel schedule,
    String? payload,
  ) async {
    try {
      await plugin.periodicallyShowWithDuration(
        id,
        title,
        body,
        Duration(minutes: schedule.intervalMinutes!),
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      return true;
    } catch (e) {
      logger.e('Error scheduling custom interval notification: $e');
      return false;
    }
  }

  Future<bool> _scheduleMinutelyNotification(
    int id,
    String title,
    String body,
    NotificationDetails details,
    String? payload,
  ) async {
    try {
      await plugin.periodicallyShow(
        id,
        title,
        body,
        RepeatInterval.everyMinute,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (e) {
      logger.e('Error scheduling minutely notification: $e');
      return false;
    }
  }

  Future<bool> _scheduleWeeklyNotifications(
    int id,
    String title,
    String body,
    NotificationDetails details,
    NotificationScheduleModel schedule,
    String? payload,
  ) async {
    try {
      var successCount = 0;
      for (final weekday in schedule.weekdays!) {
        try {
          final scheduled = nextInstanceOfWeekday(
            weekday,
            hour: schedule.hour!,
            minute: schedule.minute!,
          );

          await plugin.zonedSchedule(
            id + weekday,
            title,
            body,
            scheduled,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
          successCount++;
        } catch (e) {
          logger.e(
            'Error scheduling weekly notification for weekday $weekday: $e',
          );
        }
      }
      return successCount > 0;
    } catch (e) {
      logger.e('Error in _scheduleWeeklyNotifications: $e');
      return false;
    }
  }

  Future<bool> _scheduleCustomDateNotifications(
    int id,
    String title,
    String body,
    NotificationDetails details,
    NotificationScheduleModel schedule,
    String? payload,
  ) async {
    try {
      var successCount = 0;
      for (var i = 0; i < schedule.customDates!.length; i++) {
        try {
          final dateTime =
              tz.TZDateTime.from(schedule.customDates![i], tz.local);
          await plugin.zonedSchedule(
            id + i,
            title,
            body,
            dateTime,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
          successCount++;
        } catch (e) {
          logger.e('Error scheduling custom date notification $i: $e');
        }
      }
      return successCount > 0;
    } catch (e) {
      logger.e('Error in _scheduleCustomDateNotifications: $e');
      return false;
    }
  }
}
