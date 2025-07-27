import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

// Main Qibla compass widget that works with stream (follows old working code pattern)
class QiblaCompassWidgetWithStream extends StatefulWidget {
  const QiblaCompassWidgetWithStream({
    this.size,
    this.primaryColor,
    this.secondaryColor,
    this.kaabaColor,
    this.showDistance,
    this.distance,
    this.cityName,
    this.showAnimation,
    this.showDirectionIndicator = false,
    super.key,
  });

  final double? size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? kaabaColor;
  final bool? showDistance;
  final double? distance;
  final String? cityName;
  final bool? showAnimation;
  final bool showDirectionIndicator;

  @override
  State<QiblaCompassWidgetWithStream> createState() =>
      _QiblaCompassWidgetWithStreamState();
}

// Global variables exactly like the old working code
Animation<double>? animation;
AnimationController? _animationController;
double begin = 0;

class _QiblaCompassWidgetWithStreamState
    extends State<QiblaCompassWidgetWithStream> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _kaabaController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _kaabaAnimation;
  bool _isAligned = false;

  @override
  void initState() {
    super.initState();

    // Initialize exactly like the old code
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    animation = Tween<double>(begin: 0, end: 0).animate(_animationController!);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _kaabaController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _kaabaAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _kaabaController,
        curve: Curves.elasticOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _pulseController.dispose();
    _kaabaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 250.w;

    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.primaryColor ?? context.primaryColor,
              ),
            ),
          );
        }

        // Follow the EXACT same pattern as the old code
        final qiblahDirection = snapshot.data!;

        // Create animation exactly like the old code
        animation = Tween<double>(
          begin: begin,
          end: qiblahDirection.qiblah * (math.pi / 180) * -1,
        ).animate(_animationController!);

        // Update begin exactly like the old code
        begin = qiblahDirection.qiblah * (math.pi / 180) * -1;
        _animationController!.forward(from: 0);

        // Check alignment
        var difference =
            (qiblahDirection.direction - qiblahDirection.qiblah).abs();
        if (difference > 180) {
          difference = 360 - difference;
        }
        final isAligned = difference <= 10.0;

        if (isAligned != _isAligned) {
          _isAligned = isAligned;
          if (_isAligned && widget.showAnimation != false) {
            _kaabaController.forward().then((_) {
              _kaabaController.reverse();
            });
          }
        }

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (widget.primaryColor ?? context.primaryColor)
                          .withOpacity(0.1),
                      (widget.primaryColor ?? context.primaryColor)
                          .withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Fixed compass ring
              CustomPaint(
                size: Size(size, size),
                painter: CompassRingPainter(
                  primaryColor: widget.primaryColor ?? context.primaryColor,
                  secondaryColor: widget.primaryColor?.withOpacity(0.3) ??
                      context.primaryColor.withOpacity(0.3),
                ),
              ),

              // Animated rotating compass - EXACTLY like the old code
              AnimatedBuilder(
                animation: animation!,
                builder: (context, child) => Transform.rotate(
                  angle: animation!.value,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: QiblaCompassPainter(
                      qiblaColor: widget.kaabaColor ?? Colors.green,
                      isAligned: _isAligned,
                      primaryColor: widget.primaryColor ?? context.primaryColor,
                    ),
                  ),
                ),
              ),

              // Fixed Kaaba in center
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _kaabaAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isAligned
                        ? _pulseAnimation.value *
                            (1 + _kaabaAnimation.value * 0.3)
                        : _pulseAnimation.value,
                    child: Container(
                      width: size * 0.15,
                      height: size * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isAligned
                            ? Colors.green.withOpacity(0.9)
                            : (widget.kaabaColor ?? Colors.green)
                                .withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: (_isAligned
                                    ? Colors.green
                                    : (widget.kaabaColor ?? Colors.green))
                                .withOpacity(0.5),
                            blurRadius: _isAligned ? 25 : 15,
                            spreadRadius: _isAligned ? 5 : 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: size * 0.08,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Direction indicator
              if (widget.showDirectionIndicator == true)
                Positioned(
                  top: size * 0.1,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _isAligned
                              ? Colors.green.withOpacity(0.9)
                              : Colors.orange.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: _isAligned ? Colors.green : Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _isAligned ? 'متجه للقبلة ✓' : 'ابحث عن القبلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.cityName != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            widget.cityName!,
                            style: context.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Distance info
              if (widget.showDistance == true && widget.distance != null)
                Positioned(
                  bottom: size * 0.1,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'المسافة إلى مكة',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10.sp,
                          ),
                        ),
                        Text(
                          '${widget.distance!.toInt()} كم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Alignment indicator effect
              if (_isAligned)
                Positioned.fill(
                  child: CustomPaint(
                    painter: AlignmentIndicatorPainter(
                      color: Colors.green.withOpacity(0.3),
                      animation: _kaabaAnimation,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painters for the compass
class CompassRingPainter extends CustomPainter {
  CompassRingPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    // Outer ring
    final outerPaint = Paint()
      ..color = primaryColor.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, outerPaint);

    // Direction markers
    final markerPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 360; i += 30) {
      final angle = (i * math.pi) / 180;
      final isMainDirection = i % 90 == 0;
      final markerLength = isMainDirection ? 20.0 : 10.0;
      final startRadius = radius - 5;
      final endRadius = startRadius - markerLength;

      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + endRadius * math.cos(angle);
      final endY = center.dy + endRadius * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        markerPaint,
      );

      // Direction labels
      if (isMainDirection) {
        final labels = ['شرق', 'جنوب', 'غرب', 'شمال'];
        final labelIndex = (i / 90).round() % 4;
        final label = labels[labelIndex];

        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final labelRadius = radius + 20;
        final labelX =
            center.dx + labelRadius * math.cos(angle) - textPainter.width / 2;
        final labelY =
            center.dy + labelRadius * math.sin(angle) - textPainter.height / 2;

        textPainter.paint(canvas, Offset(labelX, labelY));
      }
    }

    // Islamic decorative patterns
    _drawIslamicPattern(canvas, center, radius * 0.7, secondaryColor);
  }

  void _drawIslamicPattern(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw star pattern
    for (var i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final innerRadius = radius * 0.3;
      final outerRadius = radius * 0.5;

      final innerX = center.dx + innerRadius * math.cos(angle);
      final innerY = center.dy + innerRadius * math.sin(angle);
      final outerX = center.dx + outerRadius * math.cos(angle);
      final outerY = center.dy + outerRadius * math.sin(angle);

      canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AlignmentIndicatorPainter extends CustomPainter {
  AlignmentIndicatorPainter({
    required this.color,
    required this.animation,
  });
  final Color color;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * (0.8 + animation.value * 0.2);

    // Clamp opacity to ensure it's always between 0.0 and 1.0
    final opacity = (0.3 * (1 - animation.value)).clamp(0.0, 1.0);

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class QiblaCompassPainter extends CustomPainter {
  QiblaCompassPainter({
    required this.qiblaColor,
    required this.isAligned,
    required this.primaryColor,
  });
  final Color qiblaColor;
  final bool isAligned;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final compassRadius = size.width * 0.4;
    final needleLength = size.width * 0.35;

    // Draw compass body (circle)
    final compassPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, compassRadius, compassPaint);

    // Draw compass border
    final borderPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, compassRadius, borderPaint);

    // Qibla needle (pointing up when aligned)
    final needlePaint = Paint()
      ..color = isAligned ? Colors.green : qiblaColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Glow effect when aligned
    if (isAligned) {
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.4)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawLine(
        center,
        Offset(center.dx, center.dy - needleLength),
        glowPaint,
      );
    }

    // Main needle pointing to Qibla (up)
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - needleLength),
      needlePaint,
    );

    // Needle tip (arrow head)
    final tipPaint = Paint()
      ..color = isAligned ? Colors.green : qiblaColor
      ..style = PaintingStyle.fill;

    final tipPath = Path();
    tipPath.moveTo(center.dx, center.dy - needleLength - 15);
    tipPath.lineTo(center.dx - 10, center.dy - needleLength);
    tipPath.lineTo(center.dx + 10, center.dy - needleLength);
    tipPath.close();

    canvas.drawPath(tipPath, tipPaint);

    // Center dot
    final centerPaint = Paint()
      ..color = isAligned ? Colors.green : qiblaColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, centerPaint);

    // Add "القبلة" text at the top of the needle
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'القبلة',
        style: TextStyle(
          color: isAligned ? Colors.green : qiblaColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    final textX = center.dx - textPainter.width / 2;
    final textY = center.dy - needleLength - 40;
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
