import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
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
        // بلا خلفية ولا ظل: الأيقونة وحدها، كبقية أيقونات الشريط.
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
      icon: AppIcon(AppIcons.backRight,
          color: AppSkin.of(context).accent, size: 21.sp),
    );
  }
}
