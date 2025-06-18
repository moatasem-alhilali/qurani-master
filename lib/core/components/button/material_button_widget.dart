import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialButtonWidget extends StatelessWidget {
  const MaterialButtonWidget({
    required this.onPressed,
    required this.child,
    this.minWidth,
    this.height,
    this.padding,
    this.color,
    this.disabledColor,
    this.shape,
    this.elevation,
    this.focusElevation = 0,
    this.highlightElevation = 0,
    this.hoverElevation = 0,
    super.key,
  });

  final void Function()? onPressed;
  final Widget? child;
  final double? minWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final ShapeBorder? shape;
  final double? elevation;
  final double? focusElevation;
  final double? highlightElevation;
  final double? hoverElevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed?.call();
        HapticFeedback.lightImpact();
      },
      height: height,
      minWidth: minWidth,
      padding: padding,
      color: color,
      disabledColor: disabledColor,
      shape: shape,
      elevation: elevation,
      hoverElevation: hoverElevation,
      focusElevation: focusElevation,
      highlightElevation: highlightElevation,
      child: child,
    );
  }
}
