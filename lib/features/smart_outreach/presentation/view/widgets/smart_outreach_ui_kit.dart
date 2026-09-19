import 'dart:async';
import 'dart:ui' as ui;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/l10n/l10n.dart';

/// أدوات شاشات «صحبة الفجر».
///
/// كانت كل مجموعة حقول وكل جدولة تجلس داخل بطاقة بحدّ وظلّ، فصارت الشاشة
/// شريطًا من الصناديق لا يبرز فيها شيء. هنا المحتوى يجلس على `skin.ground`
/// مباشرة، ويفصل بين الصفوف خطّ بسُمك شعرة، والارتفاع محجوز لعنصر واحد.

/// سهم «التالي» في صفّ قابل للنقر: يشير إلى نهاية السطر في كلا الاتجاهين.
HugeIconData outreachForwardChevron(BuildContext context) =>
    Directionality.of(context) == ui.TextDirection.rtl
        ? AppIcons.chevronLeft
        : AppIcons.chevronRight;

/// محاذاة نصّ لاتينيّ الاتجاه (رقم هاتف) إلى بداية السطر بحسب لغة الواجهة.
TextAlign outreachStartAlign(BuildContext context) =>
    Directionality.of(context) == ui.TextDirection.rtl
        ? TextAlign.right
        : TextAlign.left;

/// لون النصّ فوق تعبئة `skin.accent`.
Color outreachOnAccent(AppSkin skin) =>
    skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

/// أرضية الصفحة: عمود واحد على `skin.ground`، لا بطاقات عائمة فوقه.
class OutreachGround extends StatelessWidget {
  const OutreachGround({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return ColoredBox(
      color: skin.ground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// مربّع الأيقونة الصغير — هذا بديل البطاقة حول الصفّ.
class OutreachIconChip extends StatelessWidget {
  const OutreachIconChip({
    required this.icon,
    this.muted = false,
    super.key,
  });

  final HugeIconData icon;

  /// الصفّ المتوقّف: المربّع يبهت والأيقونة تأخذ لون النصّ الثانوي.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: muted ? skin.hairline.withValues(alpha: 0.6) : skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: AppIcon(
        icon,
        color: muted ? skin.inkSoft.withValues(alpha: 0.7) : skin.accent,
        size: 15.sp,
      ),
    );
  }
}

/// صفّ نحيل: أيقونة، عنوان، وصف تحته، ثم قيمة أو أداة على الطرف.
class OutreachRow extends StatelessWidget {
  const OutreachRow({
    required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isLast = false,
    this.showChevron = false,
    this.dimmed = false,
    super.key,
  });

  final String title;
  final HugeIconData? icon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLast;
  final bool showChevron;

  /// صفّ غير مفعّل: العنوان يخفّ وزنه ويبهت لونه.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final note = subtitle?.trim() ?? '';

    final body = Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          if (icon != null) ...[
            OutreachIconChip(icon: icon!, muted: dimmed),
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
                    color: dimmed
                        ? skin.inkSoft.withValues(alpha: 0.78)
                        : skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: dimmed ? FontWeight.w500 : FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (note.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing!,
          ],
          if (showChevron) ...[
            SizedBox(width: 4.w),
            AppIcon(
              outreachForwardChevron(context),
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return body;
    }
    return InkWell(onTap: onTap, child: body);
  }
}

/// رقم أو وقت: أرقام متساوية العرض بترتيب لاتيني حتى لا ينقلب في RTL.
class OutreachValue extends StatelessWidget {
  const OutreachValue({
    required this.text,
    this.emphasised = false,
    this.accented = false,
    super.key,
  });

  final String text;

  /// قيمة العنصر المرتفع وحده.
  final bool emphasised;
  final bool accented;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Text(
        text,
        style: TextStyle(
          color: accented ? skin.accent : skin.ink,
          fontSize: emphasised ? 15.sp : 12.5.sp,
          fontWeight: emphasised ? FontWeight.w800 : FontWeight.w600,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// حالة الجدولة: نقطة مصمتة وكلمة «نشط» بوزن ثقيل، أو حلقة مفرغة وكلمة
/// «متوقّف» بوزن خفيف. الفرق في الشكل والنصّ والوزن، لا في اللون وحده،
/// حتى تُقرأ الحالة بلا تمييز ألوان.
class OutreachStatusBadge extends StatelessWidget {
  const OutreachStatusBadge({required this.active, super.key});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final l10n = context.l10n;
    final label =
        active ? l10n.outreachStatusActive : l10n.outreachStatusStopped;

    return Semantics(
      label: l10n.outreachStatusSemantics(label),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.gold : null,
              border: active
                  ? null
                  : Border.all(
                      color: skin.inkSoft.withValues(alpha: 0.55),
                      width: 1.2,
                    ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color:
                  active ? skin.accent : skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// شارة صغيرة ممتلئة — «الأقرب»، «الآن».
class OutreachPill extends StatelessWidget {
  const OutreachPill({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: skin.accent,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: outreachOnAccent(skin),
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// مفتاح في صفّ نحيل — يهتزّ الجهاز اهتزازة خفيفة مع كل تبديل.
class OutreachSwitchRow extends StatelessWidget {
  const OutreachSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.icon,
    this.subtitle,
    this.isLast = false,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final HugeIconData? icon;
  final String? subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return OutreachRow(
      title: title,
      icon: icon,
      subtitle: subtitle,
      isLast: isLast,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onChanged(!value);
      },
      trailing: Transform.scale(
        scale: 0.72,
        child: AdaptiveSwitch(
          value: value,
          activeColor: AppColors.gold,
          onChanged: (next) {
            unawaited(HapticFeedback.selectionClick());
            onChanged(next);
          },
        ),
      ),
    );
  }
}

/// قيمة تُسحب: العنوان والقيمة في سطر، والمؤشّر تحتهما بلا صندوق.
class OutreachSliderRow extends StatelessWidget {
  const OutreachSliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
    this.isLast = false,
    super.key,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 5.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              OutreachValue(text: valueLabel, accented: true),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.5.h,
              activeTrackColor: AppColors.gold,
              inactiveTrackColor: skin.hairline,
              thumbColor: AppColors.gold,
              overlayColor: AppColors.gold.withValues(alpha: 0.12),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            ),
            child: AdaptiveSlider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: AppColors.gold,
              thumbColor: AppColors.gold,
              onChanged: onChanged,
              onChangeEnd: (_) => unawaited(HapticFeedback.selectionClick()),
            ),
          ),
        ],
      ),
    );
  }
}

/// الفعل الرئيسي — التعبئة الوحيدة الممتلئة في الشاشة.
class OutreachPrimaryButton extends StatelessWidget {
  const OutreachPrimaryButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final HugeIconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final onAccent = outreachOnAccent(skin);
    final enabled = onTap != null && !loading;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        // تعبئة عادية لا `Ink`: أرضية الصفحة تُرسم فوق مادّة السكافولد،
        // فلو رُسمت التعبئة عليها لاختفت خلف الأرضية.
        child: Container(
          decoration: BoxDecoration(
            color: enabled ? skin.accent : skin.accent.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SizedBox.square(
                  dimension: 14.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: onAccent,
                  ),
                )
              else if (icon != null)
                AppIcon(icon!, color: onAccent, size: 15.sp),
              SizedBox(width: 7.w),
              Text(
                label,
                style: TextStyle(
                  color: onAccent,
                  fontSize: 12.sp,
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

/// فعل نصّي صغير — «ابدأ الآن»، «تعديل»، «حذف».
class OutreachTextAction extends StatelessWidget {
  const OutreachTextAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.danger = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final HugeIconData? icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color = danger ? AppColors.error : skin.accent;
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(
                icon!,
                color: color.withValues(alpha: enabled ? 1 : 0.45),
                size: 13.sp,
              ),
              SizedBox(width: 3.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: enabled ? 1 : 0.45),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نبرة التنبيه: عاديّة أو حالة تحتاج تدخّل المستخدم.
enum OutreachNoticeTone { calm, alert }

/// تنبيه على الأرضية مباشرة: شعرة فوقه وتحته، بلا صندوق ولا ظل.
class OutreachNotice extends StatelessWidget {
  const OutreachNotice({
    required this.message,
    this.icon,
    this.tone = OutreachNoticeTone.calm,
    this.actions = const <Widget>[],
    super.key,
  });

  final String message;
  final HugeIconData? icon;
  final OutreachNoticeTone tone;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final alert = tone == OutreachNoticeTone.alert;
    final color = alert ? AppColors.error : skin.accent;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon(
                icon ?? (alert ? AppIcons.warning : AppIcons.news),
                color: color,
                size: 15.sp,
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.9),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 24.w),
              child: Wrap(
                spacing: 14.w,
                runSpacing: 2.h,
                children: actions,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// خلية إحصاء: الرقم فوق ووصفه تحته، بلا صندوق حولها.
class OutreachStatCell extends StatelessWidget {
  const OutreachStatCell({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OutreachValue(text: value, accented: true),
        SizedBox(height: 1.h),
        Text(
          label,
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
    );
  }
}

/// شبكة الإحصاءات: خلايا متجاورة بفجوة `6.w` بلا بطاقات.
class OutreachStatsRow extends StatelessWidget {
  const OutreachStatsRow({required this.cells, super.key});

  final List<OutreachStatCell> cells;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i != 0) SizedBox(width: 6.w),
            Expanded(child: cells[i]),
          ],
        ],
      ),
    );
  }
}

/// اختيار واحد صغير — أيام الأسبوع مثلًا.
class OutreachChoiceChip extends StatelessWidget {
  const OutreachChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: selected ? skin.accent : null,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? skin.accent : skin.hairline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? outreachOnAccent(skin)
                : skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 9.5.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

/// حالة فارغة: سطران وفعل نصّي، بلا بطاقة ولا رسم كبير.
class OutreachEmptyState extends StatelessWidget {
  const OutreachEmptyState({
    required this.title,
    required this.icon,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final HugeIconData icon;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final note = message?.trim() ?? '';
    final hasAction = actionLabel != null && onAction != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 26.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            icon,
            color: skin.accent.withValues(alpha: 0.6),
            size: 22.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (note.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              note,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
          if (hasAction) ...[
            SizedBox(height: 8.h),
            OutreachTextAction(label: actionLabel!, onTap: onAction),
          ],
        ],
      ),
    );
  }
}

/// مؤشّر تحميل على الأرضية، بلون الواجهة لا بلون الثيم القديم.
class OutreachLoading extends StatelessWidget {
  const OutreachLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28.h),
      child: Center(
        child: SizedBox.square(
          dimension: 22.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: skin.accent,
          ),
        ),
      ),
    );
  }
}

/// اسم اليوم بترقيم `DateTime.weekday` نفسه (١ الإثنين … ٧ الأحد).
String outreachWeekdayLabel(L10n l10n, int day) {
  switch (day) {
    case 1:
      return l10n.outreachWeekday1;
    case 2:
      return l10n.outreachWeekday2;
    case 3:
      return l10n.outreachWeekday3;
    case 4:
      return l10n.outreachWeekday4;
    case 5:
      return l10n.outreachWeekday5;
    case 6:
      return l10n.outreachWeekday6;
    case 7:
      return l10n.outreachWeekday7;
    default:
      return '$day';
  }
}
