import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';

/// لبنات شاشات الإعدادات، مبنية على `AppSkin` وحدها.
///
/// القاعدة نفسها المطبّقة في الشاشة الرئيسية: الصفحة سطح واحد بلون
/// `skin.ground`، والصفوف نحيلة يفصلها خطّ شعرة، بلا بطاقة حول كل عنصر.

/// لون النصّ فوق التعبئة الذهبية — بنّي عميق يُقرأ في الوضعين الفاتح والداكن.
const Color settingsOnGold = AppColors.brandBrownDeep;

/// أرضية شاشة إعدادات: لون واحد للرأس والمحتوى معًا حتى لا يظهر قطع.
class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    required this.title,
    required this.children,
    this.floatingActionButton,
    this.onRefresh,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // تمرير الأرضية عبر الثيم يجعل رأس الصفحة بلون المحتوى نفسه.
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: title,
        onRefresh: onRefresh,
        floatingActionButton: floatingActionButton,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// مجموعة إعدادات: عنوان صغير يتبعه خطّ شعرة يمتدّ لآخر السطر.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Divider(height: 1, thickness: 1, color: skin.hairline),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

/// مربّع الأيقونة الصغير — بديل البطاقة حول كل صفّ.
class SettingsIconChip extends StatelessWidget {
  const SettingsIconChip({
    required this.icon,
    this.active = true,
    super.key,
  });

  final HugeIconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: active ? skin.iconChip : skin.hairline.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: 15.sp,
          color: active ? skin.accent : skin.inkSoft.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

/// صفّ إعداد نحيل: مربّع أيقونة + اسم + وصف سطر واحد + المفتاح أو السهم.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isLast = false,
    this.active = true,
    super.key,
  });

  final HugeIconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  /// عنصر يسار الصفّ (مفتاح أو زر صغير). بلا قيمة يظهر سهم الانتقال.
  final Widget? trailing;
  final bool isLast;

  /// يخفت مربّع الأيقونة حين يكون الإعداد موقوفًا.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final description = subtitle;

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            SettingsIconChip(icon: icon, active: active),
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
                  if (description != null && description.isNotEmpty)
                    Text(
                      description,
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
            SizedBox(width: 8.w),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              AppIcon(
                Directionality.of(context) == TextDirection.rtl
                    ? AppIcons.chevronLeft
                    : AppIcons.chevronRight,
                color: skin.accent,
                size: 15.sp,
              ),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap!.call();
      },
      child: content,
    );
  }
}

/// مفتاح صغير بمقاس الصفّ النحيل.
class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.78,
      child: AdaptiveSwitch(
        value: value,
        activeColor: AppColors.gold,
        onChanged: (next) {
          HapticFeedback.selectionClick();
          onChanged(next);
        },
      ),
    );
  }
}

/// زر أيقونة صغير داخل صفّ — للتعديل أو الحذف أو فتح رابط.
class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
    super.key,
  });

  final HugeIconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null;
    final tint = color ?? skin.accent;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onTap!.call();
              }
            : null,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: AppIcon(
            icon,
            size: 15.sp,
            color: enabled ? tint : tint.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

/// العنصر المرتفع الوحيد المسموح به في الشاشة.
class SettingsRaisedPanel extends StatelessWidget {
  const SettingsRaisedPanel({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 2.h),
      child: Container(
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(color: skin.raisedBorder.withValues(alpha: 0.45)),
          boxShadow: skin.raisedShadow,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        child: child,
      ),
    );
  }
}

/// صفّ مرتفع: عنوانه أكبر قليلًا لأنه العنصر الرئيسي في الشاشة.
class SettingsRaisedRow extends StatelessWidget {
  const SettingsRaisedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final row = Row(
      children: [
        SettingsIconChip(icon: icon),
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
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: 8.w),
          trailing!,
        ],
      ],
    );

    return SettingsRaisedPanel(
      child: onTap == null
          ? row
          : InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap!.call();
              },
              child: row,
            ),
    );
  }
}

/// فقرة نصّ داخل قسم — للشرح والسياسات، بلا بطاقة تحيط بها.
class SettingsParagraph extends StatelessWidget {
  const SettingsParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
      child: Text(
        text,
        style: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.86),
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w500,
          height: 1.75,
        ),
      ),
    );
  }
}

/// سطر حالة خفيف: لا نتائج، أو تنبيه قصير.
class SettingsHint extends StatelessWidget {
  const SettingsHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        children: [
          AppIcon(
            AppIcons.error,
            size: 13.sp,
            color: skin.inkSoft.withValues(alpha: 0.7),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// مربّع اختصار صغير: أيقونة واسم تحتها — لشبكات التواصل والروابط.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null;

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap!.call();
            }
          : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsIconChip(icon: icon, active: enabled),
            SizedBox(height: 6.h),
            SizedBox(
              height: 13.h,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink.withValues(
                    alpha: enabled ? 0.9 : 0.45,
                  ),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// صفّ مربّعات اختصار بفجوة `6.w` مثل شبكة المميزات في الرئيسية.
class SettingsTileRow extends StatelessWidget {
  const SettingsTileRow({
    required this.tiles,
    this.columns = 5,
    super.key,
  });

  final List<SettingsTile> tiles;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < tiles.length; start += columns) {
      final slice = tiles.skip(start).take(columns).toList();
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < columns; i++) ...[
              if (i != 0) SizedBox(width: 6.w),
              Expanded(
                child: i < slice.length ? slice[i] : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 6.h),
      child: Column(children: rows),
    );
  }
}

/// زر رئيسي صغير — التعبئة الوحيدة المسموح بها هي `AppColors.gold`.
class SettingsPrimaryButton extends StatelessWidget {
  const SettingsPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final HugeIconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    const foreground = settingsOnGold;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.mediumImpact();
                onPressed!.call();
              }
            : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: enabled ? 1 : 0.45),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                SizedBox.square(
                  dimension: 13.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foreground),
                  ),
                )
              else if (icon != null)
                AppIcon(icon!, size: 14.sp, color: foreground),
              SizedBox(width: 7.w),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر ثانوي نصّي — لا تعبئة ولا حدّ، لئلا يزاحم العنصر المرتفع.
class SettingsGhostButton extends StatelessWidget {
  const SettingsGhostButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final HugeIconData? icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onPressed == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onPressed!.call();
            },
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 13.sp, color: skin.accent),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: skin.accent,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نافذة سفلية بأرضية الشاشة نفسها — بلا رأس متدرّج ولا بطاقة.
Future<T?> showSettingsSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final skin = AppSkin.of(context);

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: skin.ground,
    isScrollControlled: true,
    useSafeArea: true,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (sheetContext) => AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
      ),
      child: builder(sheetContext),
    ),
  );
}

/// رأس النافذة السفلية: مقبض شعرة ثم عنوان صغير.
class SettingsSheetHeader extends StatelessWidget {
  const SettingsSheetHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final description = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
            width: 34.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: skin.hairline,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 9.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              if (description != null && description.isNotEmpty) ...[
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: skin.hairline),
      ],
    );
  }
}

/// رقم أو وقت داخل صفّ — أرقام بعرض ثابت حتى لا ترتجّ الصفوف.
class SettingsValueText extends StatelessWidget {
  const SettingsValueText(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Text(
      value,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        color: skin.accent,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
