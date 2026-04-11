import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contact_form_card.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contact_form_row.dart';

class SmartOutreachContactsSection extends StatelessWidget {
  const SmartOutreachContactsSection({
    required this.rows,
    required this.onAddFromContacts,
    required this.onAddManual,
    required this.onMoveContact,
    required this.onRemoveContact,
    required this.onPickContact,
    required this.onActionTypeChanged,
    super.key,
  });

  final List<SmartOutreachContactFormRow> rows;
  final VoidCallback? onAddFromContacts;
  final VoidCallback? onAddManual;
  final void Function(int index, int direction) onMoveContact;
  final void Function(int index) onRemoveContact;
  final void Function(int index) onPickContact;
  final void Function(int index, SmartOutreachActionType type)
      onActionTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'جهات الاتصال (الحد الأقصى 5)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            TextButton.icon(
              onPressed: onAddFromContacts,
              icon: const Icon(Icons.contacts_outlined),
              label: const Text('إضافة من جهات الاتصال'),
            ),
            TextButton.icon(
              onPressed: onAddManual,
              icon: const Icon(Icons.add),
              label: const Text('إضافة يدوياً'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;

          return SmartOutreachContactFormCard(
            index: index,
            totalCount: rows.length,
            row: row,
            onMoveUp: index == 0 ? null : () => onMoveContact(index, -1),
            onMoveDown:
                index == rows.length - 1 ? null : () => onMoveContact(index, 1),
            onRemove: rows.length <= 1 ? null : () => onRemoveContact(index),
            onPickFromContacts: () => onPickContact(index),
            onActionTypeChanged: (value) => onActionTypeChanged(index, value),
          );
        }),
      ],
    );
  }
}
