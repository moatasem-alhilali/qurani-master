import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';

class NextTimePrayerRemainWidget extends StatelessWidget {
  const NextTimePrayerRemainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state.prayerState != RequestState.success ||
            state.nextPrayer == null) {
          return const SizedBox();
        }

        return PrayerTimeWidget(
          nextPrayerName: state.nextPrayer!.name,
          nextPrayerTime: state.nextPrayer!.time,
          nextPrayerTimeFormatted: state.nextPrayer!.time12,
        );
      },
    );
  }
}

class PrayerTimeWidget extends StatefulWidget {
  const PrayerTimeWidget({
    required this.nextPrayerTime,
    required this.nextPrayerName,
    required this.nextPrayerTimeFormatted,
    super.key,
  });
  final DateTime nextPrayerTime;
  final String nextPrayerName;
  final String nextPrayerTimeFormatted;

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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = widget.nextPrayerTime.difference(DateTime.now());

      final safeRemaining = remaining.isNegative ? Duration.zero : remaining;
      final formatted = _formatDuration(safeRemaining);

      _remainingTimeController!.add(formatted);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingTimeController?.close();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _remainingTimeController!.stream,
      initialData: '00:00:00',
      builder: (context, snapshot) {
        return '  ${widget.nextPrayerName} : ${widget.nextPrayerTimeFormatted}  \n الوقت المتبقي : ${snapshot.data} '
            .autoSize(
          context,
          textAlign: TextAlign.center,
          fontSize: 12.sp,
          // color: context.onPrimary,
        );
      },
    );
  }
}
