import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// وسم صغير تحت عنوان الذكر: «المناسبة»، «التكرار»، «المصدر».
///
/// كان حبّة ملوّنة بحجم زرّ؛ صار سطرًا واحدًا صغيرًا على خلفية مربّع
/// الأيقونة، فلا يزاحم نصّ الذكر.
class InfoChip extends StatelessWidget {
  const InfoChip({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: skin.ink,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
