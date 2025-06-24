import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(
  NotificationResponse response,
) async {
  selectNotificationSubject.add(response.payload ?? '');
}

class NotificationService extends BaseNotificationService {
  NotificationService() : super(FlutterLocalNotificationsPlugin());

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  /// Show instant notification with enhanced features
  Future<void> showInstantNotification({
    required String title,
    required String body,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
    String? largeIcon,
    List<AndroidNotificationAction>? actions,
    String? groupKey,
    bool setAsGroupSummary = false,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await showNotificationWithId(
      id: id,
      title: title,
      body: body,
      channel: channel,
      payload: payload ?? '$title|$body',
      largeIcon: largeIcon,
      groupKey: groupKey,
      setAsGroupSummary: setAsGroupSummary,
      actions: actions,
    );
  }

  /// Schedule notification with enhanced scheduling options
  Future<void> scheduleNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
    String? largeIcon,
    List<AndroidNotificationAction>? actions,
    String? groupKey,
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exactAllowWhileIdle,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final details = await buildNotificationDetails(
      channel,
      largeIcon: largeIcon,
      actions: actions,
      groupKey: groupKey,
    );

    final time = nextInstanceOf(hour: hour, minute: minute);

    await plugin.zonedSchedule(
      id,
      title,
      body,
      time,
      details,
      payload: payload ?? '$title|$body',
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents:
          matchDateTimeComponents ?? DateTimeComponents.time,
    );
  }

  /// Show progress notification (useful for download progress)
  Future<void> showProgressNotificationCompat({
    required int id,
    required String title,
    required int progress,
    required int maxProgress,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? body,
    bool indeterminate = false,
  }) async {
    await super.showProgressNotification(
      id: id,
      title: title,
      progress: progress,
      maxProgress: maxProgress,
      body: body,
      indeterminate: indeterminate,
      channel: channel,
    );
  }

  /// Show big text notification
  Future<void> showBigTextNotificationCompat({
    required int id,
    required String title,
    required String body,
    required String bigText,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
  }) async {
    await super.showBigTextNotification(
      id: id,
      title: title,
      body: body,
      bigText: bigText,
      channel: channel,
      payload: payload,
    );
  }

  /// Show notification with image attachment
  Future<void> showNotificationWithImageCompat({
    required int id,
    required String title,
    required String body,
    required String imagePath,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
  }) async {
    await super.showNotificationWithImage(
      id: id,
      title: title,
      body: body,
      imagePath: imagePath,
      channel: channel,
      payload: payload,
    );
  }

  Future<bool> scheduleDailyNotification(
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

  Future<bool> scheduleHourlyNotification(
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

  Future<bool> scheduleCustomIntervalNotification(
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

  Future<bool> scheduleMinutelyNotification(
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

  Future<bool> scheduleWeeklyNotifications(
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

  Future<bool> scheduleCustomDateNotifications(
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

  /// Schedule a notification based on a flexible schedule model
  /// This method provides backward compatibility while using the unified base class
  Future<bool> scheduleNotificationCompatType({
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
          return await scheduleDailyNotification(
            id,
            title,
            body,
            details,
            schedule,
            payload,
          );

        case ScheduleType.hourly:
          return await scheduleHourlyNotification(
            id,
            title,
            body,
            details,
            payload,
          );

        case ScheduleType.everyNMinutes:
          if (schedule.intervalMinutes == 1) {
            return await scheduleMinutelyNotification(
              id,
              title,
              body,
              details,
              payload,
            );
          } else {
            return await scheduleCustomIntervalNotification(
              id,
              title,
              body,
              details,
              schedule,
              payload,
            );
          }

        case ScheduleType.weekly:
          return await scheduleWeeklyNotifications(
            id,
            title,
            body,
            details,
            schedule,
            payload,
          );

        case ScheduleType.customDates:
          return await scheduleCustomDateNotifications(
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
}
