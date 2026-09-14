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
    this.notice,
    this.prayerEntriesOverride,
  });

  final TimePrayerModel nextPrayer;
  final Duration remainingTime;
  final List<PrayerInfoModel> prayerTimes;
  final PrayerInfoModel? currentPrayerInfo;
  final PrayerInfoModel? nextPrayerInfo;
  final String? currentPrayerName;
  final String? locationLabel;
  final int? utcOffsetMinutes;
  final _LocationNoticeConfig? notice;
  final List<_PrayerMiniEntry>? prayerEntriesOverride;

  @override
  State<_NextPrayerCountdownCard> createState() =>
      _NextPrayerCountdownCardState();
}

class _NextPrayerCountdownCardState extends State<_NextPrayerCountdownCard>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _currentRemainingTime;

  /// لحظة الافتتاح: القوس يرتسم والشمس تنزلق إلى موضعها عند كل فتح للشاشة.
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..forward();

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
    _reveal.dispose();
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
    final hijri = HijriDate.fromDate(locationNow).formatArabic();
    final locationLabel = widget.locationLabel ?? 'الموقع الحالي';

    final resolvedPrayers = _resolvePrayerStateFromList(
      prayerTimes: widget.prayerTimes,
      currentPrayerInfo: widget.currentPrayerInfo,
      nextPrayerInfo: widget.nextPrayerInfo,
      locationNow: locationNow,
    );

    final currentPrayer = resolvedPrayers.currentPrayer;
    final nextPrayer = resolvedPrayers.nextPrayer;

    final nextPrayerLabel = nextPrayer?.name ?? widget.nextPrayer.title;
    final effectiveRemaining = nextPrayer != null
        ? nextPrayer.time.difference(locationNow)
        : _currentRemainingTime;
    final safeRemaining =
        effectiveRemaining.isNegative ? Duration.zero : effectiveRemaining;

    final prayerEntries = widget.prayerEntriesOverride ??
        _buildPrayerEntries(
          prayerTimes: widget.prayerTimes,
          currentPrayer: currentPrayer,
          nextPrayer: nextPrayer,
          fallbackNextPrayer: widget.nextPrayer,
        );

    final palette = _SkyPalette.of(
      _skyWindowFor(currentPrayer?.type, nextPrayer?.type),
    );
    // ما مضى من نافذة الصلاة الحالية إلى التي بعدها — يغذّي سكّة اليوم
    // وشريط التقدّم في الصفّ المرتفع.
    var windowProgress = 0.0;
    if (currentPrayer != null && nextPrayer != null) {
      final total = nextPrayer.time.difference(currentPrayer.time).inSeconds;
      if (total > 0) {
        windowProgress =
            (locationNow.difference(currentPrayer.time).inSeconds / total)
                .clamp(0.0, 1.0);
      }
    }

    final pathData = _SkyPathData.build(
      prayerTimes: widget.prayerTimes,
      now: locationNow,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _reveal,
          builder: (context, _) => _SkyHeroPanel(
            reveal: Curves.easeOutCubic.transform(_reveal.value),
            palette: palette,
            pathData: pathData,
            locationLabel: locationLabel,
            currentPrayerLabel:
                currentPrayer?.name ?? widget.currentPrayerName ?? '—',
            countdownText: _buildCountdownLine(nextPrayerLabel, safeRemaining),
            onSettingsTap: () => context.push(const SettingScreen()),
            notice: widget.notice,
          ),
        ),
        _PrayerBoard(
          entries: prayerEntries,
          hijriText: hijri,
          gregorianText: _formatGregorianArabic(locationNow),
          windowProgress: windowProgress,
          remainingText: _formatShortRemaining(safeRemaining),
          onOpenAll: () => context.push(const PrayerTimeScreen()),
        ),
        const _QuickActionsPanel(),
      ],
    );
  }
}
