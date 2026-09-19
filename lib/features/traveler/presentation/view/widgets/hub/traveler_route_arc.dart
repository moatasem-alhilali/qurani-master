import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// قوس الرحلة: خطّ من موضعك إلى مكّة، بلغة خرائط الطيران.
///
/// اختيار الشكل مقصود: صفحة المسافر كانت قائمة صامتة لا تعرف أين هو، وهذا
/// أوّل ما يجب أن تقوله — كم بينك وبين مكّة وفي أي جهة. والخطّ المقوّس هو
/// الصورة التي يعرفها كل مسافر من شاشة الطائرة.
///
/// الرسم كلّه من قيم محسوبة محليًّا، فلا شبكة ولا صور ولا خرائط.
class TravelerRouteArc extends StatefulWidget {
  const TravelerRouteArc({
    required this.originLabel,
    required this.distanceLabel,
    required this.directionLabel,
    super.key,
  });

  final String originLabel;
  final String distanceLabel;
  final String directionLabel;

  @override
  State<TravelerRouteArc> createState() => _TravelerRouteArcState();
}

class _TravelerRouteArcState extends State<TravelerRouteArc>
    with SingleTickerProviderStateMixin {
  /// نقطة الضوء تقطع القوس مرّة كل ستّ ثوانٍ — بطيئة بما يكفي لتُحسّ سفرًا
  /// لا وميضًا.
  late final AnimationController _travel = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _travel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 74.h,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _travel,
                builder: (context, _) => CustomPaint(
                  size: Size.infinite,
                  painter: _RouteArcPainter(
                    progress: _travel.value,
                    line: skin.hairline,
                    accent: skin.accent,
                    ink: skin.ink,
                    isRtl: Directionality.of(context) == TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: _Endpoint(
                  label: widget.originLabel,
                  caption: context.l10n.travelerYourLocation,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.travelerDistanceKm(widget.distanceLabel),
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    widget.directionLabel,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.7),
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _Endpoint(
                  label: context.l10n.travelerMakkah,
                  caption: context.l10n.travelerQibla,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({
    required this.label,
    required this.caption,
    required this.alignment,
  });

  final String label;
  final String caption;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: skin.ink,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        Text(
          caption,
          maxLines: 1,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.6),
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _RouteArcPainter extends CustomPainter {
  const _RouteArcPainter({
    required this.progress,
    required this.line,
    required this.accent,
    required this.ink,
    required this.isRtl,
  });

  final double progress;
  final Color line;
  final Color accent;
  final Color ink;

  /// الموضع في بداية السطر ومكّة في نهايته، كصفّ الأسماء تحت القوس.
  final bool isRtl;

  /// القوس نصف قطع مكافئ: يرتفع في الوسط ويهبط على الطرفين، كخطّ الطيران.
  ///
  /// في العربية يُقرأ المشهد من اليمين لليسار، فالموضع على اليمين ومكّة على
  /// اليسار — ونقطة الضوء تسري في الاتجاه نفسه.
  Offset _pointAt(Size size, double t) {
    const inset = 0.08;
    final fromStart = inset + t * (1 - inset * 2);
    final x = size.width * (isRtl ? 1 - fromStart : fromStart);
    final lift = math.sin(math.pi * t);
    final y = size.height * (0.86 - 0.58 * lift);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const steps = 72;

    // الخطّ منقّط: يقول «مسار» لا «حدّ».
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = line;

    for (var i = 0; i < steps; i += 2) {
      canvas.drawLine(
        _pointAt(size, i / steps),
        _pointAt(size, (i + 1) / steps),
        dash,
      );
    }

    // الجزء المقطوع خلف نقطة الضوء يُصبغ بالذهب، فيُقرأ اتجاه السير.
    final travelled = Path();
    final limit = (steps * progress).floor().clamp(0, steps);
    for (var i = 0; i <= limit; i++) {
      final point = _pointAt(size, i / steps);
      i == 0
          ? travelled.moveTo(point.dx, point.dy)
          : travelled.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      travelled,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..color = accent.withValues(alpha: 0.55),
    );

    final head = _pointAt(size, progress);
    canvas
      ..drawCircle(
        head,
        5.5,
        Paint()
          ..color = accent.withValues(alpha: 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      )
      ..drawCircle(head, 2.2, Paint()..color = accent);

    _paintOrigin(canvas, _pointAt(size, 0));
    _paintKaaba(canvas, _pointAt(size, 1));
  }

  /// موضعك: حلقة مفتوحة — نقطة على خريطة لا وجهة.
  void _paintOrigin(Canvas canvas, Offset center) {
    canvas
      ..drawCircle(
        center,
        4.6,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = ink.withValues(alpha: 0.65),
      )
      ..drawCircle(center, 1.6, Paint()..color = ink.withValues(alpha: 0.65));
  }

  /// مكّة: مكعّب صغير بحزام — يُقرأ كعبةً في حجم ١٢ بكسل، والتفاصيل الأدقّ
  /// تتحوّل إلى لطخة في هذا الحجم.
  void _paintKaaba(Canvas canvas, Offset center) {
    final body = Rect.fromCenter(center: center, width: 11, height: 12);

    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(body, const Radius.circular(1.5)),
        Paint()..color = ink.withValues(alpha: 0.9),
      )
      ..drawLine(
        Offset(body.left, center.dy - 1.4),
        Offset(body.right, center.dy - 1.4),
        Paint()
          ..strokeWidth = 1.6
          ..color = accent,
      );
  }

  @override
  bool shouldRepaint(covariant _RouteArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.line != line ||
      oldDelegate.accent != accent ||
      oldDelegate.ink != ink ||
      oldDelegate.isRtl != isRtl;
}
