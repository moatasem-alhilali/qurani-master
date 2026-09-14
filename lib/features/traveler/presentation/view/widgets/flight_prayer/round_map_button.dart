import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// زرّ تحكّم صغير فوق الخريطة.
class RoundMapButton extends StatelessWidget {
  const RoundMapButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    super.key,
  });

  final HugeIconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: skin.ground.withValues(alpha: 0.94),
            shape: BoxShape.circle,
            border: Border.all(color: skin.hairline),
          ),
          child: Center(
            child: AppIcon(icon, color: skin.accent, size: 15.sp),
          ),
        ),
      ),
    );
  }
}
