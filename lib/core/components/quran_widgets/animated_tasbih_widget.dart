import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class AnimatedTasbihWidget extends StatefulWidget {
  const AnimatedTasbihWidget({
    required this.targetCount,
    this.size,
    this.beadColor,
    this.activeBeadColor,
    this.centerColor,
    this.onCountChanged,
    this.onComplete,
    this.dhikrText,
    this.resetOnComplete,
    this.showParticles,
    this.vibrate,
    super.key,
  });

  final int targetCount;
  final double? size;
  final Color? beadColor;
  final Color? activeBeadColor;
  final Color? centerColor;
  final Function(int count)? onCountChanged;
  final VoidCallback? onComplete;
  final String? dhikrText;
  final bool? resetOnComplete;
  final bool? showParticles;
  final bool? vibrate;

  @override
  State<AnimatedTasbihWidget> createState() => _AnimatedTasbihWidgetState();
}

class _AnimatedTasbihWidgetState extends State<AnimatedTasbihWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _completionController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _completionAnimation;

  int currentCount = 0;
  bool isCompleted = false;
  List<ParticleData> particles = [];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _completionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi / widget.targetCount,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.elasticOut,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.elasticOut,
      ),
    );

    _completionAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeInOut,
      ),
    );

    _particleController.addListener(() {
      setState(_updateParticles);
    });
  }

  void _updateParticles() {
    particles.removeWhere((particle) => particle.life <= 0);
    for (final particle in particles) {
      particle.update();
    }
  }

  void _increment() {
    if (isCompleted && widget.resetOnComplete != true) return;

    setState(() {
      if (isCompleted) {
        currentCount = 0;
        isCompleted = false;
        _completionController.reset();
      }

      currentCount++;

      if (currentCount >= widget.targetCount) {
        isCompleted = true;
        _completionController.forward();
        widget.onComplete?.call();

        if (widget.showParticles == true) {
          _createParticles();
          _particleController.reset();
          _particleController.forward();
        }
      }
    });

    // Haptic feedback
    if (widget.vibrate != false) {
      HapticFeedback.lightImpact();
    }

    // Animations
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });

    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });

    widget.onCountChanged?.call(currentCount);
  }

  void _createParticles() {
    final size = widget.size ?? 200.w;
    final center = Offset(size / 2, size / 2);

    for (var i = 0; i < 20; i++) {
      final angle = (math.pi * 2 / 20) * i;
      final velocity = Offset(
        math.cos(angle) * (50 + math.Random().nextDouble() * 50),
        math.sin(angle) * (50 + math.Random().nextDouble() * 50),
      );

      particles.add(
        ParticleData(
          position: center,
          velocity: velocity,
          color: widget.activeBeadColor ?? Colors.orange,
          size: 3 + math.Random().nextDouble() * 4,
          life: 1,
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      currentCount = 0;
      isCompleted = false;
      particles.clear();
    });
    _completionController.reset();
    _rotationController.reset();
    _pulseController.reset();
    _particleController.reset();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 200.w;

    return GestureDetector(
      onTap: _increment,
      onLongPress: _reset,
      child: SizedBox(
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
                    (widget.centerColor ?? context.primaryColor)
                        .withOpacity(0.1),
                    (widget.centerColor ?? context.primaryColor)
                        .withOpacity(0.05),
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

            // Tasbih beads
            AnimatedBuilder(
              animation:
                  Listenable.merge([_rotationAnimation, _completionAnimation]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(size, size),
                  painter: TasbihBeadsPainter(
                    beadCount: widget.targetCount,
                    currentCount: currentCount,
                    rotation: _rotationAnimation.value * currentCount,
                    beadColor: widget.beadColor ?? context.gray3,
                    activeBeadColor: widget.activeBeadColor ?? Colors.orange,
                    completionProgress: _completionAnimation.value,
                    isCompleted: isCompleted,
                  ),
                );
              },
            ),

            // Particles
            if (widget.showParticles == true && particles.isNotEmpty)
              CustomPaint(
                size: Size(size, size),
                painter: ParticlePainter(particles: particles),
              ),

            // Center content
            AnimatedBuilder(
              animation:
                  Listenable.merge([_pulseAnimation, _completionAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green.withOpacity(0.9)
                          : (widget.centerColor ?? context.primaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: (isCompleted
                                  ? Colors.green
                                  : (widget.centerColor ??
                                      context.primaryColor))
                              .withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCompleted)
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: size * 0.08,
                          )
                        else
                          Text(
                            '$currentCount',
                            style: TextStyle(
                              fontSize: size * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (widget.dhikrText != null)
                          Text(
                            widget.dhikrText!,
                            style: TextStyle(
                              fontSize: size * 0.03,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Progress indicator
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  '$currentCount / ${widget.targetCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Instructions
            if (currentCount == 0)
              Positioned(
                top: size * 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'اضغط للعد • اضغط مطولاً للإعادة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TasbihBeadsPainter extends CustomPainter {
  TasbihBeadsPainter({
    required this.beadCount,
    required this.currentCount,
    required this.rotation,
    required this.beadColor,
    required this.activeBeadColor,
    required this.completionProgress,
    required this.isCompleted,
  });
  final int beadCount;
  final int currentCount;
  final double rotation;
  final Color beadColor;
  final Color activeBeadColor;
  final double completionProgress;
  final bool isCompleted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final beadRadius = size.width * 0.03;

    for (var i = 0; i < beadCount; i++) {
      final angle = (2 * math.pi / beadCount) * i + rotation;
      final beadCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final isActive = i < currentCount;
      final paint = Paint()..style = PaintingStyle.fill;

      if (isCompleted) {
        // Rainbow effect when completed
        final hue = (i / beadCount) * 360;
        paint.color = HSVColor.fromAHSV(1, hue, 0.8, 0.9).toColor();
      } else if (isActive) {
        paint.color = activeBeadColor;
      } else {
        paint.color = beadColor;
      }

      // Glow effect for active beads
      if (isActive) {
        final glowPaint = Paint()
          ..color = activeBeadColor.withOpacity(0.4)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
        canvas.drawCircle(beadCenter, beadRadius * 1.5, glowPaint);
      }

      canvas.drawCircle(beadCenter, beadRadius, paint);

      // Inner highlight
      if (isActive || isCompleted) {
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(beadCenter, beadRadius * 0.4, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleData {
  ParticleData({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;

  void update() {
    position += velocity * 0.02;
    velocity *= 0.98; // Friction
    life -= 0.02;
    size *= 0.99;
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({required this.particles});
  final List<ParticleData> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (particle.life > 0) {
        final paint = Paint()
          ..color = particle.color.withOpacity(particle.life)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(particle.position, particle.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Predefined Tasbih widgets for common dhikr
class SubhanAllahTasbih extends StatelessWidget {
  const SubhanAllahTasbih({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return AnimatedTasbihWidget(
      targetCount: 33,
      size: size,
      dhikrText: 'سبحان الله',
      beadColor: Colors.teal.shade200,
      activeBeadColor: Colors.teal,
      centerColor: Colors.teal.shade600,
      showParticles: true,
    );
  }
}

class AlhamdulillahTasbih extends StatelessWidget {
  const AlhamdulillahTasbih({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return AnimatedTasbihWidget(
      targetCount: 33,
      size: size,
      dhikrText: 'الحمد لله',
      beadColor: Colors.green.shade200,
      activeBeadColor: Colors.green,
      centerColor: Colors.green.shade600,
      showParticles: true,
    );
  }
}

class AllahuAkbarTasbih extends StatelessWidget {
  const AllahuAkbarTasbih({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return AnimatedTasbihWidget(
      targetCount: 34,
      size: size,
      dhikrText: 'الله أكبر',
      beadColor: Colors.orange.shade200,
      activeBeadColor: Colors.orange,
      centerColor: Colors.orange.shade600,
      showParticles: true,
    );
  }
}
