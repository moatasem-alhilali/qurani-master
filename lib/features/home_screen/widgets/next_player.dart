import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';

class NextPlayer extends StatelessWidget {
  const NextPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state is PrayerTimeLoadingState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseShimmer(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    "الصلاة القادمة",
                    style: titleMedium(context)
                        .copyWith(color: ColorsManager.customPrimary),
                  ),
                ),
              ),
              BaseShimmer(
                child: Container(
                  height: SizeConfig.blockSizeVertical! * 12,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ).animate().fade();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text(
                "الصلاة القادمة",
                style: titleMedium(context)
                    .copyWith(color: ColorsManager.customPrimary),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: InkWell(
                onTap: () {
                  PrayerTimeController.setCurrentColorPrayer();

                  navigateTo(PrayerTimeScreen(), context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.yMMMMd("ar").format(
                            DateTime.now(),
                          ),
                          style: titleMedium(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${PrayerTimeController.getNextPrayer().title ?? ""} : ${PrayerTimeController.nextPrayerTime ?? ""}",
                          style: titleSmall(context),
                        ),
                      ],
                    ),
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/lottie/time.json",
                          width: SizeConfig.blockSizeHorizontal! * 20,
                          // height: SizeConfig.blockSizeVertical! * 20,
                          fit: BoxFit.cover,
                        ),
                        PrayerTimeWidget(nextPrayerTime: nextDateTimePrayer!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms);
      },
    );
  }
}

class PrayerTimeWidget extends StatefulWidget {
  final DateTime nextPrayerTime;

  PrayerTimeWidget({required this.nextPrayerTime});

  @override
  _PrayerTimeWidgetState createState() => _PrayerTimeWidgetState();
}

class _PrayerTimeWidgetState extends State<PrayerTimeWidget> {
  StreamController<String>? _remainingTimeController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTimeController = StreamController<String>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = widget.nextPrayerTime.difference(DateTime.now());
      final formattedTime =
          "${remainingTime.inHours}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";
      _remainingTimeController!.add(formattedTime);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _remainingTimeController!.close();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _remainingTimeController!.stream,
      initialData: "00:00:00",
      builder: (context, snapshot) {
        return Text(
          " ${snapshot.data}",
          style: titleSmall(context),
        );
      },
    );
  }
}
