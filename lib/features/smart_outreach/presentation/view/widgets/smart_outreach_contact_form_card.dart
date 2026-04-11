import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contact_form_row.dart';

class SmartOutreachContactFormCard extends StatelessWidget {
  const SmartOutreachContactFormCard({
    required this.index,
    required this.totalCount,
    required this.row,
    required this.onPickFromContacts,
    required this.onActionTypeChanged,
    this.onMoveUp,
    this.onMoveDown,
    this.onRemove,
    super.key,
  });

  final int index;
  final int totalCount;
  final SmartOutreachContactFormRow row;
  final VoidCallback onPickFromContacts;
  final ValueChanged<SmartOutreachActionType> onActionTypeChanged;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'الأولوية ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onMoveUp,
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  onPressed: onMoveDown,
                  icon: const Icon(Icons.arrow_downward),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onPickFromContacts,
                icon: const Icon(Icons.contact_phone_outlined),
                label: const Text('اختيار من جهات الاتصال'),
              ),
            ),
            TextField(
              controller: row.nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'الاسم / التسمية (اختياري)',
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: row.phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف *',
                hintText: '+9665XXXXXXX',
              ),
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<SmartOutreachActionType>(
              initialValue: row.actionType,
              items: SmartOutreachActionType.values
                  .map(
                    (type) => DropdownMenuItem<SmartOutreachActionType>(
                      value: type,
                      child: Text(type.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                onActionTypeChanged(value);
              },
              decoration: const InputDecoration(
                labelText: 'نوع الإجراء',
              ),
            ),
            if (row.actionType.includesSms) ...[
              SizedBox(height: 10.h),
              TextField(
                controller: row.smsTemplateController,
                textInputAction: TextInputAction.next,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'قالب رسالة نصية خاص (اختياري)',
                ),
              ),
            ],
            if (totalCount > 1) SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
