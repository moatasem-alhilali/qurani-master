import 'package:flutter/material.dart';
import 'dart:math' as math;

class EnhancedSpiritualLoadingWidget extends StatefulWidget {
  const EnhancedSpiritualLoadingWidget({
    super.key,
    this.size = 120.0,
    this.color,
    this.showParticles = true,
    this.showText = true,
    this.animationDuration = const Duration(seconds: 4),
  });

  final double size;
  final Color? color;
  final bool showParticles;
  final bool showText;
  final Duration animationDuration;

  @override
  State<EnhancedSpiritualLoadingWidget> createState() =>
      _EnhancedSpiritualLoadingWidgetState();
}

class _EnhancedSpiritualLoadingWidgetState
    extends State<EnhancedSpiritualLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _starRotationController;

  // Enhanced glow effects
  late Animation<double> _starGlow;
  late Animation<double> _starPulse;

  // Particle system
  late Animation<double> _particleOpacity;
  late Animation<double> _particleRotation;

  // Star rotation
  late Animation<double> _starRotation;

  @override
  void initState() {
    super.initState();

    _initializeControllers();
    _setupAnimations();
    _startAnimations();
  }

  void _initializeControllers() {
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _starRotationController = AnimationController(
      duration: const Duration(milliseconds: 20000), // Very slow rotation
      vsync: this,
    );
  }

  void _setupAnimations() {
    // Enhanced star animations
    _starGlow = Tween<double>(
      begin: 0.2,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _starPulse = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Particle animations
    _particleOpacity = Tween<double>(
      begin: 0,
      end: 0.7,
    ).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );

    _particleRotation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.linear,
      ),
    );

    // Star rotation - very slow and continuous
    _starRotation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _starRotationController,
        curve: Curves.linear,
      ),
    );
  }

  void _startAnimations() {
    _glowController.repeat(reverse: true);
    _particleController.repeat();
    _starRotationController.repeat(); // Continuous slow rotation
  }

  @override
  void dispose() {
    _glowController.dispose();
    _particleController.dispose();
    _starRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.color ??
        (isDark ? const Color(0xFFE5D4B1) : const Color(0xFF9B8364));

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _glowController,
          _particleController,
          _starRotationController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _starPulse.value,
            child: CustomPaint(
              painter: EnhancedSpiritualLoadingPainter(
                starGlow: _starGlow.value,
                starRotation: _starRotation.value,
                particleOpacity:
                    widget.showParticles ? _particleOpacity.value : 0.0,
                particleRotation: _particleRotation.value,
                baseColor: baseColor,
                showText: widget.showText,
                starScale: _starPulse.value,
              ),
              size: Size(widget.size, widget.size),
            ),
          );
        },
      ),
    );
  }
}

class EnhancedSpiritualLoadingPainter extends CustomPainter {
  EnhancedSpiritualLoadingPainter({
    required this.starGlow,
    required this.starRotation,
    required this.particleOpacity,
    required this.particleRotation,
    required this.baseColor,
    required this.showText,
    required this.starScale,
  });

  final double starGlow;
  final double starRotation;
  final double particleOpacity;
  final double particleRotation;
  final Color baseColor;
  final bool showText;
  final double starScale;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw particle effects first (background layer)
    if (particleOpacity > 0) {
      _drawParticles(canvas, center, radius);
    }

    // Save canvas state for rotation
    canvas.save();

    // Apply rotation to star only
    canvas.translate(center.dx, center.dy);
    canvas.rotate(starRotation);
    canvas.translate(-center.dx, -center.dy);

    // Draw 8-pointed star with enhanced glow
    _drawEnhancedStar(canvas, center, radius, starGlow);

    // Restore canvas state (remove rotation for inner elements)
    canvas.restore();

    // Draw text inside the star (after restoring rotation so text doesn't rotate)
    if (showText) {
      _drawCenterText(canvas, center, radius);
    }
  }

  void _drawParticles(Canvas canvas, Offset center, double radius) {
    final particlePaint = Paint()
      ..color = baseColor.withOpacity((particleOpacity * 0.4).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    // Draw small floating particles around the star
    for (var i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + particleRotation;
      final particleRadius =
          radius * (0.6 + math.sin(particleRotation + i) * 0.1);
      final particleX = center.dx + particleRadius * math.cos(angle);
      final particleY = center.dy + particleRadius * math.sin(angle);

      final particleSize = 1.5 + math.sin(particleRotation * 2 + i) * 0.5;
      canvas.drawCircle(
        Offset(particleX, particleY),
        particleSize,
        particlePaint,
      );
    }
  }

  void _drawEnhancedStar(
    Canvas canvas,
    Offset center,
    double radius,
    double glowIntensity,
  ) {
    final starPath = Path();
    final outerRadius = radius * 0.45; // Slightly larger for better proportions
    final innerRadius =
        outerRadius * 0.75; // Higher ratio for softer, broader points

    // Create 8-pointed star path with softer transitions
    for (var i = 0; i < 16; i++) {
      final angle = (i * math.pi) / 8;
      final currentRadius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    // Multiple glow layers for enhanced effect
    for (var i = 3; i >= 1; i--) {
      final glowPaint = Paint()
        ..color =
            baseColor.withOpacity((glowIntensity * 0.15 * i).clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 * i);

      canvas.drawPath(starPath, glowPaint);
    }

    // Draw star outline with gradient effect
    final starPaint = Paint()
      ..color = baseColor.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(starPath, starPaint);
  }

  void _drawCenterText(Canvas canvas, Offset center, double radius) {
    // Scale the text size based on the star scale and radius
    final textSize = (radius * 0.15 * starScale).clamp(8.0, 24.0);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'طمأنينه', // Arabic text meaning "tranquility"
        style: TextStyle(
          fontFamily: 'ios-1',
          fontSize: textSize,
          color: baseColor,
          // fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(0, 1),
              blurRadius: 2,
              color: baseColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.rtl, // Right-to-left for Arabic
    );

    textPainter.layout();

    // Center the text
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    // Apply scaling to the text position and size
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(starScale);
    canvas.translate(-center.dx, -center.dy);

    textPainter.paint(canvas, textOffset);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
