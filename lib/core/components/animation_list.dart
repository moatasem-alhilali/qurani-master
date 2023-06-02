import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BaseAnimationListView extends StatelessWidget {
  BaseAnimationListView({
    super.key,
    required this.index,
    required this.child,
     this.duration,
  });
  final int index;
  final Widget child;
  int? duration;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(milliseconds: duration ?? 400),
      child: SlideAnimation(
        horizontalOffset: 200,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
