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
  });

  final String locationLabel;
  final String hijriText;
  final String clockText;
  final String nextPrayerText;
  final String countdownText;
  final List<_PrayerMiniEntry> prayerEntries;
  final VoidCallback onSettingsTap;

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
            color: _kHeroDeep.withValues(alpha: 0.30),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
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
              top: -45.h,
              right: -50.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
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
                  color: Colors.black.withValues(alpha: 0.10),
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
                      Colors.transparent,
                      _kHeroDeep.withValues(alpha: 0.30),
                    ],
                    stops: const [0.55, 1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w,
                (12.h + topInset).clamp(12.h, 72.h),
                14.w,
                50.h,
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
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    locationLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
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
                        SizedBox(width: 8.w),
                        const _HeaderActionIcon(icon: Icons.search_rounded),
                        SizedBox(width: 6.w),
                        const _HeaderActionIcon(
                          icon: Icons.notifications_none_rounded,
                        ),
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
                      color: Colors.white.withValues(alpha: 0.92),
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
                        color: Colors.white,
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
                      color: Colors.white.withValues(alpha: 0.92),
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
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                  SizedBox(height: 9.h),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
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
                ],
              ),
            ),
          ],
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
      color: Colors.white,
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
        ? _kAccentGold
        : (isNext ? Colors.white : Colors.white.withValues(alpha: 0.88));
    final timeColor = isCurrent
        ? _kAccentGold
        : (isNext ? Colors.white : Colors.white.withValues(alpha: 0.82));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
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
        ],
      ),
    );
  }
}
