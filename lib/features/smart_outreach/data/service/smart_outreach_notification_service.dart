import 'dart:convert';

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

  static const String payloadType = 'smart_outreach';

  int notificationIdForSchedule(int scheduleId) {
    return NotificationIdManager.generateNotificationId(
      '${payloadType}_$scheduleId',
    );
  }

  String buildPayload(int scheduleId) {
    return jsonEncode({
      'type': payloadType,
      'scheduleId': scheduleId,
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

    final title = 'ابدأ ${schedule.title}';
    final body = 'اضغط لبدء تنفيذ جدول التواصل الآن.';

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
    );
  }

  Future<void> cancelForSchedule(int scheduleId) {
    return _notificationService.cancelNotificationById(
      id: notificationIdForSchedule(scheduleId),
    );
  }
}
