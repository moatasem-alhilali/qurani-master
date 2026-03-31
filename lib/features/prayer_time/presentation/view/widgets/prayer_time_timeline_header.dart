part of 'prayer_time_timeline.dart';

class _PrayerTimesHeader extends StatelessWidget {
  const _PrayerTimesHeader({
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    this.selectedLocation,
    this.currentPrayer,
    this.nextPrayer,
  });

  final PrayerLocationSelection? selectedLocation;
  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final location = selectedLocation;

    return Container(
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: _alpha(context.outlineVariant, 0.42),
        ),
      ),
      child: StreamBuilder<int>(
        stream: Stream<int>.periodic(
          const Duration(seconds: 1),
          (count) => count,
        ),
        initialData: 0,
        builder: (context, _) {
          final offsetMinutes = location?.utcOffsetMinutes ??
              DateTime.now().timeZoneOffset.inMinutes;
          final locationNow =
              DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
          final hijri = _HijriDate.fromDate(locationNow);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE، d MMMM yyyy',
                            'ar',
                          ).format(locationNow),
                          style: TextStyle(
                            color: _alpha(context.onSurfaceColor, 0.72),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          hijri.formatArabic(),
                          style: TextStyle(
                            color: _alpha(context.onSurfaceColor, 0.52),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: _alpha(context.primaryColor, 0.1),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      _formatUtcOffset(offsetMinutes),
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('hh:mm:ss a', 'en').format(locationNow),
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'الوقت الحالي',
                        style: TextStyle(
                          color: _alpha(context.onSurfaceColor, 0.6),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        (location?.isManual ?? false)
                            ? 'اختيار يدوي'
                            : 'موقع الجهاز',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: _alpha(context.scaffoldBackgroundColor, 0.45),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: _alpha(context.outlineVariant, 0.28),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: _alpha(context.onSurfaceColor, 0.72),
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location?.label ?? 'لم يتم تحديد موقع بعد',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.onSurfaceColor,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            location == null
                                ? 'اختر مدينة أو استخدم موقع الجهاز'
                                    ' لعرض المواقيت'
                                : location.detailsLabel.isEmpty
                                    ? 'المواقيت معروضة حسب المنطقة المحددة'
                                    : location.detailsLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _alpha(context.onSurfaceColor, 0.54),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  FilledButton.icon(
                    onPressed: onChangeLocation,
                    icon: const Icon(Icons.travel_explore_rounded),
                    label: const Text('تغيير المنطقة'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onUseCurrentLocation,
                    icon: const Icon(Icons.my_location_rounded),
                    label: const Text('موقعي الحالي'),
                  ),
                ],
              ),
              if (currentPrayer != null || nextPrayer != null) ...[
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    if (currentPrayer != null)
                      _PrayerInfoChip(
                        label: 'الحالية',
                        value: currentPrayer!.name,
                        tone: currentPrayer!.type == Prayer.maghrib
                            ? Colors.red
                            : context.primaryColor,
                      ),
                    if (nextPrayer != null)
                      _PrayerInfoChip(
                        label: 'القادمة',
                        value: nextPrayer!.name,
                        tone: context.onSurfaceColor,
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _formatUtcOffset(int minutes) {
    final sign = minutes >= 0 ? '+' : '-';
    final absoluteMinutes = minutes.abs();
    final hours = (absoluteMinutes ~/ 60).toString().padLeft(2, '0');
    final mins = (absoluteMinutes % 60).toString().padLeft(2, '0');
    return 'UTC$sign$hours:$mins';
  }
}

class _PrayerInfoChip extends StatelessWidget {
  const _PrayerInfoChip({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _alpha(tone, 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: _alpha(context.onSurfaceColor, 0.62),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: tone,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
