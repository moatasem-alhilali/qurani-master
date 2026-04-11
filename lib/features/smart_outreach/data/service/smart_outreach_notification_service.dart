import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';

class SmartOutreachNotificationService {
  SmartOutreachNotificationService({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;
  bool _fullScreenIntentPermissionGranted = false;
  bool _fullScreenIntentPermissionChecked = false;
  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/smart_outreach',
  );

  static const String payloadType = 'smart_outreach';

  int notificationIdForSchedule(int scheduleId) {
    return NotificationIdManager.generateNotificationId(
      '${payloadType}_$scheduleId',
    );
  }

  int notificationIdForPreview(int scheduleId) {
    return NotificationIdManager.generateNotificationId(
      '${payloadType}_preview_$scheduleId',
    );
  }

  String buildPayload(int scheduleId) {
    return jsonEncode({
      'type': payloadType,
      'scheduleId': scheduleId,
    });
  }

  String buildPayloadWithTrigger({
    required int scheduleId,
    required DateTime triggerAt,
  }) {
    return jsonEncode({
      'type': payloadType,
      'scheduleId': scheduleId,
      'triggerAt': triggerAt.toIso8601String(),
    });
  }

  int? extractScheduleId(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final type = (decoded['type'] as String?)?.trim();
      if (type != payloadType) {
        return null;
      }
      return (decoded['scheduleId'] as num?)?.toInt();
    } catch (_) {
      if (payload.startsWith('$payloadType:')) {
        return int.tryParse(payload.split(':').last.trim());
      }
      return null;
    }
  }

  bool isSmartOutreachPayload(String? payload) {
    return extractScheduleId(payload) != null;
  }

  Future<bool> scheduleDailyFor(SmartOutreachScheduleModel schedule) async {
    final scheduleId = schedule.id;
    if (scheduleId == null) {
      return false;
    }

    await _requestFullScreenIntentPermissionIfNeeded(forceRetry: true);

    final title = 'ابدأ ${schedule.title}';
    final body = 'اضغط "ابدأ المهمة" وابدأ التواصل بخطوات سريعة.';

    if (Platform.isAndroid) {
      final requestCode = notificationIdForSchedule(scheduleId);
      await _notificationService.cancelNotificationById(id: requestCode);
      return _scheduleAndroidDailyAlarm(
        requestCode: requestCode,
        scheduleId: scheduleId,
        hour: schedule.hour,
        minute: schedule.minute,
        title: title,
        body: body,
      );
    }

    return _notificationService.scheduleNotificationCompatType(
      id: notificationIdForSchedule(scheduleId),
      title: title,
      body: body,
      channel: NotificationChannel.smartOutreach,
      schedule: NotificationScheduleModel.daily(
        hour: schedule.hour,
        minute: schedule.minute,
      ),
      payload: buildPayload(scheduleId),
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: true,
      channelBypassDnd: true,
    );
  }

  Future<void> cancelForSchedule(int scheduleId) async {
    final scheduleNotificationId = notificationIdForSchedule(scheduleId);
    final previewNotificationId = notificationIdForPreview(scheduleId);

    if (Platform.isAndroid) {
      await _cancelAndroidAlarm(scheduleNotificationId);
      await _cancelAndroidAlarm(previewNotificationId);
    }

    await _notificationService.cancelNotificationById(
        id: scheduleNotificationId);
    await _notificationService.cancelNotificationById(
        id: previewNotificationId);
  }

  Future<bool> schedulePreviewInFiveSeconds(
    SmartOutreachScheduleModel schedule,
  ) async {
    return scheduleAlertAfterDelay(
      schedule: schedule,
      delay: const Duration(seconds: 5),
      titlePrefix: 'تجربة إشعار',
      body: 'بعد لحظات سيظهر لك تنبيه المهمة بواجهة كاملة.',
    );
  }

  Future<bool> scheduleSnoozeInFiveMinutes(
    SmartOutreachScheduleModel schedule,
  ) async {
    return scheduleAlertAfterDelay(
      schedule: schedule,
      delay: const Duration(minutes: 5),
      titlePrefix: 'تذكير المهمة',
      body: 'انتهت مدة التأجيل. ابدأ مهمة التواصل الآن.',
    );
  }

  Future<bool> scheduleAlertAfterDelay({
    required SmartOutreachScheduleModel schedule,
    required Duration delay,
    required String titlePrefix,
    required String body,
  }) async {
    final scheduleId = schedule.id;
    if (scheduleId == null) {
      return false;
    }

    await _requestFullScreenIntentPermissionIfNeeded(forceRetry: true);

    final previewId = notificationIdForPreview(scheduleId);
    await _notificationService.cancelNotificationById(id: previewId);

    final fireAt = DateTime.now().add(delay);

    if (Platform.isAndroid) {
      await _cancelAndroidAlarm(previewId);
      return _scheduleAndroidOneShotAlarm(
        requestCode: previewId,
        scheduleId: scheduleId,
        triggerAt: fireAt,
        title: '$titlePrefix ${schedule.title}',
        body: body,
      );
    }

    return _notificationService.scheduleNotificationCompatType(
      id: previewId,
      title: '$titlePrefix ${schedule.title}',
      body: body,
      channel: NotificationChannel.smartOutreach,
      schedule: NotificationScheduleModel.customDates(<DateTime>[fireAt]),
      payload: buildPayloadWithTrigger(
        scheduleId: scheduleId,
        triggerAt: fireAt,
      ),
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      ongoing: false,
      autoCancel: true,
      channelBypassDnd: true,
    );
  }

  Future<bool> canUseFullScreenIntent() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      final allowed =
          await _channel.invokeMethod<bool>('canUseFullScreenIntent');
      return allowed ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> openFullScreenIntentSettings() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final opened =
          await _channel.invokeMethod<bool>('openFullScreenIntentSettings');
      return opened ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<int?> consumePendingScheduleIdFromNativeAlarm() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      return await _channel.invokeMethod<int>(
        'consumePendingSmartOutreachScheduleId',
      );
    } on PlatformException {
      return null;
    }
  }

  Future<void> _requestFullScreenIntentPermissionIfNeeded({
    bool forceRetry = false,
  }) async {
    if (!Platform.isAndroid || _fullScreenIntentPermissionGranted) {
      return;
    }
    if (_fullScreenIntentPermissionChecked && !forceRetry) {
      return;
    }
    _fullScreenIntentPermissionChecked = true;

    try {
      final androidPlugin = _notificationService.plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestFullScreenIntentPermission();
      if (granted == true) {
        _fullScreenIntentPermissionGranted = true;
        return;
      }

      _fullScreenIntentPermissionGranted = await canUseFullScreenIntent();
    } catch (_) {}
  }

  Future<bool> _scheduleAndroidDailyAlarm({
    required int requestCode,
    required int scheduleId,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      final scheduled =
          await _channel.invokeMethod<bool>('scheduleSmartOutreachDailyAlarm', {
        'requestCode': requestCode,
        'scheduleId': scheduleId,
        'hour': hour,
        'minute': minute,
        'title': title,
        'body': body,
      });
      return scheduled ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> _scheduleAndroidOneShotAlarm({
    required int requestCode,
    required int scheduleId,
    required DateTime triggerAt,
    required String title,
    required String body,
  }) async {
    try {
      final scheduled = await _channel.invokeMethod<bool>(
        'scheduleSmartOutreachOneShotAlarm',
        {
          'requestCode': requestCode,
          'scheduleId': scheduleId,
          'triggerAtMillis': triggerAt.millisecondsSinceEpoch,
          'title': title,
          'body': body,
        },
      );
      return scheduled ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _cancelAndroidAlarm(int requestCode) async {
    try {
      await _channel.invokeMethod<bool>(
        'cancelSmartOutreachAlarm',
        {'requestCode': requestCode},
      );
    } on PlatformException {}
  }
}
