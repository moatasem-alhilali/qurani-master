import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quran_app/core/components/animation_list.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/home_screen/widgets/next_player.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer.dart';
import 'package:quran_app/features/prayer_time/widgets/time_line_picker.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrayerTimeScreen extends StatefulWidget {
  PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  String selectedDateTime = "";
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      customAppBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              "أوقات الصلاة ",
              style: titleMedium(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //!date time
                // const TimeLinePicker(),

                //next player
                const NextPlayer(),

                //!time line
                BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
                  builder: (context, state) {
                    if (state is PrayerTimeLoadingState) {
                      return const _shimmerEffect();
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //set the color to the next player
                        var data = prayerData[index];
                        return BaseAnimationListView(
                          index: index,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  index == 0
                                      ? Container()
                                      : SizedBox(
                                          height: 20.0,
                                          child: SolidLineConnector(
                                            color: prayerData[index].color,
                                          ),
                                        ),
                                  nextCurrentPrayer == index
                                      ? DotIndicator(
                                          color: prayerData[index].color,
                                          size: 20,
                                        )
                                      : OutlinedDotIndicator(
                                          color: prayerData[index].color,
                                          size: 20,
                                        ),
                                  index == 4
                                      ? Container()
                                      : SizedBox(
                                          height: 20.0,
                                          child: SolidLineConnector(
                                            color: prayerData[index].color,
                                          ),
                                        ),
                                ],
                              ).animate().fadeIn(),
                        
                              //
                              ItemPrayer(
                                nextPray: data,
                                data: data,
                                index: index,
                                nextCurrent: nextCurrentPrayer,
                              )
                            ],
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: 6,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _shimmerEffect extends StatelessWidget {
  const _shimmerEffect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
