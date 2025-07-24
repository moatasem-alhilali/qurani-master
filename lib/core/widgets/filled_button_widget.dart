import 'package:flutter/material.dart';

class FilledButtonWidget extends StatelessWidget {
  const FilledButtonWidget({
    super.key,
    this.onPressed,
    this.child,
    this.borderRadius,
    this.color,
    this.padding,
    this.margin,
  });
  final VoidCallback? onPressed;
  final Widget? child;
  final double? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          backgroundColor: color ?? Colors.transparent,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
