import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class AnimatedProgressRingWidget extends StatefulWidget {
  const AnimatedProgressRingWidget({
    required this.progress,
    this.size,
    this.strokeWidth,
    this.backgroundColor,
    this.progressColors,
    this.centerChild,
    this.animationDuration,
    this.showPercentage,
    this.percentageStyle,
    this.glowEffect,
    this.particleEffect,
    this.clockwise,
    this.startAngle,
    super.key,
  });

  final double progress; // 0.0 to 1.0
  final double? size;
  final double? strokeWidth;
  final Color? backgroundColor;
  final List<Color>? progressColors;
  final Widget? centerChild;
  final Duration? animationDuration;
  final bool? showPercentage;
  final TextStyle? percentageStyle;
  final bool? glowEffect;
  final bool? particleEffect;
  final bool? clockwise;
  final double? startAngle;

  @override
  State<AnimatedProgressRingWidget> createState() =>
      _AnimatedProgressRingWidgetState();
}

class _AnimatedProgressRingWidgetState extends State<AnimatedProgressRingWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _particleController;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.particleEffect == true) {
      _particleController.repeat();
    }

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressRingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeInOutCubic,
        ),
      );
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 150.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(size, size),
            painter: ProgressRingBackgroundPainter(
              strokeWidth: widget.strokeWidth ?? 12.w,
              backgroundColor: widget.backgroundColor ?? context.gray5,
              startAngle: widget.startAngle ?? -math.pi / 2,
            ),
          ),

          // Progress ring with animation
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size, size),
                painter: ProgressRingPainter(
                  progress: _progressAnimation.value,
                  strokeWidth: widget.strokeWidth ?? 12.w,
                  progressColors: widget.progressColors ??
                      [
                        context.primaryColor,
                        context.primaryColor.withOpacity(0.6),
                      ],
                  glowEffect: widget.glowEffect ?? true,
                  glowIntensity: _glowAnimation.value,
                  clockwise: widget.clockwise ?? true,
                  startAngle: widget.startAngle ?? -math.pi / 2,
                ),
              );
            },
          ),

          // Particle effects
          if (widget.particleEffect == true)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(size, size),
                  painter: ParticleEffectPainter(
                    animation: _particleController,
                    progress: _progressAnimation.value,
                    strokeWidth: widget.strokeWidth ?? 12.w,
                    particleColor:
                        widget.progressColors?.first ?? context.primaryColor,
                    startAngle: widget.startAngle ?? -math.pi / 2,
                  ),
                );
              },
            ),

          // Center content
          if (widget.centerChild != null)
            widget.centerChild!
          else if (widget.showPercentage ?? true)
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(_progressAnimation.value * 100).round()}%',
                      style: widget.percentageStyle ??
                          TextStyle(
                            fontSize: (size * 0.15).sp,
                            fontWeight: FontWeight.bold,
                            color: context.primaryColor,
                          ),
                    ),
                    if (widget.progress > 0)
                      Text(
                        'مكتمل',
                        style: TextStyle(
                          fontSize: (size * 0.08).sp,
                          color: context.onSurfaceColor.withOpacity(0.7),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class ProgressRingBackgroundPainter extends CustomPainter {
  ProgressRingBackgroundPainter({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.startAngle,
  });
  final double strokeWidth;
  final Color backgroundColor;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProgressRingPainter extends CustomPainter {
  ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColors,
    required this.glowEffect,
    required this.glowIntensity,
    required this.clockwise,
    required this.startAngle,
  });
  final double progress;
  final double strokeWidth;
  final List<Color> progressColors;
  final bool glowEffect;
  final double glowIntensity;
  final bool clockwise;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final sweepAngle = 2 * math.pi * progress * (clockwise ? 1 : -1);

    // Create gradient
    final gradient = SweepGradient(
      colors: progressColors,
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final shader = gradient.createShader(rect);

    // Main progress arc
    final paint = Paint()
      ..shader = shader
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Glow effect
    if (glowEffect) {
      final glowPaint = Paint()
        ..shader = shader
        ..strokeWidth = strokeWidth + 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * glowIntensity);

      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    }

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // Progress indicator dot
    final dotAngle = startAngle + sweepAngle;
    final dotX = center.dx + radius * math.cos(dotAngle);
    final dotY = center.dy + radius * math.sin(dotAngle);

    final dotPaint = Paint()
      ..color = progressColors.first
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 2 + 2, dotPaint);

    // Inner white dot
    final innerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 4, innerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleEffectPainter extends CustomPainter {
  ParticleEffectPainter({
    required this.animation,
    required this.progress,
    required this.strokeWidth,
    required this.particleColor,
    required this.startAngle,
  });
  final Animation<double> animation;
  final double progress;
  final double strokeWidth;
  final Color particleColor;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final progressAngle = startAngle + (2 * math.pi * progress);

    // Create multiple particles along the progress arc
    for (var i = 0; i < 5; i++) {
      final particleProgress = (animation.value + i * 0.2) % 1.0;
      final angle = startAngle + (2 * math.pi * progress * particleProgress);

      if (angle <= progressAngle) {
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        final opacity = (1 - particleProgress) * 0.8;
        final particleSize = (1 - particleProgress) * 4 + 2;

        final paint = Paint()
          ..color = particleColor.withOpacity(opacity)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Predefined progress ring widgets for common use cases
class QuranReadingProgressRing extends StatelessWidget {
  const QuranReadingProgressRing({
    required this.currentPage,
    required this.totalPages,
    this.size,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final progress = currentPage / totalPages;

    return AnimatedProgressRingWidget(
      progress: progress,
      size: size ?? 120.w,
      progressColors: const [
        Color(0xFF2DD4BF),
        Color(0xFF14B8A6),
      ],
      centerChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book,
            color: context.primaryColor,
            size: (size ?? 120.w) * 0.2,
          ),
          SizedBox(height: 4.h),
          Text(
            '$currentPage',
            style: TextStyle(
              fontSize: (size ?? 120.w) * 0.12,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          Text(
            'من $totalPages',
            style: TextStyle(
              fontSize: (size ?? 120.w) * 0.08,
              color: context.onSurfaceColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
      glowEffect: true,
      particleEffect: true,
    );
  }
}

class DhikrCounterRing extends StatelessWidget {
  const DhikrCounterRing({
    required this.currentCount,
    required this.targetCount,
    this.size,
    this.title,
    super.key,
  });

  final int currentCount;
  final int targetCount;
  final double? size;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final progress = currentCount / targetCount;

    return AnimatedProgressRingWidget(
      progress: progress.clamp(0.0, 1.0),
      size: size ?? 100.w,
      progressColors: const [
        Color(0xFFf59e0b),
        Color(0xFFd97706),
      ],
      centerChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$currentCount',
            style: TextStyle(
              fontSize: (size ?? 100.w) * 0.15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFf59e0b),
            ),
          ),
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: (size ?? 100.w) * 0.08,
                color: context.onSurfaceColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
