import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/attempts_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/hint_tile.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/stat_pill.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/timeline_prayer_card.dart';

class FlightPrayerCommandPanel extends StatelessWidget {
  const FlightPrayerCommandPanel({
    required this.controller,
    required this.onSearch,
    required this.onMoveMapTo,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final void Function(LatLng center, double zoom) onMoveMapTo;

  String _formatLocal(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatUtc(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final isSearching = state is FlightPrayerLoading;
        String? errorMessage;
        if (state is FlightPrayerFailure) {
          errorMessage = state.errorMessage;
        }

        final timeline = state is FlightPrayerSuccess
            ? state.result
            : context.read<FlightPrayerBloc>().lastResult;
        final hasResult = timeline != null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
          decoration: BoxDecoration(
            color: context.scaffoldBackgroundColor.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: context.outlineVariant.withValues(alpha: 0.34),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.flight_rounded,
                    color: context.primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'محرك الرحلات والمواقيت',
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  AttemptsBadge(
                    value: state.remainingAttempts,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => onSearch(),
                      decoration: InputDecoration(
                        hintText: 'رقم الرحلة (مثال: EK202)',
                        filled: true,
                        fillColor: context.surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 52.h,
                    child: FilledButton.tonalIcon(
                      onPressed: isSearching ? null : onSearch,
                      icon: isSearching
                          ? SizedBox(
                              width: 15.w,
                              height: 15.w,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : const Icon(Icons.search_rounded),
                      label: const Text('تشغيل'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (errorMessage != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: context.errorColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'أدخل رقم الرحلة لتحليل المواقيت على طول المسار.',
                    style: TextStyle(
                      color: context.onSurfaceColor.withValues(alpha: 0.65),
                      fontSize: 11.8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (hasResult) ...[
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    StatPill(
                      label: 'الرحلة',
                      value: timeline.track.flightNumber,
                      color: context.primaryColor,
                    ),
                    StatPill(
                      label: 'من',
                      value: timeline.track.originLabel,
                      color: context.onSurfaceColor,
                    ),
                    StatPill(
                      label: 'إلى',
                      value: timeline.track.destinationLabel,
                      color: context.onSurfaceColor,
                    ),
                    StatPill(
                      label: 'المصدر',
                      value: timeline.track.sourceLabel,
                      color: context.primaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildPrayerTimeline(context, timeline),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimeline(
      BuildContext context, FlightPrayerTimelineResult timeline) {
    final events = timeline.prayerEvents;

    if (events.isEmpty) {
      return const HintTile(
        icon: Icons.info_outline_rounded,
        text: 'لم تظهر مواقيت ضمن مدة هذه الرحلة.',
      );
    }

    return SizedBox(
      height: 106.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final event = events[index];
          return TimelinePrayerCard(
            event: event,
            localTime: _formatLocal(event.eventLocal),
            utcTime: _formatUtc(event.eventUtc),
            onTap: () => onMoveMapTo(
              LatLng(event.latitude, event.longitude),
              7.3,
            ),
          );
        },
      ),
    );
  }
}
