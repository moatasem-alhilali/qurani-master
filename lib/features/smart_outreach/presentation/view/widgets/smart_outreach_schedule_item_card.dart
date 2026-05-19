import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';

class SmartOutreachScheduleItemCard extends StatelessWidget {
  const SmartOutreachScheduleItemCard({
    required this.bundle,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  final SmartOutreachScheduleBundle bundle;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final schedule = bundle.schedule;
    final timeLabel = TimeOfDay(
      hour: schedule.hour,
      minute: schedule.minute,
    ).format(context);
    final daysLabel = schedule.isDaily
        ? 'كل يوم'
        : schedule.scheduleDays.map(_weekdayLabel).join('، ');
    final enabled = schedule.isEnabled;

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(13.w),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: enabled
                ? context.primaryColor.withValues(alpha: 0.25)
                : context.outlineVariant.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.035),
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _IconBubble(
                  icon: enabled ? AppIcons.phone : AppIcons.power,
                  color: enabled ? context.primaryColor : context.onSurfaceVariant,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        schedule.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '$timeLabel • $daysLabel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.onSurfaceVariant,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.78,
                  child: Switch(
                    value: enabled,
                    onChanged: onToggle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetaPill(
                    icon: AppIcons.contacts,
                    label: '${bundle.contacts.length} رقم',
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: _MetaPill(
                    icon: AppIcons.notifications,
                    label: '${schedule.ringTimeout}ث انتظار',
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetaPill(
                    icon: AppIcons.phone,
                    label: '${schedule.hangupDelay}ث بعد الرد',
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: _MetaPill(
                    icon: AppIcons.clock,
                    label: '${schedule.delayBetweenCalls}ث بين الأرقام',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: <Widget>[
                _ActionButton(
                  label: 'ابدأ',
                  icon: AppIcons.play,
                  filled: true,
                  onTap: onStart,
                ),
                SizedBox(width: 7.w),
                _ActionButton(
                  label: 'تعديل',
                  icon: AppIcons.edit,
                  onTap: onTap,
                ),
                const Spacer(),
                _IconAction(
                  icon: AppIcons.delete,
                  color: context.errorColor,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _weekdayLabel(int day) {
    switch (day) {
      case 1:
        return 'الإثنين';
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
        return '$day';
    }
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
  });

  final HugeIconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.w,
      height: 38.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: AppIcon(
        icon,
        color: color,
        size: 16.sp,
        strokeWidth: 1.55,
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
  });

  final HugeIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: <Widget>[
          AppIcon(
            icon,
            size: 12.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(11.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: filled
              ? context.primaryColor
              : context.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              icon,
              size: 12.sp,
              color: filled ? context.onPrimaryColor : context.primaryColor,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                color: filled ? context.onPrimaryColor : context.primaryColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final HugeIconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(11.r),
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: AppIcon(
          icon,
          size: 14.sp,
          color: color,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}
