part of 'next_prayer_countdown_widget.dart';

/// نافذة الوقت التي تحدّد مظهر السماء في الواجهة الرئيسية.
///
/// الفكرة: لا نغيّر ألوان الهوية — نغيّر الضوء. كل حالة هنا مركّبة من درجات
/// [AppColors] نفسها، فالتطبيق يبقى «طمأنينة» في كل لحظة لكنه يتنفّس مع اليوم.
enum _SkyWindow { fajr, sunrise, dhuhr, asr, maghrib, isha }

_SkyWindow _skyWindowFor(Prayer? current, Prayer? next) {
  switch (current) {
    case Prayer.fajr:
      return _SkyWindow.fajr;
    case Prayer.sunrise:
      return _SkyWindow.sunrise;
    case Prayer.dhuhr:
      return _SkyWindow.dhuhr;
    case Prayer.asr:
      return _SkyWindow.asr;
    case Prayer.maghrib:
      return _SkyWindow.maghrib;
    case Prayer.isha:
      return _SkyWindow.isha;
    case Prayer.none:
    case null:
      // قبل فجر اليوم: ما زلنا في ليل العشاء، إلا إن كان الفجر هو القادم مباشرة.
      return next == Prayer.fajr ? _SkyWindow.isha : _SkyWindow.dhuhr;
  }
}

/// لوحة ألوان مشهد واحد: التدرّج، لون الحبر فوقه، وهيئة الشمس/القمر.
class _SkyPalette {
  const _SkyPalette({
    required this.sky,
    required this.stops,
    required this.ink,
    required this.inkSoft,
    required this.veil,
    required this.orbCore,
    required this.orbGlow,
    required this.horizon,
    required this.orbAlignment,
    required this.hasStars,
    required this.lightStatusBarIcons,
  });

  factory _SkyPalette.of(_SkyWindow window) {
    switch (window) {
      case _SkyWindow.fajr:
        return const _SkyPalette(
          sky: [
            AppColors.brandDusk,
            AppColors.brandBrown,
            AppColors.brandSand,
          ],
          stops: [0, 0.55, 1],
          ink: AppColors.brandIvory,
          inkSoft: AppColors.brandMist,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandCream,
          orbGlow: AppColors.brandGoldLight,
          horizon: AppColors.brandNight,
          orbAlignment: Alignment(0.82, -0.58),
          hasStars: true,
          lightStatusBarIcons: true,
        );
      case _SkyWindow.sunrise:
        return const _SkyPalette(
          sky: [
            AppColors.brandSand,
            AppColors.brandMist,
            AppColors.brandIvory,
          ],
          stops: [0, 0.55, 1],
          ink: AppColors.brandBrownDeep,
          inkSoft: AppColors.brandBrown,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandIvory,
          orbGlow: AppColors.gold,
          horizon: AppColors.brandBrownDeep,
          orbAlignment: Alignment(0.86, -0.46),
          hasStars: false,
          lightStatusBarIcons: false,
        );
      case _SkyWindow.dhuhr:
        return const _SkyPalette(
          sky: [
            AppColors.brandGoldLight,
            AppColors.brandCream,
            AppColors.brandIvory,
          ],
          stops: [0, 0.5, 1],
          ink: AppColors.brandBrownDeep,
          inkSoft: AppColors.brandBrown,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandIvory,
          orbGlow: AppColors.brandGoldLight,
          horizon: AppColors.brandBrownDeep,
          orbAlignment: Alignment(0, -0.95),
          hasStars: false,
          lightStatusBarIcons: false,
        );
      case _SkyWindow.asr:
        return const _SkyPalette(
          sky: [
            AppColors.brandGoldDeep,
            AppColors.brandGoldLight,
            AppColors.brandCream,
          ],
          stops: [0, 0.55, 1],
          ink: AppColors.brandDusk,
          inkSoft: AppColors.brandBrownDeep,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandIvory,
          orbGlow: AppColors.brandCream,
          horizon: AppColors.brandBrownDeep,
          orbAlignment: Alignment(-0.86, -0.5),
          hasStars: false,
          lightStatusBarIcons: false,
        );
      case _SkyWindow.maghrib:
        return const _SkyPalette(
          sky: [
            AppColors.brandBrownDeep,
            AppColors.brandGoldDeep,
            AppColors.brandGoldLight,
          ],
          stops: [0, 0.58, 1],
          ink: AppColors.brandIvory,
          inkSoft: AppColors.brandCream,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandCream,
          orbGlow: AppColors.brandGoldLight,
          horizon: AppColors.brandNight,
          orbAlignment: Alignment(-0.9, -0.24),
          hasStars: false,
          lightStatusBarIcons: true,
        );
      case _SkyWindow.isha:
        return const _SkyPalette(
          sky: [
            AppColors.brandNight,
            AppColors.brandDusk,
            AppColors.brandBrown,
          ],
          stops: [0, 0.55, 1],
          ink: AppColors.brandIvory,
          inkSoft: AppColors.brandMist,
          veil: AppColors.brandIvory,
          orbCore: AppColors.brandIvory,
          orbGlow: AppColors.brandSand,
          horizon: AppColors.brandNight,
          orbAlignment: Alignment(-0.82, -0.6),
          hasStars: true,
          lightStatusBarIcons: true,
        );
    }
  }

  /// درجات التدرّج من أعلى الشاشة إلى الأفق.
  final List<Color> sky;
  final List<double> stops;

  /// لون النصوص الأساسي فوق هذه السماء.
  final Color ink;

  /// لون النصوص الثانوية والخطوط.
  final Color inkSoft;

  /// لون الحبيبات الزجاجية (الشارات والأزرار) فوق السماء.
  final Color veil;

  final Color orbCore;
  final Color orbGlow;

  /// لون ظلّ الأفق (المآذن والقبّة).
  final Color horizon;

  /// موضع الشمس أو القمر داخل المشهد.
  final Alignment orbAlignment;

  final bool hasStars;

  /// سماء داكنة تحتاج أيقونات شريط حالة فاتحة، والعكس بالعكس.
  final bool lightStatusBarIcons;
}

/// نقطة صلاة على قوس اليوم.
class _SkyPathStop {
  const _SkyPathStop({required this.t, required this.isPassed});

  /// موضعها على القوس، من ٠ (الفجر) إلى ١ (العشاء).
  final double t;
  final bool isPassed;
}

/// يحسب مواضع الصلوات وموضع «الآن» على قوس اليوم.
///
/// المدى من الفجر إلى العشاء، فما قبل الفجر يلتصق بالبداية وما بعد العشاء
/// يلتصق بالنهاية بدل أن يقفز خارج القوس.
class _SkyPathData {
  const _SkyPathData({
    required this.stops,
    required this.progress,
    this.hasNow = true,
  });

  factory _SkyPathData.build({
    required List<PrayerInfoModel> prayerTimes,
    required DateTime now,
  }) {
    if (prayerTimes.length < 2) {
      return resting;
    }

    final ordered = [...prayerTimes]..sort((a, b) => a.time.compareTo(b.time));
    final start = ordered.first.time;
    final end = ordered.last.time;
    final span = end.difference(start).inSeconds;
    if (span <= 0) {
      return resting;
    }

    double normalize(DateTime value) =>
        (value.difference(start).inSeconds / span).clamp(0.0, 1.0);

    return _SkyPathData(
      stops: ordered.map((prayer) {
        final passed = !prayer.time.isAfter(now);
        return _SkyPathStop(t: normalize(prayer.time), isPassed: passed);
      }).toList(),
      progress: normalize(now),
    );
  }

  final List<_SkyPathStop> stops;
  final double progress;

  /// هل نعرف موضع «الآن»؟ أثناء تحميل المواقيت لا نعرفه، فنرسم القوس ونقاطه
  /// بلا علامة — أفضل من فراغ في منتصف المشهد.
  final bool hasNow;

  static const resting = _SkyPathData(
    stops: [
      _SkyPathStop(t: 0, isPassed: false),
      _SkyPathStop(t: 0.2, isPassed: false),
      _SkyPathStop(t: 0.4, isPassed: false),
      _SkyPathStop(t: 0.6, isPassed: false),
      _SkyPathStop(t: 0.8, isPassed: false),
      _SkyPathStop(t: 1, isPassed: false),
    ],
    progress: 0,
    hasNow: false,
  );
}

/// يرسم قوس اليوم: المسار الكامل باهتًا، وما مضى منه مصمتًا، ونقاط الصلوات.
class _SunPathPainter extends CustomPainter {
  const _SunPathPainter({
    required this.data,
    required this.ink,
    required this.orbCore,
    this.reveal = 1,
  });

  final _SkyPathData data;
  final Color ink;
  final Color orbCore;

  /// نسبة ظهور القوس عند فتح الشاشة: يرتسم المسار وتنزلق الشمس إلى موضعها
  /// بدل أن يظهر المشهد جاهزًا دفعة واحدة.
  final double reveal;

  /// نقطة على منحنى بيزييه تكعيبي. القوس يسير من اليمين إلى اليسار ليوافق
  /// اتجاه القراءة العربية.
  Offset _pointAt(Size size, double t) {
    final baseline = size.height - 2;
    final apex = size.height * 0.06;
    final p0 = Offset(size.width - 3, baseline);
    final p1 = Offset(size.width * 0.74, apex);
    final p2 = Offset(size.width * 0.26, apex);
    final p3 = Offset(3, baseline);

    final u = 1 - t;
    final x = u * u * u * p0.dx +
        3 * u * u * t * p1.dx +
        3 * u * t * t * p2.dx +
        t * t * t * p3.dx;
    final y = u * u * u * p0.dy +
        3 * u * u * t * p1.dy +
        3 * u * t * t * p2.dy +
        t * t * t * p3.dy;
    return Offset(x, y);
  }

  Path _curve(Size size, double from, double to) {
    final path = Path();
    const steps = 48;
    for (var i = 0; i <= steps; i++) {
      final t = from + (to - from) * (i / steps);
      final point = _pointAt(size, t);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.stops.isEmpty) {
      return;
    }

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = ink.withValues(alpha: 0.26);
    canvas.drawPath(_curve(size, 0, 1), track);

    final shown = data.progress * reveal;

    if (data.hasNow && shown > 0.004) {
      final travelled = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..color = ink.withValues(alpha: 0.85);
      canvas.drawPath(_curve(size, 0, shown), travelled);
    }

    for (final stop in data.stops) {
      if (data.hasNow && stop.t > shown + 0.02 && reveal < 1) continue;
      final center = _pointAt(size, stop.t);
      canvas.drawCircle(
        center,
        3,
        Paint()
          ..color = stop.isPassed
              ? ink.withValues(alpha: 0.9)
              : ink.withValues(alpha: 0.34),
      );
    }

    if (!data.hasNow) {
      return;
    }

    // علامة «الآن» هي الشمس نفسها: قرص فاتح بهالة، يميّزها فورًا عن نقاط
    // الصلوات الصغيرة على القوس.
    final marker = _pointAt(size, shown);
    canvas
      ..drawCircle(
        marker,
        17,
        Paint()..color = orbCore.withValues(alpha: 0.16),
      )
      ..drawCircle(
        marker,
        10,
        Paint()..color = orbCore.withValues(alpha: 0.3),
      )
      ..drawCircle(marker, 5.6, Paint()..color = orbCore)
      ..drawCircle(
        marker,
        5.6,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = ink.withValues(alpha: 0.92),
      );
  }

  @override
  bool shouldRepaint(covariant _SunPathPainter oldDelegate) =>
      oldDelegate.reveal != reveal ||
      oldDelegate.data.progress != data.progress ||
      oldDelegate.data.hasNow != data.hasNow ||
      oldDelegate.data.stops.length != data.stops.length ||
      oldDelegate.ink != ink ||
      oldDelegate.orbCore != orbCore;
}

/// ظلّ الأفق: أرض وقبّة ومئذنتان ومبانٍ جانبية — يعطي المشهد أرضًا بدل
/// تدرّج معلّق في الفراغ.
class _HorizonPainter extends CustomPainter {
  const _HorizonPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ground = h * 0.88;
    final paint = Paint()..color = color;
    final path = Path()..addRect(Rect.fromLTWH(0, ground, w, h - ground));

    /// مئذنة: قاعدة، بدن نحيل، قبّة صغيرة تعلوه، ثم صارٍ رفيع.
    ///
    /// جُرّبت الشرفة البارزة والرأس المخروطي أولًا فقُرئ الشكل سهمًا لا مئذنة:
    /// عند هذا الحجم لا تظهر التفاصيل الدقيقة، فالقبّة أوضح دلالةً من الشرفة.
    void minaret(double cx, double height) {
      final s = w * 0.019;
      final tip = ground - height;
      final finial = height * 0.09;
      final apex = tip + finial;
      final capBase = apex + height * 0.12;

      path
        // القاعدة.
        ..addRect(
          Rect.fromLTWH(
            cx - s * 0.95,
            ground - height * 0.06,
            s * 1.9,
            height * 0.06,
          ),
        )
        // البدن.
        ..addRect(Rect.fromLTWH(cx - s / 2, capBase, s, ground - capBase))
        // القبّة الصغيرة.
        ..moveTo(cx - s * 0.78, capBase)
        ..cubicTo(
          cx - s * 0.78,
          apex,
          cx + s * 0.78,
          apex,
          cx + s * 0.78,
          capBase,
        )
        ..close()
        // الصاري.
        ..addRect(Rect.fromLTWH(cx - w * 0.0028, tip, w * 0.0056, finial));
    }

    // القبّة البصلية في الوسط، على رقبة قصيرة.
    final domeW = w * 0.2;
    final left = (w - domeW) / 2;
    final right = left + domeW;
    final mid = w / 2;
    final neck = ground - h * 0.14;
    final apex = ground - h * 0.62;

    path
      // الرقبة تحت القبّة.
      ..addRect(
        Rect.fromLTWH(left - w * 0.022, neck, domeW + w * 0.044, ground - neck),
      )
      ..moveTo(left, neck)
      ..cubicTo(left - domeW * 0.12, neck - h * 0.2, left + domeW * 0.1, apex,
          mid, apex)
      ..cubicTo(right - domeW * 0.1, apex, right + domeW * 0.12, neck - h * 0.2,
          right, neck)
      ..close()
      // صارٍ رفيع وهلال صغير فوق القبّة.
      ..addRect(
          Rect.fromLTWH(mid - w * 0.004, apex - h * 0.13, w * 0.008, h * 0.13))
      ..addOval(
        Rect.fromCircle(
          center: Offset(mid, apex - h * 0.155),
          radius: w * 0.014,
        ),
      );

    minaret(w * 0.15, h * 0.74);
    minaret(w * 0.85, h * 0.8);

    // مبانٍ منخفضة تملأ الأفق حول المسجد.
    path
      ..addRect(Rect.fromLTWH(w * 0.27, ground - h * 0.2, w * 0.06, h * 0.2))
      ..addRect(Rect.fromLTWH(w * 0.66, ground - h * 0.25, w * 0.06, h * 0.25))
      ..addRect(Rect.fromLTWH(w * 0.03, ground - h * 0.13, w * 0.07, h * 0.13))
      ..addRect(Rect.fromLTWH(w * 0.91, ground - h * 0.17, w * 0.07, h * 0.17));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// نجوم خفيفة تظهر في الفجر والعشاء فقط. المواضع ثابتة حتى لا ترقص النجوم
/// مع كل إعادة بناء للواجهة.
class _StarFieldPainter extends CustomPainter {
  const _StarFieldPainter({required this.color});

  final Color color;

  static const _stars = <Offset>[
    Offset(0.08, 0.16),
    Offset(0.19, 0.40),
    Offset(0.27, 0.10),
    Offset(0.38, 0.29),
    Offset(0.46, 0.07),
    Offset(0.57, 0.34),
    Offset(0.64, 0.14),
    Offset(0.73, 0.44),
    Offset(0.81, 0.20),
    Offset(0.90, 0.36),
    Offset(0.95, 0.09),
    Offset(0.13, 0.55),
    Offset(0.52, 0.51),
    Offset(0.86, 0.56),
  ];

  static const _sizes = <double>[
    1.5,
    1,
    1.8,
    1.2,
    1.6,
    1,
    1.4,
    1.1,
    1.7,
    1.2,
    1,
    1.3,
    1.1,
    1.4,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _stars.length; i++) {
      final star = _stars[i];
      canvas.drawCircle(
        Offset(star.dx * size.width, star.dy * size.height),
        _sizes[i],
        Paint()..color = color.withValues(alpha: 0.28 + (i % 3) * 0.14),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) =>
      oldDelegate.color != color;
}
