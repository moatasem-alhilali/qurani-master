part of 'next_prayer_countdown_widget.dart';

class _NextPrayerCountdownCard extends StatefulWidget {
  const _NextPrayerCountdownCard({
    required this.nextPrayer,
    required this.remainingTime,
    required this.prayerTimes,
    this.currentPrayerInfo,
    this.nextPrayerInfo,
    this.currentPrayerName,
    this.locationLabel,
    this.utcOffsetMinutes,
  });

  final TimePrayerModel nextPrayer;
  final Duration remainingTime;
  final List<PrayerInfoModel> prayerTimes;
  final PrayerInfoModel? currentPrayerInfo;
  final PrayerInfoModel? nextPrayerInfo;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;

  @override
  State<_NextPrayerCountdownCard> createState() =>
      _NextPrayerCountdownCardState();
}

class _NextPrayerCountdownCardState extends State<_NextPrayerCountdownCard> {
  late Timer _timer;
  late Duration _currentRemainingTime;

  @override
  void initState() {
    super.initState();
    _currentRemainingTime = widget.remainingTime;
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant _NextPrayerCountdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextPrayerChanged = oldWidget.nextPrayer.id != widget.nextPrayer.id ||
        oldWidget.nextPrayer.type != widget.nextPrayer.type ||
        oldWidget.nextPrayer.time != widget.nextPrayer.time;
    if (oldWidget.remainingTime != widget.remainingTime || nextPrayerChanged) {
      _currentRemainingTime = widget.remainingTime;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentRemainingTime.inSeconds > 0) {
          _currentRemainingTime =
              Duration(seconds: _currentRemainingTime.inSeconds - 1);
        }
      });
    });
  }

  DateTime _resolveLocationNow() {
    final offsetMinutes = widget.utcOffsetMinutes;
    if (offsetMinutes == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatClock12(DateTime date) {
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
  }

  String _formatPrayerTime12(DateTime date) {
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final time = '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
    final period = date.hour < 12 ? 'ص' : 'م';
    return '$time $period';
  }

  String _formatFallbackTime12(String input) {
    final normalized = input.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(normalized);
    if (match == null) {
      return normalized;
    }
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null || hour < 0 || hour > 23) {
      return normalized;
    }
    final date = DateTime(2025, 1, 1, hour, minute);
    return _formatPrayerTime12(date);
  }

  String _buildCountdownLine(String prayerName, Duration remaining) {
    if (remaining.inSeconds <= 0) {
      return 'حان الآن وقت $prayerName';
    }

    final totalMinutes = remaining.inMinutes;
    if (totalMinutes < 1) {
      return '$prayerName بعد أقل من دقيقة';
    }

    if (totalMinutes < 60) {
      return '$prayerName بعد $totalMinutes دقيقة';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes.remainder(60);
    if (minutes == 0) {
      return '$prayerName بعد $hours ساعة';
    }
    return '$prayerName بعد $hours س $minutes د';
  }

  IconData _iconForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.none:
        return Icons.access_time_rounded;
      case Prayer.fajr:
        return Icons.wb_twilight_rounded;
      case Prayer.sunrise:
        return Icons.wb_sunny_outlined;
      case Prayer.dhuhr:
        return Icons.light_mode_rounded;
      case Prayer.asr:
        return Icons.wb_sunny_rounded;
      case Prayer.maghrib:
        return Icons.brightness_5_rounded;
      case Prayer.isha:
        return Icons.nightlight_round;
    }
  }

  _ResolvedPrayerState _resolvePrayerStateFromList(DateTime locationNow) {
    PrayerInfoModel? currentPrayer;
    PrayerInfoModel? nextPrayer;

    if (widget.prayerTimes.isNotEmpty) {
      PrayerInfoModel? computedCurrent;
      PrayerInfoModel? computedNext;

      for (final prayer in widget.prayerTimes) {
        if (prayer.time.isAfter(locationNow)) {
          computedNext ??= prayer;
        } else {
          computedCurrent = prayer;
        }
      }

      if (computedNext == null) {
        final fajr = widget.prayerTimes
            .where((p) => p.type == Prayer.fajr)
            .cast<PrayerInfoModel?>()
            .firstWhere(
              (p) => p != null,
              orElse: () => null,
            );
        if (fajr != null) {
          computedNext = PrayerInfoModel(
            id: fajr.id,
            type: fajr.type,
            name: fajr.name,
            description: fajr.description,
            time: fajr.time.add(const Duration(days: 1)),
          );
        }
      }

      currentPrayer = computedCurrent;
      nextPrayer = computedNext;
    }

    currentPrayer ??= widget.currentPrayerInfo;
    nextPrayer ??= widget.nextPrayerInfo;

    return _ResolvedPrayerState(
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
    );
  }

  bool _isSamePrayerOccurrence(
    PrayerInfoModel prayer,
    PrayerInfoModel? target,
  ) {
    if (target == null) return false;
    return prayer.type == target.type &&
        prayer.time.year == target.time.year &&
        prayer.time.month == target.time.month &&
        prayer.time.day == target.time.day &&
        prayer.time.hour == target.time.hour &&
        prayer.time.minute == target.time.minute;
  }

  bool _isNextPrayerTile(PrayerInfoModel prayer, PrayerInfoModel? nextPrayer) {
    if (_isSamePrayerOccurrence(prayer, nextPrayer)) return true;
    if (nextPrayer == null) return false;

    // Handles the end-of-day case where next prayer is tomorrow's Fajr.
    if (nextPrayer.type == Prayer.fajr && prayer.type == Prayer.fajr) {
      return true;
    }
    return false;
  }

  List<_PrayerMiniEntry> _buildPrayerEntries({
    required PrayerInfoModel? currentPrayer,
    required PrayerInfoModel? nextPrayer,
  }) {
    if (widget.prayerTimes.isNotEmpty) {
      return widget.prayerTimes
          .map(
            (prayer) => _PrayerMiniEntry(
              name: prayer.name,
              time: _formatPrayerTime12(prayer.time),
              type: prayer.type,
              isCurrent: _isSamePrayerOccurrence(prayer, currentPrayer),
              isNext: _isNextPrayerTile(prayer, nextPrayer),
            ),
          )
          .toList();
    }

    return [
      _PrayerMiniEntry(
        name: widget.nextPrayer.title,
        time: _formatFallbackTime12(widget.nextPrayer.time),
        type: widget.nextPrayer.type,
        isCurrent: false,
        isNext: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final locationNow = _resolveLocationNow();
    final topInset = MediaQuery.paddingOf(context).top;
    final hijri = _HijriDate.fromDate(locationNow).formatArabic();
    final locationLabel = widget.locationLabel ?? 'الموقع الحالي';
    final resolvedPrayers = _resolvePrayerStateFromList(locationNow);
    final nextPrayerLabel =
        resolvedPrayers.nextPrayer?.name ?? widget.nextPrayer.title;
    final nextPrayerTimeText = resolvedPrayers.nextPrayer != null
        ? _formatPrayerTime12(resolvedPrayers.nextPrayer!.time)
        : _formatFallbackTime12(widget.nextPrayer.time);
    final effectiveRemaining = resolvedPrayers.nextPrayer != null
        ? resolvedPrayers.nextPrayer!.time.difference(locationNow)
        : _currentRemainingTime;
    final safeRemaining =
        effectiveRemaining.isNegative ? Duration.zero : effectiveRemaining;
    final prayerEntries = _buildPrayerEntries(
      currentPrayer: resolvedPrayers.currentPrayer,
      nextPrayer: resolvedPrayers.nextPrayer,
    );

    final prayerCard = Container(
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
                    colors: [
                      _kHeroTop,
                      _kHeroBottom,
                    ],
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
                14.h,
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
                          onTap: () {
                            context.push(const SettingScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    hijri,
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
                      _formatClock12(locationNow),
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
                    'الصلاة القادمة: $nextPrayerLabel • $nextPrayerTimeText',
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
                    _buildCountdownLine(nextPrayerLabel, safeRemaining),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        prayerCard,
        Transform.translate(
          offset: Offset(0, -14.h),
          child: const _QuickActionsPanel(),
        ),
      ],
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
