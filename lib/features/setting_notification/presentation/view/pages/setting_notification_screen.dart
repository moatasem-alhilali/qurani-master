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
import 'package:quran_app/l10n/l10n.dart';

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
  ///
  /// أسماء الأذكار المتكررة هي نصّ الذكر نفسه، فتبقى عربية بكل اللغات.
  static List<_NotifGroup> _groups(L10n l10n) => [
        _NotifGroup(
          l10n.notifSettingsGroupGeneral,
          [
            _NotifItem(
              NotificationKeys.isNotificationFirebaseGeneral,
              l10n.notifSettingsLabelGeneral,
              AppIcons.news,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupAthan,
          [
            _NotifItem(
              NotificationKeys.isNotificationAllAthan,
              l10n.notifSettingsAllPrayers,
              AppIcons.mosque,
            ),
            _NotifItem(
              NotificationKeys.isNotificationAthanFagr,
              l10n.notifSettingsAthanOf(l10n.prayerFajr),
              AppIcons.sunrise,
            ),
            _NotifItem(
              NotificationKeys.isNotificationAthanDuhr,
              l10n.notifSettingsAthanOf(l10n.prayerDhuhr),
              AppIcons.sun,
            ),
            _NotifItem(
              NotificationKeys.isNotificationAthanAsr,
              l10n.notifSettingsAthanOf(l10n.prayerAsr),
              AppIcons.clock,
            ),
            _NotifItem(
              NotificationKeys.isNotificationAthanMagrib,
              l10n.notifSettingsAthanOf(l10n.prayerMaghrib),
              AppIcons.sunset,
            ),
            _NotifItem(
              NotificationKeys.isNotificationAthanIsha,
              l10n.notifSettingsAthanOf(l10n.prayerIsha),
              AppIcons.moon,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupDailyWird,
          [
            _NotifItem(
              NotificationKeys.isNotificationDailyWirdMorning,
              l10n.notifSettingsLabelWirdMorning,
              AppIcons.sunrise,
            ),
            _NotifItem(
              NotificationKeys.isNotificationDailyWirdEvening,
              l10n.notifSettingsLabelWirdEvening,
              AppIcons.sunset,
            ),
            _NotifItem(
              NotificationKeys.isNotificationDailyWirdNight,
              l10n.notifSettingsLabelWirdNight,
              AppIcons.moon,
            ),
            _NotifItem(
              NotificationKeys.isNotificationDailyWirdSummary,
              l10n.notifSettingsLabelWirdSummary,
              AppIcons.check,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupAdhkar,
          [
            _NotifItem(
              NotificationKeys.isNotificationThikrMorning,
              l10n.notifSettingsLabelThikrMorning,
              AppIcons.dailyWird,
            ),
            _NotifItem(
              NotificationKeys.isNotificationThikrNight,
              l10n.notifSettingsLabelThikrEvening,
              AppIcons.bookOpen,
            ),
            _NotifItem(
              NotificationKeys.isNotificationMohammed,
              l10n.notifSettingsSalawatShort,
              AppIcons.heart,
            ),
            _NotifItem(
              NotificationKeys.isNotificationRandomThikr,
              l10n.notifSettingsLabelRandomAudioThikr,
              AppIcons.sound,
            ),
            _NotifItem(
              NotificationKeys.isNotificationFloatingAdhkar,
              l10n.notifSettingsLabelFloatingAdhkar,
              AppIcons.focus,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupQuran,
          [
            _NotifItem(
              NotificationKeys.isNotificationReadQuran,
              l10n.notifSettingsQuranWirdShort,
              AppIcons.quran,
            ),
            _NotifItem(
              NotificationKeys.isNotificationReadSurahMulk,
              l10n.notifSettingsLabelReadSurahMulk,
              AppIcons.book,
            ),
            _NotifItem(
              NotificationKeys.isNotificationReadSurah,
              l10n.notifSettingsLabelReadSpecificSurah,
              AppIcons.bookOpen,
            ),
            _NotifItem(
              NotificationKeys.isNotificationReadSurahAlkahf,
              l10n.notifSettingsLabelReadSurahKahf,
              AppIcons.bookmark,
            ),
            _NotifItem(
              NotificationKeys.isNotificationQuranPlan,
              l10n.notifSettingsLabelQuranPlan,
              AppIcons.calendar,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupAppSections,
          [
            _NotifItem(
              NotificationKeys.isNotificationYoungMuslimResume,
              l10n.notifSettingsLabelYoungMuslim,
              AppIcons.play,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupNightAndWaking,
          [
            _NotifItem(
              NotificationKeys.isNotificationWridGetup,
              l10n.notifSettingsLabelThikrWakeUp,
              AppIcons.sunrise,
            ),
            _NotifItem(
              NotificationKeys.isNotificationWridSleep,
              l10n.notifSettingsLabelThikrSleep,
              AppIcons.moon,
            ),
            _NotifItem(
              NotificationKeys.isNotificationMiddleNight,
              l10n.notifSettingsLabelMiddleNight,
              AppIcons.prayerRug,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupFasting,
          [
            _NotifItem(
              NotificationKeys.isNotificationFasting,
              l10n.notifSettingsLabelFasting,
              AppIcons.calendar,
            ),
            _NotifItem(
              NotificationKeys.isNotificationFastingMonday,
              l10n.notifSettingsLabelFastingMonday,
              AppIcons.calendar,
            ),
            _NotifItem(
              NotificationKeys.isNotificationFastingThursday,
              l10n.notifSettingsLabelFastingThursday,
              AppIcons.calendar,
            ),
          ],
        ),
        _NotifGroup(
          l10n.notifSettingsGroupRecurringAdhkar,
          [
            const _NotifItem(
              NotificationKeys.isNotificationAstgferAllh,
              'استغفر الله',
              AppIcons.tasbih,
            ),
            const _NotifItem(
              NotificationKeys.isNotificationHasbnaAllh,
              'حسبنا الله',
              AppIcons.allah,
            ),
            const _NotifItem(
              NotificationKeys.isNotificationLahawlaWlaquoah,
              'لا حول ولا قوة إلا بالله',
              AppIcons.tasbih,
            ),
            const _NotifItem(
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
      title: context.l10n.settingsNotificationsTitle,
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
            title: context.l10n.notifSettingsMasterTitle,
            subtitle: master.enabled
                ? context.l10n.notifSettingsMasterOnSubtitle
                : context.l10n.notifSettingsMasterOffSubtitle,
            trailing: SettingsSwitch(
              value: master.enabled,
              onChanged: (value) => context
                  .read<SettingNotificationBloc>()
                  .add(ToggleNotification(master.key, value)),
            ),
          ),
        SettingsGroup(
          title: context.l10n.notifSettingsGroupSystem,
          children: [
            SettingsRow(
              icon: AppIcons.layers,
              title: context.l10n.notifSettingsSystemTitle,
              subtitle: context.l10n.notifSettingsSystemSubtitle,
              isLast: true,
              onTap: () => context.push(const SystemNotificationScreen()),
            ),
          ],
        ),
        for (final group in _groups(context.l10n))
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
