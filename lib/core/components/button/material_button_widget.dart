import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

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
    this.focusElevation,
    this.highlightElevation,
    this.hoverElevation,
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
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
      elevation: elevation ?? 0,
      hoverColor: context.primaryColor.withOpacity(0.1),
      highlightColor: context.primaryColor.withOpacity(0.1),
      focusColor: context.primaryColor.withOpacity(0.1),
      splashColor: context.primaryColor.withOpacity(0.1),
      hoverElevation: hoverElevation ?? 0,
      focusElevation: focusElevation ?? 0,
      highlightElevation: highlightElevation ?? 0,
      child: child,
    );
  }
}
