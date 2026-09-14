import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_app/features/sabih/data/model/tasbih_bead_material.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbih_bead_painter.dart';

/// سلسلة سبحة تتحرّك خرزةً واحدة مع كل تسبيحة.
///
/// الودجت **محكومة من الخارج**: العدّاد يأتي من الأعلى ولا تملك عدّادًا
/// خاصًّا بها. النسخة القديمة في `core/widgets` كانت تحتفظ بعدّادها الداخلي،
/// فتعذّر ربطها بقاعدة البيانات وبقيت معطّلة بلا استعمال.
class TasbihBeadChain extends StatefulWidget {
  const TasbihBeadChain({
    required this.count,
    required this.material,
    required this.stringColor,
    this.beadCount = 9,
    super.key,
  });

  final int count;
  final TasbihBeadMaterial material;
  final Color stringColor;

  /// عدد الخرزات الظاهرة على القوس.
  final int beadCount;

  @override
  State<TasbihBeadChain> createState() => _TasbihBeadChainState();
}

class _TasbihBeadChainState extends State<TasbihBeadChain>
    with TickerProviderStateMixin {
  /// انزلاق السلسلة.
  ///
  /// العدّاد تراكمي ولا يُصفَّر: كل تسبيحة تُحرّك الهدف خرزةً واحدة إلى
  /// الأمام، والحركة تبدأ **من موضع السلسلة الحالي** لا من الصفر. بدون هذا
  /// كانت النقرة السريعة تُعيد الحركة إلى بدايتها فتقفز السلسلة للخلف —
  /// وهذا سبب الإحساس بأن الخرزة «تدخل بسرعة وليست سلسة».
  late final AnimationController _slide = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 430),
  );

  late final Animation<double> _curve = CurvedAnimation(
    parent: _slide,
    curve: Curves.easeOutCubic,
  );

  double _from = 0;
  double _to = 0;

  double get _offset => _from + (_to - _from) * _curve.value;

  /// تأرجح الخيط بعد الدفعة: ذبذبة تخمد تدريجيًا كأي جسم معلّق.
  late final AnimationController _swing = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1150),
  );

  @override
  void didUpdateWidget(covariant TasbihBeadChain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      // نلتقط الموضع الحالي أولًا ثم ندفع الهدف خرزةً: هكذا تتسلسل النقرات
      // المتتابعة في حركة واحدة متّصلة بلا قفزة.
      _from = _offset;
      _to += 1;
      _slide.forward(from: 0);
      _swing.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _slide.dispose();
    _swing.dispose();
    super.dispose();
  }

  /// جيبٌ متناقص السعة: يمثّل تأرجحًا مخمّدًا بلا محرّك فيزياء.
  double get _swingValue {
    if (!_swing.isAnimating && _swing.value == 0) return 0;
    final t = _swing.value;
    final decay = (1 - t) * (1 - t);
    return math.sin(t * math.pi * 3.2) * decay;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_curve, _swing]),
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _BeadChainPainter(
          // الخرزات متماثلة ومتساوية التباعد، فالجزء الكسري من الإزاحة
          // يكفي لرسم المشهد ويمنع السلسلة من الهروب خارج القوس.
          shift: _offset % 1,
          swing: _swingValue,
          palette: widget.material.palette,
          stringColor: widget.stringColor,
          beadCount: widget.beadCount,
        ),
      ),
    );
  }
}

class _BeadChainPainter extends CustomPainter {
  const _BeadChainPainter({
    required this.shift,
    required this.swing,
    required this.palette,
    required this.stringColor,
    required this.beadCount,
  });

  /// من ٠ إلى ١ — كم انزلقت السلسلة نحو الخرزة التالية.
  final double shift;

  /// تأرجح مخمّد من ‎-١ إلى ١، يميل الخيط ويعمّق تدلّيه.
  final double swing;

  final TasbihBeadPalette palette;
  final Color stringColor;
  final int beadCount;

  /// نقطة على منحنى الخيط. الخيط يتدلّى لأسفل كسبحة معلّقة، لا يقوس لأعلى.
  ///
  /// التأرجح يُزيح نقطتي التحكّم: الأولى والثانية بمقدارين متعاكسين، فيميل
  /// القوس كلّه كما يميل خيط حقيقي دُفع من طرف.
  Offset _pointAt(Size size, double t) {
    final sway = swing * size.width * 0.035;
    final dip = swing.abs() * size.height * 0.05;

    final p0 = Offset(0, size.height * 0.26);
    final p1 = Offset(
      size.width * 0.26 + sway,
      size.height * 0.96 + dip,
    );
    final p2 = Offset(
      size.width * 0.74 + sway * 0.6,
      size.height * 0.96 + dip,
    );
    final p3 = Offset(size.width, size.height * 0.26);

    final u = 1 - t;
    return Offset(
      u * u * u * p0.dx +
          3 * u * u * t * p1.dx +
          3 * u * t * t * p2.dx +
          t * t * t * p3.dx,
      u * u * u * p0.dy +
          3 * u * u * t * p1.dy +
          3 * u * t * t * p2.dy +
          t * t * t * p3.dy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // الخيط أولًا حتى تجلس الخرزات فوقه.
    final thread = Path();
    const steps = 44;
    for (var i = 0; i <= steps; i++) {
      final point = _pointAt(size, i / steps);
      i == 0
          ? thread.moveTo(point.dx, point.dy)
          : thread.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      thread,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..color = stringColor,
    );

    final slotCount = beadCount + 1;
    final baseRadius = size.height * 0.17;

    for (var i = 0; i < beadCount; i++) {
      // الطرح يُزحلق السلسلة باتجاه واحد مع تقدّم العدّاد.
      final t = (i + 1 - shift) / slotCount;
      if (t < -0.02 || t > 1.02) continue;

      final clamped = t.clamp(0.0, 1.0);
      final center = _pointAt(size, clamped);

      // الخرزات في وسط القوس أقرب إلى الناظر فتكبر قليلًا — إيحاء بالعمق
      // بلا تحويل ثلاثي الأبعاد.
      final depth = math.sin(math.pi * clamped);

      // منطقة دخول وخروج عريضة: الخرزة تكبر وتتّضح تدريجيًا عند طرفي
      // القوس بدل أن تظهر دفعةً واحدة. المنطقة الضيّقة كانت تجعل الدخول
      // يبدو مفاجئًا مهما بطُؤت الحركة.
      const fadeZone = 0.18;
      final edge = clamped < fadeZone
          ? clamped / fadeZone
          : clamped > 1 - fadeZone
              ? (1 - clamped) / fadeZone
              : 1.0;
      final entry = Curves.easeOut.transform(edge.clamp(0.0, 1.0));

      final radius = baseRadius * (0.74 + 0.26 * depth) * (0.58 + 0.42 * entry);

      paintTasbihBead(canvas, center, radius, palette, opacity: entry);
    }
  }

  @override
  bool shouldRepaint(covariant _BeadChainPainter oldDelegate) =>
      oldDelegate.shift != shift ||
      oldDelegate.swing != swing ||
      oldDelegate.palette != palette ||
      oldDelegate.stringColor != stringColor ||
      oldDelegate.beadCount != beadCount;
}
