import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/components/location_enable_screen.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';

import '../../../core/services/services_location.dart';

class ItemPrayerHome extends StatelessWidget {
  const ItemPrayerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        return !serviceEnabled
            ? const LocationEnableScreen()
            : Column(
                children: [
                  const BaseHeder(text: "اوقات الصلاة"),
                  SizedBox(
                    width: double.infinity,
                    height: context.getHight(15),
                    child: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
                      builder: (context, state) {
                        switch (state.prayerState) {
                          case RequestState.defaults:
                            return const _Loading();

                          case RequestState.loading:
                            return const _Loading();

                          case RequestState.error:
                            return const _Loading();
                          case RequestState.success:
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                //set the color to the next player
                                var data = prayerData[index];
                                return BaseAnimate(
                                  index: index,
                                  child: _ItemPrayer(
                                    nextPray: data,
                                    data: data,
                                    index: index,
                                    nextCurrent: nextCurrentPrayer,
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              itemCount: 6,
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
    required this.index,
    required this.nextPray,
  });
  final TimePrayerModel data;
  final TimePrayerModel nextPray;
  final int index;
  final int nextCurrent;

  @override
  State<_ItemPrayer> createState() => _ItemPrayerState();
}

class _ItemPrayerState extends State<_ItemPrayer> {
  bool isMaxLine = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
        border: widget.nextCurrent == widget.index
            ? Border.all(color: Colors.white)
            : null,
      ),
      child: InkWell(
        onTap: () {
          context.push(const PrayerTimeScreen());
          isMaxLine = !isMaxLine;
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.data.image,
                ),
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
