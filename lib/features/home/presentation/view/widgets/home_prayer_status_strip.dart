import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';

class HomePrayerStatusStrip extends StatelessWidget {
  const HomePrayerStatusStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        if (state.prayerState != RequestState.success ||
            state.nextPrayer == null) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<int>(
          stream: Stream<int>.periodic(const Duration(seconds: 1), (v) => v),
          initialData: 0,
          builder: (context, _) {
            final now = _resolveLocationNow(state);
            final prayerName =
                state.currentPrayer?.name ?? state.nextPrayer!.name;
            final remaining = state.nextPrayer!.time.difference(now);
            final safeRemaining =
                remaining.isNegative ? Duration.zero : remaining;
            final gregorian = DateFormat('y/M/d').format(now);
            final time =
                '${DateFormat('hh:mm').format(now)} ${_periodArabic(now)}';
            final hijri = _HijriDate.fromDate(now).formatArabic();
            final location = state.selectedLocation?.label ?? 'الموقع';
            final countdown = '-${_formatDuration(safeRemaining)}';

            return Container(
              margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF262B33),
                    Color(0xFF171A1F),
                  ],
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFF3A404A),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            '$gregorian  $time  $prayerName  $countdown',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            '$hijri  $location',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4E9D37),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
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

  String _periodArabic(DateTime date) {
    return date.hour < 12 ? 'ص' : 'م';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _HijriDate {
  _HijriDate(this.day, this.month, this.year);

  factory _HijriDate.fromDate(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    final julianDay = date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;

    var l = julianDay - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    return _HijriDate(day, month, year);
  }

  final int day;
  final int month;
  final int year;

  static const _months = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  String formatArabic() {
    final monthName = _months[(month - 1).clamp(0, _months.length - 1)];
    return '$day $monthName $year هـ';
  }
}
