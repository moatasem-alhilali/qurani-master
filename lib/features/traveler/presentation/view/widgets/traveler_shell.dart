import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/l10n/l10n.dart';

/// سهم الرجوع: يشير إلى بداية السطر بحسب اتجاه لغة الواجهة.
HugeIconData travelerBackIcon(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
        ? AppIcons.backRight
        : AppIcons.back;

/// سهم «التالي» في صفّ قابل للنقر: يشير إلى نهاية السطر.
HugeIconData travelerForwardChevron(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
        ? AppIcons.chevronLeft
        : AppIcons.chevronRight;

/// هيكل شاشات المسافر: أرضية واحدة ورأس نحيل يفصله خطّ شعرة.
///
/// الشاشات هنا كانت تركب `AppScaffoldWidget` بأرضية الثيم القديمة، فيظهر
/// شريط رمادي فوق محتوى عاجي. الأرضية الآن `skin.ground` من أعلى الشاشة
/// إلى أسفلها، فلا خطّ قطع بين الرأس والمحتوى.
class TravelerScaffold extends StatelessWidget {
  const TravelerScaffold({
    required this.title,
    required this.child,
    this.actions,
    super.key,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Scaffold(
      backgroundColor: skin.ground,
      body: SafeArea(
        child: Column(
          children: [
            TravelerHeader(title: title, actions: actions),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// رأس الشاشة: رجوع، عنوان، ثم أفعال — كلها على الأرضية نفسها.
class TravelerHeader extends StatelessWidget {
  const TravelerHeader({required this.title, this.actions, super.key});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
      child: Row(
        children: [
          TravelerIconAction(
            icon: travelerBackIcon(context),
            tooltip: context.l10n.commonBack,
            onTap: context.pop,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
          ...?actions,
        ],
      ),
    );
  }
}

/// زرّ أيقونة في الرأس أو فوق الخريطة: دائرة صغيرة بلا حدّ ولا ظل.
class TravelerIconAction extends StatelessWidget {
  const TravelerIconAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.active = false,
    super.key,
  });

  final HugeIconData icon;
  final VoidCallback onTap;
  final String tooltip;

  /// الحالة المفعّلة تأخذ خلفية مربّع الأيقونة — لا لونًا مختلفًا فقط.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? skin.iconChip : null,
          ),
          child: Center(
            child: AppIcon(icon, color: skin.accent, size: 16.sp),
          ),
        ),
      ),
    );
  }
}

/// مربّع الأيقونة الصغير — بديل البطاقة في كل صفوف المسافر.
class TravelerIconChip extends StatelessWidget {
  const TravelerIconChip({required this.icon, this.size, super.key});

  final HugeIconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final box = size ?? 28.w;

    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}

/// صفّ قائمة نحيل: أيقونة، عنوان ووصف، ثم سهم — بلا بطاقة ولا ظل.
class TravelerListRow extends StatelessWidget {
  const TravelerListRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isLast = false,
    super.key,
  });

  final HugeIconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            TravelerIconChip(icon: icon),
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
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle != null)
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
            SizedBox(width: 6.w),
            trailing ??
                AppIcon(
                  travelerForwardChevron(context),
                  color: skin.accent,
                  size: 15.sp,
                ),
          ],
        ),
      ),
    );
  }
}

/// زرّ صغير: مملوء بالحبر المميّز للفعل الأساسي، أو شفاف بحدّ شعرة لما دونه.
class TravelerPillButton extends StatelessWidget {
  const TravelerPillButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.filled = false,
    this.busy = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final HugeIconData? icon;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null && !busy;

    // التعبئة من `skin.accent` لا من الذهب الثابت: الذهب الثابت فاتح في
    // الوضع الفاتح فيضيع النصّ العاجي فوقه. والنصّ يقلب مع الوضع كما في
    // شارة الصلاة الحالية بالشاشة الرئيسية.
    final onFilled = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;
    final foreground = filled
        ? onFilled
        : (enabled ? skin.ink : skin.inkSoft.withValues(alpha: 0.5));

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color:
              filled ? skin.accent.withValues(alpha: enabled ? 1 : 0.45) : null,
          borderRadius: BorderRadius.circular(999.r),
          border: filled ? null : Border.all(color: skin.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy)
              SizedBox(
                width: 12.sp,
                height: 12.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  valueColor: AlwaysStoppedAnimation<Color>(foreground),
                ),
              )
            else if (icon != null)
              AppIcon(icon!, color: foreground, size: 14.sp),
            if (busy || icon != null) SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شارة صغيرة: نصّ فوق خلفية مربّع الأيقونة، لا بطاقة.
class TravelerTagChip extends StatelessWidget {
  const TravelerTagChip({
    required this.label,
    this.icon,
    this.emphasised = false,
    super.key,
  });

  final String label;
  final HugeIconData? icon;

  /// المميّزة تُقرأ بوزن الخطّ أيضًا، لا باللون وحده.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, color: skin.accent, size: 12.sp),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: emphasised ? skin.accent : skin.inkSoft,
              fontSize: 9.5.sp,
              fontWeight: emphasised ? FontWeight.w700 : FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// حالة فارغة أو خطأ: مربّع أيقونة ورسالة وفعل واحد — بلا صندوق.
class TravelerNotice extends StatelessWidget {
  const TravelerNotice({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isError = false,
    super.key,
  });

  final HugeIconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: AppIcon(
                  icon,
                  color: isError ? AppColors.error : skin.accent,
                  size: 19.sp,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 12.h),
              TravelerPillButton(
                label: actionLabel!,
                icon: AppIcons.refresh,
                filled: true,
                onTap: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
