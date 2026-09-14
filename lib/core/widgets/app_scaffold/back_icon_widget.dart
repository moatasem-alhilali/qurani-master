import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

class BackIconWidget extends StatelessWidget {
  const BackIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        highlightColor: context.surfaceColor.withOpacity(0.5),
        overlayColor: context.surfaceColor.withOpacity(0.5),
        shadowColor: context.surfaceColor.withOpacity(0.5),
        surfaceTintColor: context.surfaceColor.withOpacity(0.5),
        shape: const CircleBorder(),
      ),
      padding: EdgeInsets.all(8.w),
      constraints: BoxConstraints(
        minWidth: 40.w,
        minHeight: 40.w,
        maxWidth: 40.w,
        maxHeight: 40.w,
      ),
      onPressed: () {
        context.pop();
      },
      // كان `size: 50` يعتمد على الانكماش القديم داخل [AppIcon]؛ بعد أن صار
      // المقاس يعني حجم الأيقونة نفسها يلزم رقم واقعي وإلا فاضت عن زرّها.
      icon: AppIcon(AppIcons.backRight, size: 20.sp),
    );
  }
}
