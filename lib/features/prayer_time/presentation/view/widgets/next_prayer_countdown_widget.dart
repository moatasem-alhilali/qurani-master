import 'dart:async';
import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_animations.dart';

class NextPrayerCountdownWidget extends StatefulWidget {
  const NextPrayerCountdownWidget({
    required this.nextPrayer,
    required this.remainingTime,
    super.key,
  });
  final TimePrayerModel nextPrayer;
  final Duration remainingTime;

  @override
  State<NextPrayerCountdownWidget> createState() =>
      _NextPrayerCountdownWidgetState();
}

class _NextPrayerCountdownWidgetState extends State<NextPrayerCountdownWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Timer _timer;
  late Duration _currentRemainingTime;

  @override
  void initState() {
    super.initState();
    _currentRemainingTime = widget.remainingTime;

    _mainController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentRemainingTime.inSeconds > 0) {
          _currentRemainingTime =
              Duration(seconds: _currentRemainingTime.inSeconds - 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(
        horizontal: 8.sp,
        vertical: 8.sp,
      ),
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 120.h, // Reduced from 200.h to 120.h
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: _getGradientForPrayer(widget.nextPrayer.type),
          ),
          child: Stack(
            children: [
              // Background Animation
              _buildBackgroundAnimation(),

              // Particle Effects
              _buildParticleEffects(),

              // Main Content - Reorganized for compact layout
              _buildCompactContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundAnimation() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: _getAnimatedGradient(),
            ),
            child: _buildPrayerSpecificBackground(),
          ),
        );
      },
    );
  }

  Widget _buildPrayerSpecificBackground() {
    switch (widget.nextPrayer.type) {
      case Prayer.fajr:
        return _buildFajrBackground();
      case Prayer.sunrise:
        return _buildSunriseBackground();
      case Prayer.dhuhr:
        return _buildDhuhrBackground();
      case Prayer.asr:
        return _buildAsrBackground();
      case Prayer.maghrib:
        return _buildMaghribBackground();
      case Prayer.isha:
        return _buildIshaBackground();
      default:
        return Container();
    }
  }

  Widget _buildFajrBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: FajrBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildSunriseBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: SunriseBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildDhuhrBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: DhuhrBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAsrBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: AsrBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildMaghribBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: MaghribBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildIshaBackground() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return CustomPaint(
          painter: IshaBackgroundPainter(_mainController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildParticleEffects() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CustomPaint(
            painter: ParticleEffectsPainter(
              _particleController.value,
              widget.nextPrayer.type,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildCompactContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Left side - Prayer info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'الصلاة القادمة',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.nextPrayer.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            widget.nextPrayer.time,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 8.h),

                // Countdown Timer - Compact version
                _buildCompactCountdownTimer(),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right side - Prayer animation
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _mainController.value *
                    2 *
                    math.pi *
                    0.05, // Slower rotation
                child: PrayerTimeAnimationWidget(
                  prayerType: widget.nextPrayer.type,
                  size: 45, // Further reduced for better fit
                  isActive: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCountdownTimer() {
    final hours = _currentRemainingTime.inHours;
    final minutes = _currentRemainingTime.inMinutes.remainder(60);
    final seconds = _currentRemainingTime.inSeconds.remainder(60);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCompactTimeUnit(hours.toString().padLeft(2, '0'), 'س'),
                  _buildCompactTimeSeparator(),
                  _buildCompactTimeUnit(
                    minutes.toString().padLeft(2, '0'),
                    'د',
                  ),
                  _buildCompactTimeSeparator(),
                  _buildCompactTimeUnit(
                    seconds.toString().padLeft(2, '0'),
                    'ث',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactTimeUnit(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            height: 1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 9.sp,
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactTimeSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Opacity(
            opacity: 0.5 + (_pulseController.value * 0.5),
            child: Text(
              ':',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  LinearGradient _getGradientForPrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a237e), // Deep navy blue
            const Color(0xFF3949ab), // Soft indigo
            const Color(0xFF7986cb), // Light indigo
            const Color(0xFF9c27b0).withOpacity(0.3), // Soft purple accent
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        );
      case Prayer.sunrise:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF42a5f5), // Soft sky blue
            const Color(0xFF66bb6a), // Gentle mint
            const Color(0xFFffb74d), // Warm peach
            const Color(0xFFffcc02).withOpacity(0.8), // Soft golden
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      case Prayer.dhuhr:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF81c784), // Soft green
            const Color(0xFFaed581), // Light lime
            const Color(0xFFdce775), // Gentle yellow
            const Color(0xFFfff176).withOpacity(0.9), // Soft bright yellow
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      case Prayer.asr:
        return LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFFffb74d), // Warm amber
            const Color(0xFFffa726), // Soft orange
            const Color(0xFFff8a65), // Gentle coral
            const Color(0xFFffab91).withOpacity(0.8), // Light peach
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      case Prayer.maghrib:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFef5350), // Soft red
            const Color(0xFFec407a), // Gentle pink
            const Color(0xFFab47bc), // Soft purple
            const Color(0xFF7e57c2).withOpacity(0.9), // Deep lavender
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      case Prayer.isha:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2c387e), // Deep navy
            const Color(0xFF303f9f), // Soft indigo
            const Color(0xFF512da8), // Deep purple
            const Color(0xFF1a1a2e).withOpacity(0.95), // Very dark blue
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        );
      default:
        return const LinearGradient(
          colors: [
            Color(0xFF78909c), // Soft blue-gray
            Color(0xFF90a4ae), // Light blue-gray
          ],
        );
    }
  }

  LinearGradient _getAnimatedGradient() {
    final baseGradient = _getGradientForPrayer(widget.nextPrayer.type);
    final animationValue = _mainController.value;

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: baseGradient.colors.map((color) {
        // Subtle breathing effect - much gentler than before
        final breathingEffect =
            (math.sin(animationValue * 2 * math.pi) + 1) / 2;
        return Color.lerp(
          color,
          color.withOpacity(0.9),
          breathingEffect * 0.1, // Very subtle opacity change
        )!;
      }).toList(),
      stops: baseGradient.stops,
    );
  }
}

// Custom Painters for each prayer background
class FajrBackgroundPainter extends CustomPainter {
  FajrBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw moving clouds - reduced movement range
    for (var i = 0; i < 3; i++) {
      final offset = (animationValue + i * 0.3) % 1.0;
      final cloudX = size.width * offset - 30; // Reduced from -50
      final cloudY = size.height * 0.3 + i * 15; // Adjusted position

      paint.color = const Color(0xFF9c27b0).withOpacity(0.08); // Soft purple
      canvas.drawCircle(Offset(cloudX, cloudY), 20, paint); // Reduced size
      canvas.drawCircle(Offset(cloudX + 15, cloudY), 15, paint);
      canvas.drawCircle(Offset(cloudX - 15, cloudY), 12, paint);
    }

    // Draw twinkling effect - constrained to card bounds
    for (var i = 0; i < 15; i++) {
      // Reduced from 20
      final x = (size.width / 15) * i;
      final y = size.height * 0.2 +
          math.sin(animationValue * 2 * math.pi + i) * 15; // Reduced movement
      final opacity =
          (math.sin(animationValue * 4 * math.pi + i * 0.5) + 1) / 2;

      paint.color =
          const Color(0xFF7986cb).withOpacity(opacity * 0.4); // Soft indigo
      canvas.drawCircle(Offset(x, y), 1.5, paint); // Reduced size
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SunriseBackgroundPainter extends CustomPainter {
  SunriseBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw sun rays - reduced length to stay within bounds
    final center =
        Offset(size.width * 0.75, size.height * 0.25); // Adjusted position
    const rayLength = 60.0; // Reduced from 100.0

    for (var i = 0; i < 8; i++) {
      final angle = (i * 45 + animationValue * 180) * (math.pi / 180);
      final startX = center.dx + math.cos(angle) * 20; // Reduced from 30
      final startY = center.dy + math.sin(angle) * 20;
      final endX = center.dx + math.cos(angle) * rayLength;
      final endY = center.dy + math.sin(angle) * rayLength;

      // Ensure rays don't go outside canvas bounds
      if (endX >= 0 && endX <= size.width && endY >= 0 && endY <= size.height) {
        paint.color = const Color(0xFFffb74d).withOpacity(0.25); // Warm peach
        paint.strokeWidth = 2;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    }

    // Draw moving light waves - reduced amplitude
    for (var i = 0; i < 2; i++) {
      // Reduced from 3
      final waveY = size.height * 0.7 + i * 20; // Adjusted position
      final path = Path();
      path.moveTo(0, waveY);

      for (double x = 0; x <= size.width; x += 10) {
        final y = waveY +
            math.sin(
                  (x / size.width) * 4 * math.pi + animationValue * 2 * math.pi,
                ) *
                8; // Reduced amplitude
        path.lineTo(x, y);
      }

      paint.color = const Color(0xFF66bb6a).withOpacity(0.15); // Gentle mint
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DhuhrBackgroundPainter extends CustomPainter {
  DhuhrBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw bright sun with pulsing effect
    final sunCenter = Offset(size.width * 0.2, size.height * 0.2);
    final sunRadius = 40 + math.sin(animationValue * 2 * math.pi) * 8;

    // Sun glow
    paint.color =
        const Color(0xFFfff176).withOpacity(0.08); // Soft bright yellow
    canvas.drawCircle(sunCenter, sunRadius * 2, paint);

    paint.color = const Color(0xFFdce775).withOpacity(0.2); // Gentle yellow
    canvas.drawCircle(sunCenter, sunRadius, paint);

    // Draw heat waves
    for (var i = 0; i < 5; i++) {
      final waveX = size.width * (i / 5.0);
      final path = Path();
      path.moveTo(waveX, 0);

      for (double y = 0; y <= size.height; y += 10) {
        final x = waveX +
            math.sin(
                  (y / size.height) * 6 * math.pi +
                      animationValue * 3 * math.pi,
                ) *
                15;
        path.lineTo(x, y);
      }

      paint.color = const Color(0xFF81c784).withOpacity(0.12); // Soft green
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AsrBackgroundPainter extends CustomPainter {
  AsrBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw afternoon sun moving across
    final sunX = size.width * 0.7 + math.cos(animationValue * 2 * math.pi) * 40;
    final sunY =
        size.height * 0.3 + math.sin(animationValue * 2 * math.pi) * 25;

    paint.color = const Color(0xFFffb74d).withOpacity(0.3); // Warm amber
    canvas.drawCircle(Offset(sunX, sunY), 30, paint);

    // Draw shadow patterns
    for (var i = 0; i < 4; i++) {
      final shadowX = size.width * (i / 4.0) + animationValue * 80;
      final shadowY = size.height * 0.8;

      paint.color = const Color(0xFF6d4c41).withOpacity(0.08); // Soft brown
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(shadowX % size.width, shadowY),
          width: 60,
          height: 15,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MaghribBackgroundPainter extends CustomPainter {
  MaghribBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw setting sun
    final sunX = size.width * 0.8;
    final sunY = size.height * 0.6 + math.sin(animationValue * math.pi) * 30;

    paint.color = const Color(0xFFef5350).withOpacity(0.4); // Soft red
    canvas.drawCircle(Offset(sunX, sunY), 35, paint);

    // Draw horizon line with waves
    final horizonY = size.height * 0.7;
    final path = Path();
    path.moveTo(0, horizonY);

    for (double x = 0; x <= size.width; x += 20) {
      final y = horizonY +
          math.sin(
                (x / size.width) * 3 * math.pi + animationValue * 2 * math.pi,
              ) *
              8;
      path.lineTo(x, y);
    }

    paint.color = const Color(0xFFab47bc).withOpacity(0.2); // Soft purple
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IshaBackgroundPainter extends CustomPainter {
  IshaBackgroundPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw moon
    final moonX = size.width * 0.8;
    final moonY = size.height * 0.2;

    paint.color = const Color(0xFFb0bec5).withOpacity(0.6); // Soft blue-gray
    canvas.drawCircle(Offset(moonX, moonY), 25, paint);

    // Draw twinkling stars
    for (var i = 0; i < 15; i++) {
      final x = (size.width / 15) * i;
      final y = size.height * 0.1 + (i % 3) * 50;
      final twinkle = math.sin(animationValue * 4 * math.pi + i * 0.7);
      final opacity = (twinkle + 1) / 2;

      paint.color =
          const Color(0xFFecf0f1).withOpacity(opacity * 0.5); // Soft white
      canvas.drawCircle(Offset(x, y), 2, paint);
    }

    // Draw night clouds
    for (var i = 0; i < 2; i++) {
      final cloudX = size.width * (i * 0.6) + animationValue * 25;
      final cloudY = size.height * 0.4 + i * 40;

      paint.color = const Color(0xFF37474f).withOpacity(0.15); // Soft dark gray
      canvas.drawCircle(Offset(cloudX % size.width, cloudY), 50, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleEffectsPainter extends CustomPainter {
  ParticleEffectsPainter(this.animationValue, this.prayerType);
  final double animationValue;
  final Prayer prayerType;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (prayerType) {
      case Prayer.fajr:
        _drawFajrParticles(canvas, size, paint);
      case Prayer.sunrise:
        _drawSunriseParticles(canvas, size, paint);
      case Prayer.dhuhr:
        _drawDhuhrParticles(canvas, size, paint);
      case Prayer.asr:
        _drawAsrParticles(canvas, size, paint);
      case Prayer.maghrib:
        _drawMaghribParticles(canvas, size, paint);
      case Prayer.isha:
        _drawIshaParticles(canvas, size, paint);
      default:
        break;
    }
  }

  void _drawFajrParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 10; i++) {
      final x = size.width * (i / 10.0);
      final y =
          size.height * 0.5 + math.sin(animationValue * 2 * math.pi + i) * 30;
      final opacity =
          (math.sin(animationValue * 3 * math.pi + i * 0.5) + 1) / 2;

      paint.color =
          const Color(0xFF7986cb).withOpacity(opacity * 0.3); // Soft indigo
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  void _drawSunriseParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 8; i++) {
      final x = size.width * 0.2 +
          math.cos(animationValue * 2 * math.pi + i * 0.8) * 60;
      final y = size.height * 0.2 +
          math.sin(animationValue * 2 * math.pi + i * 0.8) * 60;

      paint.color = const Color(0xFFffb74d).withOpacity(0.4); // Warm peach
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  void _drawDhuhrParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 + animationValue * 360) * (math.pi / 180);
      final x = size.width * 0.5 + math.cos(angle) * 80;
      final y = size.height * 0.5 + math.sin(angle) * 80;

      paint.color = const Color(0xFFdce775).withOpacity(0.4); // Gentle yellow
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  void _drawAsrParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 6; i++) {
      final x = size.width * (animationValue + i * 0.2) % size.width;
      final y =
          size.height * 0.6 + math.sin(animationValue * 2 * math.pi + i) * 20;

      paint.color = const Color(0xFFff8a65).withOpacity(0.3); // Gentle coral
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  void _drawMaghribParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 8; i++) {
      final x = size.width * (i / 8.0);
      final y =
          size.height * 0.3 + math.sin(animationValue * 1.5 * math.pi + i) * 40;
      final opacity =
          (math.cos(animationValue * 2 * math.pi + i * 0.7) + 1) / 2;

      paint.color =
          const Color(0xFFec407a).withOpacity(opacity * 0.25); // Gentle pink
      canvas.drawCircle(Offset(x, y), 6, paint);
    }
  }

  void _drawIshaParticles(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 15; i++) {
      final x = size.width * (i / 15.0);
      final y = size.height * 0.2 + (i % 4) * 40;
      final twinkle = math.sin(animationValue * 3 * math.pi + i * 0.4);
      final opacity = (twinkle + 1) / 2;

      paint.color =
          const Color(0xFFb0bec5).withOpacity(opacity * 0.5); // Soft blue-gray
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
