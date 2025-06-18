import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
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
      padding: padding ?? EdgeInsets.all(16.sp),
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: color ?? context.secondary,
        border: border,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 1,
        //     offset: const Offset(0, 1),
        //   ),
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 1,
        //     offset: const Offset(1, 0),
        //   ),
        // ],
      ),
      child: child,
    );
  }
}
