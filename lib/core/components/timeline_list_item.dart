import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

enum TimelineItemStatus {
  completed,
  active,
  upcoming,
  inactive,
}

class TimelineListItem extends StatelessWidget {
  const TimelineListItem({
    required this.title,
    this.icon,
    this.iconWidget,
    this.iconBackgroundColor,
    this.subtitle,
    this.time,
    this.status = TimelineItemStatus.upcoming,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.timelineColor,
    this.dotColor,
    this.lineColor,
    this.padding,
    this.margin,
    this.customTrailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? time;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? iconBackgroundColor;
  final TimelineItemStatus status;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? timelineColor;
  final Color? dotColor;
  final Color? lineColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? customTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Content
          Expanded(
            child: Container(
              padding: padding ?? EdgeInsets.symmetric(vertical: 12.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? _getBackgroundColor(context),
                      borderRadius: BorderRadius.circular(12.r),
                      border: status == TimelineItemStatus.active
                          ? Border.all(
                              color: _getStatusColor(context),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: iconBackgroundColor ??
                                _getIconBackgroundColor(context),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: iconWidget ??
                              Icon(
                                icon,
                                color: iconColor ?? _getStatusColor(context),
                                size: 20.sp,
                              ),
                        ),

                        SizedBox(width: 12.w),

                        // Title and Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              title.autoSize(
                                context,
                                color: titleColor ?? _getTitleColor(context),
                                fontSize: 16,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                              if (subtitle != null) ...[
                                SizedBox(height: 2.h),
                                subtitle!.autoSize(
                                  context,
                                  color: subtitleColor ??
                                      _getSubtitleColor(context),
                                  fontSize: 12,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Time
                        if (time != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getTimeBackgroundColor(context),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: time!.autoSize(
                              context,
                              color: _getTimeTextColor(context),
                              fontSize: 11,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],

                        // Custom trailing
                        if (customTrailing != null) ...[
                          SizedBox(width: 8.w),
                          customTrailing!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Right side - Timeline
          Container(
            width: 24.w,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: [
                // Top line
                if (!isFirst)
                  Container(
                    width: 2.w,
                    height: 20.h,
                    color: lineColor ?? context.gray4,
                  ),

                // Timeline dot
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: dotColor ?? _getTimelineDotColor(context),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.primaryColor,
                      width: 2.w,
                    ),
                  ),
                  child: status == TimelineItemStatus.completed
                      ? Icon(
                          Icons.check,
                          color: context.onPrimaryColor,
                          size: 8.sp,
                        )
                      : null,
                ),

                // Bottom line
                if (!isLast)
                  Container(
                    width: 2.w,
                    height: 40.h, // Fixed height instead of Expanded
                    color: lineColor ?? context.gray4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return context.primaryColor.withOpacity(0.1);
      case TimelineItemStatus.completed:
        return context.gray6;
      case TimelineItemStatus.upcoming:
        return context.secondaryColor;
      case TimelineItemStatus.inactive:
        return context.gray6;
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return context.primaryColor;
      case TimelineItemStatus.completed:
        return Colors.green;
      case TimelineItemStatus.upcoming:
        return context.primaryColor;
      case TimelineItemStatus.inactive:
        return context.gray2;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    return _getStatusColor(context).withOpacity(0.2);
  }

  Color _getTitleColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return context.primaryColor;
      case TimelineItemStatus.completed:
        return context.gray1;
      case TimelineItemStatus.upcoming:
        return context.primaryColor;
      case TimelineItemStatus.inactive:
        return context.gray2;
    }
  }

  Color _getSubtitleColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return context.gray1;
      case TimelineItemStatus.completed:
        return context.gray2;
      case TimelineItemStatus.upcoming:
        return context.gray1;
      case TimelineItemStatus.inactive:
        return context.gray3;
    }
  }

  Color _getTimeBackgroundColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return _getStatusColor(context).withOpacity(0.2);
      case TimelineItemStatus.completed:
        return Colors.green.withOpacity(0.2);
      case TimelineItemStatus.upcoming:
        return context.gray5;
      case TimelineItemStatus.inactive:
        return context.gray5;
    }
  }

  Color _getTimeTextColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return _getStatusColor(context);
      case TimelineItemStatus.completed:
        return Colors.green;
      case TimelineItemStatus.upcoming:
        return context.gray1;
      case TimelineItemStatus.inactive:
        return context.gray2;
    }
  }

  Color _getTimelineDotColor(BuildContext context) {
    switch (status) {
      case TimelineItemStatus.active:
        return context.primaryColor;
      case TimelineItemStatus.completed:
        return Colors.green;
      case TimelineItemStatus.upcoming:
        return context.gray3;
      case TimelineItemStatus.inactive:
        return context.gray4;
    }
  }
}

// Timeline List Widget for managing multiple timeline items
class TimelineList extends StatelessWidget {
  const TimelineList({
    required this.items,
    this.padding,
    this.backgroundColor,
    super.key,
  });

  final List<TimelineListItem> items;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return TimelineListItem(
            title: item.title,
            subtitle: item.subtitle,
            time: item.time,
            icon: item.icon,
            iconWidget: item.iconWidget,
            iconBackgroundColor: item.iconBackgroundColor,
            status: item.status,
            isFirst: index == 0,
            isLast: index == items.length - 1,
            onTap: item.onTap,
            backgroundColor: item.backgroundColor,
            iconColor: item.iconColor,
            titleColor: item.titleColor,
            subtitleColor: item.subtitleColor,
            timelineColor: item.timelineColor,
            dotColor: item.dotColor,
            lineColor: item.lineColor,
            padding: item.padding,
            margin: item.margin,
            customTrailing: item.customTrailing,
          );
        }).toList(),
      ),
    );
  }
}

// Predefined Timeline Item Variants
class TimelineItemVariants {
  static TimelineListItem prayer({
    required String title,
    required IconData icon,
    required String time,
    required TimelineItemStatus status,
    Widget? iconWidget,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    return TimelineListItem(
      title: title,
      subtitle: subtitle,
      time: time,
      icon: icon,
      status: status,
      onTap: onTap,
      iconColor: iconColor,
      iconWidget: iconWidget,
      iconBackgroundColor: iconBackgroundColor,
    );
  }

  static TimelineListItem event({
    required String title,
    required IconData icon,
    required TimelineItemStatus status,
    Widget? iconWidget,
    String? subtitle,
    String? time,
    VoidCallback? onTap,
    Color? iconColor,
    Color? iconBackgroundColor,
    Widget? customTrailing,
  }) {
    return TimelineListItem(
      title: title,
      subtitle: subtitle,
      time: time,
      icon: icon,
      status: status,
      onTap: onTap,
      iconColor: iconColor,
      iconWidget: iconWidget,
      iconBackgroundColor: iconBackgroundColor,
      customTrailing: customTrailing,
    );
  }
}
