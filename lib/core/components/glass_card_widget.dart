import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassCardWidget extends StatelessWidget {
  const GlassCardWidget({
    required this.child,
    this.borderRadius,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.border,
    super.key,
  });
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color?.withOpacity(0.12) ?? Colors.white.withOpacity(0.12),
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        border: Border.all(
          color: color?.withOpacity(0.15) ?? Colors.white.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
