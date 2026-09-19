import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/system_notification_screen.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/notification_setting_item_widget.dart';

/// إعدادات الإشعارات: مفتاح رئيسي مرتفع، ثم مجموعات صغيرة من الصفوف.
class SettingNotificationScreen extends StatelessWidget {
  const SettingNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SettingNotificationBloc(sl())..add(LoadNotificationSettings()),
      lazy: false,
      child: const _SettingNotificationView(),
    );
  }
}

class _SettingNotificationView extends StatelessWidget {
  const _SettingNotificationView();

  /// المجموعات بالترتيب الذي تُقرأ به: الأقرب للاستعمال اليومي أولًا.
  static const List<_NotifGroup> _groups = [
    _NotifGroup(
      'عام',
      [
        _NotifItem(
          NotificationKeys.isNotificationFirebaseGeneral,
          'إشعارات التطبيق العامة',
          AppIcons.news,
        ),
      ],
    ),
    _NotifGroup(
      'الأذان',
      [
        _NotifItem(
          NotificationKeys.isNotificationAllAthan,
          'كل الصلوات',
          AppIcons.mosque,
        ),
        _NotifItem(
          NotificationKeys.isNotificationAthanFagr,
          'أذان الفجر',
          AppIcons.sunrise,
        ),
        _NotifItem(
          NotificationKeys.isNotificationAthanDuhr,
          'أذان الظهر',
          AppIcons.sun,
        ),
        _NotifItem(
          NotificationKeys.isNotificationAthanAsr,
          'أذان العصر',
          AppIcons.clock,
        ),
        _NotifItem(
          NotificationKeys.isNotificationAthanMagrib,
          'أذان المغرب',
          AppIcons.sunset,
        ),
        _NotifItem(
          NotificationKeys.isNotificationAthanIsha,
          'أذان العشاء',
          AppIcons.moon,
        ),
      ],
    ),
    _NotifGroup(
      'الورد اليومي',
      [
        _NotifItem(
          NotificationKeys.isNotificationDailyWirdMorning,
          'ورد الصباح',
          AppIcons.sunrise,
        ),
        _NotifItem(
          NotificationKeys.isNotificationDailyWirdEvening,
          'ورد المساء',
          AppIcons.sunset,
        ),
        _NotifItem(
          NotificationKeys.isNotificationDailyWirdNight,
          'ورد ما قبل النوم',
          AppIcons.moon,
        ),
        _NotifItem(
          NotificationKeys.isNotificationDailyWirdSummary,
          'ملخص الورد اليومي',
          AppIcons.check,
        ),
      ],
    ),
    _NotifGroup(
      'الأذكار',
      [
        _NotifItem(
          NotificationKeys.isNotificationThikrMorning,
          'أذكار الصباح',
          AppIcons.dailyWird,
        ),
        _NotifItem(
          NotificationKeys.isNotificationThikrNight,
          'أذكار المساء',
          AppIcons.bookOpen,
        ),
        _NotifItem(
          NotificationKeys.isNotificationMohammed,
          'الصلاة على محمد',
          AppIcons.heart,
        ),
        _NotifItem(
          NotificationKeys.isNotificationRandomThikr,
          'الأذكار الصوتية العشوائية',
          AppIcons.sound,
        ),
        _NotifItem(
          NotificationKeys.isNotificationFloatingAdhkar,
          'الأذكار العائمة والتنبيهات البديلة',
          AppIcons.focus,
        ),
      ],
    ),
    _NotifGroup(
      'القرآن',
      [
        _NotifItem(
          NotificationKeys.isNotificationReadQuran,
          'الورد القرآني',
          AppIcons.quran,
        ),
        _NotifItem(
          NotificationKeys.isNotificationReadSurahMulk,
          'قراءة سورة الملك',
          AppIcons.book,
        ),
        _NotifItem(
          NotificationKeys.isNotificationReadSurah,
          'قراءة سورة محددة',
          AppIcons.bookOpen,
        ),
        _NotifItem(
          NotificationKeys.isNotificationReadSurahAlkahf,
          'قراءة سورة الكهف',
          AppIcons.bookmark,
        ),
        _NotifItem(
          NotificationKeys.isNotificationQuranPlan,
          'تذكير خطط القرآن',
          AppIcons.calendar,
        ),
      ],
    ),
    _NotifGroup(
      'أقسام التطبيق',
      [
        _NotifItem(
          NotificationKeys.isNotificationYoungMuslimResume,
          'تذكير المسلم الصغير',
          AppIcons.play,
        ),
      ],
    ),
    _NotifGroup(
      'الليل واليقظة',
      [
        _NotifItem(
          NotificationKeys.isNotificationWridGetup,
          'أذكار الاستيقاظ',
          AppIcons.sunrise,
        ),
        _NotifItem(
          NotificationKeys.isNotificationWridSleep,
          'أذكار النوم',
          AppIcons.moon,
        ),
        _NotifItem(
          NotificationKeys.isNotificationMiddleNight,
          'قيام الليل',
          AppIcons.prayerRug,
        ),
      ],
    ),
    _NotifGroup(
      'الصيام',
      [
        _NotifItem(
          NotificationKeys.isNotificationFasting,
          'تذكير بالصيام',
          AppIcons.calendar,
        ),
        _NotifItem(
          NotificationKeys.isNotificationFastingMonday,
          'صيام الاثنين',
          AppIcons.calendar,
        ),
        _NotifItem(
          NotificationKeys.isNotificationFastingThursday,
          'صيام الخميس',
          AppIcons.calendar,
        ),
      ],
    ),
    _NotifGroup(
      'أذكار متكررة',
      [
        _NotifItem(
          NotificationKeys.isNotificationAstgferAllh,
          'استغفر الله',
          AppIcons.tasbih,
        ),
        _NotifItem(
          NotificationKeys.isNotificationHasbnaAllh,
          'حسبنا الله',
          AppIcons.allah,
        ),
        _NotifItem(
          NotificationKeys.isNotificationLahawlaWlaquoah,
          'لا حول ولا قوة إلا بالله',
          AppIcons.tasbih,
        ),
        _NotifItem(
          NotificationKeys.isNotificationSubhanAllh,
          'سبحان الله',
          AppIcons.star,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'إعدادات الإشعارات',
      children: [
        BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
          builder: (context, state) {
            return state.loading.handle<NotificationSettingModel>(
              list: state.settings.values.toList(),
              context: context,
              onSuccess: () => _buildBody(context, state.settings),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    Map<String, NotificationSettingModel> settings,
  ) {
    final master = settings[NotificationKeys.isNotify];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // المفتاح الرئيسي هو العنصر المرتفع الوحيد: يحكم كل ما تحته.
        if (master != null)
          SettingsRaisedRow(
            icon: AppIcons.notifications,
            title: 'كل إشعارات التطبيق',
            subtitle: master.enabled
                ? 'الإشعارات مفعّلة، وتستطيع ضبط كل نوع أدناه'
                : 'كل الإشعارات موقوفة حتى تفعّل هذا المفتاح',
            trailing: SettingsSwitch(
              value: master.enabled,
              onChanged: (value) => context
                  .read<SettingNotificationBloc>()
                  .add(ToggleNotification(master.key, value)),
            ),
          ),
        SettingsGroup(
          title: 'النظام',
          children: [
            SettingsRow(
              icon: AppIcons.layers,
              title: 'إشعارات النظام',
              subtitle: 'استعرض الإشعارات المجدولة والمفعّلة على جهازك',
              isLast: true,
              onTap: () => context.push(const SystemNotificationScreen()),
            ),
          ],
        ),
        for (final group in _groups)
          SettingsGroup(
            title: group.title,
            children: [
              for (var i = 0; i < group.items.length; i++)
                NotificationSettingItemWidget(
                  setting: settings[group.items[i].key],
                  title: group.items[i].title,
                  icon: group.items[i].icon,
                  isLast: i == group.items.length - 1,
                ),
            ],
          ),
      ],
    );
  }
}

class _NotifGroup {
  const _NotifGroup(this.title, this.items);

  final String title;
  final List<_NotifItem> items;
}

class _NotifItem {
  const _NotifItem(this.key, this.title, this.icon);

  final String key;
  final String title;
  final HugeIconData icon;
}
