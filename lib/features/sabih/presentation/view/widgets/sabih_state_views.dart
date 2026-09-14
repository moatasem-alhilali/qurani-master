import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// انتظار هادئ: خطّ رفيع بدل دائرة تدور في وسط صفحة فارغة.
class SabihLoading extends StatelessWidget {
  const SabihLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: LinearProgressIndicator(
          minHeight: 3.h,
          backgroundColor: skin.hairline,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      ),
    );
  }
}

/// رسالة حالة مع فعل اختياري — نصّ نحيل بلا بطاقة.
class SabihNotice extends StatelessWidget {
  const SabihNotice({
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasAction = actionLabel != null && onAction != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          if (hasAction) ...[
            SizedBox(height: 8.h),
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(999.r),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
