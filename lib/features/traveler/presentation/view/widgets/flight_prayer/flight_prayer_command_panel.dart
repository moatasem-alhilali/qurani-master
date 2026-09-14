import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/attempts_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_detail_row.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_journey_rail.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/hint_tile.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// جسم شاشة الطيران تحت الخريطة: البحث، ثم تفاصيل الرحلة، ثم خطّ زمنها.
///
/// كان لوحة عائمة بنصف قطر ٢٢ وظلّ ثقيل تغطّي ثلث الخريطة. صار محتوى
/// الصفحة نفسه: أقسام مفصولة بعناوين وخطوط شعرة.
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

  void _submit() {
    HapticFeedback.selectionClick();
    onSearch();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final isSearching = state is FlightPrayerLoading;
        final errorMessage =
            state is FlightPrayerFailure ? state.errorMessage : null;

        final timeline = state is FlightPrayerSuccess
            ? state.result
            : context.read<FlightPrayerBloc>().lastResult;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSectionHeader(title: 'ابحث برقم الرحلة'),
            Padding(
              padding: AppSkin.gutter,
              child: Row(
                children: [
                  Expanded(child: _FlightNumberField(controller: controller)),
                  SizedBox(width: 8.w),
                  TravelerPillButton(
                    label: 'تشغيل',
                    icon: AppIcons.search,
                    filled: true,
                    busy: isSearching,
                    onTap: _submit,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: AppSkin.gutter,
              child: HintTile(
                icon: errorMessage == null ? AppIcons.compass : AppIcons.error,
                text: errorMessage ??
                    'اكتب رقم الرحلة لنحسب مواقيت الصلاة على طول المسار.',
                isError: errorMessage != null,
              ),
            ),
            SizedBox(height: 9.h),
            Padding(
              padding: AppSkin.gutter,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: AttemptsBadge(value: state.remainingAttempts),
              ),
            ),
            if (timeline != null) ...[
              skin.divider(),
              const HomeSectionHeader(title: 'تفاصيل الرحلة'),
              Padding(
                padding: AppSkin.gutter,
                child: Column(
                  children: [
                    FlightDetailRow(
                      label: 'رقم الرحلة',
                      value: timeline.track.flightNumber,
                      emphasised: true,
                    ),
                    FlightDetailRow(
                      label: 'من',
                      value: timeline.track.originLabel,
                    ),
                    FlightDetailRow(
                      label: 'إلى',
                      value: timeline.track.destinationLabel,
                    ),
                    FlightDetailRow(
                      label: 'مصدر البيانات',
                      value: timeline.track.sourceLabel,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              skin.divider(),
              const HomeSectionHeader(title: 'خطّ زمن الرحلة'),
              Padding(
                padding: AppSkin.gutter,
                child: _Timeline(
                  timeline: timeline,
                  onMoveMapTo: onMoveMapTo,
                ),
              ),
            ],
            SizedBox(height: 18.h),
          ],
        );
      },
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.timeline, required this.onMoveMapTo});

  final FlightPrayerTimelineResult timeline;
  final void Function(LatLng center, double zoom) onMoveMapTo;

  @override
  Widget build(BuildContext context) {
    if (timeline.prayerEvents.isEmpty && timeline.track.trackPoints.isEmpty) {
      return const HintTile(
        icon: AppIcons.clock,
        text: 'لم تظهر مواقيت ضمن مدة هذه الرحلة.',
      );
    }

    return FlightJourneyRail(
      timeline: timeline,
      onFocusPoint: onMoveMapTo,
    );
  }
}

/// حقل رقم الرحلة: حدّ شعرة يتحوّل إلى حدّ مميّز عند التركيز.
class _FlightNumberField extends StatelessWidget {
  const _FlightNumberField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.characters,
      cursorColor: skin.accent,
      onSubmitted: (_) {
        HapticFeedback.selectionClick();
        context
            .read<FlightPrayerBloc>()
            .add(SearchFlightEvent(controller.text));
      },
      style: TextStyle(
        color: skin.ink,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        hintText: 'مثال: EK202',
        hintStyle: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.6),
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        border: border(skin.hairline, 1),
        enabledBorder: border(skin.hairline, 1),
        focusedBorder: border(skin.raisedBorder, 1.2),
      ),
    );
  }
}
