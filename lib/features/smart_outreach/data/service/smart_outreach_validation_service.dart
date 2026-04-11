import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';

class SmartOutreachValidationService {
  static const int maxContacts = 5;

  SmartOutreachValidationResult validateScheduleDraft({
    required String title,
    required List<SmartOutreachContactDraft> contacts,
    required bool isEnabled,
  }) {
    final errors = <String>[];

    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      errors.add('عنوان الجدول مطلوب.');
    }

    if (contacts.isEmpty) {
      errors.add('يجب إضافة جهة اتصال واحدة على الأقل.');
    }

    if (contacts.length > maxContacts) {
      errors.add('الحد الأقصى لجهات الاتصال هو $maxContacts.');
    }

    final normalizedSet = <String>{};

    for (var i = 0; i < contacts.length; i++) {
      final contact = contacts[i];
      final normalized = normalizePhone(contact.phone);
      final index = i + 1;

      if (normalized.isEmpty) {
        errors.add('رقم جهة الاتصال رقم $index مطلوب.');
        continue;
      }

      if (!isValidPhone(contact.phone)) {
        errors.add('رقم جهة الاتصال رقم $index غير صالح.');
        continue;
      }

      if (normalizedSet.contains(normalized)) {
        errors.add('لا يمكن تكرار نفس رقم الهاتف داخل نفس الجدول.');
      } else {
        normalizedSet.add(normalized);
      }
    }

    if (isEnabled && errors.isNotEmpty) {
      errors.add('لا يمكن تفعيل الجدول قبل حل الأخطاء.');
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
    final drafts = contacts
        .map(
          (contact) => SmartOutreachContactDraft(
            id: contact.id,
            name: contact.name,
            phone: contact.phone,
            actionType: contact.actionType,
            smsTemplate: contact.smsTemplate,
          ),
        )
        .toList();

    return validateScheduleDraft(
      title: title,
      contacts: drafts,
      isEnabled: isEnabled,
    );
  }

  bool isValidPhone(String input) {
    final normalized = normalizePhone(input);
    if (normalized.isEmpty) {
      return false;
    }

    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    return regex.hasMatch(normalized);
  }

  String normalizePhone(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    var cleaned = trimmed.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleaned.startsWith('+')) {
      cleaned = '+${cleaned.substring(1).replaceAll('+', '')}';
    } else {
      cleaned = cleaned.replaceAll('+', '');
    }

    return cleaned;
  }
}
