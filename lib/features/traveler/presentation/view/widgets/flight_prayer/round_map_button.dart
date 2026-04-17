import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class RoundMapButton extends StatelessWidget {
  const RoundMapButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        border: Border.all(color: context.outlineVariant.withValues(alpha: 0.38)),
      ),
      child: IconButton(onPressed: onTap, icon: Icon(icon)),
    );
  }
}
