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

/// مزاج المشهد. منه تُشتقّ تفاصيل الحياة: أي سماء فيها غيوم، وأيّها فيها
/// طيور، ومتى تُضاء نوافذ المسجد، ومتى يصير القرص هلالًا.
enum _SkyMood { dawn, day, dusk, night }

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
    required this.mood,
    this.lamp,
  });

  factory _SkyPalette.of(_SkyWindow window) {
    switch (window) {
      case _SkyWindow.fajr:
        return const _SkyPalette(
          sky: [
            AppColors.skyFajr1,
            AppColors.skyFajr2,
            AppColors.skyFajr3,
            AppColors.skyFajr4,
          ],
          stops: [0, 0.38, 0.72, 1],
          ink: AppColors.skyFajrInk,
          inkSoft: AppColors.skyFajrInkSoft,
          veil: AppColors.skyVeilLight,
          orbCore: AppColors.skyFajrOrb,
          orbGlow: AppColors.skyFajrGlow,
          horizon: AppColors.skyFajrHorizon,
          lamp: AppColors.skyLampDawn,
          orbAlignment: Alignment(0.82, -0.58),
          hasStars: true,
          lightStatusBarIcons: true,
          mood: _SkyMood.dawn,
        );
      case _SkyWindow.sunrise:
        return const _SkyPalette(
          sky: [
            AppColors.skySunrise1,
            AppColors.skySunrise2,
            AppColors.skySunrise3,
            AppColors.skySunrise4,
          ],
          stops: [0, 0.34, 0.72, 1],
          ink: AppColors.skySunriseInk,
          inkSoft: AppColors.skySunriseInkSoft,
          // فوق سماء فاتحة يصير الزجاج داكنًا، وإلا ذاب في خلفيّته.
          veil: AppColors.skySunriseVeil,
          orbCore: AppColors.skyOrbWhite,
          orbGlow: AppColors.skySunriseGlow,
          horizon: AppColors.skySunriseHorizon,
          orbAlignment: Alignment(0.86, -0.46),
          hasStars: false,
          lightStatusBarIcons: false,
          mood: _SkyMood.dawn,
        );
      case _SkyWindow.dhuhr:
        return const _SkyPalette(
          sky: [
            AppColors.skyNoon1,
            AppColors.skyNoon2,
            AppColors.skyNoon3,
            AppColors.skyNoon4,
          ],
          stops: [0, 0.34, 0.7, 1],
          ink: AppColors.skyNoonInk,
          inkSoft: AppColors.skyNoonInkSoft,
          veil: AppColors.skyNoonVeil,
          orbCore: AppColors.skyOrbWhite,
          orbGlow: AppColors.skyNoonGlow,
          horizon: AppColors.skyNoonHorizon,
          orbAlignment: Alignment(0, -0.95),
          hasStars: false,
          lightStatusBarIcons: false,
          mood: _SkyMood.day,
        );
      case _SkyWindow.asr:
        return const _SkyPalette(
          sky: [
            AppColors.skyAsr1,
            AppColors.skyAsr2,
            AppColors.skyAsr3,
            AppColors.skyAsr4,
          ],
          stops: [0, 0.3, 0.68, 1],
          ink: AppColors.skyAsrInk,
          inkSoft: AppColors.skyAsrInkSoft,
          veil: AppColors.skyAsrVeil,
          orbCore: AppColors.skyOrbWarmWhite,
          orbGlow: AppColors.skyAsrGlow,
          horizon: AppColors.skyAsrHorizon,
          orbAlignment: Alignment(-0.86, -0.5),
          hasStars: false,
          lightStatusBarIcons: false,
          mood: _SkyMood.day,
        );
      case _SkyWindow.maghrib:
        return const _SkyPalette(
          sky: [
            AppColors.skyMaghrib1,
            AppColors.skyMaghrib2,
            AppColors.skyMaghrib3,
            AppColors.skyMaghrib4,
          ],
          stops: [0, 0.34, 0.68, 1],
          ink: AppColors.skyMaghribInk,
          inkSoft: AppColors.skyMaghribInkSoft,
          veil: AppColors.skyVeilLight,
          orbCore: AppColors.skyMaghribOrb,
          orbGlow: AppColors.skyMaghribGlow,
          horizon: AppColors.skyMaghribHorizon,
          lamp: AppColors.skyLampDusk,
          orbAlignment: Alignment(-0.9, -0.24),
          hasStars: false,
          lightStatusBarIcons: true,
          mood: _SkyMood.dusk,
        );
      case _SkyWindow.isha:
        return const _SkyPalette(
          sky: [
            AppColors.skyIsha1,
            AppColors.skyIsha2,
            AppColors.skyIsha3,
            AppColors.skyIsha4,
          ],
          stops: [0, 0.36, 0.72, 1],
          ink: AppColors.skyIshaInk,
          inkSoft: AppColors.skyIshaInkSoft,
          veil: AppColors.skyVeilLight,
          orbCore: AppColors.skyIshaOrb,
          orbGlow: AppColors.skyIshaGlow,
          horizon: AppColors.skyIshaHorizon,
          lamp: AppColors.skyLampNight,
          orbAlignment: Alignment(-0.82, -0.6),
          hasStars: true,
          lightStatusBarIcons: true,
          mood: _SkyMood.night,
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

  final _SkyMood mood;

  /// لون مصابيح المسجد. وجودُه هو ما يُشعلها: السماوات المضيئة لا تمرّره،
  /// فلا حاجة إلى شرط ثانٍ يمكن أن يخالفه.
  final Color? lamp;

  /// الغيوم تنساب في كل سماء إلا العميقة الليلية.
  bool get hasClouds => mood != _SkyMood.night;

  /// الطيور في وضح النهار وبعد الشروق. لا طيور في سماء مظلمة: لونها لون
  /// الأفق نفسه فلا تُرى، فتصير ضجيجًا لا حياة.
  bool get hasBirds =>
      mood == _SkyMood.day || (mood == _SkyMood.dawn && !hasStars);

  /// نوافذ المسجد تُضاء متى أُعطي المشهد لون مصباح.
  bool get windowsLit => lamp != null;

  /// حيث تظهر النجوم يظهر الهلال — قرص الشمس لا يجتمع مع سماء مرصّعة.
  bool get isCrescent => hasStars;

  /// أشعة خفيفة تنبعث من الشمس في وضح النهار.
  bool get hasRays => mood == _SkyMood.day;
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
  const _HorizonPainter({required this.color, this.windowGlow});

  final Color color;

  /// لون ضوء النوافذ. حين يكون null فالمسجد ظلّ صامت — نهارًا.
  final Color? windowGlow;

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
      ..cubicTo(
        left - domeW * 0.12,
        neck - h * 0.2,
        left + domeW * 0.1,
        apex,
        mid,
        apex,
      )
      ..cubicTo(
        right - domeW * 0.1,
        apex,
        right + domeW * 0.12,
        neck - h * 0.2,
        right,
        neck,
      )
      ..close()
      // صارٍ رفيع وهلال صغير فوق القبّة.
      ..addRect(
        Rect.fromLTWH(mid - w * 0.004, apex - h * 0.13, w * 0.008, h * 0.13),
      )
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

    final glow = windowGlow;
    if (glow != null) _paintWindows(canvas, size, ground, glow);
  }

  /// نوافذ مضيئة في رقبة القبّة والمآذن والمباني المجاورة.
  ///
  /// تفصيلة صغيرة لكنها هي التي تقلب الظلّ الصامت إلى مسجدٍ فيه أحد —
  /// وهي أوّل ما تلحظه العين في مشهد المغرب والعشاء.
  void _paintWindows(Canvas canvas, Size size, double ground, Color glow) {
    final w = size.width;
    final h = size.height;
    final unit = w * 0.009;

    void window(double cx, double cy, [double scale = 1]) {
      final rect = Rect.fromCenter(
        center: Offset(cx, cy),
        width: unit * 1.5 * scale,
        height: unit * 2.4 * scale,
      );

      canvas
        // هالة دافئة حول كل نافذة توحي بضوء ينفذ لا برقعة لون.
        ..drawCircle(
          Offset(cx, cy),
          unit * 3.4 * scale,
          Paint()..color = glow.withValues(alpha: 0.13),
        )
        ..drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(unit * 0.75)),
          Paint()..color = glow.withValues(alpha: 0.9),
        );
    }

    // رقبة القبّة: ثلاث نوافذ.
    final neckY = ground - h * 0.075;
    window(w * 0.44, neckY);
    window(w * 0.5, neckY);
    window(w * 0.56, neckY);

    // شرفتا المئذنتين.
    window(w * 0.15, ground - h * 0.52, 0.8);
    window(w * 0.85, ground - h * 0.56, 0.8);

    // المباني المجاورة.
    window(w * 0.295, ground - h * 0.12, 0.75);
    window(w * 0.685, ground - h * 0.16, 0.75);
    window(w * 0.055, ground - h * 0.07, 0.7);
    window(w * 0.945, ground - h * 0.1, 0.7);
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.windowGlow != windowGlow;
}

/// نجوم خفيفة تظهر في الفجر والعشاء فقط. المواضع ثابتة حتى لا ترقص النجوم
/// مع كل إعادة بناء للواجهة.
/// حقل نجوم يتلألأ. المواضع والأحجام ثابتة، والمؤقّت وحده يحرّك السطوع.
class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter({required this.color, required this.clock})
      : super(repaint: clock);

  final Color color;

  /// المؤقّت يُمرَّر إلى [CustomPainter.repaint]، فيُعاد الرسم مباشرةً دون أن
  /// تُبنى ودجت واحدة في كل إطار. النسخة السابقة كانت تعيد بناء الشجرة عبر
  /// AnimatedBuilder ستّين مرّة في الثانية لتغيير رقم واحد.
  final Animation<double> clock;

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

  /// فرشاة واحدة يُعاد استعمالها: تخصيص Paint لكل نجمة كان يولّد أربعة عشر
  /// كائنًا في كل إطار بلا داعٍ.
  final Paint _brush = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final progress = clock.value;

    for (var i = 0; i < _stars.length; i++) {
      final star = _stars[i];

      // لكل نجمة إيقاع تلألؤ مختلف عن جارتها، وإلا نبض الحقل كلّه معًا
      // فبدا وميضًا صناعيًا لا سماءً.
      final rate = 1.6 + (i % 5) * 0.7;
      final phase = i * 1.37;
      final twinkle =
          0.5 + 0.5 * math.sin(progress * math.pi * 2 * rate + phase);
      final base = 0.24 + (i % 3) * 0.12;

      _brush.color = color.withValues(alpha: base + 0.3 * twinkle);
      canvas.drawCircle(
        Offset(star.dx * size.width, star.dy * size.height),
        _sizes[i] * (0.82 + 0.18 * twinkle),
        _brush,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.clock != clock;
}

/// مواصفات غيمة واحدة: ارتفاعها، حجمها، سرعتها، وإزاحتها الابتدائية.
class _CloudSpec {
  const _CloudSpec(this.y, this.scale, this.speed, this.phase, this.alpha);

  final double y;
  final double scale;
  final double speed;
  final double phase;
  final double alpha;
}

/// طبقة الحياة فوق السماء: غيوم تنساب، وطيور تعبر، وشهاب يمرّ ليلًا،
/// وأشعة تتنفّس نهارًا.
///
/// كلّها مرسومة برمجيًا بلا صور ولا ملفات حركة، ومقودة بمؤقّت واحد بطيء.
class _SkyLifePainter extends CustomPainter {
  _SkyLifePainter({required this.clock, required this.palette})
      : super(repaint: clock);

  final Animation<double> clock;
  final _SkyPalette palette;

  /// طبقتان بسرعتين مختلفتين: الفرق بينهما يصنع عمقًا بلا ثلاثيّ أبعاد.
  static const _clouds = <_CloudSpec>[
    _CloudSpec(0.16, 1, 0.22, 0, 0.16),
    _CloudSpec(0.30, 0.68, 0.34, 0.42, 0.12),
    _CloudSpec(0.11, 0.52, 0.46, 0.74, 0.10),
    _CloudSpec(0.38, 0.86, 0.28, 0.20, 0.09),
  ];

  // ---------- هندسة تُبنى مرّة واحدة لكل مقاس ----------
  //
  // الغيمة والشعاع شكلان ثابتان لا يتغيّر منهما إلا الموضع والدوران. بناؤهما
  // داخل paint كان يخلق أحد عشر مسارًا وأحد عشر متدرّجًا في كل إطار — أي نحو
  // ألف وثلاثمئة كائن في الثانية تُرمى فور إنشائها. الآن يُبنيان عند أوّل
  // رسم ويُعاد استعمالهما بتحريك اللوحة تحتهما، وهو أرخص ما في الرسم.
  Size? _builtFor;
  final List<Path> _cloudPaths = [];
  final List<Paint> _cloudPaints = [];
  Path? _rayBlade;
  Paint? _rayPaint;

  final Paint _birdPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4
    ..strokeCap = StrokeCap.round;

  void _buildGeometry(Size size) {
    if (_builtFor == size) return;
    _builtFor = size;
    _cloudPaths.clear();
    _cloudPaints.clear();

    if (palette.hasClouds) {
      for (final cloud in _clouds) {
        final w = size.width * 0.34 * cloud.scale;
        final h = w * 0.34;

        _cloudPaths.add(
          Path()
            ..addOval(Rect.fromCenter(center: Offset.zero, width: w, height: h))
            ..addOval(
              Rect.fromCenter(
                center: Offset(-w * 0.26, h * 0.16),
                width: w * 0.58,
                height: h * 0.74,
              ),
            )
            ..addOval(
              Rect.fromCenter(
                center: Offset(w * 0.24, h * 0.12),
                width: w * 0.64,
                height: h * 0.82,
              ),
            )
            ..addOval(
              Rect.fromCenter(
                center: Offset(w * 0.04, -h * 0.26),
                width: w * 0.5,
                height: h * 0.78,
              ),
            ),
        );

        _cloudPaints.add(
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                palette.orbCore.withValues(alpha: cloud.alpha * 1.5),
                palette.orbCore.withValues(alpha: cloud.alpha * 0.35),
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset.zero,
                width: w * 1.4,
                height: h * 2.2,
              ),
            ),
        );
      }
    }

    if (palette.hasRays) {
      final length = size.width * 0.5;
      _rayBlade = Path()
        ..moveTo(0, 0)
        ..lineTo(length, -length * 0.05)
        ..lineTo(length, length * 0.05)
        ..close();
      _rayPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            palette.orbGlow.withValues(alpha: 0.14),
            palette.orbGlow.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, -length * 0.06, length, length * 0.12));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _buildGeometry(size);
    final progress = clock.value;

    if (palette.hasRays) _paintRays(canvas, size, progress);
    if (palette.hasClouds) _paintClouds(canvas, size, progress);
    if (palette.hasBirds) _paintBirds(canvas, size, progress);
    if (palette.hasStars) _paintShootingStar(canvas, size, progress);
  }

  void _paintClouds(Canvas canvas, Size size, double progress) {
    for (var i = 0; i < _cloudPaths.length; i++) {
      final cloud = _clouds[i];

      // تخرج الغيمة من حافة وتدخل من الأخرى بلا قفزة: المدى أعرض من الشاشة
      // بمقدار عرض الغيمة نفسها.
      const span = 1.34;
      final x = (((progress * cloud.speed + cloud.phase) % 1) * span - 0.17) *
          size.width;

      canvas
        ..save()
        ..translate(x, cloud.y * size.height)
        ..drawPath(_cloudPaths[i], _cloudPaints[i])
        ..restore();
    }
  }

  /// ثلاثة طيور تعبر المشهد مرّة واحدة في كل دورة، ثم تغيب.
  void _paintBirds(Canvas canvas, Size size, double progress) {
    // تظهر في الربع الأول من الدورة فقط: الطيور الدائمة تتحوّل إلى ضجيج.
    const window = 0.26;
    if (progress > window) return;

    final t = progress / window;
    final fade = math.sin(math.pi * t);
    if (fade <= 0.02) return;

    _birdPaint.color = palette.horizon.withValues(alpha: 0.32 * fade);

    const offsets = [Offset.zero, Offset(-0.07, 0.05), Offset(-0.13, -0.03)];

    for (var i = 0; i < offsets.length; i++) {
      final x = (t * 1.2 - 0.1 + offsets[i].dx) * size.width;
      // رفرفة خفيفة: يتغيّر انفراج الجناحين مع الزمن.
      final flap = 0.5 + 0.5 * math.sin(t * math.pi * 14 + i);
      final y = (0.2 + offsets[i].dy) * size.height;
      final wing = size.width * 0.018;
      final lift = wing * (0.45 + 0.35 * flap);

      canvas.drawPath(
        Path()
          ..moveTo(x - wing, y)
          ..quadraticBezierTo(x - wing * 0.5, y - lift, x, y)
          ..quadraticBezierTo(x + wing * 0.5, y - lift, x + wing, y),
        _birdPaint,
      );
    }
  }

  /// شهاب قصير يمرّ مرّة كل دورة — لحظة تُلاحَظ ولا تتكرّر بإلحاح.
  void _paintShootingStar(Canvas canvas, Size size, double progress) {
    const start = 0.62;
    const span = 0.06;
    if (progress < start || progress > start + span) return;

    final t = (progress - start) / span;
    final fade = math.sin(math.pi * t);

    final from = Offset(
      size.width * (0.78 - 0.3 * t),
      size.height * (0.08 + 0.22 * t),
    );
    final to = from.translate(size.width * 0.09, size.height * 0.07);

    canvas.drawLine(
      from,
      to,
      Paint()
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            palette.orbCore.withValues(alpha: 0.85 * fade),
            palette.orbCore.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromPoints(from, to)),
    );
  }

  /// أشعة ناعمة تنبعث من موضع الشمس وتتنفّس ببطء.
  void _paintRays(Canvas canvas, Size size, double progress) {
    final blade = _rayBlade;
    final paint = _rayPaint;
    if (blade == null || paint == null) return;

    final center = Offset(
      (palette.orbAlignment.x + 1) / 2 * size.width,
      (palette.orbAlignment.y + 1) / 2 * size.height,
    );

    // التنفّس بالتكبير لا بالشفافية: تغيير الشفافية يعني متدرّجًا جديدًا في
    // كل إطار، أمّا التكبير فمصفوفة على اللوحة ولا يكلّف شيئًا.
    final breathe = 0.96 + 0.08 * math.sin(progress * math.pi * 2);

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..scale(breathe)
      // دوران بطيء جدًّا: دورة كاملة كل عشر دورات مؤقّت.
      ..rotate(progress * math.pi * 0.2);

    for (var i = 0; i < 7; i++) {
      canvas
        ..save()
        ..rotate(i * math.pi * 2 / 7)
        ..drawPath(blade, paint)
        ..restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SkyLifePainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.clock != clock;
}

/// طبقة الحياة كاملة، بمؤقّت واحد يقودها.
///
/// دورة واحدة كل تسعين ثانية: بطيئة عمدًا حتى تُحسّ السماء حيّة دون أن تسرق
/// الانتباه من المواقيت. ومغلّفة بـ [RepaintBoundary] فلا يُعاد رسم بقيّة
/// الشاشة معها، ويوقف Flutter مؤقّتها تلقائيًا حين تغادر الصفحة أو يُخلَّف
/// التطبيق إلى الخلفية.
class _SkyLifeLayer extends StatefulWidget {
  const _SkyLifeLayer({required this.palette});

  final _SkyPalette palette;

  @override
  State<_SkyLifeLayer> createState() => _SkyLifeLayerState();
}

class _SkyLifeLayerState extends State<_SkyLifeLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 90),
  )..repeat();

  // الرسّامان يُبنيان مرّة واحدة ويعيشان مع الحالة. الودجت الأمّ يُعاد بناؤها
  // كل ثانية مع العدّاد التنازلي، فبناؤهما داخل build كان يرمي الهندسة
  // المخزّنة ويعيد حسابها من الصفر مع كل دقّة.
  _StarFieldPainter? _stars;
  late _SkyLifePainter _life;

  @override
  void initState() {
    super.initState();
    _makePainters();
  }

  @override
  void didUpdateWidget(covariant _SkyLifeLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لوحات الألوان ثوابت const، فمقارنة الهويّة تكفي ولا تُعاد البنية إلا
    // عند تبدّل الصلاة فعلًا.
    if (oldWidget.palette != widget.palette) _makePainters();
  }

  void _makePainters() {
    _stars = widget.palette.hasStars
        ? _StarFieldPainter(color: widget.palette.ink, clock: _clock)
        : null;
    _life = _SkyLifePainter(clock: _clock, palette: widget.palette);
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stars = _stars;
    return RepaintBoundary(
      child: Stack(
        children: [
          if (stars != null)
            Positioned.fill(child: CustomPaint(painter: stars)),
          Positioned.fill(child: CustomPaint(painter: _life)),
        ],
      ),
    );
  }
}

/// هلال مرسوم لا قرص: دائرتان، والثانية تقتطع من الأولى.
///
/// جهة الاقتطاع تتبع موضع القرص في السماء، فيبقى الجزء المضيء ناحية الأفق
/// كما يحدث فعلًا — الهلال المقلوب يُقرأ خطأً في لمحة.
class _CrescentPainter extends CustomPainter {
  const _CrescentPainter({required this.palette});

  final _SkyPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    final bite = palette.orbAlignment.x >= 0 ? -1.0 : 1.0;

    final crescent = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: center, radius: r * 0.84)),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: center.translate(bite * r * 0.46, -r * 0.12),
            radius: r * 0.8,
          ),
        ),
    );

    canvas
      // هالة تحت الهلال تفصله عن السماء بلا حدّ حادّ.
      ..drawPath(
        crescent,
        Paint()
          ..color = palette.orbGlow.withValues(alpha: 0.55)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.34),
      )
      ..drawPath(
        crescent,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.orbCore, palette.orbGlow],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
  }

  @override
  bool shouldRepaint(covariant _CrescentPainter oldDelegate) =>
      oldDelegate.palette != palette;
}
