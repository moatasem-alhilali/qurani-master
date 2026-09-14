import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// علامة طرف المسار على الخريطة: الإقلاع أو الهبوط.
///
/// فوق بلاط الخريطة لا يكفي اللون، فالعلامة قرص من أرضية التطبيق بحلقة
/// ذهبية — تُقرأ فوق البحر والمدينة والصحراء سواء.
class FlightEdgeMarker extends StatelessWidget {
  const FlightEdgeMarker({
    required this.icon,
    this.isDestination = false,
    super.key,
  });

  final HugeIconData icon;

  /// طرف الوصول يأخذ حلقة مصمتة، فيختلف عن الإقلاع بالشكل لا باللون.
  final bool isDestination;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDestination ? skin.accent : skin.ground,
        shape: BoxShape.circle,
        border: Border.all(color: skin.raisedBorder, width: 2),
      ),
      child: Center(
        child: AppIcon(
          icon,
          color: isDestination
              ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
              : skin.accent,
          size: 16.sp,
        ),
      ),
    );
  }
}
