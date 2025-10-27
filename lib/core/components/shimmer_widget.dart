import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShimmerSkeletonizerWidget extends StatelessWidget {
  const ShimmerSkeletonizerWidget({
    required this.child,
    this.isLoading = true,
    super.key,
  });
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    return Skeletonizer(
      enabled: isLoading,
      child: child,
    );
  }
}

class BaseAnimate extends StatelessWidget {
  const BaseAnimate({
    required this.index,
    required this.child,
    super.key,
  });
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    // return child.animate().fadeIn(delay: Duration(milliseconds: index * 100));
    return child;
  }
}

// class BaseAnimateSlideLeft extends StatelessWidget {
//   BaseAnimateSlideLeft({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fadeIn(delay: Duration(milliseconds: index * 100))
//         .slide(
//           begin: Offset(horizontalOffset ?? -0.1, verticalOffset ?? 0),
//           duration: 1.seconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         );
//   }
// }

// class BaseAnimateSlideRight extends StatelessWidget {
//   BaseAnimateSlideRight({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fadeIn(delay: Duration(milliseconds: index * 100))
//         .slide(
//           begin: Offset(horizontalOffset ?? 0.5, verticalOffset ?? 0),
//           duration: 1.seconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         );
//   }
// }

// class BaseAnimateSlideDownList extends StatelessWidget {
//   BaseAnimateSlideDownList({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fade(delay: Duration(milliseconds: index * 100))
//         .slide(
//           begin: Offset(0, verticalOffset ?? -0.5),
//           duration: 1.seconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         );
//   }
// }

// class BaseAnimateFlipList extends StatelessWidget {
//   BaseAnimateFlipList({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fadeIn(delay: Duration(milliseconds: index * 100))
//         .slide(
//           begin: const Offset(0.1, 0),
//           duration: 500.milliseconds,
//         )
//         .flip(
//           duration: 500.milliseconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         );
//   }
// }

// class BaseAnimateScaleUpList extends StatelessWidget {
//   BaseAnimateScaleUpList({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fadeIn(delay: Duration(milliseconds: index * 100))
//         .animate()
//         .scale(
//           begin: const Offset(2, 2),
//           duration: 500.milliseconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         )
//         .animate()
//         .shimmer(duration: 2000.ms);
//   }
// }

// class BaseAnimateScaleDownList extends StatelessWidget {
//   BaseAnimateScaleDownList({
//     required this.child,
//     required this.index,
//     super.key,
//     this.horizontalOffset,
//     this.verticalOffset,
//   });
//   final Widget child;
//   final int index;
//   double? horizontalOffset;
//   double? verticalOffset;
//   @override
//   Widget build(BuildContext context) {
//     return child
//         .animate()
//         .fadeIn(delay: Duration(milliseconds: index * 100))
//         .animate()
//         .scale(
//           duration: 500.milliseconds,
//           curve: Curves.easeOut,
//           delay: Duration(milliseconds: index * 100),
//         );
//   }
// }
