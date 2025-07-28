import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class FlipCard3DWidget extends StatefulWidget {
  const FlipCard3DWidget({
    required this.frontChild,
    required this.backChild,
    this.width,
    this.height,
    this.borderRadius,
    this.flipDuration,
    this.autoFlip,
    this.autoFlipDuration,
    this.flipOnTap,
    this.shadowColor,
    this.elevation,
    this.onFlipComplete,
    super.key,
  });

  final Widget frontChild;
  final Widget backChild;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Duration? flipDuration;
  final bool? autoFlip;
  final Duration? autoFlipDuration;
  final bool? flipOnTap;
  final Color? shadowColor;
  final double? elevation;
  final VoidCallback? onFlipComplete;

  @override
  State<FlipCard3DWidget> createState() => _FlipCard3DWidgetState();
}

class _FlipCard3DWidgetState extends State<FlipCard3DWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool _isShowingFront = true;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: widget.flipDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _flipAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFlipComplete?.call();
      }
    });

    // Auto flip if enabled
    if (widget.autoFlip == true) {
      _startAutoFlip();
    }
  }

  void _startAutoFlip() {
    Future.delayed(widget.autoFlipDuration ?? const Duration(seconds: 3), () {
      if (mounted) {
        flip();
        _startAutoFlip();
      }
    });
  }

  void flip() {
    if (!_flipController.isAnimating) {
      if (_flipController.isCompleted) {
        _flipController.reverse();
      } else {
        _flipController.forward();
      }
      setState(() {
        _isShowingFront = !_isShowingFront;
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    if (widget.flipOnTap ?? true) {
      flip();
    }
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _scaleAnimation]),
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.width ?? 300.w,
              height: widget.height ?? 200.h,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnimation.value * math.pi),
                child: Card(
                  elevation: widget.elevation ?? 8,
                  shadowColor:
                      widget.shadowColor ?? Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(16.r),
                    child: isShowingFront
                        ? widget.frontChild
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: widget.backChild,
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Predefined beautiful card fronts and backs
class QuranVerseCard extends StatelessWidget {
  const QuranVerseCard({
    required this.verseArabic,
    required this.verseTranslation,
    required this.surahName,
    required this.verseNumber,
    this.primaryColor,
    this.textColor,
    super.key,
  });

  final String verseArabic;
  final String verseTranslation;
  final String surahName;
  final int verseNumber;
  final Color? primaryColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return FlipCard3DWidget(
      frontChild: _buildFront(context),
      backChild: _buildBack(context),
      flipOnTap: true,
      autoFlip: false,
    );
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor ?? context.primaryColor,
            (primaryColor ?? context.primaryColor).withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternBackgroundPainter(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Surah name and verse number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      surahName,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '$verseNumber',
                        style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Arabic verse
                Expanded(
                  child: Center(
                    child: Text(
                      verseArabic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.8,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ),
                ),
                // Tap hint
                Text(
                  'اضغط للترجمة',
                  style: TextStyle(
                    color: (textColor ?? Colors.white).withOpacity(0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternBackgroundPainter(
                color: (primaryColor ?? context.primaryColor).withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Translation label
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: primaryColor ?? context.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'الترجمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Translation
                Expanded(
                  child: Center(
                    child: Text(
                      verseTranslation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                // Tap hint
                Text(
                  'اضغط للعودة',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.sp,
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

class IslamicPatternBackgroundPainter extends CustomPainter {
  IslamicPatternBackgroundPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw geometric Islamic pattern
    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        _drawStarPattern(canvas, Offset(x, y), 15, paint);
      }
    }
  }

  void _drawStarPattern(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final path = Path();
    const points = 8;
    final outerRadius = size;
    final innerRadius = size * 0.5;

    for (var i = 0; i < points * 2; i++) {
      final angle = (math.pi * i) / points;
      final radius = i.isEven ? outerRadius : innerRadius;
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
