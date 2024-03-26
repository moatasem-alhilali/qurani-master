import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class BaseShimmer extends StatelessWidget {
  const BaseShimmer({
    super.key,
    required this.child,
    this.baseColors,
  });
  final Widget child;
  final Color? baseColors;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.8),
      highlightColor: const Color.fromARGB(255, 215, 215, 215),
      enabled: true,
      child: child,
    );
  }
}

class BaseAnimate extends StatelessWidget {
  const BaseAnimate({
    super.key,
    required this.index,
    required this.child,
  });
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return child.animate().fadeIn(delay: Duration(milliseconds: index * 100));
  }
}

class BaseAnimateSlideLeft extends StatelessWidget {
  BaseAnimateSlideLeft({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slide(
          begin: Offset(horizontalOffset ?? -0.1, verticalOffset ?? 0),
          duration: 1.seconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        );
  }
}

class BaseAnimateSlideRight extends StatelessWidget {
  BaseAnimateSlideRight({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slide(
          begin: Offset(horizontalOffset ?? 0.5, verticalOffset ?? 0),
          duration: 1.seconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        );
  }
}

class BaseAnimateSlideDownList extends StatelessWidget {
  BaseAnimateSlideDownList({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fade(delay: Duration(milliseconds: index * 100))
        .slide(
          begin: Offset(0, verticalOffset ?? -0.5),
          duration: 1.seconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        );
  }
}

class BaseAnimateFlipList extends StatelessWidget {
  BaseAnimateFlipList({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slide(
          begin: const Offset(0.1, 0),
          duration: 500.milliseconds,
        )
        .flip(
          duration: 500.milliseconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        );
  }
}

class BaseAnimateScaleUpList extends StatelessWidget {
  BaseAnimateScaleUpList({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .animate()
        .scale(
          begin: const Offset(2, 2),
          duration: 500.milliseconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        )
        .animate()
        .shimmer(duration: 2000.ms);
  }
}

class BaseAnimateScaleDownList extends StatelessWidget {
  BaseAnimateScaleDownList({
    super.key,
    required this.child,
    required this.index,
    this.horizontalOffset,
    this.verticalOffset,
  });
  final Widget child;
  final int index;
  double? horizontalOffset;
  double? verticalOffset;
  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .animate()
        .scale(
          duration: 500.milliseconds,
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 100),
        );
  }
}
