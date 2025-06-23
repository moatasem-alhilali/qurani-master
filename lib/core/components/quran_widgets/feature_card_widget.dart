import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

class FeatureCardWidget extends StatelessWidget {
  const FeatureCardWidget({
    required this.icon,
    this.title,
    this.onTap,
    this.primaryColor,
    this.secondaryColor,
    this.iconColor,
    this.textColor,
    this.borderRadius,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.shadowColor,
    this.elevation,
    this.shapeType = CardShapeType.circles,
    super.key,
  });

  final String? title;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? iconColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? shadowColor;
  final double? elevation;
  final CardShapeType shapeType;

  @override
  Widget build(BuildContext context) {
    final cardPrimaryColor = primaryColor ?? context.primaryScheme;
    final cardSecondaryColor =
        secondaryColor ?? cardPrimaryColor.withOpacity(0.3);

    return Container(
      width: width ?? 160.w,
      height: height ?? 160.h,
      margin: margin ?? EdgeInsets.all(8.w),
      child: Material(
        elevation: elevation ?? 6,
        shadowColor: shadowColor ?? cardPrimaryColor.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20.r),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardPrimaryColor,
                        cardPrimaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                // Custom geometric shapes
                CustomPaint(
                  size: Size(width ?? 160.w, height ?? 160.h),
                  painter: GeometricShapePainter(
                    primaryColor: cardSecondaryColor,
                    secondaryColor: cardSecondaryColor.withOpacity(0.5),
                    shapeType: shapeType,
                  ),
                ),
                // Content
                Padding(
                  padding: padding ?? EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color: iconColor ?? Colors.white,
                            size: 32.sp,
                          ),
                          child: icon,
                        ),
                      ),
                      if (title != null) ...[
                        SizedBox(height: 16.h),
                        // Title Section
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: context.titleMedium.copyWith(
                            color: textColor ?? Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum CardShapeType {
  circles,
  triangles,
  diamonds,
  hexagons,
  stars,
  waves,
}

class GeometricShapePainter extends CustomPainter {
  GeometricShapePainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.shapeType,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final CardShapeType shapeType;

  @override
  void paint(Canvas canvas, Size size) {
    switch (shapeType) {
      case CardShapeType.circles:
        _drawCircles(canvas, size);
      case CardShapeType.triangles:
        _drawTriangles(canvas, size);
      case CardShapeType.diamonds:
        _drawDiamonds(canvas, size);
      case CardShapeType.hexagons:
        _drawHexagons(canvas, size);
      case CardShapeType.stars:
        _drawStars(canvas, size);
      case CardShapeType.waves:
        _drawWaves(canvas, size);
    }
  }

  void _drawCircles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large background circle
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.6,
      paint,
    );

    // Medium circle
    paint.color = secondaryColor;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      size.width * 0.4,
      paint,
    );

    // Small circles
    paint.color = primaryColor.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      size.width * 0.15,
      paint,
    );
  }

  void _drawTriangles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large triangle
    final path1 = Path();
    path1.moveTo(size.width * 0.8, 0);
    path1.lineTo(size.width * 1.2, size.height * 0.5);
    path1.lineTo(size.width * 0.4, size.height * 0.5);
    path1.close();
    canvas.drawPath(path1, paint);

    // Small triangle
    paint.color = secondaryColor;
    final path2 = Path();
    path2.moveTo(size.width * 0.1, size.height * 0.9);
    path2.lineTo(size.width * 0.4, size.height * 0.6);
    path2.lineTo(-size.width * 0.1, size.height * 0.6);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  void _drawDiamonds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large diamond
    final path1 = Path();
    path1.moveTo(size.width * 0.8, size.height * 0.1);
    path1.lineTo(size.width * 1.1, size.height * 0.4);
    path1.lineTo(size.width * 0.8, size.height * 0.7);
    path1.lineTo(size.width * 0.5, size.height * 0.4);
    path1.close();
    canvas.drawPath(path1, paint);

    // Small diamond
    paint.color = secondaryColor;
    final path2 = Path();
    path2.moveTo(size.width * 0.2, size.height * 0.7);
    path2.lineTo(size.width * 0.35, size.height * 0.85);
    path2.lineTo(size.width * 0.2, size.height * 1.0);
    path2.lineTo(size.width * 0.05, size.height * 0.85);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  void _drawHexagons(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    _drawHexagon(
      canvas,
      Offset(size.width * 0.8, size.height * 0.3),
      size.width * 0.3,
      paint,
    );

    paint.color = secondaryColor;
    _drawHexagon(
      canvas,
      Offset(size.width * 0.2, size.height * 0.8),
      size.width * 0.2,
      paint,
    );
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    _drawStar(
      canvas,
      Offset(size.width * 0.8, size.height * 0.3),
      size.width * 0.25,
      paint,
    );

    paint.color = secondaryColor;
    _drawStar(
      canvas,
      Offset(size.width * 0.2, size.height * 0.8),
      size.width * 0.15,
      paint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.5;

    for (var i = 0; i < 10; i++) {
      final angle = (math.pi / 5) * i;
      final currentRadius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + currentRadius * math.cos(angle - math.pi / 2);
      final y = center.dy + currentRadius * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawWaves(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x += 10) {
      final y = size.height * 0.7 +
          math.sin((x / size.width) * 4 * math.pi) * size.height * 0.1;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Second wave
    paint.color = secondaryColor;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.3);

    for (double x = 0; x <= size.width; x += 10) {
      final y = size.height * 0.3 +
          math.sin((x / size.width) * 3 * math.pi + math.pi) *
              size.height *
              0.05;
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
