import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// الهدف الحالي للتسبيح: ثلاث وثلاثون، ثم تسع وتسعون، ثم كل مئة.
///
/// حين يبلغ العدد هدفًا نُبقي الهدف نفسه لحظةً حتى تُقرأ الحلقة ممتلئة،
/// ثم ينتقل الهدف من تلقاء نفسه مع التسبيحة التالية.
int tasbeehTargetFor(int count) {
  if (count <= 33) return 33;
  if (count <= 99) return 99;
  return (((count - 1) ~/ 100) + 1) * 100;
}

/// هل هذا العدد محطّة تستحقّ اهتزازة أوضح؟
bool tasbeehIsMilestone(int count) {
  if (count <= 0) return false;
  if (count == 33 || count == 99) return true;
  return count > 99 && count % 100 == 0;
}

/// عدّاد المسبحة — قلب الشاشة.
///
/// العدّاد هنا يُحسّ لا يُقرأ: اهتزازة خفيفة مع كل تسبيحة، واهتزازة أوضح
/// عند بلوغ الهدف، وحلقة ذهبية تمتلئ بسلاسة بدل أن تُبدَّل، ونبضة حجم
/// عند اللمس — على نهج `_TrackerButton` في متتبّع الصلوات.
class TasbeehCounter extends StatefulWidget {
  const TasbeehCounter({
    required this.count,
    required this.onTap,
    super.key,
  });

  final int count;
  final VoidCallback onTap;

  @override
  State<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends State<TasbeehCounter>
    with TickerProviderStateMixin {
  /// امتلاء الحلقة — يتحرّك بين قيمتين بدل أن يقفز.
  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: 1,
  );

  /// نبضة الحجم عند اللمس.
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  /// وميض ذهبي يمرّ مرّة واحدة عند بلوغ الهدف.
  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late double _fromProgress = _progressOf(widget.count);
  late double _toProgress = _fromProgress;

  double _progressOf(int count) {
    if (count <= 0) return 0;
    return (count / tasbeehTargetFor(count)).clamp(0.0, 1.0);
  }

  late final Animation<double> _popScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.07), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.07, end: 1), weight: 65),
  ]).animate(CurvedAnimation(parent: _pop, curve: Curves.easeOut));

  @override
  void didUpdateWidget(covariant TasbeehCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count == oldWidget.count) return;

    _fromProgress = _displayedProgress;
    _toProgress = _progressOf(widget.count);
    _ring.forward(from: 0);

    if (tasbeehIsMilestone(widget.count) && widget.count > oldWidget.count) {
      _flash.forward(from: 0);
    }
  }

  double get _displayedProgress {
    final t = Curves.easeOutCubic.transform(_ring.value);
    return _fromProgress + (_toProgress - _fromProgress) * t;
  }

  void _handleTap() {
    // الاهتزاز عند اللمس لا بعد رجوع الحالة، حتى يلتصق الإحساس بالفعل.
    final next = widget.count + 1;
    if (tasbeehIsMilestone(next)) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    _pop.forward(from: 0);
    widget.onTap();
  }

  @override
  void dispose() {
    _ring.dispose();
    _pop.dispose();
    _flash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final target = tasbeehTargetFor(widget.count);
    final reached = widget.count >= target;
    final diameter = 148.w;

    return Semantics(
      button: true,
      label: 'تسبيح',
      value: '${widget.count}',
      child: Center(
        child: InkResponse(
          onTap: _handleTap,
          radius: diameter / 2,
          child: AnimatedBuilder(
            animation: Listenable.merge([_ring, _pop, _flash]),
            builder: (context, _) {
              final progress = _displayedProgress;
              final flash = _flash.isAnimating
                  ? math.sin(_flash.value * math.pi) * 0.22
                  : 0.0;

              return Transform.scale(
                scale: _popScale.value,
                child: SizedBox.square(
                  dimension: diameter,
                  child: CustomPaint(
                    painter: _RingPainter(
                      progress: progress,
                      track: skin.hairline,
                      fill: AppColors.gold,
                      glowAlpha: flash,
                      stroke: 6.w,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.count}',
                            style: TextStyle(
                              color: skin.ink,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            reached ? 'بلغت $target' : 'من $target',
                            style: TextStyle(
                              color: reached
                                  ? skin.accent
                                  : skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 9.5.sp,
                              fontWeight:
                                  reached ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// حلقة التقدّم: مسار بسُمك شعرة غليظة، وذهبٌ يدور عكس عقارب الساعة
/// كما تدور حبّات المسبحة في اليد.
class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
    required this.glowAlpha,
    required this.stroke,
  });

  final double progress;
  final Color track;
  final Color fill;
  final double glowAlpha;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );

    if (glowAlpha > 0) {
      canvas.drawCircle(
        center,
        radius - stroke / 2,
        Paint()..color = fill.withValues(alpha: glowAlpha),
      );
    }

    if (progress <= 0) return;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      -2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.track != track ||
      oldDelegate.fill != fill ||
      oldDelegate.glowAlpha != glowAlpha ||
      oldDelegate.stroke != stroke;
}
