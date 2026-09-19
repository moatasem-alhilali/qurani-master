part of 'prayer_time_timeline.dart';

/// ترويسة الجدول: تاريخ اليوم وساعته، ثم صفّ الموقع وصلتا الصلاة الحالية
/// والقادمة — كلّها سطور نحيلة بلا صندوق.
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
    final skin = AppSkin.of(context);
    final location = selectedLocation;

    return StreamBuilder<int>(
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
        final hijri = HijriDate.fromDate(locationNow);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.yMMMMEEEEd(context.localeCode)
                              .format(locationNow),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.ink,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '${hijri.format(context.l10n)} · '
                          '${_formatUtcOffset(offsetMinutes)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.78),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      DateFormat('HH:mm:ss', 'en').format(locationNow),
                      style: TextStyle(
                        color: skin.accent,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        fontFeatures: const [ui.FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onChangeLocation,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: skin.hairline)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                child: Row(
                  children: [
                    _TimelineIconChip(icon: AppIcons.mapPin, skin: skin),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            location?.label ??
                                context.l10n.prayerTimeLocationNotSet,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: skin.ink,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            location == null
                                ? context.l10n.prayerTimeLocationPickHint
                                : location.detailsLabel.isEmpty
                                    ? (location.isManual
                                        ? context
                                            .l10n.prayerTimeLocationSourceManual
                                        : context.l10n
                                            .prayerTimeLocationSourceDevice)
                                    : location.detailsLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: onUseCurrentLocation,
                      borderRadius: BorderRadius.circular(999.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: AppIcon(
                          AppIcons.location,
                          color: skin.accent,
                          size: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    AppIcon(
                      AppIcons.forwardFor(context),
                      color: skin.accent,
                      size: 15.sp,
                    ),
                  ],
                ),
              ),
            ),
            if (currentPrayer != null || nextPrayer != null)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 2.h),
                child: Text(
                  [
                    if (currentPrayer != null)
                      context.l10n.prayerTimeCurrentLabel(
                        currentPrayer!.localizedName(context.l10n),
                      ),
                    if (nextPrayer != null)
                      context.l10n.prayerTimeNextLabel(
                        nextPrayer!.localizedName(context.l10n),
                      ),
                  ].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
          ],
        );
      },
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

/// مربّع الأيقونة الصغير — بديل البطاقة حول الصفّ.
class _TimelineIconChip extends StatelessWidget {
  const _TimelineIconChip({required this.icon, required this.skin});

  final HugeIconData icon;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}
