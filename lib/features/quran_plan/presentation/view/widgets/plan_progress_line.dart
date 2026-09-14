import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// تقدّم الخطة: خطّ بسُمك شعرة يمتلئ ذهبًا.
///
/// الحلقة الكبيرة والبطاقة الملوّنة كانتا تأخذان ثلث الصفّ ليقولا ما يقوله
/// خطّ واحد. والتعبئة تتحرّك لا تُبدَّل، حتى يُحسّ الإنجاز.
class PlanProgressLine extends StatelessWidget {
  const PlanProgressLine({required this.value, super.key});

  /// نسبة الإنجاز بين ٠ و ١.
  final double value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      height: 3.h,
      decoration: BoxDecoration(
        color: skin.hairline,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: AlignmentDirectional.centerStart,
        widthFactor: value.clamp(0.0, 1.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ),
    );
  }
}
