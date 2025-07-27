import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class ButtonIconCircleWidget extends StatelessWidget {
  const ButtonIconCircleWidget({
    required this.icon,
    this.color,
    this.iconColor,
    this.onPressed,
    this.disable,
    this.size,
    this.iconSize,
    this.quarterTurns = 0,
    this.padding,
    this.fromPackage = true,
    this.isSvgNetwork = false,
    super.key,
  });

  final Color? color;
  final Color? iconColor;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool? disable;
  final double? size;
  final double? iconSize;
  final int quarterTurns;
  final double? padding;
  final bool fromPackage;
  final bool isSvgNetwork;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 40.h,
      width: size ?? 40.h,
      decoration: BoxDecoration(
        color: color ?? context.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: IconButton(
        padding: EdgeInsets.all(padding ?? 6),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        icon: icon,
      ),
    );
  }
}
