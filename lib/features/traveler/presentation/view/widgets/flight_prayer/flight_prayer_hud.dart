import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';

class FlightPrayerHud extends StatelessWidget {
  const FlightPrayerHud({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final timeline = state is FlightPrayerSuccess
            ? state.result
            : context.read<FlightPrayerBloc>().lastResult;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                context.primaryColor.withValues(alpha: 0.92),
                context.primaryColor.withValues(alpha: 0.72),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.24),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeline == null
                          ? 'اكتب رقم الرحلة أو استخدم زر البحث العلوي'
                          : 'الرحلة: ${timeline.track.flightNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.6.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      timeline == null
                          ? 'تحليل المواقيت على طول مسار الرحلة'
                          : '${timeline.track.originLabel} ⟶ '
                              '${timeline.track.destinationLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 11.2.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (timeline != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${timeline.prayerEvents.length} مواقيت',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
