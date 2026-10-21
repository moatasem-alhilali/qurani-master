import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_phone_normalizer.dart';
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

      // Counts digits, not characters: `+966 50 123 4567` is 17 characters and
      // `٠٥٠١٢٣٤٥٦٧` is 10, and the old length check passed or failed on the
      // separators rather than the number.
      if (!SmartOutreachPhoneNormalizer.isPlausible(phone)) {
        errors.add(l10n.outreachValidationIncompleteNumber);
      }

      // +966501234567 and 00966501234567 are the same line.
      if (!normalizedNumbers.add(
        SmartOutreachPhoneNormalizer.comparisonKey(phone),
      )) {
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
