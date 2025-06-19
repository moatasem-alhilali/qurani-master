/// Types of schedule supported for notifications
enum ScheduleType {
  daily, // Every day at a fixed time
  hourly, // Every hour at minute X
  everyNMinutes, // Every N minutes
  weekly, // On specific days of the week at a fixed time
  customDates, // On specific date-times (list)
}

/// The unified model to describe how a notification is scheduled.
/// You can store instances of this model in your DB or preferences for flexibility.
class NotificationScheduleModel {
  NotificationScheduleModel({
    required this.type,
    this.hour,
    this.minute,
    this.intervalMinutes,
    this.weekdays,
    this.customDates,
  });

  /// Factory for daily schedule (e.g. every day at 7:00)
  factory NotificationScheduleModel.daily({
    required int hour,
    required int minute,
  }) {
    return NotificationScheduleModel(
      type: ScheduleType.daily,
      hour: hour,
      minute: minute,
    );
  }

  /// Factory for hourly schedule (every hour at minute X)
  factory NotificationScheduleModel.hourly({required int minute}) {
    return NotificationScheduleModel(
      type: ScheduleType.hourly,
      minute: minute,
    );
  }

  /// Factory for every N minutes
  factory NotificationScheduleModel.everyNMinutes({
    required int intervalMinutes,
  }) {
    return NotificationScheduleModel(
      type: ScheduleType.everyNMinutes,
      intervalMinutes: intervalMinutes,
    );
  }

  /// Factory for weekly schedule (e.g. every Monday and Thursday at 7:30)
  factory NotificationScheduleModel.weekly({
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) {
    return NotificationScheduleModel(
      type: ScheduleType.weekly,
      hour: hour,
      minute: minute,
      weekdays: weekdays,
    );
  }

  /// Factory for specific custom dates
  factory NotificationScheduleModel.customDates(List<DateTime> dates) {
    return NotificationScheduleModel(
      type: ScheduleType.customDates,
      customDates: dates,
    );
  }

  /// Example: create model from Map (after loading from DB)
  factory NotificationScheduleModel.fromMap(Map<String, dynamic> map) {
    final type = ScheduleType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => ScheduleType.daily,
    );
    return NotificationScheduleModel(
      type: type,
      hour: map['hour'] as int?,
      minute: map['minute'] as int?,
      intervalMinutes: map['intervalMinutes'] as int?,
      weekdays: (map['weekdays'] as List<dynamic>?)?.cast<int>(),
      customDates: (map['customDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
    );
  }

  /// The type of schedule (see ScheduleType above)
  final ScheduleType type;

  /// For daily/weekly schedules: hour (0..23)
  final int? hour;

  /// For daily/weekly schedules: minute (0..59)
  final int? minute;

  /// For everyNMinutes schedule: how many minutes between each notification
  final int? intervalMinutes;

  /// For weekly schedule: list of weekdays (DateTime.monday, ..., DateTime.sunday)
  final List<int>? weekdays;

  /// For customDates: list of DateTime objects for each specific notification time
  final List<DateTime>? customDates;

  // You can add toJson/fromJson if you want to persist it as JSON string.

  /// Example: convert model to Map (for storing in DB as JSON)
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'hour': hour,
      'minute': minute,
      'intervalMinutes': intervalMinutes,
      'weekdays': weekdays,
      'customDates': customDates?.map((d) => d.toIso8601String()).toList(),
    };
  }
}
