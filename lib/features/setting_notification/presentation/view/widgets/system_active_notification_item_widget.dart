import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// صفّ إشعار نظام ظاهر الآن في شريط الإشعارات.
class SystemActiveNotificationItemWidget extends StatelessWidget {
  const SystemActiveNotificationItemWidget({
    required this.activeNotification,
    this.isLast = false,
    super.key,
  });

  final ActiveNotification? activeNotification;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final notification = activeNotification;
    if (notification == null) {
      return const SizedBox.shrink();
    }

    return SettingsRow(
      icon: AppIcons.notifications,
      title: notification.title ?? 'إشعار بلا عنوان',
      subtitle: notification.body ?? '',
      isLast: isLast,
      trailing: SettingsIconButton(
        icon: AppIcons.delete,
        tooltip: 'إخفاء الإشعار',
        color: AppColors.error,
        onTap: () => context.read<NotificationBloc>().add(
              CancelPendingNotificationEvent(id: notification.id ?? 0),
            ),
      ),
    );
  }
}
