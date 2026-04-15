part of 'next_prayer_countdown_widget.dart';

class _NextPrayerHeroCard extends StatelessWidget {
  const _NextPrayerHeroCard({
    required this.locationLabel,
    required this.hijriText,
    required this.clockText,
    required this.nextPrayerText,
    required this.countdownText,
    required this.prayerEntries,
    required this.onSettingsTap,
    this.notice,
  });

  final String locationLabel;
  final String hijriText;
  final String clockText;
  final String nextPrayerText;
  final String countdownText;
  final List<_PrayerMiniEntry> prayerEntries;
  final VoidCallback onSettingsTap;
  final _LocationNoticeConfig? notice;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(22.r),
        ),
        boxShadow: [
          BoxShadow(
            color: _kHeroDeep.withValues(alpha: 0.22),
            blurRadius: 22.r,
            offset: Offset(0, 11.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(22.r),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_kHeroTop, _kHeroBottom],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -36.h,
              left: -20.w,
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kAccentGold.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              top: -45.h,
              right: -50.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kAccentGold.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -70.h,
              left: -30.w,
              child: Container(
                width: 210.w,
                height: 210.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kPanelText.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _kAccentGold.withValues(alpha: 0.06),
                      _kHeroDeep.withValues(alpha: 0.38),
                    ],
                    stops: const [0.12, 1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w,
                (12.h + topInset).clamp(12.h, 72.h),
                14.w,
                70.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _kAccentGold.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(
                                color: _kAccentGold.withValues(alpha: 0.42),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: _kAccentGold.withValues(alpha: 0.96),
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    locationLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: _kAccentGold,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(width: 8.w),
                        // const _HeaderActionIcon(icon: Icons.search_rounded),
                        SizedBox(width: 20.w),
                        // const _HeaderActionIcon(
                        //   icon: Icons.notifications_none_rounded,
                        // ),
                        SizedBox(width: 6.w),
                        _HeaderActionIcon(
                          icon: Icons.settings_outlined,
                          onTap: onSettingsTap,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    hijriText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kAccentGold.withValues(alpha: 0.96),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      clockText,
                      style: TextStyle(
                        color: _kAccentGold,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    nextPrayerText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kAccentGold.withValues(alpha: 0.94),
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    countdownText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kAccentGold.withValues(alpha: 0.90),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 1,
                    color: _kAccentGold.withValues(alpha: 0.34),
                  ),
                  SizedBox(height: 9.h),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Row(
                      children: prayerEntries
                          .map(
                            (entry) => Expanded(
                              child: _PrayerTimeMiniTile(
                                entry: entry,
                                icon: _iconForPrayer(entry.type),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (notice != null) ...[
                    SizedBox(height: 12.h),
                    _LocationNoticeCard(notice: notice!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationNoticeCard extends StatelessWidget {
  const _LocationNoticeCard({required this.notice});

  final _LocationNoticeConfig notice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: _kAccentGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _kAccentGold.withValues(alpha: 0.26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notice.message,
            style: TextStyle(
              color: _kAccentGold,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          if (notice.primaryAction != null ||
              notice.secondaryAction != null) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                if (notice.primaryAction != null)
                  _NoticeActionChip(action: notice.primaryAction!),
                if (notice.secondaryAction != null)
                  _NoticeActionChip(action: notice.secondaryAction!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoticeActionChip extends StatelessWidget {
  const _NoticeActionChip({required this.action});

  final _LocationNoticeAction action;

  @override
  Widget build(BuildContext context) {
    if (action.isRefreshIcon) {
      // أيقونة تحديث دائرية – تظهر بجانب زر "تفعيل الموقع"
      return InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _kAccentGold.withValues(alpha: 0.18),
            border: Border.all(
              color: _kAccentGold.withValues(alpha: 0.54),
            ),
          ),
          child: Icon(
            Icons.refresh_rounded,
            color: _kAccentGold,
            size: 17.sp,
          ),
        ),
      );
    }

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: _kAccentGold,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          action.label,
          style: TextStyle(
            color: _kHeroDeep,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _HeaderActionIcon extends StatelessWidget {
  const _HeaderActionIcon({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      color: _kAccentGold,
      size: 20.sp,
    );

    if (onTap == null) {
      return iconWidget;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: iconWidget,
      ),
    );
  }
}

class _PrayerTimeMiniTile extends StatelessWidget {
  const _PrayerTimeMiniTile({
    required this.entry,
    required this.icon,
  });

  final _PrayerMiniEntry entry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isCurrent = entry.isCurrent;
    final isNext = entry.isNext;
    final foregroundColor = isCurrent
        ? _kHeroDeep
        : (isNext
            ? _kAccentGold.withValues(alpha: 0.94)
            : _kAccentGold.withValues(alpha: 0.80));
    final timeColor = isCurrent
        ? _kHeroDeep.withValues(alpha: 0.92)
        : (isNext
            ? _kAccentGold.withValues(alpha: 0.92)
            : _kAccentGold.withValues(alpha: 0.74));
    final backgroundColor = isCurrent
        ? _kAccentGold
        : (isNext ? _kAccentGold.withValues(alpha: 0.08) : Colors.transparent);
    final borderColor = isCurrent
        ? _kAccentGold
        : (isNext ? _kAccentGold.withValues(alpha: 0.20) : Colors.transparent);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: _kAccentGold.withValues(alpha: 0.24),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: foregroundColor,
              size: 17.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 11.sp,
                fontWeight:
                    isCurrent || isNext ? FontWeight.w700 : FontWeight.w600,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Text(
                entry.time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: timeColor,
                  fontSize: 12.sp,
                  fontWeight:
                      isCurrent || isNext ? FontWeight.w700 : FontWeight.w500,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isCurrent) ...[
              SizedBox(height: 4.h),
              Container(
                width: 16.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: _kHeroDeep.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
