import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';

class SmartOutreachContactModel {
  const SmartOutreachContactModel({
    this.id,
    required this.scheduleId,
    this.name,
    required this.phone,
    required this.order,
    required this.actionType,
    this.smsTemplate,
  });

  factory SmartOutreachContactModel.fromMap(Map<String, dynamic> map) {
    return SmartOutreachContactModel(
      id: map['id'] as int?,
      scheduleId: (map['schedule_id'] as num?)?.toInt() ??
          (map['group_id'] as num?)?.toInt() ??
          0,
      name: ((map['name'] ?? map['label']) as String?)?.trim(),
      phone: ((map['phone'] ?? map['number']) as String? ?? '').trim(),
      order: (map['contact_order'] as num?)?.toInt() ??
          (map['sort_order'] as num?)?.toInt() ??
          0,
      actionType: SmartOutreachActionTypeX.fromDbValue(
        (map['action_type'] as String? ?? 'call_only').trim(),
      ),
      smsTemplate: (map['sms_template'] as String?)?.trim(),
    );
  }

  final int? id;
  final int scheduleId;
  final String? name;
  final String phone;
  final int order;
  final SmartOutreachActionType actionType;
  final String? smsTemplate;

  SmartOutreachContactModel copyWith({
    int? id,
    int? scheduleId,
    String? name,
    String? phone,
    int? order,
    SmartOutreachActionType? actionType,
    String? smsTemplate,
  }) {
    return SmartOutreachContactModel(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      order: order ?? this.order,
      actionType: actionType ?? this.actionType,
      smsTemplate: smsTemplate ?? this.smsTemplate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'group_id': scheduleId,
      'label': name?.trim(),
      'number': phone.trim(),
      'sort_order': order,
    };
  }

  String get displayName {
    final safeName = (name ?? '').trim();
    if (safeName.isNotEmpty) {
      return safeName;
    }
    return phone;
  }
}
