import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/show_edit_schedule_dialog.dart';

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
      subtitle: _describe(model),
      active: model.enabled,
      isLast: isLast,
      onTap: () => _toggle(context, model, value: !model.enabled),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canSchedule)
            SettingsIconButton(
              icon: AppIcons.clock,
              tooltip: 'مواعيد التنبيه',
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
          SettingsSheetHeader(title: title, subtitle: _describe(model)),
          SettingsRow(
            icon: AppIcons.edit,
            title: 'تعديل الجدولة',
            subtitle: 'غيّر نوع التكرار ووقت التنبيه',
            onTap: () {
              Navigator.of(sheetContext).pop();
              _openEditSchedule(context, bloc, model);
            },
          ),
          SettingsRow(
            icon: AppIcons.calendar,
            title: 'إدارة مواعيد إضافية',
            subtitle: 'أضف أكثر من موعد لهذا الإشعار',
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

  String _describe(NotificationSettingModel model) {
    if (!model.enabled) {
      return 'موقوف';
    }
    if (model.onlySetting) {
      return 'مفعّل';
    }
    return scheduleSummary(model);
  }
}

/// وصف مختصر لجدولة إشعار — يُستخدم في الصفّ وفي نافذة التعديل.
String scheduleSummary(NotificationSettingModel model) {
  switch (model.scheduleType) {
    case ScheduleType.daily:
      return 'يومياً · ${formatClock(model.hour, model.minute)}';
    case ScheduleType.hourly:
      return 'كل ساعة عند الدقيقة ${model.minute ?? 0}';
    case ScheduleType.everyNMinutes:
      return 'كل ${model.intervalMinutes ?? 1} دقيقة';
    case ScheduleType.weekly:
      final days = (model.weekdays ?? []).map(arabicDayOfWeek).join('، ');
      final label = days.isEmpty ? 'بدون أيام محددة' : days;
      return 'أسبوعياً ($label) · ${formatClock(model.hour, model.minute)}';
    case ScheduleType.customDates:
      return 'جدولة مخصصة · ${model.customDates?.length ?? 0} توقيت';
  }
}

/// وقت بصيغة ثابتة `HH:mm`.
String formatClock(int? hour, int? minute) {
  final h = hour?.toString().padLeft(2, '0') ?? '--';
  final m = minute?.toString().padLeft(2, '0') ?? '--';
  return '$h:$m';
}

/// اسم يوم الأسبوع بالعربية (1 = الاثنين ... 7 = الأحد).
String arabicDayOfWeek(int day) {
  switch (day) {
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
