import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/weekdays_picker_widget.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// يفتح نموذج إنشاء أو تعديل موعد كنافذة سفلية بأرضية الشاشة نفسها.
Future<void> showImprovedScheduleDialog(
  BuildContext context,
  NotificationScheduleCustomModel model,
  void Function(NotificationScheduleCustomModel result) onSave,
) async {
  await showSettingsSheet<void>(
    context: context,
    builder: (sheetContext) => CreateOrUpdateScheduleDialog(
      model: model,
      onSave: onSave,
    ),
  );
}

/// نموذج واحد لكل خيارات الموعد: النوع، التفاصيل، ثم وصف اختياري.
class CreateOrUpdateScheduleDialog extends StatefulWidget {
  const CreateOrUpdateScheduleDialog({
    required this.model,
    required this.onSave,
    super.key,
  });

  final NotificationScheduleCustomModel model;
  final void Function(NotificationScheduleCustomModel result) onSave;

  @override
  State<CreateOrUpdateScheduleDialog> createState() =>
      _CreateOrUpdateScheduleDialogState();
}

class _CreateOrUpdateScheduleDialogState
    extends State<CreateOrUpdateScheduleDialog> {
  late ScheduleType _type;
  int? _hour;
  int? _minute;
  int? _intervalMinutes;
  late List<int> _weekdays;
  late List<DateTime> _customDates;
  String? _label;
  String? _error;

  @override
  void initState() {
    super.initState();
    _type = widget.model.scheduleType;
    _hour = widget.model.hour;
    _minute = widget.model.minute;
    _intervalMinutes = widget.model.intervalMinutes;
    _weekdays = List<int>.of(widget.model.weekdays ?? []);
    _customDates = List<DateTime>.of(widget.model.customDates ?? []);
    _label = widget.model.label;
  }

  String? _validate() {
    switch (_type) {
      case ScheduleType.daily:
      case ScheduleType.hourly:
        if (_type == ScheduleType.daily && (_hour == null || _minute == null)) {
          return 'حدد وقت التنبيه أولاً';
        }
        if (_type == ScheduleType.hourly && _minute == null) {
          return 'حدد الدقيقة من كل ساعة';
        }
        return null;
      case ScheduleType.weekly:
        if (_hour == null || _minute == null) {
          return 'حدد وقت التنبيه أولاً';
        }
        if (_weekdays.isEmpty) {
          return 'حدد يوماً واحداً على الأقل من الأسبوع';
        }
        return null;
      case ScheduleType.everyNMinutes:
        if (_intervalMinutes == null || _intervalMinutes! < 1) {
          return 'أدخل عدد الدقائق (أكبر من صفر)';
        }
        return null;
      case ScheduleType.customDates:
        if (_customDates.isEmpty) {
          return 'أضف تاريخاً واحداً على الأقل';
        }
        return null;
    }
  }

  Future<void> _addCustomDate() async {
    final now = DateTime.now();
    final pickedDate = await AdaptiveDatePicker.show(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await AdaptiveTimePicker.show(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _customDates.add(
        DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );
      _error = null;
    });
  }

  void _save() {
    final error = _validate();
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    final result = widget.model.copyWith(
      scheduleType: _type,
      hour: _hour,
      minute: _minute,
      intervalMinutes: _intervalMinutes,
      weekdays: _weekdays.isNotEmpty ? _weekdays : null,
      customDates: _customDates.isNotEmpty ? _customDates : null,
      label: _label,
    );

    Navigator.of(context).pop();
    widget.onSave(result);
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.model.id == null;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSheetHeader(
            title: isNew ? 'إضافة موعد جديد' : 'تعديل الموعد',
            subtitle: scheduleTypeDescription(_type),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScheduleTypeSelector(
                    value: _type,
                    onChanged: (type) => setState(() {
                      _type = type;
                      _error = null;
                      if (type == ScheduleType.weekly && _weekdays.isEmpty) {
                        _weekdays = [1];
                      }
                    }),
                  ),
                  SettingsGroup(
                    title: 'التفاصيل',
                    children: _detailFields(),
                  ),
                  SettingsGroup(
                    title: 'وصف اختياري',
                    children: [
                      ScheduleLabelField(
                        value: _label,
                        onChanged: (value) => _label = value,
                      ),
                    ],
                  ),
                  if (_error != null) SettingsHint(_error!),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          SettingsPrimaryButton(
            label: isNew ? 'إضافة الموعد' : 'حفظ التعديل',
            icon: AppIcons.save,
            onPressed: _save,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  List<Widget> _detailFields() {
    switch (_type) {
      case ScheduleType.daily:
        return [
          ScheduleTimeRow(
            hour: _hour,
            minute: _minute,
            isLast: true,
            onChanged: _setTime,
          ),
        ];
      case ScheduleType.weekly:
        return [
          ScheduleTimeRow(
            hour: _hour,
            minute: _minute,
            isLast: true,
            onChanged: _setTime,
          ),
          WeekdaysPickerWidget(
            initialSelection: _weekdays,
            onChanged: (days) => _weekdays = days,
          ),
        ];
      case ScheduleType.hourly:
        return [
          ScheduleNumberRow(
            icon: AppIcons.clock,
            title: 'الدقيقة من كل ساعة',
            subtitle: 'رقم بين 0 و 59',
            value: _minute,
            suffix: 'دقيقة',
            isLast: true,
            onChanged: (value) => _minute = value,
          ),
        ];
      case ScheduleType.everyNMinutes:
        return [
          ScheduleNumberRow(
            icon: AppIcons.refresh,
            title: 'التكرار',
            subtitle: 'المدة بين كل تنبيه والذي يليه',
            value: _intervalMinutes,
            suffix: 'دقيقة',
            isLast: true,
            onChanged: (value) => _intervalMinutes = value,
          ),
        ];
      case ScheduleType.customDates:
        return [
          for (var i = 0; i < _customDates.length; i++)
            SettingsRow(
              icon: AppIcons.calendar,
              title: _formatDate(_customDates[i]),
              subtitle: 'موعد مخصص',
              trailing: SettingsIconButton(
                icon: AppIcons.delete,
                tooltip: 'حذف الموعد',
                color: AppColors.error,
                onTap: () => setState(() => _customDates.removeAt(i)),
              ),
            ),
          if (_customDates.isEmpty) const SettingsHint('لم تضف أي موعد بعد'),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SettingsGhostButton(
                label: 'إضافة موعد',
                icon: AppIcons.add,
                onPressed: _addCustomDate,
              ),
            ),
          ),
        ];
    }
  }

  void _setTime(int hour, int minute) {
    setState(() {
      _hour = hour;
      _minute = minute;
      _error = null;
    });
  }

  String _formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd – HH:mm').format(date);
}
