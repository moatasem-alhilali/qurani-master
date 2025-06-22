import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/item_prayer.dart';

class CurrentPrayerHomeWidget extends StatefulWidget {
  const CurrentPrayerHomeWidget({super.key});

  @override
  State<CurrentPrayerHomeWidget> createState() =>
      _CurrentPrayerHomeWidgetState();
}

class _CurrentPrayerHomeWidgetState extends State<CurrentPrayerHomeWidget> {
  bool isMaxLine = false;
  final String title = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state.prayerState == RequestState.success &&
            state.currentPrayerModel != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: Text(
                  'الصلاة الحالية',
                  style: titleMedium(context).copyWith(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              BaseAnimate(
                index: 0,
                child: ItemPrayerWidget(
                  currentPrayer: state.currentPrayerModel!,
                  isNavigate: true,
                ),
              ),
            ],
          );
        }

        if (state.prayerState == RequestState.success &&
            state.nextPrayerModel != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: Text(
                  'الصلاة القادمة',
                  style: titleMedium(context).copyWith(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              BaseAnimate(
                index: 0,
                child: ItemPrayerWidget(
                  currentPrayer: state.nextPrayerModel!,
                  isNavigate: true,
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
