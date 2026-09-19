import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

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
      title: scheduleTypeLabel(context.l10n, schedule.scheduleType),
      subtitle: _subtitle(context.l10n),
      active: schedule.enabled,
      isLast: isLast,
      onTap: onEdit,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsIconButton(
            icon: AppIcons.delete,
            tooltip: context.l10n.notifScheduleDeleteTime,
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

  String _subtitle(L10n l10n) {
    final label = schedule.label?.trim();
    final details = _details(l10n);
    if (label != null && label.isNotEmpty) {
      return '$details · $label';
    }
    return details;
  }

  String _details(L10n l10n) {
    switch (schedule.scheduleType) {
      case ScheduleType.daily:
        return l10n.notifScheduleRowDaily(_time());
      case ScheduleType.hourly:
        return l10n.notifSettingsSummaryHourly(schedule.minute ?? 0);
      case ScheduleType.weekly:
        final days = schedule.weekdays
                ?.map((day) => shortWeekdayName(l10n, day))
                .join(l10n.notifSettingsListSeparator) ??
            '';
        final when = days.isEmpty ? l10n.notifScheduleNoDays : days;
        return l10n.notifScheduleRowWeekly(when, _time());
      case ScheduleType.everyNMinutes:
        return l10n.notifSettingsSummaryEveryNMinutes(
          schedule.intervalMinutes ?? 1,
        );
      case ScheduleType.customDates:
        return l10n.notifScheduleRowCustom(schedule.customDates?.length ?? 0);
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
}
