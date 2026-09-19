import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_active_notification_item_widget.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_notification_item_widget.dart';
import 'package:quran_app/l10n/l10n.dart';

/// إشعارات النظام: مجموعتان — ما هو مجدول، وما هو ظاهر الآن.
class SystemNotificationScreen extends StatelessWidget {
  const SystemNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: context.l10n.notifSettingsSystemTitle,
      children: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return state.pendingNotificationsState.handle<Object>(
              context: context,
              onSuccess: () => _buildBody(context, state),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, NotificationState state) {
    final pending = state.pendingNotifications;
    final active = state.activeNotifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroup(
          title: context.l10n.notifSettingsScheduledGroup,
          children: [
            if (pending.isEmpty)
              SettingsHint(context.l10n.notifSettingsNoScheduled)
            else
              for (var i = 0; i < pending.length; i++)
                SystemNotificationItemWidget(
                  pendingNotification: pending[i],
                  isLast: i == pending.length - 1,
                ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.notifSettingsShownNowGroup,
          children: [
            if (active.isEmpty)
              SettingsHint(context.l10n.notifSettingsNoShown)
            else
              for (var i = 0; i < active.length; i++)
                SystemActiveNotificationItemWidget(
                  activeNotification: active[i],
                  isLast: i == active.length - 1,
                ),
          ],
        ),
      ],
    );
  }
}
