import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/main.dart';
import 'package:rxdart/rxdart.dart';

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

  /// Check if notifications are enabled on the device
  @override
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidPlugin = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      final iOSPlugin = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final permissions = await iOSPlugin?.checkPermissions();
      if (permissions == null) return false;
      return permissions.isEnabled;
    }
    return false;
  }

  /// Request notification permissions (required for Android 13+ and iOS)
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+, request notification permission
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (status != PermissionStatus.granted) {
          return false;
        }
      }

      // Request exact alarm permission for scheduled notifications
      final exactAlarmPermission = await requestExactAlarmPermission();
      logger.d('Exact alarm permission: $exactAlarmPermission');

      return areNotificationsEnabled();
    } else if (Platform.isIOS) {
      return requestNotificationPermissions();
    }
    return false;
  }

  Future<void> initialize() async {
    // Initialize timezone using base class method
    await configureLocalTimeZone();

    // Android initialization settings with proper configuration
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings with proper permissions
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // Linux settings (if supporting desktop)
    final linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('assets/image/beads_icon.png'),
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );

    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );

    await initAllAndroidChannels();
    _configureSelectNotificationSubject();

    logger.d('Notification service initialized successfully');
  }

  /// Initialize all Android notification channels with enhanced configuration
  Future<void> initAllAndroidChannels() async {
    try {
      if (!Platform.isAndroid) return;

      final androidPlugin = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // Create notification channel group for better organization
      const channelGroup = AndroidNotificationChannelGroup(
        'islamic_notifications',
        'الإشعارات الإسلامية',
        description: 'مجموعة الإشعارات الخاصة بالتطبيق الإسلامي',
      );

      await androidPlugin?.createNotificationChannelGroup(channelGroup);
      logger.d('Android notification channels initialized');

      for (final channel in NotificationChannel.values) {
        final data = channel.data;

        final androidChannel = AndroidNotificationChannel(
          data.id,
          data.name,
          description: 'قناة ${data.name} للإشعارات الإسلامية',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound(data.sound),
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          enableLights: true,
          ledColor: const Color.fromARGB(255, 0, 255, 0),
          groupId: 'islamic_notifications',
        );

        await androidPlugin?.createNotificationChannel(androidChannel);
      }
    } catch (e, stackTrace) {
      logger
        ..e('Error initializing Android notification channels: $e')
        ..e('Error initializing Android notification channels: $stackTrace');
    }
  }

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

  /// Get pending notifications
  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return super.getPendingNotifications();
  }

  /// Get active notifications
  @override
  Future<List<ActiveNotification>> getActiveNotifications() async {
    return super.getActiveNotifications();
  }

  /// Cancel notification by ID
  Future<void> cancel({required int id}) async =>
      cancelNotificationById(id: id);

  /// Cancel all notifications
  @override
  Future<void> cancelAll() async => super.cancelAll();

  // ================== Internal Methods ==================

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) {
      debugPrint('Notification tapped with payload: $payload');
      _handleNotificationTap(payload);
    });
  }

  void _handleNotificationTap(String payload) {
    // Handle notification tap based on payload
    // This can be extended to navigate to specific screens
    logger.d('Handling notification tap: $payload');
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) async {
    selectNotificationSubject.add(response.payload ?? '');
  }

  /// Setup notification actions for iOS
  Future<void> setupNotificationActions() async {
    if (Platform.isIOS) {
      final iosPlugin = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      final actions = [
        DarwinNotificationAction.plain(
          'mark_as_read',
          'تم القراءة',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          'remind_later',
          'تذكير لاحقاً',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
      ];

      final category = DarwinNotificationCategory(
        'islamic_notifications',
        actions: actions,
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.allowInCarPlay,
        },
      );

      await iosPlugin?.initialize(
        DarwinInitializationSettings(
          notificationCategories: [category],
        ),
      );
    }
  }
}
