import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// صفّ إشعار نظام مجدول: عنوانه ونصّه وزر إلغائه.
class SystemNotificationItemWidget extends StatelessWidget {
  const SystemNotificationItemWidget({
    required this.pendingNotification,
    this.isLast = false,
    super.key,
  });

  final PendingNotificationRequest? pendingNotification;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final notification = pendingNotification;
    if (notification == null) {
      return const SizedBox.shrink();
    }

    return SettingsRow(
      icon: AppIcons.clock,
      title: notification.title ?? context.l10n.notifSettingsUntitled,
      subtitle: notification.body ?? '',
      isLast: isLast,
      trailing: SettingsIconButton(
        icon: AppIcons.delete,
        tooltip: context.l10n.notifSettingsCancelNotification,
        color: AppColors.error,
        onTap: () => context.read<NotificationBloc>().add(
              CancelPendingNotificationEvent(id: notification.id),
            ),
      ),
    );
  }
}
