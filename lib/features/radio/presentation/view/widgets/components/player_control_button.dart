import 'package:flutter/material.dart';

class PlayerControlButton extends StatelessWidget {
  const PlayerControlButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    required this.borderRadius,
    required this.bgColor,
    required this.iconColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
