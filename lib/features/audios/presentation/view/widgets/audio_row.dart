import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// يقرأ حقلاً نصيًّا من عنصر قادم من الـ API بلا استدعاء على نوع `dynamic`.
String audioFieldOf(dynamic item, String key) {
  if (item is Map) {
    return item[key]?.toString() ?? '';
  }
  return '';
}

/// صفّ صوتي نحيل: مربّع أيقونة، عنوان ووصف، ثم سهم أو لاحقة.
///
/// هذا هو النمط الموحّد لكل قوائم الصوت — لا بطاقة حول كل عنصر.
class AudioRow extends StatelessWidget {
  const AudioRow({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isLast = false,
    this.isRaised = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final HugeIconData icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;
  final bool isRaised;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final body = Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: skin.iconChip,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: AppIcon(icon, color: skin.accent, size: 15.sp),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: isRaised ? 14.sp : 12.5.sp,
                  fontWeight: isRaised ? FontWeight.w800 : FontWeight.w600,
                  height: 1.2,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: 8.w),
          trailing!,
        ] else
          AppIcon(
            Directionality.of(context) == TextDirection.rtl
                ? AppIcons.chevronLeft
                : AppIcons.chevronRight,
            color: skin.accent,
            size: 15.sp,
          ),
      ],
    );

    if (isRaised) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: skin.raised,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: skin.raisedBorder),
              boxShadow: skin.raisedShadow,
            ),
            child: body,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: body,
      ),
    );
  }
}
