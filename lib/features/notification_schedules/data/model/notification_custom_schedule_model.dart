import 'dart:convert';

import 'package:quran_app/core/notification/model/notification_schedule_model.dart';

class NotificationScheduleCustomModel {
  NotificationScheduleCustomModel({
    required this.notifKey,
    required this.enabled,
    required this.scheduleType,
    this.id,
    this.hour,
    this.minute,
    this.intervalMinutes,
    this.weekdays,
    this.customDates,
    this.label,
  });
  final int? id;
  final String notifKey;
  final bool enabled;
  final ScheduleType scheduleType;
  final int? hour;
  final int? minute;
  final int? intervalMinutes;
  final List<int>? weekdays;
  final List<DateTime>? customDates;
  final String? label;

  NotificationScheduleCustomModel copyWith({
    int? id,
    String? notifKey,
    bool? enabled,
    ScheduleType? scheduleType,
    int? hour,
    int? minute,
    int? intervalMinutes,
    List<int>? weekdays,
    List<DateTime>? customDates,
    String? label,
  }) {
    return NotificationScheduleCustomModel(
      id: id ?? this.id,
      notifKey: notifKey ?? this.notifKey,
      enabled: enabled ?? this.enabled,
      scheduleType: scheduleType ?? this.scheduleType,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      weekdays: weekdays ?? this.weekdays,
      customDates: customDates ?? this.customDates,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notif_key': notifKey,
      'enabled': enabled ? 1 : 0,
      'schedule_type': scheduleType.name,
      'hour': hour,
      'minute': minute,
      'interval_minutes': intervalMinutes,
      'weekdays': weekdays != null ? jsonEncode(weekdays) : null,
      'custom_dates': customDates != null
          ? jsonEncode(customDates!.map((d) => d.toIso8601String()).toList())
          : null,
      'label': label,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static NotificationScheduleCustomModel fromMap(Map<String, dynamic> map) {
    return NotificationScheduleCustomModel(
      id: map['id'] as int?,
      notifKey: map['notif_key'] as String,
      enabled: map['enabled'] == 1,
      scheduleType: ScheduleType.values.firstWhere(
        (e) => e.name == (map['schedule_type'] ?? 'daily'),
      ),
      hour: map['hour'] as int?,
      minute: map['minute'] as int?,
      intervalMinutes: map['interval_minutes'] as int?,
      weekdays: map['weekdays'] != null
          ? List<int>.from(jsonDecode(map['weekdays'] as String) as List<int>)
          : null,
      customDates: map['custom_dates'] != null
          ? (jsonDecode(map['custom_dates'] as String) as List<String>)
              .map(DateTime.parse)
              .toList() as List<DateTime>?
          : null,
      label: map['label'] as String?,
    );
  }
}

extension ScheduleModelMapper on NotificationScheduleCustomModel {
  NotificationScheduleModel toScheduleModel() {
    return NotificationScheduleModel(
      type: scheduleType,
      hour: hour,
      minute: minute,
      intervalMinutes: intervalMinutes,
      weekdays: weekdays,
      customDates: customDates,
    );
  }
}
