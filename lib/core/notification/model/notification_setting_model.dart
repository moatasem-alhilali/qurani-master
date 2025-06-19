import 'package:quran_app/core/notification/model/notification_schedule_model.dart';

class NotificationSettingModel {
  // schedule info

  NotificationSettingModel({
    required this.key,
    required this.label,
    required this.enabled,
    required this.schedule,
  });

  factory NotificationSettingModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingModel(
      key: map['key'] as String,
      label: map['label'] as String,
      enabled: map['enabled'] as bool,
      schedule: NotificationScheduleModel.fromMap(
          map['schedule'] as Map<String, dynamic>),
    );
  }
  final String key; // Example: 'isNotificationRandomThikr'
  final String label; // Example: 'Random Thikr'
  final bool enabled; // is notification enabled
  final NotificationScheduleModel schedule;

  // Save as Map for DB/Prefs
  Map<String, dynamic> toMap() => {
        'key': key,
        'label': label,
        'enabled': enabled,
        'schedule': schedule.toMap(),
      };
}
