import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// سطر حالة الرحلة تحت الخريطة مباشرة.
///
/// كان لوحة بتدرّج لوني وظلّ تطفو فوق الخريطة وتحجب المسار. صار صفًّا
/// نحيلًا على الأرضية: الخريطة تبقى للخريطة، والنصّ للنصّ.
class FlightPrayerHud extends StatelessWidget {
  const FlightPrayerHud({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final timeline = state is FlightPrayerSuccess
            ? state.result
            : context.read<FlightPrayerBloc>().lastResult;

        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: skin.hairline)),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
          child: Row(
            children: [
              const TravelerIconChip(icon: AppIcons.flight),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeline == null
                          ? 'لم تُحمَّل رحلة بعد'
                          : 'الرحلة ${timeline.track.flightNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      timeline == null
                          ? 'أدخل رقم الرحلة لرسم المواقيت على المسار'
                          : '${timeline.track.originLabel}'
                              ' ← ${timeline.track.destinationLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (timeline != null) ...[
                SizedBox(width: 8.w),
                TravelerTagChip(
                  label: '${timeline.prayerEvents.length} مواقيت',
                  emphasised: true,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
