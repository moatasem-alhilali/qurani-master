class SmartOutreachScheduleModel {
  const SmartOutreachScheduleModel({
    this.id,
    required this.title,
    this.note,
    required this.hour,
    required this.minute,
    required this.isEnabled,
    this.smsTemplate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SmartOutreachScheduleModel.fromMap(Map<String, dynamic> map) {
    return SmartOutreachScheduleModel(
      id: map['id'] as int?,
      title: (map['title'] as String? ?? '').trim(),
      note: (map['note'] as String?)?.trim(),
      hour: (map['daily_hour'] as num?)?.toInt() ?? 9,
      minute: (map['daily_minute'] as num?)?.toInt() ?? 0,
      isEnabled: ((map['is_enabled'] as num?)?.toInt() ?? 0) == 1,
      smsTemplate: (map['sms_template'] as String?)?.trim(),
      createdAt: DateTime.tryParse((map['created_at'] as String?) ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((map['updated_at'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  final int? id;
  final String title;
  final String? note;
  final int hour;
  final int minute;
  final bool isEnabled;
  final String? smsTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;

  SmartOutreachScheduleModel copyWith({
    int? id,
    String? title,
    String? note,
    int? hour,
    int? minute,
    bool? isEnabled,
    String? smsTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SmartOutreachScheduleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
      smsTemplate: smsTemplate ?? this.smsTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title.trim(),
      'note': note?.trim(),
      'daily_hour': hour,
      'daily_minute': minute,
      'is_enabled': isEnabled ? 1 : 0,
      'sms_template': smsTemplate?.trim(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
