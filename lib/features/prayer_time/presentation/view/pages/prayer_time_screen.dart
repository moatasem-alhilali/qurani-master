import 'package:adhan/src/prayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/home/presentation/view/widgets/next_player.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/item_prayer.dart';
import 'package:timelines/timelines.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      titleWidget: const NextTimePrayerRemain(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
            builder: (context, state) {
              if (state.prayerState != RequestState.success) {
                return ShimmerWidget(
                  child: _buildList(PrayerInfoModel.dummy(), null, null),
                );
              }

              final list = state.prayerList;
              final currentType = state.currentPrayer?.type;
              final nextType = state.nextPrayer?.type;

              return _buildList(list, currentType, nextType);
            },
          ),
        ],
      ),
    );
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

        return Row(
          children: [
            Column(
              children: [
                if (index != 0)
                  const SizedBox(
                    height: 20,
                    child: SolidLineConnector(
                      color: Colors.grey,
                    ),
                  ),
                if (isCurrent)
                  const DotIndicator(
                    color: Colors.blue,
                    size: 20,
                  )
                else
                  const OutlinedDotIndicator(
                    color: Colors.grey,
                    size: 20,
                  ),
                if (index != list.length - 1)
                  const SizedBox(
                    height: 20,
                    child: SolidLineConnector(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ).animate().fadeIn(),

            // 📦 المحتوى الجانبي
            Expanded(
              child: BaseAnimate(
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
              ),
            ),
          ],
        );
      },
    );
  }
}
