import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';


class TimelinePrayerCard extends StatelessWidget {
  const TimelinePrayerCard({
    super.key,
    required this.event,
    required this.localTime,
    required this.utcTime,
    required this.onTap,
  });

  final FlightPrayerEvent event;
  final String localTime;
  final String utcTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: context.primaryColor, size: 14.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    event.shortName,
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            _buildTimeRow(context, 'محلي', localTime),
            SizedBox(height: 2.h),
            _buildTimeRow(context, 'جرينتش', utcTime),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(BuildContext context, String prefix, String time) {
    return Row(
      children: [
        Text(
          '$prefix: ',
          style: TextStyle(
            color: context.onSurfaceColor.withValues(alpha: 0.65),
            fontSize: 11.2.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            time,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.2.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
