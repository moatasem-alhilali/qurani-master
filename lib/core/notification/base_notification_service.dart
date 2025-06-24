import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Unified ID management for all notifications
class NotificationIdManager {
  static final Map<String, int> _keyToIdMap = {};
  static int _nextIdCounter = 1000; // Start from 1000 to avoid conflicts

  /// Generate a unique notification ID for a given key
  /// If the key already exists, return the existing ID
  static int generateNotificationId(String key) {
    if (_keyToIdMap.containsKey(key)) {
      return _keyToIdMap[key]!;
    }

    final id = key.hashCode.abs() %
        100000; // Use hashCode but ensure it's within reasonable range
    _keyToIdMap[key] = id;
    return id;
  }

  /// Get the notification ID for a specific key (returns null if not found)
  static int? getNotificationId(String key) {
    return _keyToIdMap[key];
  }

  /// Generate a sequential ID for range-based notifications (like hourly notifications)
  static int generateSequentialId(String baseKey, int index) {
    final baseId = generateNotificationId(baseKey);
    return baseId + index;
  }

  /// Clear all stored IDs (useful for testing or reset)
  static void clearAll() {
    _keyToIdMap.clear();
    _nextIdCounter = 1000;
  }

  /// Get all registered keys and their IDs
  static Map<String, int> getAllIds() {
    return Map.from(_keyToIdMap);
  }
}

/// Base notification service containing all shared logic
abstract class BaseNotificationService {
  BaseNotificationService(this.plugin);

  final FlutterLocalNotificationsPlugin plugin;

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

  // ================== Shared Permission Methods ==================

  /// Check if notifications are enabled on the device
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin = plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        return await androidPlugin?.areNotificationsEnabled() ?? false;
      } else if (Platform.isIOS) {
        final iosPlugin = plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final permissions = await iosPlugin?.checkPermissions();
        return permissions?.isEnabled ?? false;
      }
      return false;
    } catch (e) {
      logger.e('Error checking notification permissions: $e');
      return false;
    }
  }

  /// Request exact alarm permissions for Android 12+
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final androidPlugin = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final result = await androidPlugin?.requestExactAlarmsPermission();
      logger.d('Exact alarm permission result: $result');
      return result ?? false;
    } catch (e) {
      logger.e('Error requesting exact alarm permission: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+, request notification permission
        if (await Permission.notification.isDenied) {
          final status = await Permission.notification.request();
          if (status != PermissionStatus.granted) {
            return false;
          }
        }
        return await areNotificationsEnabled();
      } else if (Platform.isIOS) {
        final iosPlugin = plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

        final result = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        return result == true;
      }

      return true;
    } catch (e) {
      logger.e('Error requesting notification permissions: $e');
      return false;
    }
  }

  // ================== Shared Timezone Methods ==================

  /// Configure local timezone
  Future<void> configureLocalTimeZone() async {
    try {
      tz.initializeTimeZones();
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(localTimezone);
      tz.setLocalLocation(location);
    } catch (e) {
      logger.e('Error configuring timezone: $e');
      // Fallback to UTC if timezone detection fails
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  /// Get next instance of a specific time
  tz.TZDateTime nextInstanceOf({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Get next instance of a specific weekday and time
  tz.TZDateTime nextInstanceOfWeekday(
    int weekday, {
    required int hour,
    required int minute,
  }) {
    var scheduled = nextInstanceOf(hour: hour, minute: minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // ================== Shared Notification Building Methods ==================

  /// Build standard notification details with all common options
  Future<NotificationDetails> buildNotificationDetails(
    NotificationChannel channel, {
    String? largeIcon,
    List<AndroidNotificationAction>? actions,
    String? groupKey,
    bool setAsGroupSummary = false,
    AndroidNotificationCategory? category,
    NotificationVisibility? visibility,
    BigTextStyleInformation? bigTextStyle,
    BigPictureStyleInformation? bigPictureStyle,
    InboxStyleInformation? inboxStyle,
    bool showProgress = false,
    int maxProgress = 100,
    int progress = 0,
    bool indeterminate = false,
    bool ongoing = false,
    bool autoCancel = true,
    bool showWhen = true,
    bool enableVibration = true,
  }) async {
    final data = channel.data;

    final android = AndroidNotificationDetails(
      data.id,
      data.name,
      channelDescription: 'قناة ${data.name}',
      sound: RawResourceAndroidNotificationSound(data.sound),
      priority: Priority.high,
      importance: Importance.max,
      largeIcon:
          largeIcon != null ? DrawableResourceAndroidBitmap(largeIcon) : null,
      actions: actions,
      groupKey: groupKey,
      setAsGroupSummary: setAsGroupSummary,
      vibrationPattern:
          enableVibration ? Int64List.fromList([0, 1000, 500, 1000]) : null,
      enableLights: true,
      ledColor: const Color.fromARGB(255, 0, 255, 0),
      ticker: 'تطبيق طمأنينة',
      when: DateTime.now().millisecondsSinceEpoch,
      category: category ?? AndroidNotificationCategory.reminder,
      visibility: visibility ?? NotificationVisibility.public,
      styleInformation: bigTextStyle ?? bigPictureStyle ?? inboxStyle,
      showProgress: showProgress,
      maxProgress: maxProgress,
      progress: progress,
      indeterminate: indeterminate,
      ongoing: ongoing,
      autoCancel: autoCancel,
      showWhen: showWhen,
      enableVibration: enableVibration,
      // ledColor: const Color.fromARGB(255, 0, 255, 0),
      ledOnMs: 1000, // 1 ثانية تشغيل
      ledOffMs: 500, // نصف ثانية إطفاء
      additionalFlags: autoCancel
          ? null
          : Int32List.fromList(<int>[4]), // FLAG_INSISTENT for ongoing
    );

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      subtitle: 'تطبيق طمأنينة',
      threadIdentifier: 'islamic_app_notifications',
      categoryIdentifier: 'islamic_notifications',
      interruptionLevel: InterruptionLevel.active,
    );

    return NotificationDetails(android: android, iOS: ios);
  }

  // ================== Shared Core Notification Methods ==================

  /// Show an instant notification using unified ID management
  Future<bool> showNotificationWithKey({
    required String key,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
    String? largeIcon,
    String? groupKey,
    bool setAsGroupSummary = false,
    AndroidNotificationCategory? category,
    NotificationVisibility? visibility,
    List<AndroidNotificationAction>? actions,
  }) async {
    try {
      final id = NotificationIdManager.generateNotificationId(key);
      final details = await buildNotificationDetails(
        channel,
        largeIcon: largeIcon,
        groupKey: groupKey,
        setAsGroupSummary: setAsGroupSummary,
        category: category,
        visibility: visibility,
        actions: actions,
      );

      await plugin.show(id, title, body, details, payload: payload);
      return true;
    } catch (e) {
      logger.e('Error showing notification for key $key: $e');
      return false;
    }
  }

  /// Show an instant notification with direct ID
  Future<bool> showNotificationWithId({
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
    List<AndroidNotificationAction>? actions,
  }) async {
    try {
      final details = await buildNotificationDetails(
        channel,
        largeIcon: largeIcon,
        groupKey: groupKey,
        setAsGroupSummary: setAsGroupSummary,
        category: category,
        visibility: visibility,
        actions: actions,
      );

      await plugin.show(id, title, body, details, payload: payload);
      return true;
    } catch (e) {
      logger.e('Error showing notification with id $id: $e');
      return false;
    }
  }

  // ================== Shared Special Notification Methods ==================

  /// Show a big text notification
  Future<bool> showBigTextNotification({
    required String title,
    required String body,
    required String bigText,
    required NotificationChannel channel,
    String? key,
    int? id,
    String? payload,
    String? summaryText,
  }) async {
    try {
      assert(key != null || id != null, 'Either key or id must be provided');

      final notificationId =
          id ?? NotificationIdManager.generateNotificationId(key!);

      final bigTextStyleInformation = BigTextStyleInformation(
        bigText,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: summaryText ?? 'المزيد...',
        htmlFormatSummaryText: true,
      );

      final details = await buildNotificationDetails(
        channel,
        bigTextStyle: bigTextStyleInformation,
      );

      await plugin.show(notificationId, title, body, details, payload: payload);
      return true;
    } catch (e) {
      logger.e('Error showing big text notification: $e');
      return false;
    }
  }

  /// Show a progress notification
  Future<bool> showProgressNotification({
    required String title,
    required int progress,
    required int maxProgress,
    String? key,
    int? id,
    String? body,
    bool indeterminate = false,
    NotificationChannel channel = NotificationChannel.defaultChannel,
  }) async {
    try {
      assert(key != null || id != null, 'Either key or id must be provided');

      final notificationId =
          id ?? NotificationIdManager.generateNotificationId(key!);

      final details = await buildNotificationDetails(
        channel,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        indeterminate: indeterminate,
        ongoing: true,
        autoCancel: false,
        showWhen: false,
        enableVibration: false,
      );

      await plugin.show(
        notificationId,
        title,
        body ?? 'Progress: $progress/$maxProgress',
        details,
      );
      return true;
    } catch (e) {
      logger.e('Error showing progress notification: $e');
      return false;
    }
  }

  /// Show notification with image attachment
  Future<bool> showNotificationWithImage({
    required String title,
    required String body,
    required String imagePath,
    String? key,
    int? id,
    NotificationChannel channel = NotificationChannel.defaultChannel,
    String? payload,
  }) async {
    try {
      assert(key != null || id != null, 'Either key or id must be provided');

      final notificationId =
          id ?? NotificationIdManager.generateNotificationId(key!);

      final bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );

      final details = await buildNotificationDetails(
        channel,
        bigPictureStyle: bigPictureStyleInformation,
      );

      await plugin.show(notificationId, title, body, details, payload: payload);
      return true;
    } catch (e) {
      logger.e('Error showing notification with image: $e');
      return false;
    }
  }

  /// Show grouped notifications
  Future<bool> showGroupedNotifications({
    required String groupKey,
    required String groupTitle,
    required List<Map<String, dynamic>> notifications,
    NotificationChannel channel = NotificationChannel.defaultChannel,
  }) async {
    try {
      // Show individual notifications
      for (var i = 0; i < notifications.length; i++) {
        final notification = notifications[i];
        await showNotificationWithId(
          id: (groupKey.hashCode + i).abs(),
          title: notification['title'] as String,
          body: notification['body'] as String,
          channel: channel,
          payload: notification['payload'] as String?,
          groupKey: groupKey,
        );
      }

      // Show summary notification for Android
      if (Platform.isAndroid && notifications.length > 1) {
        final lines =
            notifications.map((n) => '${n['title']}: ${n['body']}').toList();

        final inboxStyleInformation = InboxStyleInformation(
          lines,
          contentTitle: groupTitle,
          summaryText: '${notifications.length} إشعارات',
        );

        final details = await buildNotificationDetails(
          channel,
          inboxStyle: inboxStyleInformation,
          groupKey: groupKey,
          setAsGroupSummary: true,
        );

        await plugin.show(
          groupKey.hashCode.abs(),
          groupTitle,
          '${notifications.length} إشعارات جديدة',
          details,
        );
      }

      return true;
    } catch (e) {
      logger.e('Error showing grouped notifications: $e');
      return false;
    }
  }

  // ================== Shared Cancellation Methods ==================

  /// Cancel notification by key
  Future<void> cancelNotificationByKey(String key, {int? range}) async {
    try {
      final id = NotificationIdManager.getNotificationId(key);
      if (id != null) {
        await cancelNotificationById(id: id, range: range);
      }
    } catch (e) {
      logger.e('Error canceling notification by key $key: $e');
    }
  }

  /// Cancel notification by ID, or cancel a range (for repeated notifications)
  Future<void> cancelNotificationById({required int id, int? range}) async {
    try {
      if (range != null) {
        for (var i = 0; i < range; i++) {
          await plugin.cancel(id + i);
        }
      } else {
        await plugin.cancel(id);
      }
    } catch (e) {
      logger.e('Error canceling notification by id $id: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    try {
      await plugin.cancelAll();
    } catch (e) {
      logger.e('Error canceling all notifications: $e');
    }
  }

  /// Cancel notifications for a specific key pattern
  Future<void> cancelAllForKey(String notifKey, {int count = 50}) async {
    try {
      final baseId = NotificationIdManager.getNotificationId(notifKey);
      if (baseId != null) {
        for (var i = 0; i < count; i++) {
          await plugin.cancel(baseId + i);
        }
      }
    } catch (e) {
      logger.e('Error canceling notifications for key $notifKey: $e');
    }
  }

  // ================== Shared Query Methods ==================

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await plugin.pendingNotificationRequests();
    } catch (e) {
      logger.e('Error getting pending notifications: $e');
      return [];
    }
  }

  /// Get active notifications (Android 6.0+, iOS 10.0+, macOS 10.14+)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      return await plugin.getActiveNotifications();
    } catch (e) {
      logger.e('Error getting active notifications: $e');
      return [];
    }
  }
}
