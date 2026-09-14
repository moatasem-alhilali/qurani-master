import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// بوصلة القبلة: بطلة الشاشة.
///
/// القرص يدور مع الجهاز، وسهم القبلة الذهبي يصعد حتى يلتقي بالعلامة الثابتة
/// أعلى الإطار. عند المحاذاة يضيء الإطار ذهبًا وتنبض الكعبة في المركز، حتى
/// يُحسّ الاتجاه الصحيح لا يُقرأ فقط.
class QiblahCompass extends StatefulWidget {
  const QiblahCompass({
    required this.qiblahDegrees,
    required this.isAligned,
    required this.size,
    super.key,
  });

  /// زاوية القبلة كما يعطيها المستشعر: صفر يعني أن الجهاز متوجّه للقبلة.
  final double qiblahDegrees;

  final bool isAligned;
  final double size;

  @override
  State<QiblahCompass> createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass>
    with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final CurvedAnimation _spinCurve = CurvedAnimation(
    parent: _spin,
    curve: Curves.easeOutCubic,
  );

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  double _from = 0;
  double _to = 0;

  @override
  void initState() {
    super.initState();
    _from = _to = _radians(widget.qiblahDegrees);
    _spin.value = 1;
    if (widget.isAligned) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant QiblahCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.qiblahDegrees != widget.qiblahDegrees) {
      // ننطلق من الزاوية المعروضة الآن لا من هدف الحركة السابقة، وإلا قفز
      // القرص كلّما وصلت قراءة جديدة قبل انتهاء الحركة.
      final start = _displayAngle;
      final target = _radians(widget.qiblahDegrees);

      // أقصر طريق بين الزاويتين، وإلا دار القرص دورة كاملة عند تجاوز الشمال.
      var delta = (target - start) % (2 * math.pi);
      if (delta > math.pi) delta -= 2 * math.pi;

      _from = start;
      _to = start + delta;
      _spin.forward(from: 0);
    }

    if (widget.isAligned != oldWidget.isAligned) {
      if (widget.isAligned) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse
          ..stop()
          ..value = 0;
      }
    }
  }

  @override
  void dispose() {
    _spinCurve.dispose();
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  /// القرص يدور عكس زاوية القبلة، فيصعد السهم إلى الأعلى عند المحاذاة.
  double _radians(double degrees) => -degrees * math.pi / 180;

  double get _displayAngle => _from + (_to - _from) * _spinCurve.value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_spinCurve, _pulse]),
        builder: (context, _) {
          final angle = _displayAngle;
          final pulse =
              widget.isAligned ? Curves.easeInOut.transform(_pulse.value) : 0.0;

          return Stack(
            alignment: Alignment.center,
            children: [
              // الإطار الثابت: الحلقة وعلامة القبلة أعلاها.
              CustomPaint(
                size: Size.square(widget.size),
                painter: _CompassFramePainter(
                  ring: skin.hairline,
                  accent: skin.accent,
                  isAligned: widget.isAligned,
                  pulse: pulse,
                ),
              ),
              // القرص الدوّار: التدريج والجهات وسهم القبلة.
              Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _CompassDialPainter(
                    tick: skin.hairline,
                    strongTick: skin.inkSoft.withValues(alpha: 0.55),
                    label: skin.inkSoft.withValues(alpha: 0.78),
                    isAligned: widget.isAligned,
                    labelSize: 9.sp,
                  ),
                ),
              ),
              // الكعبة في المركز: تنبض عند المحاذاة.
              Transform.scale(
                scale: 1 + pulse * 0.08,
                child: _KaabaMark(size: widget.size * 0.17),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// علامة الكعبة في مركز البوصلة.
class _KaabaMark extends StatelessWidget {
  const _KaabaMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: skin.ground,
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(color: AppColors.gold, width: 1.4),
      ),
      child: Center(
        child: Container(
          width: size * 0.44,
          height: size * 0.44,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(size * 0.12),
          ),
        ),
      ),
    );
  }
}

/// الحلقة الخارجية وعلامة القبلة الثابتة أعلى الإطار.
class _CompassFramePainter extends CustomPainter {
  const _CompassFramePainter({
    required this.ring,
    required this.accent,
    required this.isAligned,
    required this.pulse,
  });

  final Color ring;
  final Color accent;
  final bool isAligned;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    if (isAligned) {
      // هالة ذهبية تتنفّس حول الحلقة عند المحاذاة.
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6 + pulse * 4
          ..color = AppColors.gold.withValues(alpha: 0.12 + pulse * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isAligned ? 1.6 : 1
        ..color = isAligned ? AppColors.gold : ring,
    );

    // علامة ثابتة أعلى الإطار: حين يلتقي بها السهم فأنت متوجّه للقبلة.
    final markerColor = isAligned ? AppColors.gold : accent;
    final top = center.dy - radius;
    final path = Path()
      ..moveTo(center.dx, top + 13)
      ..lineTo(center.dx - 5.5, top + 2)
      ..lineTo(center.dx + 5.5, top + 2)
      ..close();

    canvas.drawPath(path, Paint()..color = markerColor);
  }

  @override
  bool shouldRepaint(covariant _CompassFramePainter oldDelegate) =>
      oldDelegate.isAligned != isAligned ||
      oldDelegate.pulse != pulse ||
      oldDelegate.ring != ring ||
      oldDelegate.accent != accent;
}

/// القرص الدوّار: تدريج الدرجات، أسماء الجهات، وسهم القبلة.
class _CompassDialPainter extends CustomPainter {
  const _CompassDialPainter({
    required this.tick,
    required this.strongTick,
    required this.label,
    required this.isAligned,
    required this.labelSize,
  });

  final Color tick;
  final Color strongTick;
  final Color label;
  final bool isAligned;
  final double labelSize;

  static const _directions = <int, String>{
    0: 'شمال',
    90: 'شرق',
    180: 'جنوب',
    270: 'غرب',
  };

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    for (var degree = 0; degree < 360; degree += 15) {
      final isCardinal = degree % 90 == 0;
      final isMid = degree % 45 == 0;
      final length = isCardinal ? 11.0 : (isMid ? 7.0 : 4.0);
      // صفر الدرجات في أعلى الدائرة.
      final angle = (degree - 90) * math.pi / 180;
      final outer = radius - 6;
      final inner = outer - length;

      canvas.drawLine(
        center + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
        center + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
        Paint()
          ..strokeWidth = isCardinal ? 1.6 : 1
          ..strokeCap = StrokeCap.round
          ..color = isCardinal ? strongTick : tick,
      );

      final name = _directions[degree];
      if (name == null) continue;

      final painter = TextPainter(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: label,
            fontSize: labelSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();

      final labelRadius = inner - 12;
      final offset = center +
          Offset(math.cos(angle) * labelRadius, math.sin(angle) * labelRadius);
      painter.paint(
        canvas,
        offset - Offset(painter.width / 2, painter.height / 2),
      );
    }

    _paintNeedle(canvas, center, radius);
  }

  void _paintNeedle(Canvas canvas, Offset center, double radius) {
    final tip = center.dy - radius + 18;
    final tail = center.dy + radius * 0.24;

    if (isAligned) {
      canvas.drawLine(
        Offset(center.dx, tail),
        Offset(center.dx, tip),
        Paint()
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..color = AppColors.gold.withValues(alpha: 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    canvas
      ..drawLine(
        Offset(center.dx, tail),
        Offset(center.dx, tip + 12),
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = AppColors.gold,
      )
      ..drawPath(
        Path()
          ..moveTo(center.dx, tip)
          ..lineTo(center.dx - 7, tip + 15)
          ..lineTo(center.dx + 7, tip + 15)
          ..close(),
        Paint()..color = AppColors.gold,
      );
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.isAligned != isAligned ||
      oldDelegate.tick != tick ||
      oldDelegate.label != label ||
      oldDelegate.labelSize != labelSize;
}
