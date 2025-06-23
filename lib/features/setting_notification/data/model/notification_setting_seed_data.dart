import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';

class NotificationSettingSeedData {
  NotificationSettingSeedData({
    required this.key,
    required this.label,
    required this.enabled,
    required this.scheduleType,
    this.hour,
    this.minute,
    this.intervalMinutes,
    this.weekdays,
    this.onlySetting = false,
    this.customDates,
  });
  final String key;
  final String label;
  final bool enabled;
  final ScheduleType scheduleType;
  final int? hour;
  final int? minute;
  final int? intervalMinutes;
  final bool onlySetting;
  final List<int>? weekdays;
  final List<DateTime>? customDates;

  NotificationSettingModel toSettingModel() {
    return NotificationSettingModel(
      key: key,
      label: label,
      enabled: enabled,
      scheduleType: scheduleType,
      hour: hour,
      minute: minute,
      intervalMinutes: intervalMinutes,
      weekdays: weekdays,
      customDates: customDates,
      onlySetting: onlySetting,
    );
  }
}
