import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/show_edit_schedule_dialog.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
      builder: (context, state) {
        if (state.loading == LoadState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        // كل الإعدادات (مفتاح -> موديل)
        final s = state.settings;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const BaseHederWidget(text: 'الاذان'),
              ..._groupSwitches(context, s, [
                _NotifItem(
                  NotificationKeys.isNotificationAllAthan,
                  'كل الصلوات',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationAthanFagr,
                  'اذان الفجر',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationAthanDuhr,
                  'اذان الظهر',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationAthanAsr,
                  'اذان العصر',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationAthanMagrib,
                  'اذان المغرب',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationAthanIsha,
                  'اذان العشاء',
                ),
              ]),
              const BaseHederWidget(text: 'الورد اليومي'),
              ..._groupSwitches(context, s, [
                _NotifItem(
                  NotificationKeys.isNotificationThikrMorning,
                  'اذكار الصباح',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationThikrNight,
                  'اذكار المساء',
                ),
              ]),
              const BaseHederWidget(text: 'العشوائي'),
              ..._groupSwitches(context, s, [
                _NotifItem(
                  NotificationKeys.isNotificationMohammed,
                  'الصلاة على محمد',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationRandomThikr,
                  'الاذكار الصوتيه العشوائية',
                ),
              ]),
              const BaseHederWidget(text: 'أخرى'),
              ..._groupSwitches(context, s, [
                _NotifItem(
                  NotificationKeys.isNotificationWridGetup,
                  'اذكار الاستيقاظ',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationWridSleep,
                  'اذكار النوم',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationReadSurahMulk,
                  'قراءة سورة الملك',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationReadQuran,
                  'الورد القرآني',
                ),
                _NotifItem(
                  NotificationKeys.isNotificationMiddleNight,
                  'قيام الليل',
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  /// عنصر واحد قابل لإعادة الاستخدام
  Widget _notifSwitch(
    BuildContext context,
    NotificationSettingModel? setting,
    String title,
  ) {
    if (setting == null) return const SizedBox();
    return BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
      builder: (context, state) {
        return CardWidget(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleMedium(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _subtitleFromSchedule(setting),
                        style: titleSmall(context),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.schedule,
                        color: context.primaryScheme,
                      ),
                      tooltip: 'إدارة أوقات التنبيه',
                      onPressed: () {
                        context.push(
                          NotificationSchedulesScreen(
                            notifKey: setting.key,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_calendar_outlined,
                        color: context.primaryScheme,
                      ),
                      tooltip: 'تعديل وقت/جدولة الإشعار',
                      onPressed: () {
                        showEditScheduleDialog(
                          context,
                          setting,
                          (updated) {
                            context.read<SettingNotificationBloc>().add(
                                  EditNotificationSchedule(
                                    setting.key,
                                    updated,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
                Switch(
                  value: setting.enabled,
                  activeColor: context.primaryScheme,
                  inactiveTrackColor: context.gray1,
                  activeTrackColor: context.primaryScheme.withOpacity(0.5),
                  onChanged: (val) {
                    context.read<SettingNotificationBloc>().add(
                          ToggleNotification(setting.key, val),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// مجموعة عناصر سويتشات متجاورة
  List<Widget> _groupSwitches(
    BuildContext context,
    Map<String, NotificationSettingModel> state,
    List<_NotifItem> items,
  ) {
    return [
      for (final i in items) _notifSwitch(context, state[i.key], i.title),
    ];
  }

  /// شرح مختصر لنوع الجدولة أسفل كل سطر
  String _subtitleFromSchedule(NotificationSettingModel s) {
    switch (s.scheduleType) {
      case ScheduleType.daily:
        return 'يوميًا الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.hourly:
        return 'كل ساعة عند الدقيقة ${s.minute ?? 0}';
      case ScheduleType.everyNMinutes:
        return 'كل ${s.intervalMinutes ?? 1} دقيقة';
      case ScheduleType.weekly:
        final days = (s.weekdays ?? []).map(_arabicDayOfWeek).join('، ');
        return 'أسبوعيًا (${days.isEmpty ? "بدون أيام محددة" : days}) الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.customDates:
        return 'جدولة مخصصة (${s.customDates?.length ?? 0} توقيت)';
    }
  }

  String _formatTime(int? h, int? m) =>
      '${h?.toString().padLeft(2, '0') ?? '--'}:${m?.toString().padLeft(2, '0') ?? '--'}';

  String _arabicDayOfWeek(int d) {
    // 1=الاثنين...5=الجمعة...7=الأحد (حسب ISO أو نظامك)
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
}

class _NotifItem {
  _NotifItem(this.key, this.title);
  final String key;
  final String title;
}
