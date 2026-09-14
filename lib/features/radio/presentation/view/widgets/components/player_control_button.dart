import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// زرّ تحكّم في المشغّل.
///
/// الأزرار الثانوية بلا تعبئة ولا حدّ — أيقونة على الأرضية مباشرة — والزرّ
/// الرئيسي وحده يرتفع بتعبئة ذهبية، فيبقى في الشاشة عنصر بارز واحد.
class PlayerControlButton extends StatelessWidget {
  const PlayerControlButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    this.tooltip,
    super.key,
  });

  final HugeIconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final size = isPrimary ? 56.w : 38.w;
    final radius = isPrimary ? 18.r : 12.r;

    return Semantics(
      label: tooltip,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: isPrimary ? skin.raisedShadow : null,
          ),
          child: Center(
            child: AppIcon(
              icon,
              color: isPrimary
                  ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                  : skin.ink.withValues(alpha: 0.72),
              size: isPrimary ? 26.sp : 18.sp,
              strokeWidth: isPrimary ? 2.2 : 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
