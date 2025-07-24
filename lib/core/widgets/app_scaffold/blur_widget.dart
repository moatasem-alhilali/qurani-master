
import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    required this.child,
    this.sigmaX,
    this.sigmaY,
    this.borderRadius,
    super.key,
  });

  final double? sigmaX;
  final double? sigmaY;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX ?? 5,
          sigmaY: sigmaY ?? 5,
        ),
        child: child,
      ),
    );
  }
}
