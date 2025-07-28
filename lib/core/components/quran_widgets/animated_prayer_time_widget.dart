import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class AnimatedPrayerTimeWidget extends StatefulWidget {
  const AnimatedPrayerTimeWidget({
    required this.prayerTimes,
    this.size,
    this.primaryColor,
    this.secondaryColor,
    this.activeColor,
    this.textColor,
    super.key,
  });

  final List<PrayerTime> prayerTimes;
  final double? size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? activeColor;
  final Color? textColor;

  @override
  State<AnimatedPrayerTimeWidget> createState() =>
      _AnimatedPrayerTimeWidgetState();
}

class _AnimatedPrayerTimeWidgetState extends State<AnimatedPrayerTimeWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  int currentPrayerIndex = 0;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _findCurrentPrayer();
  }

  void _findCurrentPrayer() {
    final now = TimeOfDay.now();
    for (var i = 0; i < widget.prayerTimes.length; i++) {
      final prayer = widget.prayerTimes[i];
      if (now.hour < prayer.time.hour ||
          (now.hour == prayer.time.hour && now.minute < prayer.time.minute)) {
        setState(() {
          currentPrayerIndex = i;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 200.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: IslamicPatternPainter(
                    primaryColor: widget.primaryColor ?? context.primaryColor,
                    secondaryColor: widget.secondaryColor ??
                        context.primaryColor.withOpacity(0.3),
                  ),
                ),
              );
            },
          ),

          // Prayer times circle
          CustomPaint(
            size: Size(size, size),
            painter: PrayerTimeCirclePainter(
              prayerTimes: widget.prayerTimes,
              currentIndex: currentPrayerIndex,
              primaryColor: widget.primaryColor ?? context.primaryColor,
              activeColor: widget.activeColor ?? Colors.orange,
              textColor: widget.textColor ?? context.onSurfaceColor,
            ),
          ),

          // Center pulsing indicator
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: size * 0.2,
                  height: size * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.activeColor ?? Colors.orange,
                        (widget.activeColor ?? Colors.orange).withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.activeColor ?? Colors.orange)
                            .withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mosque,
                    color: Colors.white,
                    size: size * 0.08,
                  ),
                ),
              );
            },
          ),

          // Current prayer name in center
          if (widget.prayerTimes.isNotEmpty)
            Positioned(
              bottom: size * 0.15,
              child: Column(
                children: [
                  Text(
                    'الصلاة القادمة',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: widget.textColor ?? context.onSurfaceColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    widget.prayerTimes[currentPrayerIndex].name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: widget.textColor ?? context.onSurfaceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.prayerTimes[currentPrayerIndex].time.format(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: widget.activeColor ?? Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PrayerTime {
  PrayerTime({
    required this.name,
    required this.time,
    required this.arabicName,
  });
  final String name;
  final TimeOfDay time;
  final String arabicName;
}

class PrayerTimeCirclePainter extends CustomPainter {
  PrayerTimeCirclePainter({
    required this.prayerTimes,
    required this.currentIndex,
    required this.primaryColor,
    required this.activeColor,
    required this.textColor,
  });
  final List<PrayerTime> prayerTimes;
  final int currentIndex;
  final Color primaryColor;
  final Color activeColor;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    for (var i = 0; i < prayerTimes.length; i++) {
      final angle = (2 * math.pi * i / prayerTimes.length) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      // Prayer time indicator
      final paint = Paint()
        ..color =
            i == currentIndex ? activeColor : primaryColor.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), i == currentIndex ? 8 : 6, paint);

      // Glow effect for current prayer
      if (i == currentIndex) {
        final glowPaint = Paint()
          ..color = activeColor.withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(Offset(x, y), 15, glowPaint);
      }

      // Prayer name text
      final textPainter = TextPainter(
        text: TextSpan(
          text: prayerTimes[i].arabicName,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: i == currentIndex ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.rtl,
      );

      textPainter.layout();

      // Position text outside the circle
      final textRadius = radius + 25;
      final textX =
          center.dx + textRadius * math.cos(angle) - textPainter.width / 2;
      final textY =
          center.dy + textRadius * math.sin(angle) - textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IslamicPatternPainter extends CustomPainter {
  IslamicPatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw multiple concentric geometric patterns
    for (var ring = 0; ring < 3; ring++) {
      final currentRadius = radius - (ring * 20);
      paint.color =
          (ring % 2 == 0 ? primaryColor : secondaryColor).withOpacity(0.3);

      // Draw star pattern
      for (var i = 0; i < 8; i++) {
        final angle1 = 2 * math.pi * i / 8;
        final angle2 = 2 * math.pi * (i + 1) / 8;

        final x1 = center.dx + currentRadius * math.cos(angle1);
        final y1 = center.dy + currentRadius * math.sin(angle1);
        final x2 = center.dx + currentRadius * math.cos(angle2);
        final y2 = center.dy + currentRadius * math.sin(angle2);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

        // Inner connections
        if (ring == 0) {
          final innerRadius = currentRadius * 0.6;
          final ix = center.dx + innerRadius * math.cos(angle1);
          final iy = center.dy + innerRadius * math.sin(angle1);
          canvas.drawLine(Offset(x1, y1), Offset(ix, iy), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
