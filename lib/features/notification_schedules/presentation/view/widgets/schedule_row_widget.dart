import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// صفّ موعد واحد: نوعه وتفاصيله ووقته، مع الحذف والتشغيل في طرف الصفّ.
class ScheduleRowWidget extends StatelessWidget {
  const ScheduleRowWidget({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    this.isLast = false,
    super.key,
  });

  final NotificationScheduleCustomModel schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: scheduleTypeIcon(schedule.scheduleType),
      title: scheduleTypeLabel(schedule.scheduleType),
      subtitle: _subtitle(),
      active: schedule.enabled,
      isLast: isLast,
      onTap: onEdit,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsIconButton(
            icon: AppIcons.delete,
            tooltip: 'حذف الموعد',
            color: AppColors.error,
            onTap: onDelete,
          ),
          SettingsSwitch(
            value: schedule.enabled,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    final label = schedule.label?.trim();
    final details = _details();
    if (label != null && label.isNotEmpty) {
      return '$details · $label';
    }
    return details;
  }

  String _details() {
    switch (schedule.scheduleType) {
      case ScheduleType.daily:
        return 'كل يوم · ${_time()}';
      case ScheduleType.hourly:
        return 'كل ساعة عند الدقيقة ${schedule.minute ?? 0}';
      case ScheduleType.weekly:
        final days = schedule.weekdays?.map(_shortDayName).join('، ') ?? '';
        final when = days.isEmpty ? 'بدون أيام' : days;
        return '$when · ${_time()}';
      case ScheduleType.everyNMinutes:
        return 'كل ${schedule.intervalMinutes ?? 1} دقيقة';
      case ScheduleType.customDates:
        return '${schedule.customDates?.length ?? 0} موعد مخصص';
    }
  }

  String _time() {
    final hour = schedule.hour;
    final minute = schedule.minute;
    if (hour == null || minute == null) {
      return '--:--';
    }
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  String _shortDayName(int day) {
    switch (day) {
      case 1:
        return 'اثنين';
      case 2:
        return 'ثلاثاء';
      case 3:
        return 'أربعاء';
      case 4:
        return 'خميس';
      case 5:
        return 'جمعة';
      case 6:
        return 'سبت';
      case 7:
        return 'أحد';
      default:
        return '؟';
    }
  }
}
