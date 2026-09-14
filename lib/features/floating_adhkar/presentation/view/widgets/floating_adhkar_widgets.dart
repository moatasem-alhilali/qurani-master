import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';

/// صفّ واحد في شاشات الأذكار العائمة: مربّع أيقونة، عنوان، وصف، ثم سهم.
///
/// هذا بديل الصناديق الملوّنة التي كانت تحيط بكل إعداد وكل زرّ.
class FloatingAdhkarRow extends StatelessWidget {
  const FloatingAdhkarRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.tone,
    this.enabled = true,
    this.isLast = false,
    super.key,
  });

  final HugeIconData icon;
  final String title;
  final String? subtitle;

  /// عنصر يحلّ محلّ السهم، مثل سهم الطيّ في «إعدادات متقدمة».
  final Widget? trailing;

  /// لون تنبيهي يُستخدم حين يكون الصفّ تحذيرًا لا مجرّد مدخل.
  final Color? tone;
  final bool enabled;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final accent = tone ?? skin.accent;
    final iconColor = enabled ? accent : skin.inkSoft.withValues(alpha: 0.42);
    final titleColor = enabled ? skin.ink : skin.inkSoft.withValues(alpha: 0.5);
    final note = subtitle?.trim() ?? '';

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: tone == null
                    ? skin.iconChip
                    : tone!.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppIcon(icon, color: iconColor, size: 15.sp),
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
                      color: titleColor,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (note.isNotEmpty)
                    Text(
                      note,
                      maxLines: 2,
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
            trailing ??
                AppIcon(AppIcons.chevronLeft, color: iconColor, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

/// صفّ مفتاح: نفس شكل الصفّ العادي، لكن طرفه مفتاح لا سهم.
class FloatingAdhkarSwitchRow extends StatelessWidget {
  const FloatingAdhkarSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.isLast = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final HugeIconData? icon;
  final bool value;
  final bool isLast;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final note = subtitle?.trim() ?? '';
    final enabled = onChanged != null;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 12.w, 6.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppIcon(
                  icon!,
                  color: enabled
                      ? skin.accent
                      : skin.inkSoft.withValues(alpha: 0.42),
                  size: 15.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
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
                    color: enabled
                        ? skin.ink
                        : skin.inkSoft.withValues(alpha: 0.5),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (note.isNotEmpty)
                  Text(
                    note,
                    maxLines: 2,
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
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.gold,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// نصّ معدّل الظهور بالعربية.
String formatFloatingInterval(int minutes) {
  if (minutes == 1) {
    return 'كل دقيقة';
  }

  return 'كل $minutes دقائق';
}

/// وصف مصادر الأذكار المفعّلة.
String describeFloatingSources(FloatingAdhkarSettings settings) {
  if (settings.includeBuiltIn && settings.includeCustom) {
    return settings.mixSources
        ? 'دمج بين الافتراضي والمخصص'
        : 'تناوب بين الافتراضي والمخصص';
  }
  if (settings.includeBuiltIn) {
    return 'الأذكار الافتراضية فقط';
  }
  if (settings.includeCustom) {
    return 'أذكار المستخدم فقط';
  }
  return 'لا يوجد مصدر مفعّل';
}
