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

  @override
  Widget build(BuildContext context) {
    final locationNow = _resolveLocationNowFromOffset(widget.utcOffsetMinutes);
    final hijri = _HijriDate.fromDate(locationNow).formatArabic();
    final locationLabel = widget.locationLabel ?? 'الموقع الحالي';

    final resolvedPrayers = _resolvePrayerStateFromList(
      prayerTimes: widget.prayerTimes,
      currentPrayerInfo: widget.currentPrayerInfo,
      nextPrayerInfo: widget.nextPrayerInfo,
      locationNow: locationNow,
    );

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
      prayerTimes: widget.prayerTimes,
      currentPrayer: resolvedPrayers.currentPrayer,
      nextPrayer: resolvedPrayers.nextPrayer,
      fallbackNextPrayer: widget.nextPrayer,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NextPrayerHeroCard(
          locationLabel: locationLabel,
          hijriText: hijri,
          clockText: _formatClock12(locationNow),
          nextPrayerText:
              'الصلاة القادمة: $nextPrayerLabel • $nextPrayerTimeText',
          countdownText: _buildCountdownLine(nextPrayerLabel, safeRemaining),
          prayerEntries: prayerEntries,
          onSettingsTap: () {
            context.push(const SettingScreen());
          },
        ),
        // const SizedBox(
        //   height: 10,
        // ),
        Transform.translate(
          offset: Offset(0, -14.h),
          child: const _QuickActionsPanel(),
        ),
      ],
    );
  }
}
