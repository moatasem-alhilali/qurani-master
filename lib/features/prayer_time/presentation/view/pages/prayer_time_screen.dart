import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/home/presentation/view/widgets/next_player.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/item_prayer.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:adhan/adhan.dart';

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
                return const _ShimmerEffect();
              }

              final list = state.prayerList;
              final currentType = state.currentPrayer?.type;
              final nextType = state.nextPrayer?.type;

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
                            data: TimePrayerModel(
                              id: 200 + index,
                              title: data.name,
                              time: data.time12,
                              content: data.type.description,
                              image: data.type.imageAsset,
                              color: isCurrent
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            nextPray: isNext
                                ? TimePrayerModel(
                                    title: data.name,
                                    time: data.time12,
                                    content: '',
                                    image: '',
                                    color: Colors.blue,
                                    id: -1,
                                  )
                                : null,
                            index: index,
                            nextCurrent: index,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  const _ShimmerEffect();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: BaseShimmer(
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
