import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/components/location_enable_screen.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/prayer_time/data/text/teme_prayer_text.dart';

import '../../../../../core/services/services_location.dart';

class ItemPrayerHome extends StatelessWidget {
  const ItemPrayerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (!CacheConfig.hasInitLocal && !serviceEnabled) {
          return const LocationEnableScreen();
        }

        return Column(
          children: [
            const BaseHeder(text: "اوقات الصلاة"),
            SizedBox(
              width: double.infinity,
              height: context.getHight(15),
              child: Builder(
                builder: (context) {
                  switch (state.prayerState) {
                    case RequestState.initial:
                    case RequestState.loading:
                    case RequestState.error:
                      return const _Loading();

                    case RequestState.success:
                      final prayers = state.prayerList;
                      final currentType = state.currentPrayer?.type;
                      final nextType = state.nextPrayer?.type;

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: prayers.length,
                        itemBuilder: (context, index) {
                          final data = prayers[index];
                          final isCurrent = data.type == currentType;
                          final isNext = data.type == nextType;

                          return BaseAnimate(
                            index: index,
                            child: _ItemPrayer(
                              data: TimePrayerModel(
                                id: 200 + index,
                                title: data.name,
                                time: data.time12,
                                image: data.type.imageAsset,
                                content: '',
                                color: isCurrent
                                    ? Colors.white
                                    : Colors.grey.shade300,
                              ),
                              nextCurrent: isCurrent,
                              nextPray: isNext
                                  ? TimePrayerModel(
                                      id: -1,
                                      title: '',
                                      time: '',
                                      image: '',
                                      content: '',
                                      color: Colors.transparent,
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ).animate().fade();
      },
    );
  }
}

class _ItemPrayer extends StatefulWidget {
  const _ItemPrayer({
    required this.data,
    required this.nextCurrent,
    this.nextPray,
    super.key,
  });

  final TimePrayerModel data;
  final bool nextCurrent;
  final TimePrayerModel? nextPray;

  @override
  State<_ItemPrayer> createState() => _ItemPrayerState();
}

class _ItemPrayerState extends State<_ItemPrayer> {
  bool isMaxLine = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getWidth(35),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
        border: widget.nextCurrent
            ? Border.all(color: Colors.white, width: 1.5)
            : null,
      ),
      child: InkWell(
        onTap: () {
          context.push(const PrayerTimeScreen());
          setState(() {
            isMaxLine = !isMaxLine;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(widget.data.image),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.data.title,
              style: titleMedium(context),
            ),
            const SizedBox(height: 5),
            Text(
              widget.data.time,
              style: titleMedium(context).copyWith(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < 4; i++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: BaseShimmer(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BaseShimmer(
                    child: Container(
                      height: context.getWidth(2),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: const Text("sfsfs"),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
