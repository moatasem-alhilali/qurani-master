import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

class AdvancedNotificationService {
  AdvancedNotificationService(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;

  /// Schedule a notification based on a flexible schedule model
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    required NotificationScheduleModel schedule,
    String? payload,
  }) async {
    final details = await _buildNotificationDetails(channel);

    switch (schedule.type) {
      case ScheduleType.daily:
        final nextInstanceOf =
            _nextInstanceOf(hour: schedule.hour!, minute: schedule.minute!);
        try {
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            nextInstanceOf,
            details,
            payload: payload,

            matchDateTimeComponents: DateTimeComponents.time,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle, // daily
          );
        } catch (e) {
          logger.e(
            'Error scheduling daily notification title: $title, error: $e, nextInstanceOf: $nextInstanceOf',
          );
        }
        return;

      case ScheduleType.hourly:
        // Schedule once for each hour in the day at minute X
        for (var hour = 0; hour < 24; hour++) {
          final nextInstanceOf =
              _nextInstanceOf(hour: hour, minute: schedule.minute!);
          try {
            await _plugin.zonedSchedule(
              id + hour,
              title,
              body,
              nextInstanceOf,
              details,
              payload: payload,
              matchDateTimeComponents: DateTimeComponents.time,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
          } catch (e) {
            logger.e(
              'Error scheduling hourly notification title: $title, error: $e, nextInstanceOf: $nextInstanceOf',
            );
          }
        }
        return;

      case ScheduleType.everyNMinutes:
        final now = tz.TZDateTime.now(tz.local);
        final interval = schedule.intervalMinutes!;
        // احسب أول "نقطة" صحيحة بعد الآن
        final minutesPastMidnight = now.hour * 60 + now.minute;
        final nextMinute = ((minutesPastMidnight ~/ interval) + 1) * interval;
        final todayMidnight =
            tz.TZDateTime(tz.local, now.year, now.month, now.day);

        // نبدأ من أول موعد مناسب بعد الآن، ثم نكرر لغاية 24 ساعة للأمام
        for (var m = nextMinute; m < 24 * 60; m += interval) {
          final dateTime = todayMidnight.add(Duration(minutes: m));
          // دائماً تأكد أن التاريخ في المستقبل وليس الآن فقط!
          if (dateTime.isAfter(now)) {
            try {
              await _plugin.zonedSchedule(
                id + m, // استخدم m كمؤشر فريد
                title,
                body,
                dateTime,
                details,
                payload: payload,
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              );
            } catch (e) {
              logger.e(
                'Error scheduling everyNMinutes notification title: $title, error: $e, dateTime: $dateTime',
              );
            }
          }
        }
        return;

      case ScheduleType.weekly:
        // For each selected weekday, schedule for the next occurrence at given hour/minute
        for (final weekday in schedule.weekdays!) {
          final scheduled = _nextInstanceOfWeekday(
            weekday,
            hour: schedule.hour!,
            minute: schedule.minute!,
          );
          try {
            await _plugin.zonedSchedule(
              id + weekday, // use base id + weekday for uniqueness
              title,
              body,
              scheduled,
              details,
              payload: payload,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            );
          } catch (e) {
            logger.e(
              'Error scheduling weekly notification title: $title, error: $e, scheduled: $scheduled',
            );
          }
        }
        return;

      case ScheduleType.customDates:
        // For each specific datetime, schedule a one-time notification
        for (var i = 0; i < schedule.customDates!.length; i++) {
          final dateTime = tz.TZDateTime.from(
            schedule.customDates![i],
            tz.local,
          );
          try {
            await _plugin.zonedSchedule(
              id + i,
              title,
              body,
              dateTime,
              details,
              payload: payload,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
          } catch (e) {
            logger.e(
              'Error scheduling customDates notification title: $title , error: $e, dateTime: $dateTime',
            );
          }
        }
        return;
    }
  }

  /// Cancel a notification by id, or cancel a range (for repeated notifications)
  Future<void> cancelNotification({required int id, int? range}) async {
    if (range != null) {
      for (var i = 0; i < range; i++) {
        await _plugin.cancel(id + i);
      }
    } else {
      await _plugin.cancel(id);
    }
  }

  /// Cancel all notifications (useful for "Disable all" from settings)
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // Internal: notification details builder (Android/iOS channels etc.)
  Future<NotificationDetails> _buildNotificationDetails(
    NotificationChannel channel,
  ) async {
    final data = channel.data;

    final android = AndroidNotificationDetails(
      data.id,
      data.name,
      channelDescription: 'Channel for ${data.name}',
      sound: RawResourceAndroidNotificationSound(data.sound),
      priority: Priority.high,
      importance: Importance.max,
    );

    const ios = DarwinNotificationDetails();

    return NotificationDetails(android: android, iOS: ios);
  }

  /// Calculate next instance of hour:minute from now
  tz.TZDateTime _nextInstanceOf({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Calculate next instance of a specific weekday at hour:minute
  tz.TZDateTime _nextInstanceOfWeekday(
    int weekday, {
    required int hour,
    required int minute,
  }) {
    var scheduled = _nextInstanceOf(hour: hour, minute: minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// تلغي جميع الإشعارات المرتبطة بمفتاح واحد (ممكن تمرر count ثابت أو dynamic)
  Future<void> cancelAllForKey(String notifKey, {int count = 50}) async {
    // notificationId = notifKey.hashCode.abs() + scheduleId
    for (var i = 1; i < count; i++) {
      await cancelNotification(id: notifKey.hashCode.abs() + i);
    }
  }

  // get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  // get scheduled notifications
  Future<List<ActiveNotification>> getActiveNotifications() async {
    return _plugin.getActiveNotifications();
  }

  // get completed notifications
}
