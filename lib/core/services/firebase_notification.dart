import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/firebase_options.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  // Notification channel constants
  static const String _highImportanceChannelId = 'high_importance_channel';
  static const String _defaultChannelId = 'default_channel';
  static const String _chatChannelId = 'chat_channel';
  static const String _orderChannelId = 'order_channel';

  static const String _highImportanceChannelName =
      'High Importance Notifications';
  static const String _defaultChannelName = 'Default Notifications';
  static const String _chatChannelName = 'Chat Notifications';
  static const String _orderChannelName = 'Order Notifications';

  // Notification action IDs
  static const String _actionReply = 'reply';
  static const String _actionView = 'view';
  static const String _actionDismiss = 'dismiss';

  Future<void> initialize() async {
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        debugPrint(
          'Warning: Firebase not initialized. Initializing now...',
        );
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Request permission first
      await _requestPermission();

      // Setup local notifications
      await setupFlutterNotifications();

      // Setup message handlers for foreground and app state changes
      await _setupMessageHandlers();

      // Get and log FCM token
      await getFCMToken();

      // Clear app badge on startup
      await _clearAppBadge();

      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  Future<NotificationSettings> _requestPermission() async {
    try {
      // Request FCM permissions
      final settings = await _messaging.requestPermission();

      debugPrint('FCM Permission status: ${settings.authorizationStatus}');

      // For iOS, request local notification permission
      if (Platform.isIOS) {
        final granted = await _localNotifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        debugPrint('iOS local notification permission granted: $granted');
      }

      // For Android 13+, request notification permission
      if (Platform.isAndroid) {
        final granted = await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        debugPrint('Android notification permission granted: $granted');
      }

      return settings;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      rethrow;
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    try {
      // Create multiple notification channels for Android
      await _createNotificationChannels();

      // Android initialization settings
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      // Combined initialization settings
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
      );

      // Initialize the plugin
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      _isFlutterLocalNotificationsInitialized = true;
      debugPrint('Flutter local notifications initialized successfully');
    } catch (e) {
      debugPrint('Error setting up flutter notifications: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        // High importance channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _highImportanceChannelId,
            _highImportanceChannelName,
            description:
                'This channel is used for high importance notifications.',
            importance: Importance.high,
            enableLights: true,
          ),
        );

        // Default channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _defaultChannelId,
            _defaultChannelName,
            description: 'This channel is used for general notifications.',
            enableLights: true,
          ),
        );

        // Chat channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _chatChannelId,
            _chatChannelName,
            description: 'This channel is used for chat notifications.',
            importance: Importance.high,
            enableLights: true,
          ),
        );

        // Order channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _orderChannelId,
            _orderChannelName,
            description: 'This channel is used for order notifications.',
            importance: Importance.high,
            enableLights: true,
          ),
        );

        debugPrint('Android notification channels created');
      }
    }
  }

  // Callback for notification taps
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    debugPrint('Action ID: ${response.actionId}');

    // Handle notification tap here
    _handleNotificationTap(response.payload, response.actionId);
  }

  static void _handleNotificationTap(String? payload, String? actionId) {
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        debugPrint('Handling notification tap with payload: $data');
        debugPrint('Action ID: $actionId');

        // Handle different actions
        switch (actionId) {
          case _actionReply:
            debugPrint('User chose to reply');
          case _actionView:
            debugPrint('User chose to view');
          case _actionDismiss:
            debugPrint('User chose to dismiss');
          default:
            debugPrint('User tapped notification (no specific action)');
        }

        // Handle navigation based on type
        final type = data['type'] as String?;
        final route = data['route'] as String?;
        final id = data['id'] as String?;

        debugPrint('Navigation data - Type: $type, Route: $route, ID: $id');

        // TODO: Implement navigation logic
        // NavigationService.instance.navigateTo(route, arguments: {'id': id});
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;

      if (notification != null) {
        // Determine the channel based on message type
        final channelId = _getChannelId(message.data['type'] as String?);
        final channelName = _getChannelName(message.data['type'] as String?);
        final importance = _getImportance(message.data['type'] as String?);

        // Create notification actions
        final androidActions = <AndroidNotificationAction>[
          const AndroidNotificationAction(
            _actionView,
            'View',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
          const AndroidNotificationAction(
            _actionDismiss,
            'Dismiss',
          ),
        ];

        // Create notification details
        final androidNotificationDetails = AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription:
              _getChannelDescription(message.data['type'] as String?),
          importance: importance,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          enableLights: true,
          actions: androidActions,
          groupKey: message.data['type'] as String? ?? 'default',
          when: DateTime.now().millisecondsSinceEpoch,
          color: const Color.fromARGB(255, 33, 150, 243),
          colorized: true,
        );

        const iosNotificationDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
          subtitle: 'New notification',
          threadIdentifier: 'notification_thread',
          categoryIdentifier: 'general',
          interruptionLevel: InterruptionLevel.active,
        );

        final notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
          macOS: iosNotificationDetails,
        );

        // Prepare payload
        final payload = <String, dynamic>{
          ...message.data,
          'title': notification.title,
          'body': notification.body,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Show the notification
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
          payload: jsonEncode(payload),
        );

        debugPrint('Notification shown: ${notification.title}');
      }
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  String _getChannelId(String? type) {
    switch (type) {
      case 'chat':
        return _chatChannelId;
      case 'order':
        return _orderChannelId;
      case 'high_importance':
        return _highImportanceChannelId;
      default:
        return _defaultChannelId;
    }
  }

  String _getChannelName(String? type) {
    switch (type) {
      case 'chat':
        return _chatChannelName;
      case 'order':
        return _orderChannelName;
      case 'high_importance':
        return _highImportanceChannelName;
      default:
        return _defaultChannelName;
    }
  }

  String _getChannelDescription(String? type) {
    switch (type) {
      case 'chat':
        return 'Notifications for chat messages';
      case 'order':
        return 'Notifications for order updates';
      case 'high_importance':
        return 'High importance notifications';
      default:
        return 'General notifications';
    }
  }

  Importance _getImportance(String? type) {
    switch (type) {
      case 'high_importance':
      case 'chat':
      case 'order':
        return Importance.high;
      default:
        return Importance.defaultImportance;
    }
  }

  Future<void> _setupMessageHandlers() async {
    try {
      // Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
            'Message also contained a notification: ${message.notification}',
          );
          showNotification(message);
        }
      });

      // Background message handler (app is in background but not terminated)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('A new onMessageOpenedApp event was published!');
        _handleBackgroundMessage(message);
      });

      // Terminated app handler
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('App was opened from a terminated state by a notification');
        _handleBackgroundMessage(initialMessage);
      }

      debugPrint('Message handlers setup successfully');
    } catch (e) {
      debugPrint('Error setting up message handlers: $e');
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    try {
      debugPrint('Handling background message: ${message.data}');

      // Handle different notification types
      final type = message.data['type'] as String?;
      final route = message.data['route'] as String?;
      final id = message.data['id'] as String?;

      switch (type) {
        case 'chat':
          debugPrint('Navigating to chat screen');
        case 'order':
          debugPrint('Navigating to order screen');
        case 'general':
          debugPrint('Navigating to general notification screen');
        default:
          debugPrint('Unknown notification type: $type');
      }

      // TODO: Implement navigation logic
      // NavigationService.instance.navigateTo(route, arguments: {'id': id});
    } catch (e) {
      debugPrint('Error handling background message: $e');
    }
  }

  Future<String?> getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((String token) {
        debugPrint('FCM Token refreshed: $token');
        // TODO: Send token to your server here
        // ApiService.instance.updateFCMToken(token);
      });

      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  // Clear app badge
  Future<void> _clearAppBadge() async {
    try {
      if (Platform.isIOS) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(badge: true);
      }
    } catch (e) {
      debugPrint('Error clearing app badge: $e');
    }
  }

  // Get notification settings
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final enabled = await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled();
        return enabled ?? false;
      }

      if (Platform.isIOS) {
        final enabled = await _localNotifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions();
        return enabled ?? false;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking notification settings: $e');
      return false;
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      debugPrint('Notification $id cancelled');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      debugPrint('All notifications cancelled');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  // Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      if (Platform.isAndroid) {
        final notifications = await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications();
        return notifications ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Error getting active notifications: $e');
      return [];
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  // Get notification permission status
  Future<AuthorizationStatus> getNotificationPermissionStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus;
    } catch (e) {
      debugPrint('Error getting notification permission status: $e');
      return AuthorizationStatus.notDetermined;
    }
  }

  // Check if notifications are properly configured
  Future<bool> isProperlyConfigured() async {
    try {
      final permissionStatus = await getNotificationPermissionStatus();
      final localNotificationsEnabled = await areNotificationsEnabled();

      return permissionStatus == AuthorizationStatus.authorized &&
          localNotificationsEnabled &&
          _isFlutterLocalNotificationsInitialized;
    } catch (e) {
      debugPrint('Error checking configuration: $e');
      return false;
    }
  }
}
