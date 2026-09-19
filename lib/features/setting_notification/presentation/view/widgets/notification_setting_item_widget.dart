import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/show_edit_schedule_dialog.dart';
import 'package:quran_app/l10n/l10n.dart';

/// صفّ إشعار واحد: أيقونة + اسم + وصف جدولته + مفتاح التشغيل.
///
/// وصف الجدولة صار سطرًا ثانويًا داخل الصفّ بدل صندوق تحته، فبقي الصفّ نحيلًا.
class NotificationSettingItemWidget extends StatelessWidget {
  const NotificationSettingItemWidget({
    required this.setting,
    required this.title,
    required this.icon,
    required this.isLast,
    super.key,
  });

  final NotificationSettingModel? setting;
  final String title;
  final HugeIconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final model = setting;
    if (model == null) {
      return const SizedBox.shrink();
    }

    final canSchedule = model.enabled && !model.onlySetting;

    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: _describe(context, model),
      active: model.enabled,
      isLast: isLast,
      onTap: () => _toggle(context, model, value: !model.enabled),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canSchedule)
            SettingsIconButton(
              icon: AppIcons.clock,
              tooltip: context.l10n.notifSettingsScheduleTimesTooltip,
              onTap: () => _openActions(context, model),
            ),
          SettingsSwitch(
            value: model.enabled,
            onChanged: (value) => _toggle(context, model, value: value),
          ),
        ],
      ),
    );
  }

  void _toggle(
    BuildContext context,
    NotificationSettingModel model, {
    required bool value,
  }) {
    context
        .read<SettingNotificationBloc>()
        .add(ToggleNotification(model.key, value));
  }

  /// خيارات الجدولة: تعديل الموعد الأساسي أو إدارة مواعيد إضافية.
  Future<void> _openActions(
    BuildContext context,
    NotificationSettingModel model,
  ) async {
    final bloc = context.read<SettingNotificationBloc>();

    await showSettingsSheet<void>(
      context: context,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSheetHeader(
            title: title,
            subtitle: _describe(context, model),
          ),
          SettingsRow(
            icon: AppIcons.edit,
            title: context.l10n.notifSettingsEditScheduleTitle,
            subtitle: context.l10n.notifSettingsEditScheduleSubtitle,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _openEditSchedule(context, bloc, model);
            },
          ),
          SettingsRow(
            icon: AppIcons.calendar,
            title: context.l10n.notifSettingsExtraSchedulesTitle,
            subtitle: context.l10n.notifSettingsExtraSchedulesSubtitle,
            isLast: true,
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(
                NotificationSchedulesScreen(notifKey: model.key),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  void _openEditSchedule(
    BuildContext context,
    SettingNotificationBloc bloc,
    NotificationSettingModel model,
  ) {
    showSettingsSheet<void>(
      context: context,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: ShowEditScheduleDialog(
          model: model,
          onSave: (updated) {
            bloc.add(EditNotificationSchedule(model.key, updated));
          },
        ),
      ),
    );
  }

  String _describe(BuildContext context, NotificationSettingModel model) {
    final l10n = context.l10n;
    if (!model.enabled) {
      return l10n.notifSettingsStatusStopped;
    }
    if (model.onlySetting) {
      return l10n.notifSettingsStatusEnabled;
    }
    return scheduleSummary(l10n, model);
  }
}

/// وصف مختصر لجدولة إشعار — يُستخدم في الصفّ وفي نافذة التعديل.
String scheduleSummary(L10n l10n, NotificationSettingModel model) {
  switch (model.scheduleType) {
    case ScheduleType.daily:
      return l10n.notifSettingsSummaryDaily(
        formatClock(model.hour, model.minute),
      );
    case ScheduleType.hourly:
      return l10n.notifSettingsSummaryHourly(model.minute ?? 0);
    case ScheduleType.everyNMinutes:
      return l10n.notifSettingsSummaryEveryNMinutes(
        model.intervalMinutes ?? 1,
      );
    case ScheduleType.weekly:
      final days = (model.weekdays ?? [])
          .map((day) => localizedDayOfWeek(l10n, day))
          .join(l10n.notifSettingsListSeparator);
      final label = days.isEmpty ? l10n.notifSettingsNoDaysSelected : days;
      return l10n.notifSettingsSummaryWeekly(
        label,
        formatClock(model.hour, model.minute),
      );
    case ScheduleType.customDates:
      return l10n.notifSettingsSummaryCustom(model.customDates?.length ?? 0);
  }
}

/// وقت بصيغة ثابتة `HH:mm`.
String formatClock(int? hour, int? minute) {
  final h = hour?.toString().padLeft(2, '0') ?? '--';
  final m = minute?.toString().padLeft(2, '0') ?? '--';
  return '$h:$m';
}

/// اسم يوم الأسبوع بلغة الواجهة (1 = الاثنين ... 7 = الأحد).
String localizedDayOfWeek(L10n l10n, int day) {
  if (day < 1 || day > 7) return '?';
  // 1 يناير 2024 كان يوم اثنين، فيطابق ترقيم DateTime.weekday.
  return DateFormat.EEEE(l10n.localeName).format(DateTime(2024, 1, day));
}
