import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

/// A custom animated Tasbih (Muslim prayer beads) widget that provides
/// a realistic, interactive prayer bead counting experience
class AnimatedTasbihWidget extends StatefulWidget {
  /// Creates an animated Tasbih widget
  const AnimatedTasbihWidget({
    super.key,
    this.beadCount = 33,
    this.onCountChanged,
    this.initialCount = 0,
    this.primaryColor,
    this.secondaryColor,
    this.stringColor,
    this.countTextStyle,
    this.showCount = true,
    this.animationDuration = const Duration(milliseconds: 700),
    this.enableHapticFeedback = true,
    this.enableDragging = true,
    this.minAnimationDuration = const Duration(milliseconds: 300),
  });

  /// Number of beads in the tasbih (default: 33)
  final int beadCount;

  /// Callback when count changes
  final ValueChanged<int>? onCountChanged;

  /// Initial count value
  final int initialCount;

  /// Primary color for beads (defaults to theme primary color)
  final Color? primaryColor;

  /// Secondary color for beads (defaults to a darker shade of primary)
  final Color? secondaryColor;

  /// Color of the string connecting beads (defaults to brown)
  final Color? stringColor;

  /// TextStyle for the count display
  final TextStyle? countTextStyle;

  /// Whether to show the count in the center
  final bool showCount;

  /// Duration for the bead animation
  final Duration animationDuration;

  /// Minimum duration for the animation when moving rapidly
  final Duration minAnimationDuration;

  /// Whether to enable haptic feedback on count
  final bool enableHapticFeedback;

  /// Whether to enable dragging beads
  final bool enableDragging;

  @override
  State<AnimatedTasbihWidget> createState() => _AnimatedTasbihWidgetState();
}

class _AnimatedTasbihWidgetState extends State<AnimatedTasbihWidget>
    with SingleTickerProviderStateMixin {
  late int _count;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _bounceAnimation;
  int _targetBeadIndex = 0;
  int _startBeadIndex = 0;
  bool _isDragging = false;
  double _dragStartAngle = 0;
  double _dragCurrentAngle = 0;
  Offset? _dragStartPosition;
  bool _isAnimationInProgress = false;
  int _pendingCount = 0;
  int _lastTargetBeadIndex = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Main animation for bead movement
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Bounce animation when bead reaches its destination
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1),
      ),
    );

    _animationController.addStatusListener(_onAnimationStatusChanged);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Update count when animation completes
      setState(() {
        _count = (_count + 1) % (widget.beadCount + 1);
        if (_count == 0) _count = 1; // Skip zero
        _isAnimationInProgress = false;
      });

      if (widget.onCountChanged != null) {
        widget.onCountChanged!(_count);
      }

      // Check if we have pending counts to process
      if (_pendingCount > 0) {
        _processNextPendingCount();
      }
    }
  }

  void _processNextPendingCount() {
    if (_pendingCount > 0) {
      setState(() {
        _pendingCount--;
        _startBeadIndex = _targetBeadIndex;
        _targetBeadIndex = (_targetBeadIndex + 1) % widget.beadCount;
      });
      _startSmoothAnimation();
    }
  }

  void _startSmoothAnimation() {
    // Calculate the remaining distance to travel
    final totalDistance =
        _calculateBeadDistance(_startBeadIndex, _targetBeadIndex);

    // Adjust animation duration based on distance
    final adjustedDuration = _calculateAdjustedDuration(totalDistance);

    _animationController.duration = adjustedDuration;

    if (_animationController.isAnimating) {
      // If already animating, smoothly transition to the new target
      final currentValue = _animationController.value;
      _animationController.stop();

      // Reset the animation with new start and target
      _animationController.reset();
      _animationController.forward(from: currentValue);
    } else {
      _animationController.forward(from: 0);
    }
  }

  double _calculateBeadDistance(int startIndex, int targetIndex) {
    // Calculate the shortest path distance between beads
    var distance = (targetIndex - startIndex).abs();
    if (distance > widget.beadCount / 2) {
      distance = widget.beadCount - distance;
    }
    return distance.toDouble();
  }

  Duration _calculateAdjustedDuration(double distance) {
    // Adjust duration based on distance but ensure it's not too short
    final normalizedDistance = distance / widget.beadCount;
    final factor =
        1.0 + normalizedDistance * 2; // Scale factor based on distance

    final calculatedDuration = Duration(
      milliseconds: (widget.animationDuration.inMilliseconds / factor).round(),
    );

    // Ensure we don't go below the minimum animation duration
    return calculatedDuration.compareTo(widget.minAnimationDuration) < 0
        ? widget.minAnimationDuration
        : calculatedDuration;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Increments the count and triggers the animation
  void _incrementCount() {
    // Provide haptic feedback
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    setState(() {
      if (_isAnimationInProgress) {
        // If animation is already in progress, queue the next count
        _pendingCount++;
        _lastTargetBeadIndex = (_targetBeadIndex + 1) % widget.beadCount;
      } else {
        // Start a new animation
        _isAnimationInProgress = true;
        _startBeadIndex = _count % widget.beadCount;
        _targetBeadIndex = (_startBeadIndex + 1) % widget.beadCount;
        _startSmoothAnimation();
      }
    });
  }

  /// Handles the start of a drag gesture
  void _onDragStart(
    DragStartDetails details,
    Size size,
    Offset center,
    double radius,
  ) {
    if (!widget.enableDragging || _animationController.isAnimating) return;

    final touchPosition = details.localPosition;
    final touchVector = touchPosition - center;
    final touchDistance = touchVector.distance;

    // Only start dragging if the touch is close to the beads path
    final beadPathRadius = radius * 0.4;
    final distanceFromPath = (touchDistance - beadPathRadius).abs();

    if (distanceFromPath < 30) {
      _isDragging = true;
      _dragStartPosition = touchPosition;
      _dragStartAngle = _calculateAngleFromPosition(touchPosition, center);
      _dragCurrentAngle = _dragStartAngle;
    }
  }

  /// Handles drag updates
  void _onDragUpdate(DragUpdateDetails details, Offset center) {
    if (!_isDragging) return;

    final touchPosition = details.localPosition;
    final newAngle = _calculateAngleFromPosition(touchPosition, center);
    final angleDiff = _normalizeAngleDifference(newAngle - _dragStartAngle);

    // Calculate how many beads we've moved past
    final beadsPerRadian = widget.beadCount / (2 * pi);
    final beadsMoved = (angleDiff * beadsPerRadian).round();

    if (beadsMoved != 0) {
      setState(() {
        _count = (_count + beadsMoved) % (widget.beadCount + 1);
        if (_count == 0) _count = 1; // Skip zero

        // Provide haptic feedback
        if (widget.enableHapticFeedback) {
          HapticFeedback.selectionClick();
        }

        // Update for next drag calculation
        _dragStartAngle = newAngle;

        // Update target bead index for visualization
        if (_isAnimationInProgress) {
          _pendingCount += beadsMoved;
          _lastTargetBeadIndex =
              (_lastTargetBeadIndex + beadsMoved) % widget.beadCount;
        } else {
          _isAnimationInProgress = true;
          _startBeadIndex = _count % widget.beadCount;
          _targetBeadIndex = (_startBeadIndex + beadsMoved) % widget.beadCount;
          _startSmoothAnimation();
        }
      });

      if (widget.onCountChanged != null) {
        widget.onCountChanged!(_count);
      }
    }

    _dragCurrentAngle = newAngle;
  }

  /// Handles the end of a drag gesture
  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    _dragStartPosition = null;
  }

  /// Calculates angle from a position relative to center
  double _calculateAngleFromPosition(Offset position, Offset center) {
    final vector = position - center;
    return atan2(vector.dy, vector.dx);
  }

  /// Normalizes angle difference to ensure proper direction
  double _normalizeAngleDifference(double angleDiff) {
    if (angleDiff > pi) {
      angleDiff -= 2 * pi;
    } else if (angleDiff < -pi) {
      angleDiff += 2 * pi;
    }
    return angleDiff;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? context.primaryScheme;
    final secondaryColor =
        widget.secondaryColor ?? primaryColor.withOpacity(0.7);
    final stringColor = widget.stringColor ?? const Color(0xFF8B4513); // Brown

    return GestureDetector(
      onTap: _incrementCount,
      onPanStart: (details) {
        final size = context.size!;
        final center = Offset(size.width / 2, size.height / 2);
        final radius = size.shortestSide / 2;
        _onDragStart(details, size, center, radius);
      },
      onPanUpdate: (details) {
        final size = context.size!;
        final center = Offset(size.width / 2, size.height / 2);
        _onDragUpdate(details, center);
      },
      onPanEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([_animation, _bounceAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: TasbihPainter(
              beadCount: widget.beadCount,
              activeBeadIndex: _startBeadIndex,
              targetBeadIndex: _targetBeadIndex,
              animationValue: _animation.value,
              bounceScale: _bounceAnimation.value,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              stringColor: stringColor,
              isDragging: _isDragging,
            ),
            child: Center(
              child: widget.showCount
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        _count.toString(),
                        style: widget.countTextStyle ??
                            theme.textTheme.displayLarge?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter that draws the Tasbih beads and string
class TasbihPainter extends CustomPainter {
  TasbihPainter({
    required this.beadCount,
    required this.activeBeadIndex,
    required this.targetBeadIndex,
    required this.animationValue,
    required this.bounceScale,
    required this.primaryColor,
    required this.secondaryColor,
    required this.stringColor,
    this.isDragging = false,
  });

  final int beadCount;
  final int activeBeadIndex;
  final int targetBeadIndex;
  final double animationValue;
  final double bounceScale;
  final Color primaryColor;
  final Color secondaryColor;
  final Color stringColor;
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shortestSide = size.shortestSide;
    final radius = shortestSide * 0.4; // Radius of the tasbih loop
    final beadRadius = shortestSide * 0.05; // Radius of each bead

    // Apply a slight jiggle effect to the entire string when animating
    final jiggleAmount = isDragging ? 0.0 : sin(animationValue * pi * 2) * 2.0;
    final jiggleOffset = Offset(0, jiggleAmount);

    // Draw the string (path)
    final stringPaint = Paint()
      ..color = stringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw main loop with slight jiggle
    canvas.drawOval(
      Rect.fromCenter(
        center: center + jiggleOffset,
        width: radius * 2,
        height: radius * 2.1, // Slightly oval shape
      ),
      stringPaint,
    );

    // Draw tassel/tail with more natural curve
    final path = Path();
    final tailStartPoint =
        Offset(center.dx, center.dy + radius * 1.05) + jiggleOffset;
    path.moveTo(tailStartPoint.dx, tailStartPoint.dy);

    // Create a more natural S-curve for the tassel
    path.cubicTo(
      tailStartPoint.dx + 15,
      tailStartPoint.dy + 20,
      tailStartPoint.dx - 15,
      tailStartPoint.dy + 40,
      tailStartPoint.dx,
      tailStartPoint.dy + 60,
    );
    canvas.drawPath(path, stringPaint);

    // Draw decorative knot at the end
    final knotPaint = Paint()
      ..color = stringColor
      ..style = PaintingStyle.fill;

    // Draw a more detailed knot with two parts
    final knotCenter =
        Offset(tailStartPoint.dx, tailStartPoint.dy + 65) + jiggleOffset;
    canvas.drawOval(
      Rect.fromCenter(
        center: knotCenter,
        width: 12,
        height: 18,
      ),
      knotPaint,
    );

    // Small decorative bead at the very end
    final endBeadPaint = Paint()
      ..color = primaryColor.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(knotCenter.dx, knotCenter.dy + 15),
      8,
      endBeadPaint,
    );

    // Calculate positions for all beads
    final beadPositions = <Offset>[];
    final angleStep = 2 * pi / beadCount;

    for (var i = 0; i < beadCount; i++) {
      // Start from the bottom and go counter-clockwise (traditional tasbih direction)
      final angle = pi / 2 + i * angleStep;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * 1.05 * sin(angle);
      beadPositions.add(Offset(x, y) + jiggleOffset);
    }

    // Draw all beads except the active one
    for (var i = 0; i < beadCount; i++) {
      if (i == activeBeadIndex) {
        continue; // Skip active bead, will draw it separately
      }

      final position = beadPositions[i];

      // Create gradient for 3D effect
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3), // Light source from top-left
        radius: 0.9,
        colors: [
          primaryColor,
          secondaryColor,
        ],
        stops: const [0.3, 1.0],
      );

      final beadPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: position, radius: beadRadius),
        );

      // Draw the bead
      canvas.drawCircle(position, beadRadius, beadPaint);

      // Add highlight for 3D effect
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          position.dx - beadRadius * 0.3,
          position.dy - beadRadius * 0.3,
        ),
        beadRadius * 0.3,
        highlightPaint,
      );

      // Add subtle shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(position.dx + 1, position.dy + 1),
        beadRadius - 1,
        shadowPaint,
      );
    }

    // Draw the active bead with animation
    if (activeBeadIndex >= 0 && activeBeadIndex < beadCount) {
      final startAngle = pi / 2 + activeBeadIndex * angleStep;
      final endAngle = pi / 2 + targetBeadIndex * angleStep;

      // Handle wrapping around the circle
      var angleDiff = endAngle - startAngle;
      if (angleDiff > pi) angleDiff -= 2 * pi;
      if (angleDiff < -pi) angleDiff += 2 * pi;

      final currentAngle = startAngle + angleDiff * animationValue;

      final currentPosition = Offset(
            center.dx + radius * cos(currentAngle),
            center.dy + radius * 1.05 * sin(currentAngle),
          ) +
          jiggleOffset;

      // Apply bounce scale effect
      final scaledBeadRadius = beadRadius * bounceScale;

      // Create gradient for 3D effect
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.9,
        colors: [
          primaryColor,
          secondaryColor,
        ],
        stops: const [0.3, 1.0],
      );

      final beadPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: currentPosition, radius: scaledBeadRadius),
        );

      // Add subtle shadow under the moving bead
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(currentPosition.dx + 1, currentPosition.dy + 1),
        scaledBeadRadius - 1,
        shadowPaint,
      );

      // Draw the active bead
      canvas.drawCircle(currentPosition, scaledBeadRadius, beadPaint);

      // Add highlight for 3D effect
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          currentPosition.dx - scaledBeadRadius * 0.3,
          currentPosition.dy - scaledBeadRadius * 0.3,
        ),
        scaledBeadRadius * 0.3,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TasbihPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.bounceScale != bounceScale ||
        oldDelegate.activeBeadIndex != activeBeadIndex ||
        oldDelegate.targetBeadIndex != targetBeadIndex ||
        oldDelegate.beadCount != beadCount ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.isDragging != isDragging;
  }
}
