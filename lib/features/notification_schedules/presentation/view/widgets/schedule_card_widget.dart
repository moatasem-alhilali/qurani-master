import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';

class ScheduleCardWidget extends StatelessWidget {
  const ScheduleCardWidget({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  final NotificationScheduleCustomModel schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: schedule.enabled
              ? context.primaryColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Schedule Type Icon
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: schedule.enabled
                          ? context.primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _getScheduleIcon(),
                      color:
                          schedule.enabled ? context.primaryColor : Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Schedule Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getScheduleTitle(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: schedule.enabled
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _getScheduleSubtitle(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Toggle Switch
                  Switch.adaptive(
                    value: schedule.enabled,
                    onChanged: (_) => onToggle(),
                    activeColor: context.primaryColor,
                  ),
                ],
              ),

              if (schedule.label?.isNotEmpty == true) ...[
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    schedule.label!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],

              SizedBox(height: 12.h),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Time Display (if applicable)
                  if (_hasTimeDisplay()) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _getTimeDisplay(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],

                  // Edit Button
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: Colors.blue[600],
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      padding: EdgeInsets.all(8.w),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Delete Button
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20.sp,
                      color: Colors.red[600],
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      padding: EdgeInsets.all(8.w),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getScheduleIcon() {
    switch (schedule.scheduleType) {
      case ScheduleType.daily:
        return Icons.today;
      case ScheduleType.weekly:
        return Icons.date_range;
      case ScheduleType.everyNMinutes:
        return Icons.schedule;
      case ScheduleType.customDates:
        return Icons.event_note;
      default:
        return Icons.schedule;
    }
  }

  String _getScheduleTitle() {
    switch (schedule.scheduleType) {
      case ScheduleType.daily:
        return 'إشعار يومي';
      case ScheduleType.weekly:
        return 'إشعار أسبوعي';
      case ScheduleType.everyNMinutes:
        return 'إشعار دوري';
      case ScheduleType.customDates:
        return 'مواعيد مخصصة';
      default:
        return 'إشعار';
    }
  }

  String _getScheduleSubtitle() {
    switch (schedule.scheduleType) {
      case ScheduleType.daily:
        return 'كل يوم في ${_getTimeDisplay()}';
      case ScheduleType.weekly:
        final days = schedule.weekdays?.map(_arabicDayOfWeek).join('، ') ?? '';
        return 'أيام: $days';
      case ScheduleType.everyNMinutes:
        return 'كل ${schedule.intervalMinutes} دقيقة';
      case ScheduleType.customDates:
        return '${schedule.customDates?.length ?? 0} موعد مخصص';
      default:
        return '';
    }
  }

  bool _hasTimeDisplay() {
    return schedule.scheduleType == ScheduleType.daily ||
        schedule.scheduleType == ScheduleType.weekly;
  }

  String _getTimeDisplay() {
    if (schedule.hour != null && schedule.minute != null) {
      return '${schedule.hour.toString().padLeft(2, '0')}:${schedule.minute.toString().padLeft(2, '0')}';
    }
    return '--:--';
  }

  String _arabicDayOfWeek(int d) {
    switch (d) {
      case 1:
        return 'اثنين';
      case 2:
        return 'ثلاثاء';
      case 3:
        return 'أربعاء';
      case 4:
        return 'خميس';
      case 5:
        return 'جمعة';
      case 6:
        return 'سبت';
      case 7:
        return 'أحد';
      default:
        return '؟';
    }
  }
}
