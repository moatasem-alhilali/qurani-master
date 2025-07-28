import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/theme/theme_data.dart';

class SystemActiveNotificationItemWidget extends StatefulWidget {
  const SystemActiveNotificationItemWidget({
    required this.activeNotification,
    super.key,
  });
  final ActiveNotification? activeNotification;

  @override
  State<SystemActiveNotificationItemWidget> createState() =>
      _SystemActiveNotificationItemWidgetState();
}

class _SystemActiveNotificationItemWidgetState
    extends State<SystemActiveNotificationItemWidget> {
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
                widget.activeNotification?.title ?? '',
                style: titleMedium(context),
              ),
              Text(
                widget.activeNotification?.body ?? '',
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
                      id: widget.activeNotification?.id ?? 0,
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
