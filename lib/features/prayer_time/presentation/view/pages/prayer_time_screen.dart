import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_timeline.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      // titleWidget: const NextTimePrayerRemainWidget(),
      // titleWidget: const SizedBox(),
      // showBackground: false,
      title: 'أوقات الصلاة',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
          //   builder: (context, state) {
          //     if (state.prayerState == RequestState.success &&
          //         state.nextPrayer != null) {
          //       // Calculate remaining time
          //       final remainingTime =
          //           state.nextPrayer!.time.difference(DateTime.now());
          //       final safeRemainingTime =
          //           remainingTime.isNegative ? Duration.zero : remainingTime;

          //       // Create TimePrayerModel from the next prayer
          //       final nextPrayerModel = TimePrayerModel(
          //         id: 999,
          //         title: state.nextPrayer!.name,
          //         time: state.nextPrayer!.time12,
          //         type: state.nextPrayer!.type,
          //         image: state.nextPrayer!.type.imageAsset,
          //         content: state.nextPrayer!.description,
          //         color: Colors.blue,
          //       );

          //       return NextPrayerCountdownWidget(
          //         nextPrayer: nextPrayerModel,
          //         remainingTime: safeRemainingTime,
          //       );
          //     }
          //     return const SizedBox();
          //   },
          // ),
          BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
            builder: (context, state) {
              if (state.prayerState != RequestState.success) {
                return ShimmerSkeletonizerWidget(
                  child:
                      _buildTimelineList(PrayerInfoModel.dummy(), null, null),
                );
              }

              final list = state.prayerList;
              final currentType = state.currentPrayer?.type;
              final nextType = state.nextPrayer?.type;

              return _buildTimelineList(list, currentType, nextType);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(
    List<PrayerInfoModel> list,
    Prayer? currentType,
    Prayer? nextType,
  ) {
    final timelineEntries = list.map((data) {
      final isCurrent = currentType == data.type;
      final isNext = nextType == data.type;
      final isPassed = _isPrayerPassed(data, currentType, list);

      PrayerTimelineStatus status;
      if (isPassed) {
        status = PrayerTimelineStatus.completed;
      } else if (isCurrent) {
        status = PrayerTimelineStatus.current;
      } else if (isNext) {
        status = PrayerTimelineStatus.next;
      } else {
        status = PrayerTimelineStatus.upcoming;
      }

      return PrayerTimelineEntry(
        prayer: data,
        status: status,
        accentColor: _getPrayerColor(data),
      );
    }).toList();

    return BaseAnimate(
      index: 2,
      child: PrayerTimeTimeline(entries: timelineEntries),
    );
  }

  bool _isPrayerPassed(
    PrayerInfoModel prayer,
    Prayer? currentType,
    List<PrayerInfoModel> allPrayers,
  ) {
    if (currentType == null) return false;

    final currentIndex = allPrayers.indexWhere((p) => p.type == currentType);
    final prayerIndex = allPrayers.indexWhere((p) => p.type == prayer.type);

    return prayerIndex < currentIndex;
  }

  Color _getPrayerColor(PrayerInfoModel data) {
    switch (data.type) {
      case Prayer.none:
        return Colors.grey;
      case Prayer.fajr:
        return Colors.blue;
      case Prayer.sunrise:
        return Colors.orange;
      case Prayer.dhuhr:
        return Colors.amber;
      case Prayer.asr:
        return Colors.deepOrange;
      case Prayer.maghrib:
        return Colors.red;
      case Prayer.isha:
        return Colors.indigo;
    }
  }
}
