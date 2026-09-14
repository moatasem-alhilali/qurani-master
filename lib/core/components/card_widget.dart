import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

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
      padding: padding ?? EdgeInsets.all(8.sp),
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        // كانت الخلفية الافتراضية `context.surfaceColor` من اللوحة القديمة
        // (بنّي فاتح في الفاتح، ‎#222326‎ في الداكن)، فبقي كل ما يستعمل هذا
        // الغلاف جزيرةً بالثيم القديم داخل شاشات أُعيد تصميمها.
        color: color ?? AppSkin.of(context).raised,
        border: border,
      ),
      child: child,
    );
  }
}
