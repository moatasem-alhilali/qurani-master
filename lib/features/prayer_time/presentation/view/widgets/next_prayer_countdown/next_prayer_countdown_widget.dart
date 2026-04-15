import 'dart:async';
import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/setting/presentation/view/pages/setting_screen.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/main_thikr_screen.dart';

part 'next_prayer_countdown_card_logic_part.dart';
part 'next_prayer_countdown_card_part.dart';
part 'next_prayer_countdown_card_widgets_part.dart';
part 'next_prayer_countdown_models_part.dart';
part 'next_prayer_countdown_quick_actions_part.dart';

const _kHeroTop = Color(0xFF2D7E99);
const _kHeroBottom = Color(0xFF1F667F);
const _kHeroDeep = Color(0xFF1A5A71);
const _kAccentGold = Color(0xFFD4B17A);
const _kPanelText = Color(0xFF2F3443);

class NextPrayerCountdownWidget extends StatelessWidget {
  const NextPrayerCountdownWidget({
    this.nextPrayer,
    this.remainingTime,
    this.prayerTimes,
    this.currentPrayerInfo,
    this.nextPrayerInfo,
    this.currentPrayerName,
    this.locationLabel,
    this.utcOffsetMinutes,
    this.useBlocFallback = true,
    super.key,
  }) : assert(
          (nextPrayer == null && remainingTime == null) ||
              (nextPrayer != null && remainingTime != null),
          'nextPrayer and remainingTime must be provided together.',
        );

  final TimePrayerModel? nextPrayer;
  final Duration? remainingTime;
  final List<PrayerInfoModel>? prayerTimes;
  final PrayerInfoModel? currentPrayerInfo;
  final PrayerInfoModel? nextPrayerInfo;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;
  final bool useBlocFallback;

  @override
  Widget build(BuildContext context) {
    final manualPrayer = nextPrayer;
    final manualRemainingTime = remainingTime;
    if (manualPrayer != null && manualRemainingTime != null) {
      return _NextPrayerCountdownCard(
        nextPrayer: manualPrayer,
        remainingTime: manualRemainingTime,
        prayerTimes: prayerTimes ?? const [],
        currentPrayerInfo: currentPrayerInfo,
        nextPrayerInfo: nextPrayerInfo,
        currentPrayerName: currentPrayerName,
        locationLabel: locationLabel,
        utcOffsetMinutes: utcOffsetMinutes,
      );
    }

    if (!useBlocFallback) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        if (state.prayerState != RequestState.success ||
            state.nextPrayer == null) {
          return const SizedBox.shrink();
        }

        final remainingTime =
            state.nextPrayer!.time.difference(_resolveLocationNow(state));
        final safeRemainingTime =
            remainingTime.isNegative ? Duration.zero : remainingTime;

        final nextPrayerModel = TimePrayerModel(
          id: 999,
          title: state.nextPrayer!.name,
          time: state.nextPrayer!.time12,
          type: state.nextPrayer!.type,
          image: state.nextPrayer!.type.imageAsset,
          content: state.nextPrayer!.description,
          color: Colors.blue,
        );

        return _NextPrayerCountdownCard(
          nextPrayer: nextPrayerModel,
          remainingTime: safeRemainingTime,
          prayerTimes: state.prayerList,
          currentPrayerInfo: state.currentPrayer,
          nextPrayerInfo: state.nextPrayer,
          currentPrayerName: state.currentPrayer?.name,
          locationLabel: state.selectedLocation?.label,
          utcOffsetMinutes: state.selectedLocation?.utcOffsetMinutes,
        );
      },
    );
  }

  DateTime _resolveLocationNow(PrayerTimeState state) {
    final offsetMinutes = state.selectedLocation?.utcOffsetMinutes;
    if (offsetMinutes == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
  }
}
