import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_location_picker_sheet.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_timeline.dart';

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
          // BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
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
          BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
            builder: (context, state) {
              final list = state.prayerState == RequestState.loading
                  ? PrayerInfoModel.dummy()
                  : state.prayerList;
              final currentPrayer = state.currentPrayer;
              final nextPrayer = state.nextPrayer;
              final locationNow = _resolveLocationNow(
                state.selectedLocation?.utcOffsetMinutes,
              );

              final content = _buildTimelineList(
                context: context,
                state: state,
                list: list,
                currentPrayer: currentPrayer,
                nextPrayer: nextPrayer,
                locationNow: locationNow,
              );

              if (state.prayerState == RequestState.loading) {
                return ShimmerSkeletonizerWidget(child: content);
              }

              return content;
            },
          ),
          SizedBox(
            height: 50.h,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList({
    required BuildContext context,
    required PrayerTimeState state,
    required List<PrayerInfoModel> list,
    required PrayerInfoModel? currentPrayer,
    required PrayerInfoModel? nextPrayer,
    required DateTime locationNow,
  }) {
    final timelineEntries = list.map((data) {
      final isCurrent = _isSamePrayerOccurrence(data, currentPrayer);
      final isNext = _isSamePrayerOccurrence(data, nextPrayer);
      final isPassed = _isPrayerPassed(
        prayer: data,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        locationNow: locationNow,
      );

      PrayerTimelineStatus status;
      if (isPassed) {
        status = PrayerTimelineStatus.completed;
      } else if (isCurrent) {
        status = PrayerTimelineStatus.current;
      } else if (isNext) {
        status = PrayerTimelineStatus.next;
      } else {
        status = PrayerTimelineStatus.upcoming;
      }

      return PrayerTimelineEntry(
        prayer: data,
        status: status,
        accentColor: _getPrayerColor(data),
      );
    }).toList();

    PrayerLocationNoticeType? noticeType;
    Future<void> Function()? onResolveNotice;

    switch (state.locationStatus) {
      case PrayerLocationStatus.serviceDisabled:
        noticeType = PrayerLocationNoticeType.serviceDisabled;
        onResolveNotice = () => _openLocationSettings(context);
      case PrayerLocationStatus.permissionDenied:
      case PrayerLocationStatus.permissionDeniedForever:
        noticeType = PrayerLocationNoticeType.permissionRequired;
        onResolveNotice = () => _openPermissionSettings(context);
      case PrayerLocationStatus.initial:
      case PrayerLocationStatus.resolving:
      case PrayerLocationStatus.ready:
      case PrayerLocationStatus.error:
        noticeType = null;
        onResolveNotice = null;
    }

    return BaseAnimate(
      index: 2,
      child: PrayerTimeTimeline(
        entries: timelineEntries,
        selectedLocation: state.selectedLocation,
        noticeType: noticeType,
        noticeMessage: state.locationStatusMessage,
        onResolveNotice: onResolveNotice,
        currentPrayer: state.currentPrayer,
        nextPrayer: state.nextPrayer,
        onChangeLocation: () => _openLocationPicker(context, state),
        onUseCurrentLocation: () {
          context.read<PrayerTimeBloc>().add(
                const PrayerTimeUseCurrentDeviceLocationRequested(),
              );
        },
      ),
    );
  }

  Future<void> _openLocationPicker(
    BuildContext context,
    PrayerTimeState state,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return PrayerLocationPickerSheet(
          initialLocation: state.selectedLocation,
          onUseCurrentLocation: () async {
            context.read<PrayerTimeBloc>().add(
                  const PrayerTimeUseCurrentDeviceLocationRequested(),
                );
          },
          onLocationSelected: (selection) async {
            context.read<PrayerTimeBloc>().add(
                  PrayerTimeManualLocationSelected(selection),
                );
          },
        );
      },
    );
  }

  Future<void> _openLocationSettings(BuildContext context) async {
    await Geolocator.openLocationSettings();
    if (!context.mounted) return;
    context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
  }

  Future<void> _openPermissionSettings(BuildContext context) async {
    await openAppSettings();
    if (!context.mounted) return;
    context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
  }

  DateTime _resolveLocationNow(int? utcOffsetMinutes) {
    if (utcOffsetMinutes == null) {
      return DateTime.now();
    }

    return DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes));
  }

  bool _isSamePrayerOccurrence(
    PrayerInfoModel prayer,
    PrayerInfoModel? target,
  ) {
    if (target == null) return false;

    return prayer.type == target.type &&
        prayer.time.year == target.time.year &&
        prayer.time.month == target.time.month &&
        prayer.time.day == target.time.day;
  }

  bool _isPrayerPassed({
    required PrayerInfoModel prayer,
    required PrayerInfoModel? currentPrayer,
    required PrayerInfoModel? nextPrayer,
    required DateTime locationNow,
  }) {
    if (_isSamePrayerOccurrence(prayer, currentPrayer)) return false;
    if (_isSamePrayerOccurrence(prayer, nextPrayer)) return false;

    return prayer.time.isBefore(locationNow);
  }

  Color _getPrayerColor(PrayerInfoModel data) {
    switch (data.type) {
      case Prayer.none:
        return Colors.grey;
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
    }
  }
}
