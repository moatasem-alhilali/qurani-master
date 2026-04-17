import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';

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
    final borderRadius = BorderRadius.circular(16.r);
    final accent = context.primaryColor;
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.05);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardBackground,
            cardBackgroundSoft,
          ],
        ),
        border: Border.all(
          color: cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned(
              bottom: -12.h,
              right: -12.w,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.activeNotification?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: context.onSurfaceColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.activeNotification?.body ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.onSurfaceVariant.withValues(alpha: 0.8),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    decoration: BoxDecoration(
                      color: context.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
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
                        color: context.errorColor,
                      ),
                      padding: EdgeInsets.all(8.w),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
