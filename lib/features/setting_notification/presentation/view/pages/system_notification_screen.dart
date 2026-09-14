import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_active_notification_item_widget.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_notification_item_widget.dart';

/// إشعارات النظام: مجموعتان — ما هو مجدول، وما هو ظاهر الآن.
class SystemNotificationScreen extends StatelessWidget {
  const SystemNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'إشعارات النظام',
      children: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return state.pendingNotificationsState.handle<Object>(
              context: context,
              onSuccess: () => _buildBody(state),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(NotificationState state) {
    final pending = state.pendingNotifications;
    final active = state.activeNotifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroup(
          title: 'مجدولة',
          children: [
            if (pending.isEmpty)
              const SettingsHint('لا توجد إشعارات مجدولة حالياً')
            else
              for (var i = 0; i < pending.length; i++)
                SystemNotificationItemWidget(
                  pendingNotification: pending[i],
                  isLast: i == pending.length - 1,
                ),
          ],
        ),
        SettingsGroup(
          title: 'ظاهرة الآن',
          children: [
            if (active.isEmpty)
              const SettingsHint('لا توجد إشعارات ظاهرة في شريط الإشعارات')
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
