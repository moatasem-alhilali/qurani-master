import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService() : plugin = FlutterLocalNotificationsPlugin();
  final FlutterLocalNotificationsPlugin plugin;

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    final localTimezone = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(localTimezone);

    tz.setLocalLocation(location);
    await _configureLocalTimeZone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(
      settings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          selectNotificationSubject.add(payload);
        }
      },
    );

    await initAllAndroidChannels();

    _configureSelectNotificationSubject();

    logger.d('Notification service initialized');
  }

  Future<void> initAllAndroidChannels() async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    for (final channel in NotificationChannel.values) {
      final data = channel.data;

      final androidChannel = AndroidNotificationChannel(
        data.id,
        data.name,
        description: 'Channel for ${data.name}',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(data.sound),
      );

      await androidPlugin?.createNotificationChannel(androidChannel);
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    NotificationChannel channel = NotificationChannel.defaultChannel,
  }) async {
    final details = await _buildNotificationDetails(channel);
    await plugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000, // unique ID
      title,
      body,
      details,
      payload: '$title|$body',
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
  }) async {
    final details = await _buildNotificationDetails(channel);
    final time = _nextInstanceOf(hour: hour, minute: minute);

    await plugin.zonedSchedule(
      id,
      title,
      body,
      time,
      details,
      payload: payload ?? '$title|$body',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    // logger.i('Notification service scheduled at $time');
  }

  Future<void> cancel({required int id}) async => plugin.cancel(id);
  Future<void> cancelAll() async => plugin.cancelAll();

  // ================== Internals ==================

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

    const ios = IOSNotificationDetails();

    return NotificationDetails(android: android, iOS: ios);
  }

  tz.TZDateTime _nextInstanceOf({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> _configureLocalTimeZone() async {
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) {
      debugPrint('Notification tapped with payload: $payload');
      // Navigate or handle inside app
    });
  }

  Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    debugPrint('Legacy iOS notification received: $title');
  }
}
