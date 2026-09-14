part of 'prayer_time_timeline.dart';

/// تنبيه الموقع: سطر واحد ورابط إجراء — بلا صندوق ملوّن.
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
    final skin = AppSkin.of(context);
    final actionLabel = type == PrayerLocationNoticeType.serviceDisabled
        ? 'تفعيل الموقع'
        : 'منح الصلاحية';

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineIconChip(
            icon: type == PrayerLocationNoticeType.serviceDisabled
                ? AppIcons.location
                : AppIcons.shield,
            skin: skin,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                if (onResolve != null)
                  InkWell(
                    onTap: onResolve,
                    borderRadius: BorderRadius.circular(999.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      child: Column(
        children: [
          AppIcon(AppIcons.clock, color: skin.accent, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            'لا يمكن عرض مواقيت الصلاة قبل تحديد المنطقة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'اختر مدينة يدويًا أو استخدم موقع الجهاز الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: onChangeLocation,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Text(
                'اختيار منطقة',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
