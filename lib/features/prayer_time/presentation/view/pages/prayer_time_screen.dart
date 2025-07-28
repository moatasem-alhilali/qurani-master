import 'package:adhan/src/prayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/timeline_list_item.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/item_prayer.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_animations.dart';
// import 'package:timelines/timelines.dart';

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
                return ShimmerWidget(
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
    final timelineItems = list.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isCurrent = currentType == data.type;
      final isNext = nextType == data.type;
      final isPassed = _isPrayerPassed(data, currentType, list);

      // Determine timeline status
      TimelineItemStatus status;
      if (isPassed) {
        status = TimelineItemStatus.completed;
      } else if (isCurrent) {
        status = TimelineItemStatus.active;
      } else if (isNext) {
        status = TimelineItemStatus.upcoming;
      } else {
        status = TimelineItemStatus.upcoming;
      }

      return TimelineListItem(
        title: data.name,
        subtitle: data.description,
        time: data.time12,
        iconWidget: PrayerTimeAnimationWidget(
          prayerType: data.type,
          size: 30,
          isActive: isCurrent || isNext,
        ),
        status: status,
        isFirst: index == 0,
        isLast: index == list.length - 1,
        iconColor: _getPrayerColor(data),
        iconBackgroundColor: Colors.transparent,
        backgroundColor: context.surfaceColor,
        // iconBackgroundColor: _getPrayerColor(data),
        onTap: () {
          // Handle prayer item tap if needed
        },
      );
    }).toList();

    return BaseAnimate(
      index: 2,
      child: TimelineList(items: timelineItems),
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

  IconData _getPrayerIcon(PrayerInfoModel data) {
    switch (data.type) {
      case Prayer.fajr:
        return Icons.wb_twilight;
      case Prayer.sunrise:
        return Icons.wb_sunny;
      case Prayer.dhuhr:
        return Icons.wb_sunny_outlined;
      case Prayer.asr:
        return Icons.wb_cloudy;
      case Prayer.maghrib:
        return Icons.wb_incandescent;
      case Prayer.isha:
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerColor(PrayerInfoModel data) {
    switch (data.type) {
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
      default:
        return Colors.grey;
    }
  }

  ListView _buildList(
    List<PrayerInfoModel> list,
    Prayer? currentType,
    Prayer? nextType,
  ) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final data = list[index];
        final isCurrent = currentType == data.type;
        final isNext = nextType == data.type;

        return BaseAnimate(
          index: index + 2,
          child: ItemPrayerWidget(
            currentPrayer: TimePrayerModel(
              id: 200 + index,
              type: data.type,
              title: data.name,
              time: data.time12,
              content: data.type.description,
              image: data.type.imageAsset,
              color: isCurrent ? Colors.blue : Colors.grey.shade300,
            ),
            nextPray: isNext
                ? TimePrayerModel(
                    title: data.name,
                    time: data.time12,
                    content: '',
                    image: '',
                    color: Colors.blue,
                    id: -1,
                    type: data.type,
                  )
                : null,
          ),
        );
      },
    );
  }
}
