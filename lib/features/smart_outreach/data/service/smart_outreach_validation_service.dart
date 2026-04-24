import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';

class SmartOutreachValidationService {
  SmartOutreachValidationResult validateScheduleDraft({
    required String title,
    required List<SmartOutreachContactDraft> contacts,
    required bool isEnabled,
    required bool isDaily,
    required List<int> scheduleDays,
  }) {
    final errors = <String>[];

    if (title.trim().isEmpty) {
      errors.add('اكتب اسمًا للقائمة.');
    }

    if (contacts.isEmpty) {
      errors.add('أضف رقمًا واحدًا على الأقل.');
    }

    final normalizedNumbers = <String>{};
    for (final contact in contacts) {
      final phone = contact.phone.trim();
      if (phone.isEmpty) {
        errors.add('كل خانة يجب أن تحتوي على رقم هاتف.');
        continue;
      }

      if (phone.length < 7) {
        errors.add('يوجد رقم غير مكتمل.');
      }

      final normalized = phone.replaceAll(RegExp('[^0-9+]'), '');
      if (!normalizedNumbers.add(normalized)) {
        errors.add('يوجد رقم مكرر في نفس القائمة.');
      }
    }

    if (!isDaily && scheduleDays.isEmpty) {
      errors.add('اختر يومًا واحدًا على الأقل.');
    }

    if (isEnabled && contacts.isEmpty) {
      errors.add('لا يمكن تشغيل قائمة بدون أرقام.');
    }

    if (errors.isEmpty) {
      return SmartOutreachValidationResult.valid();
    }

    return SmartOutreachValidationResult.invalid(errors);
  }

  SmartOutreachValidationResult validateContactModels(
    String title,
    List<SmartOutreachContactModel> contacts,
    bool isEnabled,
  ) {
    return validateScheduleDraft(
      title: title,
      contacts: contacts
          .map(SmartOutreachContactDraft.fromModel)
          .toList(growable: false),
      isEnabled: isEnabled,
      isDaily: true,
      scheduleDays: const <int>[],
    );
  }
}
