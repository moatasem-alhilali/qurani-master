import 'dart:convert';

import 'package:quran_app/core/notification/model/notification_schedule_model.dart';

class NotificationSettingModel {
  NotificationSettingModel({
    required this.key,
    required this.label,
    required this.enabled,
    required this.scheduleType,
    this.id,
    this.onlySetting = false,
    this.hour,
    this.minute,
    this.intervalMinutes,
    this.weekdays,
    this.customDates,
  });

  /// Converts a DB row (Map) to NotificationSettingModel instance
  factory NotificationSettingModel.fromMap(Map<String, dynamic> map) {
    // Decode weekdays/custom_dates from JSON text if present
    List<int>? parseWeekdays(String? s) {
      if (s == null || s.isEmpty) return null;
      final list = jsonDecode(s) as List;
      return list.map((e) => e as int).toList();
    }

    List<DateTime>? parseCustomDates(String? s) {
      if (s == null || s.isEmpty) return null;
      final list = jsonDecode(s) as List;
      return list.map((e) => DateTime.parse(e as String)).toList();
    }

    return NotificationSettingModel(
      id: map['id'] as int?,
      key: map['key'] as String,
      label: map['label'] as String,
      enabled: (map['value'] ?? 0) == 1,
      scheduleType: ScheduleType.values.firstWhere(
        (e) => e.name == map['schedule_type'],
        orElse: () => ScheduleType.daily,
      ),
      hour: map['hour'] as int?,
      minute: map['minute'] as int?,
      onlySetting: map['only_setting'] == 1,
      intervalMinutes: map['interval_minutes'] as int?,
      weekdays: parseWeekdays(map['weekdays'] as String?),
      customDates: parseCustomDates(map['custom_dates'] as String?),
    );
  }
  final int? id; // For DB autoincrement (optional)
  final String key; // e.g., 'isNotificationRandomThikr'
  final String label; // e.g., 'Random Thikr'
  final bool enabled; // is notification enabled
  final ScheduleType scheduleType;
  final int? hour;
  final int? minute;
  final bool onlySetting;
  final int? intervalMinutes;
  final List<int>? weekdays;
  final List<DateTime>? customDates;

  /// Converts the instance to a Map for inserting/updating in DB
  Map<String, dynamic> toMap() => {
        'id': id,
        'key': key,
        'label': label,
        'value': enabled ? 1 : 0,
        'only_setting': onlySetting ? 1 : 0,
        'schedule_type': scheduleType.name,
        'hour': hour,
        'minute': minute,
        'interval_minutes': intervalMinutes,
        'weekdays': weekdays == null ? null : jsonEncode(weekdays),
        'custom_dates': customDates == null
            ? null
            : jsonEncode(customDates!.map((d) => d.toIso8601String()).toList()),
        'updated_at': DateTime.now().toIso8601String(),
      };


  /// Converts back to NotificationScheduleModel (to use with scheduling service)
  NotificationScheduleModel get schedule {
    switch (scheduleType) {
      case ScheduleType.daily:
        return NotificationScheduleModel.daily(hour: hour!, minute: minute!);
      case ScheduleType.hourly:
        return NotificationScheduleModel.hourly(minute: minute!);
      case ScheduleType.everyNMinutes:
        return NotificationScheduleModel.everyNMinutes(
          intervalMinutes: intervalMinutes!,
        );
      case ScheduleType.weekly:
        return NotificationScheduleModel.weekly(
          hour: hour!,
          minute: minute!,
          weekdays: weekdays ?? [],
        );
      case ScheduleType.customDates:
        return NotificationScheduleModel.customDates(customDates ?? []);
    }
  }

  NotificationSettingModel copyWith({
    int? id,
    String? key,
    String? label,
    bool? enabled,
    ScheduleType? scheduleType,
    int? hour,
    int? minute,
    int? intervalMinutes,
    List<int>? weekdays,
    List<DateTime>? customDates,
    bool? onlySetting,
  }) {
    return NotificationSettingModel(
      id: id ?? this.id,
      key: key ?? this.key,
      label: label ?? this.label,
      onlySetting: onlySetting ?? this.onlySetting,
      enabled: enabled ?? this.enabled,
      scheduleType: scheduleType ?? this.scheduleType,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      weekdays: weekdays ?? this.weekdays,
      customDates: customDates ?? this.customDates,
    );
  }
}
