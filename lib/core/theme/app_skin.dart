import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// لوحة أسطح التطبيق، تتبدّل مع الوضع الفاتح والداكن.
///
/// الأرضية محايدة تمامًا: أبيض نقيّ في الفاتح وأسود في الداكن. جُرِّبت أرضية
/// ورقية دافئة أولًا فكانت مرهقة للعين على امتداد الصفحة.
///
/// الدفء لم يُلغَ — انتقل إلى اللمسات وحدها: الذهب في [accent]، والسطح
/// المرتفع [raised]، والمشهد العلوي. فتبقى هوية «طمأنينة» ظاهرة دون أن
/// تتحمّلها العين في كل بكسل.
@immutable
class AppSkin {
  const AppSkin._({
    required this.ground,
    required this.raised,
    required this.hairline,
    required this.ink,
    required this.inkSoft,
    required this.accent,
    required this.isDark,
  });

  factory AppSkin.of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  /// أرضية الصفحة — امتداد لأسفل المشهد، فلا قطع بين السماء والمحتوى.
  final Color ground;

  /// سطح مرتفع: محجوز للعنصر الواحد المسموح له بالارتفاع في الشاشة.
  final Color raised;

  /// خط الفصل — شعرة واحدة، لا حدّ حول صندوق.
  final Color hairline;

  final Color ink;
  final Color inkSoft;
  final Color accent;
  final bool isDark;

  static const light = AppSkin._(
    ground: AppColors.surface,
    raised: AppColors.brandCream,
    hairline: AppColors.divider,
    ink: AppColors.onSurface,
    inkSoft: AppColors.brandBrown,
    accent: AppColors.brandGoldDeep,
    isDark: false,
  );

  static const dark = AppSkin._(
    ground: Colors.black,
    raised: AppColors.brandNight,
    hairline: AppColors.brandDusk,
    ink: AppColors.brandIvory,
    inkSoft: AppColors.brandSand,
    accent: AppColors.brandGoldLight,
    isDark: true,
  );

  /// خلفية مربّع الأيقونة الصغير.
  Color get iconChip => AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12);

  /// حدّ العنصر المرتفع.
  Color get raisedBorder => isDark ? AppColors.brandGoldLight : AppColors.gold;

  /// ظلّ خفيف — يُلغى في الوضع الداكن لأن الظلال لا تُقرأ على أرضية داكنة.
  List<BoxShadow> get raisedShadow => isDark
      ? const []
      : [
          BoxShadow(
            color: AppColors.brandBrownDeep.withValues(alpha: 0.12),
            blurRadius: 9.r,
            offset: Offset(0, 3.h),
          ),
        ];

  /// الهامش الجانبي الموحّد لكل أقسام الشاشة.
  static EdgeInsets get gutter => EdgeInsets.symmetric(horizontal: 16.w);

  /// فاصل بعرض المحتوى بين الأقسام.
  Widget divider() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Divider(height: 1, thickness: 1, color: hairline),
      );
}
