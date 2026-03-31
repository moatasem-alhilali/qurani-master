part of 'prayer_time_timeline.dart';

class _PrayerLocationNotice extends StatelessWidget {
  const _PrayerLocationNotice({
    required this.type,
    required this.message,
    this.onResolve,
  });

  final PrayerLocationNoticeType type;
  final String message;
  final Future<void> Function()? onResolve;

  @override
  Widget build(BuildContext context) {
    final actionLabel = type == PrayerLocationNoticeType.serviceDisabled
        ? 'تفعيل الموقع'
        : 'منح الصلاحية';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: _alpha(context.primaryColor, 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _alpha(context.primaryColor, 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: _alpha(context.primaryColor, 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              type == PrayerLocationNoticeType.serviceDisabled
                  ? Icons.location_off_rounded
                  : Icons.lock_open_rounded,
              color: context.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          if (onResolve != null) ...[
            SizedBox(width: 12.w),
            TextButton(
              onPressed: () => onResolve!.call(),
              child: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrayerEmptyState extends StatelessWidget {
  const _PrayerEmptyState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: _alpha(context.outlineVariant, 0.38),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 34.sp,
            color: _alpha(context.onSurfaceColor, 0.5),
          ),
          SizedBox(height: 10.h),
          Text(
            'لا يمكن عرض مواقيت الصلاة قبل تحديد المنطقة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'اختر مدينة يدويًا أو استخدم موقع الجهاز الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _alpha(context.onSurfaceColor, 0.54),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14.h),
          FilledButton.icon(
            onPressed: onChangeLocation,
            icon: const Icon(Icons.travel_explore_rounded),
            label: const Text('اختيار منطقة'),
          ),
        ],
      ),
    );
  }
}
