class NotificationSettingModel {
  NotificationSettingModel({
    required this.key,
    required this.value,
    this.id,
    this.label,
    this.updatedAt,
    this.time,
  });

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingModel(
      id: json['id'] as int?,
      key: json['key'] as String,
      value: json['value'] == 1,
      label: json['label'] as String?,
      updatedAt: json['updated_at'] as String?,
      time: json['time'] as String?,
    );
  }
  final int? id;
  final String key;
  final bool value;
  final String? label;
  final String? updatedAt;
  final String? time;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'value': value ? 1 : 0,
      'label': label,
      'updated_at': DateTime.now().toIso8601String(),
      'time': time,
    };
  }
}
