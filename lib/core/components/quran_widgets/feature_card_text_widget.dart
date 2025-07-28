import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class FeatureCardTextWidget extends StatelessWidget {
  const FeatureCardTextWidget({
    required this.title,
    this.withBackground = true,
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
    this.maxLines,
    super.key,
  });

  final String title;
  final bool withBackground;
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
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    final cardPrimaryColor = primaryColor ?? context.primaryColor;
    final cardSecondaryColor =
        secondaryColor ?? cardPrimaryColor.withOpacity(0.3);

    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate responsive default sizes
    final defaultWidth = width ?? math.min(screenWidth * 0.4, 160.w);
    final defaultHeight = height ?? math.min(screenHeight * 0.25, 160.h);

    // Calculate responsive values based on actual card size
    final cardWidth = defaultWidth;
    final cardHeight = defaultHeight;
    final minDimension = math.min(cardWidth, cardHeight);

    // Responsive padding and margin
    final responsivePadding = padding ?? EdgeInsets.all(minDimension * 0.1);
    final responsiveMargin =
        margin ?? EdgeInsets.all(math.min(8.w, minDimension * 0.05));

    // Responsive border radius
    final responsiveBorderRadius = borderRadius ??
        BorderRadius.circular(math.min(20.r, minDimension * 0.125));

    // Responsive icon size
    final iconSize = math.min(minDimension * 0.25, 32.sp);

    // Responsive text size
    final textSize = math.min(minDimension * 0.12, 16.sp).clamp(12.sp, 20.sp);

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: responsiveMargin,
      child: Material(
        elevation: elevation ?? math.min(6, minDimension * 0.04),
        shadowColor: shadowColor ?? cardPrimaryColor.withOpacity(0.3),
        borderRadius: responsiveBorderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: responsiveBorderRadius,
          child: ClipRRect(
            borderRadius: responsiveBorderRadius,
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
                  size: Size(cardWidth, cardHeight),
                  painter: GeometricShapePainter(
                    primaryColor: cardSecondaryColor,
                    secondaryColor: cardSecondaryColor.withOpacity(0.5),
                    shapeType: shapeType,
                  ),
                ),
                // Content
                Padding(
                  padding: responsivePadding,
                  child:
                      _buildContent(context, iconSize, textSize, minDimension),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    double iconSize,
    double textSize,
    double minDimension,
  ) {
    // Calculate if we have enough space for both icon and text
    final availableHeight =
        (height ?? math.min(MediaQuery.of(context).size.height * 0.25, 160.h)) -
            (padding?.vertical ?? minDimension * 0.2);

    // Adaptive layout based on available space and content
    if (withBackground) {
      // Icon only - center it
      return Center(
        child: _buildIconContainer(context, textSize, minDimension),
      );
    }

    // Check if we need to use a more compact layout
    final needsCompactLayout = availableHeight < minDimension * 0.8;

    if (needsCompactLayout) {
      // Compact horizontal layout for small cards
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: _buildIconContainer(context, textSize * 0.8, minDimension),
          ),
          SizedBox(width: minDimension * 0.05),
          Flexible(
            flex: 3,
            child: _buildTitleText(context, textSize * 0.9),
          ),
        ],
      );
    }

    // Standard vertical layout
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (withBackground)
          _buildIconContainer(context, textSize, minDimension),
        if (withBackground) SizedBox(height: minDimension * 0.08),
        _buildTitleText(context, textSize),
      ],
    );
  }

  Widget _buildIconContainer(
    BuildContext context,
    double textSize,
    double minDimension,
  ) {
    return Container(
      padding: EdgeInsets.all(minDimension * 0.08),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(minDimension * 0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: math.max(1, minDimension * 0.005),
        ),
      ),
      alignment: Alignment.center,
      child: _buildTitleText(context, textSize),
    );
  }

  Widget _buildTitleText(BuildContext context, double textSize) {
    if (title.isEmpty) return const SizedBox.shrink();

    return title.autoSize(
      context,
      style: context.titleMedium?.copyWith(
        color: textColor ?? Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: textSize,
        height: 1.2,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
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
    // Ensure shapes scale properly with any size
    final scaleFactor = math.min(size.width, size.height) / 160;

    switch (shapeType) {
      case CardShapeType.circles:
        _drawCircles(canvas, size, scaleFactor);
      case CardShapeType.triangles:
        _drawTriangles(canvas, size, scaleFactor);
      case CardShapeType.diamonds:
        _drawDiamonds(canvas, size, scaleFactor);
      case CardShapeType.hexagons:
        _drawHexagons(canvas, size, scaleFactor);
      case CardShapeType.stars:
        _drawStars(canvas, size, scaleFactor);
      case CardShapeType.waves:
        _drawWaves(canvas, size, scaleFactor);
    }
  }

  void _drawCircles(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large background circle - positioned relative to size
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      math.min(size.width, size.height) * 0.4 * scaleFactor,
      paint,
    );

    // Medium circle
    paint.color = secondaryColor;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      math.min(size.width, size.height) * 0.25 * scaleFactor,
      paint,
    );

    // Small circles
    paint.color = primaryColor.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      math.min(size.width, size.height) * 0.1 * scaleFactor,
      paint,
    );
  }

  void _drawTriangles(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large triangle - scale with size
    final path1 = Path();
    path1.moveTo(size.width * 0.8, 0);
    path1.lineTo(size.width * (1.2 * scaleFactor), size.height * 0.5);
    path1.lineTo(size.width * (0.4 * scaleFactor), size.height * 0.5);
    path1.close();
    canvas.drawPath(path1, paint);

    // Small triangle
    paint.color = secondaryColor;
    final path2 = Path();
    path2.moveTo(size.width * 0.1, size.height * 0.9);
    path2.lineTo(size.width * (0.4 * scaleFactor), size.height * 0.6);
    path2.lineTo(size.width * (-0.1 * scaleFactor), size.height * 0.6);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  void _drawDiamonds(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Large diamond - responsive sizing
    final path1 = Path();
    final centerX = size.width * 0.8;
    final centerY = size.height * 0.4;
    final diamondSize = math.min(size.width, size.height) * 0.3 * scaleFactor;

    path1.moveTo(centerX, centerY - diamondSize);
    path1.lineTo(centerX + diamondSize, centerY);
    path1.lineTo(centerX, centerY + diamondSize);
    path1.lineTo(centerX - diamondSize, centerY);
    path1.close();
    canvas.drawPath(path1, paint);

    // Small diamond
    paint.color = secondaryColor;
    final path2 = Path();
    final smallCenterX = size.width * 0.2;
    final smallCenterY = size.height * 0.8;
    final smallDiamondSize =
        math.min(size.width, size.height) * 0.15 * scaleFactor;

    path2.moveTo(smallCenterX, smallCenterY - smallDiamondSize);
    path2.lineTo(smallCenterX + smallDiamondSize, smallCenterY);
    path2.lineTo(smallCenterX, smallCenterY + smallDiamondSize);
    path2.lineTo(smallCenterX - smallDiamondSize, smallCenterY);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  void _drawHexagons(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    _drawHexagon(
      canvas,
      Offset(size.width * 0.8, size.height * 0.3),
      math.min(size.width, size.height) * 0.2 * scaleFactor,
      paint,
    );

    paint.color = secondaryColor;
    _drawHexagon(
      canvas,
      Offset(size.width * 0.2, size.height * 0.8),
      math.min(size.width, size.height) * 0.12 * scaleFactor,
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

  void _drawStars(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    _drawStar(
      canvas,
      Offset(size.width * 0.8, size.height * 0.3),
      math.min(size.width, size.height) * 0.18 * scaleFactor,
      paint,
    );

    paint.color = secondaryColor;
    _drawStar(
      canvas,
      Offset(size.width * 0.2, size.height * 0.8),
      math.min(size.width, size.height) * 0.1 * scaleFactor,
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

  void _drawWaves(Canvas canvas, Size size, double scaleFactor) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Responsive wave amplitude
    final waveAmplitude = size.height * 0.08 * scaleFactor;
    final waveFrequency = 4 * math.pi * scaleFactor;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Adaptive wave resolution based on width
    final step = math.max(2, size.width / 50);
    for (double x = 0; x <= size.width; x += step) {
      final y = size.height * 0.7 +
          math.sin((x / size.width) * waveFrequency) * waveAmplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Second wave with different frequency
    paint.color = secondaryColor;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.3);

    for (double x = 0; x <= size.width; x += step) {
      final y = size.height * 0.3 +
          math.sin((x / size.width) * 3 * math.pi * scaleFactor + math.pi) *
              waveAmplitude *
              0.5;
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
