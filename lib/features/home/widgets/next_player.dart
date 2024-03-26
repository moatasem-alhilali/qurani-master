import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';

class NextTimePrayerRemain extends StatelessWidget {
  const NextTimePrayerRemain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        switch (state.prayerState) {
          case RequestState.defaults:
            return const SizedBox();
          case RequestState.loading:
            return const SizedBox();

          case RequestState.error:
            return const SizedBox();

          case RequestState.success:
            if (nextDateTimePrayer != null) {
              return PrayerTimeWidget(
                nextPrayerTime: nextDateTimePrayer!,
              );
            }
            return const SizedBox();
        }
      },
    );
  }
}

class PrayerTimeWidget extends StatefulWidget {
  final DateTime nextPrayerTime;

  const PrayerTimeWidget({super.key, required this.nextPrayerTime});

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

      // Check if remaining time is negative and set it to zero
      final adjustedTime =
          remainingTime.isNegative ? Duration.zero : remainingTime;

      final formattedTime =
          "${adjustedTime.inHours}:${adjustedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${adjustedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";
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
        return "  ${PrayerTimeController.getNextPrayer().title ?? ""} : ${PrayerTimeController.nextPrayerTime ?? ""}  \n الوقت المتبقي : ${snapshot.data} "
            .autoSize(
          context,
          textAlign: TextAlign.center,
          fontSize: 12,
          color: Colors.grey,
        );
      },
    );
  }
}
