import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/weekdays_picker_widget.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// تعديل جدولة إشعار: نموذج واحد بدل معالج بثلاث صفحات.
///
/// الصفحات الثلاث كانت تخفي الخيارات وراء أزرار «التالي»، وكل ما فيها يسع
/// شاشة واحدة من الصفوف النحيلة.
class ShowEditScheduleDialog extends StatefulWidget {
  const ShowEditScheduleDialog({
    required this.model,
    required this.onSave,
    super.key,
  });

  final NotificationSettingModel model;
  final void Function(NotificationSettingModel updated) onSave;

  @override
  State<ShowEditScheduleDialog> createState() => _ShowEditScheduleDialogState();
}

class _ShowEditScheduleDialogState extends State<ShowEditScheduleDialog> {
  late ScheduleType _type;
  int? _hour;
  int? _minute;
  int? _interval;
  late List<int> _weekdays;
  late List<DateTime> _customDates;
  String? _error;

  @override
  void initState() {
    super.initState();
    _type = widget.model.scheduleType;
    _hour = widget.model.hour;
    _minute = widget.model.minute;
    _interval = widget.model.intervalMinutes;
    _weekdays = List<int>.of(widget.model.weekdays ?? []);
    _customDates = List<DateTime>.of(widget.model.customDates ?? []);
  }

  String? _validate() {
    if (_type == ScheduleType.daily || _type == ScheduleType.weekly) {
      if (_hour == null || _minute == null) {
        return 'حدد وقت التنبيه أولاً';
      }
    }
    if (_type == ScheduleType.weekly && _weekdays.isEmpty) {
      return 'حدد يوماً واحداً على الأقل من الأسبوع';
    }
    if (_type == ScheduleType.everyNMinutes) {
      if (_interval == null || _interval! < 1) {
        return 'أدخل عدد الدقائق (أكبر من صفر)';
      }
    }
    if (_type == ScheduleType.customDates && _customDates.isEmpty) {
      return 'أضف تاريخاً واحداً على الأقل';
    }
    return null;
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
    });
  }

  void _save() {
    final error = _validate();
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    final isClockType =
        _type == ScheduleType.daily || _type == ScheduleType.weekly;

    final updated = widget.model.copyWith(
      scheduleType: _type,
      hour: isClockType ? _hour : null,
      minute: isClockType || _type == ScheduleType.hourly ? _minute : null,
      intervalMinutes: _type == ScheduleType.everyNMinutes ? _interval : null,
      weekdays: _type == ScheduleType.weekly ? _weekdays : null,
      customDates: _type == ScheduleType.customDates ? _customDates : null,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSheetHeader(
            title: 'تعديل الجدولة',
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
                  if (_error != null) SettingsHint(_error!),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          SettingsPrimaryButton(
            label: 'حفظ الجدولة',
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
            onChanged: (hour, minute) => setState(() {
              _hour = hour;
              _minute = minute;
              _error = null;
            }),
          ),
        ];
      case ScheduleType.weekly:
        return [
          ScheduleTimeRow(
            hour: _hour,
            minute: _minute,
            isLast: true,
            onChanged: (hour, minute) => setState(() {
              _hour = hour;
              _minute = minute;
              _error = null;
            }),
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
            value: _interval,
            suffix: 'دقيقة',
            isLast: true,
            onChanged: (value) => _interval = value,
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

  String _formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd – HH:mm').format(date);
}
