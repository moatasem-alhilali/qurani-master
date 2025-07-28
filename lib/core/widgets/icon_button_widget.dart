import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    required this.icon,
    required this.onPressed,
    this.isCircle = true,
    this.backgroundColor,
    this.tooltip,
    this.size,
    super.key,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool isCircle;
  final Color? backgroundColor;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        highlightColor: context.primaryColor.withOpacity(0.5),
        overlayColor: context.primaryColor.withOpacity(0.5),
        shadowColor: context.primaryColor.withOpacity(0.5),
        surfaceTintColor: context.primaryColor.withOpacity(0.5),
        shape: isCircle ? const CircleBorder() : null,
      ),
      // constraints: BoxConstraints(
      //   minWidth: size ?? 0,
      //   minHeight: size ?? 0,
      //   maxWidth: size ?? 0,
      //   maxHeight: size ?? 0,
      // ),
      // padding: const EdgeInsets.all(10),
      tooltip: tooltip,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
