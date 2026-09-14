import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// سطر إرشادي أو رسالة خطأ تحت حقل الرحلة — بلا صندوق ولا حدّ.
class HintTile extends StatelessWidget {
  const HintTile({
    required this.icon,
    required this.text,
    this.isError = false,
    super.key,
  });

  final HugeIconData icon;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TravelerIconChip(icon: icon),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              text,
              style: TextStyle(
                color: isError
                    ? AppColors.error
                    : skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                // الخطأ يُقرأ بوزن الخطّ أيضًا، لا بلونه وحده.
                fontWeight: isError ? FontWeight.w700 : FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
