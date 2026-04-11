import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_result_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_session_model.dart';

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

class SmartOutreachSessionBundle {
  const SmartOutreachSessionBundle({
    required this.scheduleBundle,
    required this.session,
    required this.results,
  });

  final SmartOutreachScheduleBundle scheduleBundle;
  final SmartOutreachSessionModel session;
  final List<SmartOutreachContactResultModel> results;

  Map<int, List<SmartOutreachContactResultType>> get resultTypesByContact {
    final grouped = <int, List<SmartOutreachContactResultType>>{};
    for (final result in results) {
      grouped.putIfAbsent(
          result.contactId, () => <SmartOutreachContactResultType>[]);
      grouped[result.contactId]!.add(result.resultType);
    }
    return grouped;
  }

  bool isContactCompleted(SmartOutreachContactModel contact) {
    final resultTypes = resultTypesByContact[contact.id] ?? const [];

    if (resultTypes.contains(SmartOutreachContactResultType.skipped) ||
        resultTypes.contains(SmartOutreachContactResultType.answered) ||
        resultTypes.contains(SmartOutreachContactResultType.smsSent)) {
      return true;
    }

    if (contact.actionType == SmartOutreachActionType.callOnly &&
        resultTypes.contains(SmartOutreachContactResultType.notAnswered)) {
      return true;
    }

    return false;
  }

  int get completedCount =>
      scheduleBundle.contacts.where(isContactCompleted).length;

  bool get isFullyCompleted => completedCount >= scheduleBundle.contacts.length;

  SmartOutreachContactModel? get currentContact {
    if (scheduleBundle.contacts.isEmpty) {
      return null;
    }

    final safeIndex =
        session.currentIndex.clamp(0, scheduleBundle.contacts.length - 1);
    return scheduleBundle.contacts[safeIndex];
  }

  int firstIncompleteIndex() {
    for (var i = 0; i < scheduleBundle.contacts.length; i++) {
      if (!isContactCompleted(scheduleBundle.contacts[i])) {
        return i;
      }
    }
    return scheduleBundle.contacts.isEmpty
        ? 0
        : scheduleBundle.contacts.length - 1;
  }

  SmartOutreachSessionBundle copyWith({
    SmartOutreachScheduleBundle? scheduleBundle,
    SmartOutreachSessionModel? session,
    List<SmartOutreachContactResultModel>? results,
  }) {
    return SmartOutreachSessionBundle(
      scheduleBundle: scheduleBundle ?? this.scheduleBundle,
      session: session ?? this.session,
      results: results ?? this.results,
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
