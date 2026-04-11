import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contact_form_row.dart';

class SmartOutreachContactsFormManager {
  SmartOutreachContactsFormManager._(this.rows);

  factory SmartOutreachContactsFormManager.fromInitial(
    List<SmartOutreachContactModel> contacts,
  ) {
    if (contacts.isEmpty) {
      return SmartOutreachContactsFormManager._(
        <SmartOutreachContactFormRow>[SmartOutreachContactFormRow.empty()],
      );
    }

    return SmartOutreachContactsFormManager._(
      contacts
          .map(SmartOutreachContactFormRow.fromContact)
          .toList(growable: true),
    );
  }

  final List<SmartOutreachContactFormRow> rows;

  void dispose() {
    for (final row in rows) {
      row.dispose();
    }
  }

  bool addEmpty({int maxContacts = 5}) {
    if (rows.length >= maxContacts) {
      return false;
    }
    rows.add(SmartOutreachContactFormRow.empty());
    return true;
  }

  bool removeAt(int index, {int minContacts = 1}) {
    if (rows.length <= minContacts || index < 0 || index >= rows.length) {
      return false;
    }

    final removed = rows.removeAt(index);
    removed.dispose();
    return true;
  }

  bool move(int index, int direction) {
    final target = index + direction;
    if (target < 0 || target >= rows.length) {
      return false;
    }

    final row = rows.removeAt(index);
    rows.insert(target, row);
    return true;
  }

  int firstEmptyIndex() {
    return rows.indexWhere(
      (row) =>
          row.nameController.text.trim().isEmpty &&
          row.phoneController.text.trim().isEmpty,
    );
  }

  bool fillRow({
    required int index,
    required String name,
    required String phone,
  }) {
    if (index < 0 || index >= rows.length) {
      return false;
    }

    final row = rows[index];
    final cleanName = name.trim();

    if (cleanName.isNotEmpty && cleanName != 'بدون اسم') {
      row.nameController.text = cleanName;
    }

    row.phoneController.text = phone.trim();
    return true;
  }

  bool appendPrefilled({
    required String name,
    required String phone,
    int maxContacts = 5,
  }) {
    if (rows.length >= maxContacts) {
      return false;
    }

    rows.add(
      SmartOutreachContactFormRow.prefilled(
        name: name,
        phone: phone,
      ),
    );
    return true;
  }

  List<SmartOutreachContactDraft> buildDrafts() {
    return rows
        .map(
          (row) => SmartOutreachContactDraft(
            id: row.id,
            name: row.nameController.text,
            phone: row.phoneController.text,
            actionType: row.actionType,
            smsTemplate: row.smsTemplateController.text,
          ),
        )
        .toList(growable: false);
  }
}
