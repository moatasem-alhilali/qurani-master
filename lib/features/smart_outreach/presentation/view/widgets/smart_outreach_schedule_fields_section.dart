import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmartOutreachScheduleFieldsSection extends StatelessWidget {
  const SmartOutreachScheduleFieldsSection({
    required this.titleController,
    required this.noteController,
    required this.scheduleSmsController,
    required this.time,
    required this.isEnabled,
    required this.isSettingTimeFromFajr,
    required this.onPickTime,
    required this.onApplyTimeFromFajr,
    required this.onEnabledChanged,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController noteController;
  final TextEditingController scheduleSmsController;
  final TimeOfDay time;
  final bool isEnabled;
  final bool isSettingTimeFromFajr;
  final VoidCallback onPickTime;
  final VoidCallback onApplyTimeFromFajr;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'عنوان الجدول *',
            hintText: 'تواصل الصباح',
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: noteController,
          textInputAction: TextInputAction.next,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'ملاحظة (اختياري)',
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: onPickTime,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'الوقت اليومي',
            ),
            child: Text(time.format(context)),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: isSettingTimeFromFajr ? null : onApplyTimeFromFajr,
            icon: isSettingTimeFromFajr
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.schedule_rounded),
            label: const Text('ضبط تلقائيًا على موعد صلاة الفجر'),
          ),
        ),
        SizedBox(height: 12.h),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: isEnabled,
          onChanged: onEnabledChanged,
          title: const Text('تفعيل الجدول'),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: scheduleSmsController,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'قالب الرسالة النصية الافتراضي (اختياري)',
          ),
        ),
      ],
    );
  }
}
