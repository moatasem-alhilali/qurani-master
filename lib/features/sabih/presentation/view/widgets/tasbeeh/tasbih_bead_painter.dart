import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quran_app/features/sabih/data/model/tasbih_bead_material.dart';

/// رسم خرزة سبحة واحدة — مصدر واحد تستعمله السلسلة ومربّعات الاختيار معًا،
/// فما تراه في الإعدادات هو ما تحصل عليه في السبحة حرفيًا.
///
/// الكرة المقنعة ليست تدرّجًا شعاعيًا. الطبقات بالترتيب:
/// ١. ظلّ تماسّ تحتها يفصلها عن الخيط.
/// ٢. تدرّج الجسم: الضوء من أعلى اليسار، والجانب البعيد يغمق حتى الحدّ.
/// ٣. الملمس — عروق خشب أو عروق حجر — مقصوصة على الكرة ومضغوطة نحو
///    الحافّتين بمقدار انحناء الكرة، لا مرسومة مسطّحة.
/// ٤. تعتيم محيطي عند الحافة (ambient occlusion).
/// ٥. **ضوء الحافة المرتدّ** أسفل اليمين — أكثر طبقة تصنع الإحساس بالكروية،
///    وغيابها هو ما كان يجعل الخرزة تبدو دائرة ملوّنة.
/// ٦. البريق: حادّ صغير للمصقول، عريض خافت للخشب.
/// ٧. انعكاس بيئي عريض للمصقول وحده.
void paintTasbihBead(
  Canvas canvas,
  Offset center,
  double radius,
  TasbihBeadPalette palette, {
  double opacity = 1,
  bool withContactShadow = true,
}) {
  if (radius <= 0 || opacity <= 0) return;

  final rect = Rect.fromCircle(center: center, radius: radius);

  if (withContactShadow) {
    canvas.drawCircle(
      center.translate(0, radius * 0.18),
      radius * 0.94,
      Paint()
        ..color = palette.shadow.withValues(alpha: 0.38 * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.16),
    );
  }

  // جسم الكرة. مركز الضوء منزاح إلى أعلى اليسار، وآخر درجة أغمق من لون
  // الظلّ نفسه حتى ينغلق الحدّ بدل أن يتلاشى.
  canvas
    ..save()
    ..clipPath(Path()..addOval(rect))
    ..drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.45, -0.52),
          radius: 1.18,
          colors: [
            Color.lerp(palette.highlight, Colors.white, 0.34)!
                .withValues(alpha: opacity),
            palette.highlight.withValues(alpha: opacity),
            palette.base.withValues(alpha: opacity),
            palette.shadow.withValues(alpha: opacity),
            Color.lerp(palette.shadow, Colors.black, 0.45)!
                .withValues(alpha: opacity),
          ],
          stops: const [0, 0.2, 0.52, 0.86, 1],
        ).createShader(rect),
    );

  switch (palette.finish) {
    case TasbihBeadFinish.wood:
      _paintWoodGrain(canvas, center, radius, palette, opacity);
    case TasbihBeadFinish.stone:
      _paintStoneVeins(canvas, center, radius, palette, opacity);
    case TasbihBeadFinish.polished:
      break;
  }

  // تعتيم محيطي: حلقة داكنة عريضة ملتصقة بالحافة تُقعّر الكرة.
  canvas
    ..drawCircle(
      center,
      radius * 0.88,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.3
        ..color = Color.lerp(palette.shadow, Colors.black, 0.3)!
            .withValues(alpha: 0.34 * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.2),
    )

    // ضوء الحافة المرتدّ: قوس رفيع أسفل اليمين، عكس جهة الضوء.
    ..drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      -0.08 * math.pi,
      0.82 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.16
        ..strokeCap = StrokeCap.round
        ..color = Color.lerp(palette.highlight, Colors.white, 0.2)!
            .withValues(alpha: (0.28 + 0.34 * palette.gloss) * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.13),
    );

  _paintSpecular(canvas, center, radius, palette, opacity);

  canvas
    ..restore()
    // حدّ خارجي رفيع يقفل الشكل على الخلفية.
    ..drawCircle(
      center,
      radius - radius * 0.02,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.05
        ..color = Color.lerp(palette.shadow, Colors.black, 0.35)!
            .withValues(alpha: 0.55 * opacity),
    );
}

/// تفاوت ثابت بين خطوط العرق: عشوائية محفوظة لا تتغيّر بين إطار وآخر،
/// فلا ترتجف العروق أثناء الحركة.
const _grainAlpha = <double>[
  0.5,
  0.26,
  0.72,
  0.34,
  0.9,
  0.42,
  0.6,
  0.3,
  0.82,
  0.38,
  0.66,
  0.28,
  0.54,
];
const _grainWidth = <double>[
  0.9,
  0.5,
  1.3,
  0.6,
  1.6,
  0.7,
  1.1,
  0.55,
  1.45,
  0.65,
  1.2,
  0.5,
  0.95,
];

void _paintWoodGrain(
  Canvas canvas,
  Offset center,
  double radius,
  TasbihBeadPalette palette,
  double opacity,
) {
  final strength = palette.grainStrength;
  if (strength <= 0) return;

  final grainColor = Color.lerp(palette.shadow, palette.base, 0.25)!;
  const lines = 13;

  for (var i = 0; i < lines; i++) {
    // u يمسح قطر الكرة من ‎-١ إلى ١.
    final u = ((i + 0.5) / lines) * 2 - 1;

    // انضغاط المنظور: الخطّ قرب الحافة يضيق ويقصر بمقدار جذر(١-u²).
    final k = math.sqrt(math.max(0, 1 - u * u));
    if (k < 0.1) continue;

    final x = center.dx + u * radius * 0.97;
    final bow = radius * (0.14 + 0.46 * k);
    final height = 2 * radius * k * 0.99;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(x, center.dy),
        width: bow,
        height: height,
      ),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = radius * 0.035 * _grainWidth[i % _grainWidth.length]
        ..color = grainColor.withValues(
          alpha: 0.4 * strength * _grainAlpha[i % _grainAlpha.length] * opacity,
        ),
    );
  }

  // نطاقان أعرض وأغمق: قلب الخشب، يكسر انتظام الخطوط.
  for (final u in const [-0.42, 0.34]) {
    final k = math.sqrt(math.max(0, 1 - u * u));
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + u * radius * 0.97, center.dy),
        width: radius * (0.2 + 0.5 * k),
        height: 2 * radius * k * 0.99,
      ),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.13
        ..color = palette.shadow.withValues(alpha: 0.2 * strength * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.05),
    );
  }
}

void _paintStoneVeins(
  Canvas canvas,
  Offset center,
  double radius,
  TasbihBeadPalette palette,
  double opacity,
) {
  final strength = palette.grainStrength;
  if (strength <= 0) return;

  final veinColor = Color.lerp(palette.highlight, Colors.white, 0.25)!;

  // ثلاثة عروق سائلة بميول مختلفة — الرخام لا ينتظم.
  const veins = <List<double>>[
    [-1.0, 0.25, -0.2, -0.35, 0.45, 0.1, 1.0, -0.15],
    [-1.0, -0.3, -0.25, 0.3, 0.4, -0.2, 1.0, 0.4],
    [-0.9, 0.62, 0.0, 0.3, 0.5, 0.7, 1.0, 0.45],
  ];

  for (var v = 0; v < veins.length; v++) {
    final p = veins[v];
    final path = Path()
      ..moveTo(center.dx + p[0] * radius, center.dy + p[1] * radius)
      ..cubicTo(
        center.dx + p[2] * radius,
        center.dy + p[3] * radius,
        center.dx + p[4] * radius,
        center.dy + p[5] * radius,
        center.dx + p[6] * radius,
        center.dy + p[7] * radius,
      );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = radius * (v == 1 ? 0.075 : 0.045)
        ..color = veinColor.withValues(
          alpha: (v == 1 ? 0.3 : 0.2) * strength * opacity,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.035),
    );
  }
}

void _paintSpecular(
  Canvas canvas,
  Offset center,
  double radius,
  TasbihBeadPalette palette,
  double opacity,
) {
  final gloss = palette.gloss;

  // البريق الأساسي: يضيق ويشتدّ كلّما زاد الصقل.
  final size = radius * (0.46 - 0.2 * gloss);
  canvas.drawOval(
    Rect.fromCenter(
      center: center.translate(-radius * 0.38, -radius * 0.44),
      width: size * 1.5,
      height: size,
    ),
    Paint()
      ..color = Colors.white.withValues(alpha: (0.16 + 0.52 * gloss) * opacity)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        radius * (0.16 - 0.1 * gloss),
      ),
  );

  if (gloss < 0.6) return;

  canvas
    // نقطة الضوء الحادّة — لا تظهر إلا على سطح مصقول.
    ..drawCircle(
      center.translate(-radius * 0.34, -radius * 0.46),
      radius * 0.1,
      Paint()..color = Colors.white.withValues(alpha: 0.9 * opacity),
    )

    // انعكاس بيئي عريض أسفل اليمين: ما يعكسه السطح من محيطه.
    ..drawOval(
      Rect.fromCenter(
        center: center.translate(radius * 0.3, radius * 0.42),
        width: radius * 0.95,
        height: radius * 0.5,
      ),
      Paint()
        ..color = Color.lerp(palette.highlight, Colors.white, 0.35)!
            .withValues(alpha: 0.16 * gloss * opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.16),
    );
}

/// خرزة مرسومة مسبقًا على نسيج واحد (texture) يُعاد ختمه في كل إطار.
///
/// **لماذا؟** [paintTasbihBead] تُنفّذ ٦ عمليات تمويه (`MaskFilter.blur`) وقصّ
/// مسار وأكثر من عشر عمليات رسم. الخرزات على الخيط تسع، والحركة تدوم أكثر
/// من ثانية بعد كل تسبيحة — أي ما يقارب **٥٤ تمويهة في الإطار الواحد**،
/// وكل تمويهة تفرض تمريرة رسم خارج الشاشة. هذا كافٍ لإسقاط إطارات على
/// أجهزة متوسطة، وأشدّ ما يظهر عند التسبيح السريع وهو أكثر وقت تُستعمل فيه
/// الصفحة.
///
/// والخرزة **لا تتغيّر**: كل ما يتغيّر موضعها وحجمها وشفافيّتها. فتُرسم مرّة
/// واحدة لكل خامة، ثم يصير كل إطار تسع عمليات `drawImageRect` فقط — رسم
/// مربّع منسوج، أرخص عملية في الرسم. النتيجة نفس الصورة بالضبط لأن
/// النسيج نفسه مولَّد من [paintTasbihBead] بلا نسخة ثانية من الكود.
class TasbihBeadStamp {
  const TasbihBeadStamp._(this.image, this.side);

  final ui.Image image;
  final int side;

  /// موضع مركز الكرة ونصف قطرها داخل النسيج، نسبةً إلى ضلعه. الكرة مرفوعة
  /// قليلًا عن المنتصف ليتّسع أسفلها لظلّ التماسّ ممّوهًا بلا اقتطاع.
  static const _centerY = 0.40;
  static const _radius = 0.36;

  static final Map<int, TasbihBeadStamp> _cache = {};

  /// ١٢ نسيجًا كحدّ أقصى: ثماني خامات مضروبة في مقاسين على أسوأ تقدير،
  /// وكلّها صغيرة (٢٥٦×٢٥٦ في أعلى كثافة = ربع ميغابايت).
  static const _maxEntries = 12;

  /// النسيج بحجم البكسل الحقيقي: الخرزة لا تتجاوز ٦٤ نقطة منطقية في أي
  /// استعمال، فـ `64 × كثافة الشاشة` رسمٌ بدقّة الجهاز تمامًا بلا إسراف.
  static int _sideFor(double devicePixelRatio) =>
      (64 * devicePixelRatio).round().clamp(96, 256);

  // ignore: prefer_constructors_over_static_methods -- مصنع بذاكرة مؤقّتة
  static TasbihBeadStamp of(TasbihBeadMaterial material, double dpr) {
    final side = _sideFor(dpr);
    final key = Object.hash(material, side);

    final cached = _cache[key];
    if (cached != null) return cached;

    if (_cache.length >= _maxEntries) {
      final oldest = _cache.keys.first;
      _cache.remove(oldest)?.image.dispose();
    }

    final stamp = _render(material, side);
    _cache[key] = stamp;
    return stamp;
  }

  static TasbihBeadStamp _render(TasbihBeadMaterial material, int side) {
    final recorder = ui.PictureRecorder();
    paintTasbihBead(
      Canvas(recorder),
      Offset(side / 2, side * _centerY),
      side * _radius,
      material.palette,
    );
    final picture = recorder.endRecording();
    final image = picture.toImageSync(side, side);
    picture.dispose();
    return TasbihBeadStamp._(image, side);
  }

  /// ختم الخرزة بحيث يقع مركز الكرة على [center] ويصير نصف قطرها [radius].
  void paint(
    Canvas canvas,
    Offset center,
    double radius, {
    double opacity = 1,
  }) {
    if (radius <= 0 || opacity <= 0) return;

    // ضلع الوجهة يُشتقّ من نصف القطر المطلوب، فينكمش النسيج كلّه بنفس
    // النسبة ويبقى الظلّ والبريق في مواضعهما من الكرة.
    final extent = radius / _radius;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, side.toDouble(), side.toDouble()),
      Rect.fromLTWH(
        center.dx - extent / 2,
        center.dy - extent * _centerY,
        extent,
        extent,
      ),
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(255, 255, 255, opacity),
    );
  }
}

/// عيّنة خامة مفردة. تستعمل نفس نسيج السبحة، فما يُختار هنا هو ما يظهر على
/// الخيط بالضبط — ولا تُرسم الخرزة من جديد عند كل إعادة بناء للشيت.
class TasbihBeadPreview extends StatelessWidget {
  const TasbihBeadPreview({
    required this.material,
    required this.size,
    super.key,
  });

  final TasbihBeadMaterial material;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _BeadPreviewPainter(
          stamp: TasbihBeadStamp.of(
            material,
            MediaQuery.devicePixelRatioOf(context),
          ),
        ),
      ),
    );
  }
}

class _BeadPreviewPainter extends CustomPainter {
  const _BeadPreviewPainter({required this.stamp});

  final TasbihBeadStamp stamp;

  @override
  void paint(Canvas canvas, Size size) {
    stamp.paint(
      canvas,
      size.center(Offset.zero),
      size.shortestSide / 2 * 0.9,
    );
  }

  @override
  bool shouldRepaint(covariant _BeadPreviewPainter oldDelegate) =>
      oldDelegate.stamp != stamp;
}
