import 'dart:math' as math;

import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/l10n/l10n.dart';

/// بوصلة القبلة: بطلة الشاشة.
///
/// قرص الجهات يدور مع الجهاز فيبقى «شمال» على الشمال الحقيقي، وسهم القبلة
/// الذهبي يتحرّك حتى يلتقي بالعلامة الثابتة أعلى الإطار. عند المحاذاة تضيء
/// الحلقة ذهبًا وتنبض الكعبة في المركز — ليُحسّ الاتجاه الصحيح لا يُقرأ فقط.
class QiblahCompass extends StatefulWidget {
  const QiblahCompass({
    required this.headingDegrees,
    required this.qiblahOffsetDegrees,
    required this.isAligned,
    required this.size,
    super.key,
  });

  /// اتجاه الجهاز بالدرجات من الشمال.
  final double headingDegrees;

  /// فرق القبلة عن اتجاه الجهاز: صفر يعني أنك متوجّه إليها.
  final double qiblahOffsetDegrees;

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

  late final _SmoothAngle _dial;
  late final _SmoothAngle _needle;

  @override
  void initState() {
    super.initState();
    _dial = _SmoothAngle(_radians(-widget.headingDegrees));
    _needle = _SmoothAngle(_radians(widget.qiblahOffsetDegrees));
    _spin.value = 1;
    if (widget.isAligned) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant QiblahCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    final headingChanged = oldWidget.headingDegrees != widget.headingDegrees;
    final offsetChanged =
        oldWidget.qiblahOffsetDegrees != widget.qiblahOffsetDegrees;

    if (headingChanged || offsetChanged) {
      // ننطلق من الزاوية المعروضة الآن لا من هدف الحركة السابقة، وإلا قفز
      // القرص كلّما وصلت قراءة جديدة قبل انتهاء الحركة.
      final t = _spinCurve.value;
      _dial.retarget(_radians(-widget.headingDegrees), t);
      _needle.retarget(_radians(widget.qiblahOffsetDegrees), t);
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

  double _radians(double degrees) => degrees * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_spinCurve, _pulse]),
        builder: (context, _) {
          final t = _spinCurve.value;
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
              // قرص الجهات: يدور عكس اتجاه الجهاز فيبقى الشمال شمالًا.
              Transform.rotate(
                angle: _dial.value(t),
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _CompassDialPainter(
                    tick: skin.hairline,
                    strongTick: skin.inkSoft.withValues(alpha: 0.55),
                    label: skin.inkSoft.withValues(alpha: 0.78),
                    labelSize: 9.sp,
                    directions: {
                      0: context.l10n.qiblahCompassNorth,
                      90: context.l10n.qiblahCompassEast,
                      180: context.l10n.qiblahCompassSouth,
                      270: context.l10n.qiblahCompassWest,
                    },
                    textDirection: Directionality.of(context),
                  ),
                ),
              ),
              // سهم القبلة: يعلو الأعلى تمامًا عند المحاذاة.
              Transform.rotate(
                angle: _needle.value(t),
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _QiblahNeedlePainter(isAligned: widget.isAligned),
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

/// زاوية تتحرّك بنعومة وتأخذ دائمًا أقصر طريق بين قراءتين.
class _SmoothAngle {
  _SmoothAngle(double initial)
      : _from = initial,
        _to = initial;

  double _from;
  double _to;

  double value(double t) => _from + (_to - _from) * t;

  void retarget(double target, double t) {
    final current = value(t);
    var delta = (target - current) % (2 * math.pi);
    if (delta > math.pi) delta -= 2 * math.pi;

    _from = current;
    _to = current + delta;
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

    // علامة ثابتة أعلى الإطار: حين يصلها السهم فأنت متوجّه للقبلة.
    final top = center.dy - radius;
    canvas.drawPath(
      Path()
        ..moveTo(center.dx, top + 13)
        ..lineTo(center.dx - 5.5, top + 2)
        ..lineTo(center.dx + 5.5, top + 2)
        ..close(),
      Paint()..color = isAligned ? AppColors.gold : accent,
    );
  }

  @override
  bool shouldRepaint(covariant _CompassFramePainter oldDelegate) =>
      oldDelegate.isAligned != isAligned ||
      oldDelegate.pulse != pulse ||
      oldDelegate.ring != ring ||
      oldDelegate.accent != accent;
}

/// قرص الجهات: تدريج الدرجات وأسماء الجهات الأربع.
class _CompassDialPainter extends CustomPainter {
  const _CompassDialPainter({
    required this.tick,
    required this.strongTick,
    required this.label,
    required this.labelSize,
    required this.directions,
    required this.textDirection,
  });

  final Color tick;
  final Color strongTick;
  final Color label;
  final double labelSize;

  /// أسماء الجهات الأربع بلغة الواجهة، مفهرسة بالدرجة.
  final Map<int, String> directions;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;

    for (var degree = 0; degree < 360; degree += 15) {
      final isCardinal = degree % 90 == 0;
      final isMid = degree % 45 == 0;
      final length = isCardinal ? 10.0 : (isMid ? 7.0 : 4.0);
      // صفر الدرجات في أعلى الدائرة.
      final angle = (degree - 90) * math.pi / 180;
      final outer = radius - 5;
      final inner = outer - length;

      canvas.drawLine(
        center + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
        center + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
        Paint()
          ..strokeWidth = isCardinal ? 1.6 : 1
          ..strokeCap = StrokeCap.round
          ..color = isCardinal ? strongTick : tick,
      );

      final name = directions[degree];
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
        textDirection: textDirection,
      )..layout();

      final labelRadius = radius - 27;
      final offset = center +
          Offset(math.cos(angle) * labelRadius, math.sin(angle) * labelRadius);
      painter.paint(
        canvas,
        offset - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.tick != tick ||
      oldDelegate.strongTick != strongTick ||
      oldDelegate.label != label ||
      oldDelegate.labelSize != labelSize ||
      oldDelegate.textDirection != textDirection ||
      !mapEquals(oldDelegate.directions, directions);
}

/// سهم القبلة: خطّ ذهبي ينتهي برأس مثلّث، ويتوهّج عند المحاذاة.
class _QiblahNeedlePainter extends CustomPainter {
  const _QiblahNeedlePainter({required this.isAligned});

  final bool isAligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;
    // يقف الرأس قبل شريط أسماء الجهات فلا يركبها.
    final tip = center.dy - radius + 46;
    final tail = center.dy + radius * 0.26;

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
        Offset(center.dx, tip + 13),
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
  bool shouldRepaint(covariant _QiblahNeedlePainter oldDelegate) =>
      oldDelegate.isAligned != isAligned;
}
