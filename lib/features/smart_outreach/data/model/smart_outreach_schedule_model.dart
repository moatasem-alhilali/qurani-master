import 'dart:convert';

class SmartOutreachScheduleModel {
  const SmartOutreachScheduleModel({
    this.id,
    required this.title,
    this.note,
    required this.isEnabled,
    required this.scheduleTime,
    required this.scheduleDays,
    required this.isDaily,
    required this.ringTimeout,
    required this.hangupDelay,
    required this.retryEnabled,
    required this.delayBetweenCalls,
    required this.stopOnFirstAnswered,
    required this.repeatCycle,
    this.smsTemplate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SmartOutreachScheduleModel.fromMap(Map<String, dynamic> map) {
    final scheduleTime = (map['schedule_time'] as String? ?? '08:00').trim();
    return SmartOutreachScheduleModel(
      id: map['id'] as int?,
      title: (map['name'] as String? ?? '').trim(),
      note: (map['note'] as String?)?.trim(),
      isEnabled: ((map['is_enabled'] as num?)?.toInt() ?? 0) == 1,
      scheduleTime: scheduleTime,
      scheduleDays: _readDays(map['schedule_days']),
      isDaily: ((map['is_daily'] as num?)?.toInt() ?? 1) == 1,
      ringTimeout: (map['ring_timeout'] as num?)?.toInt() ?? 20,
      hangupDelay: (map['hangup_delay'] as num?)?.toInt() ?? 30,
      retryEnabled: ((map['retry_enabled'] as num?)?.toInt() ?? 0) == 1,
      delayBetweenCalls: (map['delay_between_calls'] as num?)?.toInt() ?? 3,
      stopOnFirstAnswered:
          ((map['stop_on_first_answered'] as num?)?.toInt() ?? 0) == 1,
      repeatCycle: ((map['repeat_cycle'] as num?)?.toInt() ?? 0) == 1,
      smsTemplate: (map['sms_template'] as String?)?.trim(),
      createdAt: DateTime.tryParse((map['created_at'] as String?) ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((map['updated_at'] as String?) ?? '') ??
          DateTime.tryParse((map['created_at'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  final int? id;
  final String title;
  final String? note;
  final bool isEnabled;
  final String scheduleTime;
  final List<int> scheduleDays;
  final bool isDaily;
  final int ringTimeout;
  final int hangupDelay;
  final bool retryEnabled;
  final int delayBetweenCalls;
  final bool stopOnFirstAnswered;
  final bool repeatCycle;
  final String? smsTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get hour => _timeParts.$1;
  int get minute => _timeParts.$2;

  (int, int) get _timeParts {
    final parts = scheduleTime.split(':');
    final parsedHour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 8 : 8;
    final parsedMinute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return (parsedHour.clamp(0, 23), parsedMinute.clamp(0, 59));
  }

  SmartOutreachScheduleModel copyWith({
    int? id,
    String? title,
    String? note,
    bool? isEnabled,
    String? scheduleTime,
    List<int>? scheduleDays,
    bool? isDaily,
    int? ringTimeout,
    int? hangupDelay,
    bool? retryEnabled,
    int? delayBetweenCalls,
    bool? stopOnFirstAnswered,
    bool? repeatCycle,
    String? smsTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SmartOutreachScheduleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      isEnabled: isEnabled ?? this.isEnabled,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      isDaily: isDaily ?? this.isDaily,
      ringTimeout: ringTimeout ?? this.ringTimeout,
      hangupDelay: hangupDelay ?? this.hangupDelay,
      retryEnabled: retryEnabled ?? this.retryEnabled,
      delayBetweenCalls: delayBetweenCalls ?? this.delayBetweenCalls,
      stopOnFirstAnswered: stopOnFirstAnswered ?? this.stopOnFirstAnswered,
      repeatCycle: repeatCycle ?? this.repeatCycle,
      smsTemplate: smsTemplate ?? this.smsTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': title.trim(),
      'is_enabled': isEnabled ? 1 : 0,
      'schedule_time': scheduleTime,
      'schedule_days': jsonEncode(scheduleDays),
      'is_daily': isDaily ? 1 : 0,
      'ring_timeout': ringTimeout,
      'hangup_delay': hangupDelay,
      'retry_enabled': retryEnabled ? 1 : 0,
      'delay_between_calls': delayBetweenCalls,
      'stop_on_first_answered': stopOnFirstAnswered ? 1 : 0,
      'repeat_cycle': repeatCycle ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static List<int> _readDays(Object? raw) {
    if (raw == null) {
      return const <int>[];
    }

    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) {
        return const <int>[];
      }

      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return decoded
              .map((item) => item is num ? item.toInt() : int.tryParse('$item'))
              .whereType<int>()
              .toList(growable: false);
        }
      } catch (_) {
        return const <int>[];
      }
    }

    if (raw is List) {
      return raw
          .map((item) => item is num ? item.toInt() : int.tryParse('$item'))
          .whereType<int>()
          .toList(growable: false);
    }

    return const <int>[];
  }
}
