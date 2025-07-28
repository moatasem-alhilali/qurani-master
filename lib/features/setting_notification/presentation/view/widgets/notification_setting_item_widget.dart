import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/show_edit_schedule_dialog.dart';

class NotificationSettingItemWidget extends StatefulWidget {
  const NotificationSettingItemWidget({
    required this.setting,
    required this.title,
    required this.iconData,
    required this.isLast,
    super.key,
  });
  final NotificationSettingModel? setting;
  final String title;
  final IconData iconData;
  final bool isLast;

  @override
  State<NotificationSettingItemWidget> createState() =>
      _NotificationSettingItemWidgetState();
}

class _NotificationSettingItemWidgetState
    extends State<NotificationSettingItemWidget> {
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.setting?.enabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
      builder: (context, state) {
        if (widget.setting == null) return const SizedBox();
        return Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: widget.isLast
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  )
                : null,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<SettingNotificationBloc>().add(
                          ToggleNotification(
                            widget.setting!.key,
                            !widget.setting!.enabled,
                          ),
                        );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 28.w,
                              height: 28.w,
                              decoration: BoxDecoration(
                                color: widget.setting!.enabled
                                    ? context.primaryColor
                                    : CupertinoColors.systemGrey4,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                widget.iconData,
                                color: widget.setting!.enabled
                                    ? CupertinoColors.white
                                    : CupertinoColors.systemGrey,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: titleMedium(context).copyWith(
                                  // color: setting.enabled
                                  //     ? context.primaryColor
                                  //     : CupertinoColors.secondaryLabel,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            if (isEnabled) ...[
                              GestureDetector(
                                onTap: () {
                                  context.showBottomSheetUIHeader(
                                    child: BlocProvider.value(
                                      value: context
                                          .read<SettingNotificationBloc>(),
                                      child: ShowEditScheduleDialog(
                                        model: widget.setting!,
                                        onSave: (updated) {
                                          context
                                              .read<SettingNotificationBloc>()
                                              .add(
                                                EditNotificationSchedule(
                                                  widget.setting!.key,
                                                  updated,
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  );
                                  // _showActionMenu(context, widget.setting!);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  child: Icon(
                                    CupertinoIcons.ellipsis_circle,
                                    color: context.primaryColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            CupertinoSwitch(
                              value: isEnabled,
                              activeTrackColor: context.primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  isEnabled = val;
                                });
                                context.read<SettingNotificationBloc>().add(
                                      ToggleNotification(
                                        widget.setting!.key,
                                        val,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                        if (widget.setting!.enabled) ...[
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: context.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              _subtitleFromSchedule(widget.setting!),
                              style: titleMedium(context).copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (!widget.isLast)
                Container(
                  margin: EdgeInsets.only(left: 60.w),
                  height: 0.5.h,
                  color: CupertinoColors.separator,
                ),
            ],
          ),
        );
      },
    );
  }

  void _showActionMenu(BuildContext context, NotificationSettingModel setting) {
    showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'إدارة الإشعار',
          style: titleMedium(context).copyWith(
            fontSize: 20.sp,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              context.push(
                NotificationSchedulesScreen(
                  notifKey: setting.key,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.time,
                  color: context.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'إدارة أوقات التنبيه',
                  style: titleMedium(context).copyWith(
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              context.showBottomSheetUIHeader(
                child: BlocProvider.value(
                  value: context.read<SettingNotificationBloc>(),
                  child: ShowEditScheduleDialog(
                    model: setting,
                    onSave: (updated) {
                      if (context.mounted) {
                        context.read<SettingNotificationBloc>().add(
                              LoadNotificationSettings(),
                            );
                      }
                    },
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.calendar_badge_plus,
                  color: context.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'تعديل جدولة الإشعار',
                  style: titleMedium(context).copyWith(
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _subtitleFromSchedule(NotificationSettingModel s) {
    switch (s.scheduleType) {
      case ScheduleType.daily:
        return 'يومياً الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.hourly:
        return 'كل ساعة عند الدقيقة ${s.minute ?? 0}';
      case ScheduleType.everyNMinutes:
        return 'كل ${s.intervalMinutes ?? 1} دقيقة';
      case ScheduleType.weekly:
        final days = (s.weekdays ?? []).map(_arabicDayOfWeek).join('، ');
        return 'أسبوعياً (${days.isEmpty ? "بدون أيام محددة" : days}) الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.customDates:
        return 'جدولة مخصصة (${s.customDates?.length ?? 0} توقيت)';
    }
  }

  String _formatTime(int? h, int? m) =>
      '${h?.toString().padLeft(2, '0') ?? '--'}:${m?.toString().padLeft(2, '0') ?? '--'}';

  String _arabicDayOfWeek(int d) {
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
