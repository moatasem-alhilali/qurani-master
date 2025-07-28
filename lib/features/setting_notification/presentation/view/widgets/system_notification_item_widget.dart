import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/theme/theme_data.dart';

class SystemNotificationItemWidget extends StatefulWidget {
  const SystemNotificationItemWidget({
    required this.pendingNotification,
    super.key,
  });
  final PendingNotificationRequest? pendingNotification;

  @override
  State<SystemNotificationItemWidget> createState() =>
      _SystemNotificationItemWidgetState();
}

class _SystemNotificationItemWidgetState
    extends State<SystemNotificationItemWidget> {
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pendingNotification?.title ?? '',
                style: titleMedium(context),
              ),
              Text(
                widget.pendingNotification?.body ?? '',
                style: titleMedium(context).copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.read<NotificationBloc>().add(
                    CancelPendingNotificationEvent(
                      id: widget.pendingNotification?.id ?? 0,
                    ),
                  );
            },
            icon: Icon(
              CupertinoIcons.xmark,
              size: 20.sp,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
