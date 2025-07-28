import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class BreathingAnimationWidget extends StatefulWidget {
  const BreathingAnimationWidget({
    this.size,
    this.primaryColor,
    this.secondaryColor,
    this.breathingPattern,
    this.showInstructions,
    this.showCounter,
    this.onCycleComplete,
    this.autoStart,
    this.dhikrText,
    super.key,
  });

  final double? size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final BreathingPattern? breathingPattern;
  final bool? showInstructions;
  final bool? showCounter;
  final Function(int cycles)? onCycleComplete;
  final bool? autoStart;
  final String? dhikrText;

  @override
  State<BreathingAnimationWidget> createState() =>
      _BreathingAnimationWidgetState();
}

class _BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late AnimationController _particleController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  BreathingPhase currentPhase = BreathingPhase.inhale;
  int cycleCount = 0;
  bool isPlaying = false;
  List<BreathingParticle> particles = [];

  @override
  void initState() {
    super.initState();

    final pattern = widget.breathingPattern ?? BreathingPatterns.fourSevenEight;

    _breathingController = AnimationController(
      duration: Duration(milliseconds: pattern.totalDurationMs),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
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

    _colorAnimation = ColorTween(
      begin: widget.primaryColor ?? Colors.blue,
      end: widget.secondaryColor ?? Colors.lightBlue,
    ).animate(_breathingAnimation);

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          cycleCount++;
        });
        widget.onCycleComplete?.call(cycleCount);
        if (isPlaying) {
          _breathingController.reset();
          _breathingController.forward();
        }
      }
    });

    _breathingAnimation.addListener(() {
      _updatePhase();
      _updateParticles();
    });

    _pulseController.repeat(reverse: true);
    _particleController.repeat();

    if (widget.autoStart == true) {
      start();
    }

    _initializeParticles();
  }

  void _initializeParticles() {
    final size = widget.size ?? 200.w;
    for (var i = 0; i < 12; i++) {
      particles.add(
        BreathingParticle(
          angle: (2 * math.pi / 12) * i,
          baseRadius: size * 0.4,
          color: (widget.primaryColor ?? Colors.blue).withOpacity(0.3),
        ),
      );
    }
  }

  void _updatePhase() {
    final pattern = widget.breathingPattern ?? BreathingPatterns.fourSevenEight;
    final progress = _breathingAnimation.value;

    if (progress < pattern.inhaleRatio) {
      if (currentPhase != BreathingPhase.inhale) {
        setState(() {
          currentPhase = BreathingPhase.inhale;
        });
      }
    } else if (progress < pattern.inhaleRatio + pattern.holdRatio) {
      if (currentPhase != BreathingPhase.hold) {
        setState(() {
          currentPhase = BreathingPhase.hold;
        });
      }
    } else {
      if (currentPhase != BreathingPhase.exhale) {
        setState(() {
          currentPhase = BreathingPhase.exhale;
        });
      }
    }
  }

  void _updateParticles() {
    final progress = _breathingAnimation.value;
    for (final particle in particles) {
      particle.update(progress);
    }
  }

  void start() {
    setState(() {
      isPlaying = true;
    });
    _breathingController.reset();
    _breathingController.forward();
  }

  void stop() {
    setState(() {
      isPlaying = false;
    });
    _breathingController.stop();
  }

  void reset() {
    setState(() {
      isPlaying = false;
      cycleCount = 0;
      currentPhase = BreathingPhase.inhale;
    });
    _breathingController.reset();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
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
          // Background gradient
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (_colorAnimation.value ?? Colors.blue).withOpacity(0.1),
                      (_colorAnimation.value ?? Colors.blue).withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),

          // Breathing particles
          AnimatedBuilder(
            animation:
                Listenable.merge([_breathingAnimation, _particleController]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(size, size),
                painter: BreathingParticlePainter(
                  particles: particles,
                  animationValue: _particleController.value,
                ),
              );
            },
          ),

          // Main breathing circle
          AnimatedBuilder(
            animation: Listenable.merge(
              [_breathingAnimation, _pulseAnimation, _colorAnimation],
            ),
            builder: (context, child) {
              final breathingScale = _getBreathingScale();
              return Transform.scale(
                scale: breathingScale * _pulseAnimation.value,
                child: Container(
                  width: size * 0.6,
                  height: size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _colorAnimation.value ?? Colors.blue,
                        (_colorAnimation.value ?? Colors.blue).withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_colorAnimation.value ?? Colors.blue)
                            .withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.dhikrText != null)
                          Text(
                            widget.dhikrText!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (widget.showCounter == true)
                          Text(
                            '$cycleCount',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: size * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Breathing instruction
          if (widget.showInstructions != false)
            Positioned(
              bottom: size * 0.15,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(currentPhase),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getPhaseText(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // Control buttons
          Positioned(
            bottom: -size * 0.15,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'breathing_play',
                  onPressed: isPlaying ? stop : start,
                  backgroundColor: widget.primaryColor ?? Colors.blue,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),
                FloatingActionButton.small(
                  heroTag: 'breathing_reset',
                  onPressed: reset,
                  backgroundColor: Colors.grey,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getBreathingScale() {
    final pattern = widget.breathingPattern ?? BreathingPatterns.fourSevenEight;
    final progress = _breathingAnimation.value;

    if (progress < pattern.inhaleRatio) {
      // Inhale: grow from 0.6 to 1.0
      final inhaleProgress = progress / pattern.inhaleRatio;
      return 0.6 + (0.4 * inhaleProgress);
    } else if (progress < pattern.inhaleRatio + pattern.holdRatio) {
      // Hold: stay at 1.0
      return 1;
    } else {
      // Exhale: shrink from 1.0 to 0.6
      final exhaleProgress =
          (progress - pattern.inhaleRatio - pattern.holdRatio) /
              pattern.exhaleRatio;
      return 1.0 - (0.4 * exhaleProgress);
    }
  }

  String _getPhaseText() {
    switch (currentPhase) {
      case BreathingPhase.inhale:
        return 'استنشق';
      case BreathingPhase.hold:
        return 'احبس النفس';
      case BreathingPhase.exhale:
        return 'اخرج النفسك';
    }
  }
}

enum BreathingPhase {
  inhale,
  hold,
  exhale,
}

class BreathingPattern {
  BreathingPattern({
    required this.inhaleDuration,
    required this.holdDuration,
    required this.exhaleDuration,
    required this.name,
  });
  final int inhaleDuration;
  final int holdDuration;
  final int exhaleDuration;
  final String name;

  int get totalDurationMs =>
      (inhaleDuration + holdDuration + exhaleDuration) * 1000;
  double get inhaleRatio =>
      inhaleDuration / (inhaleDuration + holdDuration + exhaleDuration);
  double get holdRatio =>
      holdDuration / (inhaleDuration + holdDuration + exhaleDuration);
  double get exhaleRatio =>
      exhaleDuration / (inhaleDuration + holdDuration + exhaleDuration);
}

class BreathingPatterns {
  static final fourSevenEight = BreathingPattern(
    inhaleDuration: 4,
    holdDuration: 7,
    exhaleDuration: 8,
    name: '4-7-8 التنفس',
  );

  static final equal = BreathingPattern(
    inhaleDuration: 4,
    holdDuration: 4,
    exhaleDuration: 4,
    name: 'التنفس المتساوي',
  );

  static final calm = BreathingPattern(
    inhaleDuration: 4,
    holdDuration: 2,
    exhaleDuration: 6,
    name: 'التنفس الهادئ',
  );

  static final energizing = BreathingPattern(
    inhaleDuration: 3,
    holdDuration: 3,
    exhaleDuration: 3,
    name: 'التنفس المنشط',
  );
}

class BreathingParticle {
  BreathingParticle({
    required this.angle,
    required this.baseRadius,
    required this.color,
  })  : currentRadius = baseRadius,
        opacity = 1.0;
  final double angle;
  final double baseRadius;
  final Color color;
  double currentRadius;
  double opacity;

  void update(double breathingProgress) {
    // Particles move in and out with breathing
    currentRadius =
        baseRadius + (math.sin(breathingProgress * 2 * math.pi) * 20);
    opacity = 0.3 + (math.sin(breathingProgress * 2 * math.pi) * 0.4);
  }

  Offset get position {
    return Offset(
      currentRadius * math.cos(angle),
      currentRadius * math.sin(angle),
    );
  }
}

class BreathingParticlePainter extends CustomPainter {
  BreathingParticlePainter({
    required this.particles,
    required this.animationValue,
  });
  final List<BreathingParticle> particles;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final position = center + particle.position;
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      // Add gentle rotation to particles
      final rotatedAngle = particle.angle + (animationValue * math.pi / 4);
      final rotatedPosition = center +
          Offset(
            particle.currentRadius * math.cos(rotatedAngle),
            particle.currentRadius * math.sin(rotatedAngle),
          );

      canvas.drawCircle(rotatedPosition, 4, paint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(rotatedPosition, 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Predefined breathing widgets for specific purposes
class DhikrBreathingWidget extends StatelessWidget {
  const DhikrBreathingWidget({
    this.size,
    this.dhikrText,
    super.key,
  });

  final double? size;
  final String? dhikrText;

  @override
  Widget build(BuildContext context) {
    return BreathingAnimationWidget(
      size: size,
      primaryColor: Colors.green.shade600,
      secondaryColor: Colors.green.shade300,
      breathingPattern: BreathingPatterns.calm,
      dhikrText: dhikrText ?? 'لا إله إلا الله',
      showInstructions: true,
      showCounter: true,
      autoStart: false,
    );
  }
}

class RelaxationBreathingWidget extends StatelessWidget {
  const RelaxationBreathingWidget({
    this.size,
    super.key,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return BreathingAnimationWidget(
      size: size,
      primaryColor: Colors.blue.shade600,
      secondaryColor: Colors.blue.shade300,
      breathingPattern: BreathingPatterns.fourSevenEight,
      dhikrText: 'استرخ',
      showInstructions: true,
      showCounter: true,
      autoStart: false,
    );
  }
}
