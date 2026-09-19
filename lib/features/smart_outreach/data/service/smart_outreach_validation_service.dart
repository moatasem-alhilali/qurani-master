import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/l10n/l10n.dart';

class SmartOutreachValidationService {
  SmartOutreachValidationResult validateScheduleDraft({
    required String title,
    required List<SmartOutreachContactDraft> contacts,
    required bool isEnabled,
    required bool isDaily,
    required List<int> scheduleDays,
  }) {
    final l10n = L10nService.current;
    final errors = <String>[];

    if (title.trim().isEmpty) {
      errors.add(l10n.outreachValidationTitleRequired);
    }

    if (contacts.isEmpty) {
      errors.add(l10n.outreachValidationAddNumber);
    }

    final normalizedNumbers = <String>{};
    for (final contact in contacts) {
      final phone = contact.phone.trim();
      if (phone.isEmpty) {
        errors.add(l10n.outreachValidationEmptyPhone);
        continue;
      }

      if (phone.length < 7) {
        errors.add(l10n.outreachValidationIncompleteNumber);
      }

      final normalized = phone.replaceAll(RegExp('[^0-9+]'), '');
      if (!normalizedNumbers.add(normalized)) {
        errors.add(l10n.outreachValidationDuplicateNumber);
      }
    }

    if (!isDaily && scheduleDays.isEmpty) {
      errors.add(l10n.outreachValidationPickDay);
    }

    if (isEnabled && contacts.isEmpty) {
      errors.add(l10n.outreachValidationEnableWithoutNumbers);
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
