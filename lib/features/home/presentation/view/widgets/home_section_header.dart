import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// عنوان قسم: سطر واحد صغير، بلا شرطة ولا وصف.
///
/// الوصف تحت كل عنوان كان يضيف سطرًا لا يقول شيئًا جديدًا ويطيل الصفحة،
/// فحُذف. العنوان وحده يكفي.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasAction = actionLabel != null && onAction != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          if (hasAction)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(999.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: TextStyle(
                        color: skin.accent,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppIcon(
                      AppIcons.chevronLeft,
                      color: skin.accent,
                      size: 13.sp,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
