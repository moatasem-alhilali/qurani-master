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

  /// منحنى الافتتاح جاهزًا: يُبنى مرّة ويُمرَّر إلى الرسّام، فلا يُحسب في كل
  /// إطار ولا يجرّ معه إعادة بناء.
  late final CurvedAnimation _revealCurve = CurvedAnimation(
    parent: _reveal,
    curve: Curves.easeOutCubic,
  );

  /// موعد الصلاة القادمة كما حُسب في آخر بناء — يقرأه المؤقّت ليعرف متى
  /// تستحقّ الشاشة إعادة بناء فعلًا.
  DateTime? _nextPrayerAt;

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
    _revealCurve.dispose();
    _reveal.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final at = _nextPrayerAt;
      final remaining = at != null
          ? at.difference(
              _resolveLocationNowFromOffset(widget.utcOffsetMinutes),
            )
          : Duration(seconds: _currentRemainingTime.inSeconds - 1);
      final safe = remaining.isNegative ? Duration.zero : remaining;

      // لا شيء على الشاشة أدقّ من الدقيقة: العدّاد يقول «بعد ٦ دقيقة» وسكّة
      // اليوم تقول «بقي ٦ د». فإعادة البناء في كل ثانية كانت تبني الشجرة
      // نفسها — السماء والسكّة والإجراءات — تسعًا وخمسين مرّة دون أن يتغيّر
      // بكسل واحد. الآن تُعاد مرّة في الدقيقة، وعند انقضاء الوقت.
      final visiblyChanged =
          safe.inMinutes != _currentRemainingTime.inMinutes ||
              (safe.inSeconds <= 0) != (_currentRemainingTime.inSeconds <= 0);

      _currentRemainingTime = safe;
      if (visiblyChanged) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locationNow = _resolveLocationNowFromOffset(widget.utcOffsetMinutes);
    final hijri = HijriDate.fromDate(locationNow).format(l10n);
    final locationLabel =
        widget.locationLabel ?? l10n.prayerTimeCurrentLocationFallback;

    final resolvedPrayers = _resolvePrayerStateFromList(
      prayerTimes: widget.prayerTimes,
      currentPrayerInfo: widget.currentPrayerInfo,
      nextPrayerInfo: widget.nextPrayerInfo,
      locationNow: locationNow,
    );

    final currentPrayer = resolvedPrayers.currentPrayer;
    final nextPrayer = resolvedPrayers.nextPrayer;

    // يلتقطه المؤقّت ليحسب المتبقّي دون إعادة بناء.
    _nextPrayerAt = nextPrayer?.time;

    final nextPrayerLabel =
        nextPrayer?.localizedName(l10n) ?? widget.nextPrayer.title;
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

    // تتقدّم نقطة «الآن» على القوس أقلّ من واحد بالمئة في الدقيقة،
    // فخطوة الدقيقة لا تُرى، وتوفّر تسعًا وخمسين إعادة حساب.
    final pathData = _SkyPathData.build(
      prayerTimes: widget.prayerTimes,
      now: locationNow,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SkyHeroPanel(
          reveal: _revealCurve,
          palette: palette,
          pathData: pathData,
          locationLabel: locationLabel,
          currentPrayerLabel: currentPrayer?.localizedName(l10n) ??
              widget.currentPrayerName ??
              '—',
          countdownText:
              _buildCountdownLine(l10n, nextPrayerLabel, safeRemaining),
          onSettingsTap: () => context.push(const SettingScreen()),
          notice: widget.notice,
        ),
        _PrayerBoard(
          entries: prayerEntries,
          hijriText: hijri,
          gregorianText: _formatGregorian(context.localeCode, locationNow),
          windowProgress: windowProgress,
          remainingText: _formatShortRemaining(l10n, safeRemaining),
          onOpenAll: () => context.push(const PrayerTimeScreen()),
        ),
        const _QuickActionsPanel(),
      ],
    );
  }
}
