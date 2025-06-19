import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';

// يمكنك تعديل استدعاء هذا الديالوج من زر التخصيص كما في الرد السابق

Future<void> showEditScheduleDialog(
  BuildContext context,
  NotificationSettingModel model,
  void Function(NotificationSettingModel updated) onSave,
) async {
  // Local state
  var selectedType = model.scheduleType;
  var hour = model.hour;
  var minute = model.minute;
  var interval = model.intervalMinutes;
  var weekdays = List<int>.of(model.weekdays ?? []);
  final customDates = List<DateTime>.of(model.customDates ?? []);

  String? validationError;

  void validate() {
    validationError = null;
    if (selectedType == ScheduleType.daily ||
        selectedType == ScheduleType.weekly) {
      if (hour == null || minute == null) {
        validationError = 'حدد الساعة والدقيقة';
      }
    }
    if (selectedType == ScheduleType.weekly) {
      if (weekdays.isEmpty) {
        validationError = 'حدد يوم واحد على الأقل من الأسبوع';
      }
    }
    if (selectedType == ScheduleType.everyNMinutes) {
      if (interval == null || interval! < 1) {
        validationError = 'أدخل عدد الدقائق (يجب أن يكون أكبر من صفر)';
      }
    }
    if (selectedType == ScheduleType.customDates) {
      if (customDates.isEmpty) {
        validationError = 'أضف تاريخ/وقت واحد على الأقل';
      }
    }
  }

  await showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        // طريقة عرض التاريخ/الوقت
        String formatDate(DateTime dt) =>
            DateFormat('yyyy-MM-dd – HH:mm').format(dt);

        Future<void> onAddCustomDate() async {
          final now = DateTime.now();
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: now,
            lastDate: now.add(const Duration(days: 365)),
          );
          if (pickedDate != null) {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(now),
            );
            if (pickedTime != null) {
              final full = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              setState(() {
                customDates.add(full);
              });
            }
          }
        }

        validate();

        return AlertDialog(
          title: const Text('تعديل جدولة الإشعار'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع الجدولة
                DropdownButton<ScheduleType>(
                  value: selectedType,
                  items: ScheduleType.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(_typeToStr(e)),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() {
                    selectedType = val!;
                    // إعادة تعيين الخيارات إذا تغير النوع
                    if (selectedType == ScheduleType.weekly &&
                        weekdays.isEmpty) {
                      weekdays = [1];
                    }
                  }),
                ),
                const SizedBox(height: 12),
                if (selectedType == ScheduleType.daily ||
                    selectedType == ScheduleType.weekly)
                  Row(
                    children: [
                      const Text('الساعة: '),
                      DropdownButton<int>(
                        value: hour ?? 0,
                        items: List.generate(24, (i) => i)
                            .map(
                              (h) => DropdownMenuItem(
                                value: h,
                                child: Text(h.toString().padLeft(2, '0')),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => hour = val),
                      ),
                      const SizedBox(width: 8),
                      const Text('الدقيقة: '),
                      DropdownButton<int>(
                        value: minute ?? 0,
                        items: List.generate(60, (i) => i)
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(m.toString().padLeft(2, '0')),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => minute = val),
                      ),
                    ],
                  ),
                if (selectedType == ScheduleType.everyNMinutes)
                  Row(
                    children: [
                      const Text('كل'),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          initialValue: interval?.toString() ?? '5',
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              setState(() => interval = int.tryParse(v) ?? 5),
                        ),
                      ),
                      const Text('دقيقة'),
                    ],
                  ),
                if (selectedType == ScheduleType.weekly)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      children: List.generate(7, (idx) {
                        final day = idx + 1;
                        final selected = weekdays.contains(day);
                        return FilterChip(
                          label: Text(_arabicDayOfWeek(day)),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                weekdays.add(day);
                              } else {
                                weekdays.remove(day);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ),
                if (selectedType == ScheduleType.customDates) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة تاريخ/وقت'),
                          onPressed: onAddCustomDate,
                        ),
                        if (customDates.isNotEmpty) const SizedBox(width: 12),
                        if (customDates.isNotEmpty)
                          Text('عدد التواريخ: ${customDates.length}'),
                      ],
                    ),
                  ),
                  for (int i = 0; i < customDates.length; i++)
                    ListTile(
                      dense: true,
                      title: Text(formatDate(customDates[i])),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () =>
                            setState(() => customDates.removeAt(i)),
                      ),
                    ),
                  if (customDates.isEmpty)
                    const Text(
                      'لم تقم بإضافة أي تاريخ بعد',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
                if (validationError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      validationError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: (validationError != null)
                  ? null
                  : () {
                      final updated = model.copyWith(
                        scheduleType: selectedType,
                        hour: (selectedType == ScheduleType.daily ||
                                selectedType == ScheduleType.weekly)
                            ? hour
                            : null,
                        minute: (selectedType == ScheduleType.daily ||
                                selectedType == ScheduleType.weekly)
                            ? minute
                            : null,
                        intervalMinutes:
                            selectedType == ScheduleType.everyNMinutes
                                ? interval
                                : null,
                        weekdays: selectedType == ScheduleType.weekly
                            ? weekdays
                            : null,
                        customDates: selectedType == ScheduleType.customDates
                            ? customDates
                            : null,
                      );
                      Navigator.pop(context);
                      onSave(updated);
                    },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    ),
  );
}

String _typeToStr(ScheduleType t) {
  switch (t) {
    case ScheduleType.daily:
      return 'يومي';
    case ScheduleType.hourly:
      return 'كل ساعة';
    case ScheduleType.everyNMinutes:
      return 'كل عدة دقائق';
    case ScheduleType.weekly:
      return 'أسبوعي';
    case ScheduleType.customDates:
      return 'تواريخ مخصصة';
  }
}

String _arabicDayOfWeek(int d) {
  switch (d) {
    case 1:
      return 'الاثنين';
    case 2:
      return 'الثلاثاء';
    case 3:
      return 'الأربعاء';
    case 4:
      return 'الخميس';
    case 5:
      return 'الجمعة';
    case 6:
      return 'السبت';
    case 7:
      return 'الأحد';
    default:
      return '؟';
  }
}
