import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'android_channel.dart';

class NotifyHelper {
  //time

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  //!================================initialize Notification===================================
  Future<void> initializeNotification(context) async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject(context);
    await _configureLocalTimeZone();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }
  //!===================================notification Details================================

  Future<void> initChannelAndroid() async {
    await initAllChannelAndroid(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }

  //custom Notification Details
  Future<NotificationDetails> customNotificationDetails({
    required String contentTitle,
    required String summaryText,
    required String channelId,
    required String channelName,
  }) async {
    var android = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'channel description',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'test ticker',
      playSound: true,
      // largeIcon: const DrawableResourceAndroidBitmap("logo"),
    );
    return NotificationDetails(android: android);
  }

//default Notification Details
  Future<NotificationDetails> defaultNotificationDetails() async {
    var android = const AndroidNotificationDetails(
      "default_android_channel",
      "default  Android Channel",
      channelDescription: 'channel description',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      ticker: 'test ticker',
      // largeIcon: DrawableResourceAndroidBitmap("logo"),
    );
    return NotificationDetails(
      android: android,
    );
  }

  //TODO:===============================scheduled Notification====================================
  Future<void> customScheduledNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String contentTitle,
    required String summaryText,
    required String channelId,
    required String channelName,
    required int id,
  }) async {
    var notificationDetail = await customNotificationDetails(
      channelId: channelId,
      channelName: channelName,
      contentTitle: contentTitle,
      summaryText: summaryText,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      contentTitle,
      summaryText,
      _nextInstanceOfTenAM(
        hour: hour,
        minute: minute,
      ),
      notificationDetail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'payload|',
    );
  }

//default Scheduled Notification
  Future<void> defaultScheduledNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required int id,
  }) async {
    var notificationDetail = await defaultNotificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTenAM(
        hour: hour,
        minute: minute,
      ),
      notificationDetail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'payload|',
    );
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    var notificationDetail = await defaultNotificationDetails();
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetail,
      payload: '$title|$body',
    );
  }
  //TODO:===============================TZ Date Time====================================

//داله لحساب الوقت
  tz.TZDateTime _nextInstanceOfTenAM({
    required int hour,
    required int minute,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      now.second,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  //!===================================================================

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

//Older IOS
  Future _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    return Text(body!);
  }

  void cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void cancel({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

//_configure Select Notification Subject
  void _configureSelectNotificationSubject(context) {
    selectNotificationSubject.stream.listen(
      (String? payload) async {},
    );
  }
}
