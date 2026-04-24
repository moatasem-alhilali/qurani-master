import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';

class SmartOutreachScheduleBundle {
  const SmartOutreachScheduleBundle({
    required this.schedule,
    required this.contacts,
  });

  final SmartOutreachScheduleModel schedule;
  final List<SmartOutreachContactModel> contacts;

  SmartOutreachScheduleBundle copyWith({
    SmartOutreachScheduleModel? schedule,
    List<SmartOutreachContactModel>? contacts,
  }) {
    return SmartOutreachScheduleBundle(
      schedule: schedule ?? this.schedule,
      contacts: contacts ?? this.contacts,
    );
  }
}

class SmartOutreachValidationResult {
  const SmartOutreachValidationResult({
    required this.isValid,
    this.errors = const <String>[],
  });

  final bool isValid;
  final List<String> errors;

  factory SmartOutreachValidationResult.valid() {
    return const SmartOutreachValidationResult(isValid: true);
  }

  factory SmartOutreachValidationResult.invalid(List<String> errors) {
    return SmartOutreachValidationResult(isValid: false, errors: errors);
  }
}

class SmartOutreachContactDraft {
  const SmartOutreachContactDraft({
    this.id,
    this.name,
    this.phone = '',
    required this.actionType,
    this.smsTemplate,
  });

  final int? id;
  final String? name;
  final String phone;
  final SmartOutreachActionType actionType;
  final String? smsTemplate;

  SmartOutreachContactDraft copyWith({
    int? id,
    String? name,
    String? phone,
    SmartOutreachActionType? actionType,
    String? smsTemplate,
  }) {
    return SmartOutreachContactDraft(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      actionType: actionType ?? this.actionType,
      smsTemplate: smsTemplate ?? this.smsTemplate,
    );
  }

  SmartOutreachContactModel toModel({
    required int scheduleId,
    required int order,
  }) {
    return SmartOutreachContactModel(
      id: id,
      scheduleId: scheduleId,
      name: name?.trim().isEmpty == true ? null : name?.trim(),
      phone: phone.trim(),
      order: order,
      actionType: actionType,
      smsTemplate:
          smsTemplate?.trim().isEmpty == true ? null : smsTemplate?.trim(),
    );
  }

  factory SmartOutreachContactDraft.fromModel(SmartOutreachContactModel model) {
    return SmartOutreachContactDraft(
      id: model.id,
      name: model.name,
      phone: model.phone,
      actionType: model.actionType,
      smsTemplate: model.smsTemplate,
    );
  }
}
