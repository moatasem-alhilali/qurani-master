import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerTimeAnimationWidget extends StatelessWidget {
  const PrayerTimeAnimationWidget({
    required this.prayerType,
    super.key,
    this.size = 50.0,
    this.isActive = false,
  });
  final Prayer prayerType;
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    switch (prayerType) {
      case Prayer.fajr:
        return FajrAnimation(size: size, isActive: isActive);
      case Prayer.sunrise:
        return SunriseAnimation(size: size, isActive: isActive);
      case Prayer.dhuhr:
        return DhuhrAnimation(size: size, isActive: isActive);
      case Prayer.asr:
        return AsrAnimation(size: size, isActive: isActive);
      case Prayer.maghrib:
        return MaghribAnimation(size: size, isActive: isActive);
      case Prayer.isha:
        return IshaAnimation(size: size, isActive: isActive);
      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        );
    }
  }
}

// Fajr (Dawn) Animation
class FajrAnimation extends StatefulWidget {
  const FajrAnimation({required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<FajrAnimation> createState() => _FajrAnimationState();
}

class _FajrAnimationState extends State<FajrAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            gradient: RadialGradient(
              colors: [
                Colors.orange.withOpacity(_glowAnimation.value),
                Colors.pink.withOpacity(_glowAnimation.value * 0.5),
                Colors.purple.withOpacity(_glowAnimation.value * 0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
          ),
          child: Center(
            child: Container(
              width: widget.size * 0.6,
              height: widget.size * 0.6,
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.circular(widget.size * 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Sunrise Animation
class SunriseAnimation extends StatefulWidget {
  const SunriseAnimation(
      {required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<SunriseAnimation> createState() => _SunriseAnimationState();
}

class _SunriseAnimationState extends State<SunriseAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _riseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _riseAnimation = Tween<double>(begin: 0.8, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * 3.14159).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Background gradient
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade200,
                      Colors.orange.shade200,
                      Colors.yellow.shade100,
                    ],
                  ),
                ),
              ),
              // Sun
              Positioned(
                left: widget.size * 0.25,
                top: widget.size * _riseAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: widget.size * 0.5,
                    height: widget.size * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(widget.size * 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: SunRaysPainter(),
                    ),
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

// Dhuhr (Noon) Animation
class DhuhrAnimation extends StatefulWidget {
  const DhuhrAnimation({required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<DhuhrAnimation> createState() => _DhuhrAnimationState();
}

class _DhuhrAnimationState extends State<DhuhrAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            gradient: RadialGradient(
              colors: [
                Colors.yellow.shade300,
                Colors.orange.shade300,
                Colors.blue.shade100,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Center(
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade600,
                  borderRadius: BorderRadius.circular(widget.size * 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.8),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: SunRaysPainter(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Asr (Afternoon) Animation
class AsrAnimation extends StatefulWidget {
  const AsrAnimation({required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<AsrAnimation> createState() => _AsrAnimationState();
}

class _AsrAnimationState extends State<AsrAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _moveAnimation = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade300,
                Colors.amber.shade200,
                Colors.yellow.shade100,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: widget.size * _moveAnimation.value,
                top: widget.size * _moveAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    width: widget.size * 0.5,
                    height: widget.size * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(widget.size * 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
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

// Maghrib (Sunset) Animation
class MaghribAnimation extends StatefulWidget {
  const MaghribAnimation(
      {required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<MaghribAnimation> createState() => _MaghribAnimationState();
}

class _MaghribAnimationState extends State<MaghribAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sunsetAnimation;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _sunsetAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(
                  Colors.orange.shade300,
                  Colors.red.shade400,
                  _colorAnimation.value,
                )!,
                Color.lerp(
                  Colors.red.shade300,
                  Colors.purple.shade300,
                  _colorAnimation.value,
                )!,
                Color.lerp(
                  Colors.purple.shade200,
                  Colors.indigo.shade200,
                  _colorAnimation.value,
                )!,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: widget.size * 0.25,
                top: widget.size * _sunsetAnimation.value,
                child: Container(
                  width: widget.size * 0.5,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      Colors.orange.shade400,
                      Colors.red.shade500,
                      _colorAnimation.value,
                    ),
                    borderRadius: BorderRadius.circular(widget.size * 0.25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ],
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

// Isha (Night) Animation
class IshaAnimation extends StatefulWidget {
  const IshaAnimation({required this.size, required this.isActive, super.key});
  final double size;
  final bool isActive;

  @override
  State<IshaAnimation> createState() => _IshaAnimationState();
}

class _IshaAnimationState extends State<IshaAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _twinkleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _twinkleAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _twinkleAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade800,
                Colors.purple.shade900,
                Colors.black87,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Moon
              Positioned(
                left: widget.size * 0.15,
                top: widget.size * 0.15,
                child: Opacity(
                  opacity: _twinkleAnimation.value,
                  child: Container(
                    width: widget.size * 0.35,
                    height: widget.size * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(widget.size * 0.175),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Stars
              Positioned(
                right: widget.size * 0.2,
                top: widget.size * 0.2,
                child: Opacity(
                  opacity: _twinkleAnimation.value * 0.8,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: widget.size * 0.3,
                top: widget.size * 0.6,
                child: Opacity(
                  opacity: _twinkleAnimation.value * 0.6,
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: widget.size * 0.6,
                top: widget.size * 0.4,
                child: Opacity(
                  opacity: _twinkleAnimation.value * 0.9,
                  child: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
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

// Custom painter for sun rays
class SunRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.shade600
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final start = Offset(
        center.dx + (radius * 0.6) * cos(angle),
        center.dy + (radius * 0.6) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius * 0.9) * cos(angle),
        center.dy + (radius * 0.9) * sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double cos(double angle) => math.cos(angle);
double sin(double angle) => math.sin(angle);
