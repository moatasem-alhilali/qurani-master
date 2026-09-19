part of 'young_muslim_shared_widgets.dart';

/// عنوان قسم داخل «المسلم الصغير».
///
/// حين لا يحتاج العنوان تذييلًا فهو `HomeSectionHeader` نفسه المستخدم في
/// الشاشة الرئيسية — سطر واحد بلا وصف ولا شرطة. والتذييل الاختياري (عدّاد
/// أو زرّ إغلاق) يبقى على المقاس نفسه.
class YoungMuslimSectionHeader extends StatelessWidget {
  const YoungMuslimSectionHeader({
    required this.title,
    this.trailing,
    this.padded = true,
    super.key,
  });

  final String title;
  final Widget? trailing;

  /// الأوراق السفلية تضع هامشها بنفسها، فتُطفئ الهامش الجانبي هنا.
  final bool padded;

  @override
  Widget build(BuildContext context) {
    if (trailing == null && padded) {
      return HomeSectionHeader(title: title);
    }

    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        padded ? 16.w : 0,
        16.h,
        padded ? 16.w : 0,
        8.h,
      ),
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
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// مربّع الأيقونة الصغير — بديل البطاقة في كل صفوف التطبيق.
class YoungMuslimIconChip extends StatelessWidget {
  const YoungMuslimIconChip({
    required this.icon,
    this.size,
    this.active = false,
    super.key,
  });

  final HugeIconData icon;
  final double? size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final dimension = size ?? 30.w;

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: active ? AppColors.gold : skin.iconChip,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Center(
        child: AppIcon(
          icon,
          color: active
              ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
              : skin.accent,
          size: dimension * 0.53,
        ),
      ),
    );
  }
}

/// شارة صغيرة لرقم أو مدّة — بخلفية مربّع الأيقونة نفسها، بلا حدّ ولا ظلّ.
class YoungMuslimMetricChip extends StatelessWidget {
  const YoungMuslimMetricChip({
    required this.label,
    this.icon,
    super.key,
  });

  final String label;
  final HugeIconData? icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, color: skin.accent, size: 11.sp),
            SizedBox(width: 4.w),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: youngMuslimNumber(
                skin,
                size: 9.5.sp,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// شريط تقدّم: ذهب يمتدّ فوق شعرة، ويتحرّك إلى قيمته بدل أن يقفز إليها.
class YoungMuslimProgressBar extends StatelessWidget {
  const YoungMuslimProgressBar({
    required this.value,
    this.height,
    super.key,
  });

  final double value;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final target = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: SizedBox(
        height: height ?? 4.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: skin.hairline),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: target),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (context, animated, _) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: animated,
                    heightFactor: 1,
                    child: const ColoredBox(color: AppColors.gold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// زرّ حبّة: مرشّح أو سلسلة. المفعّل يمتلئ ذهبًا، والمطفأ يجلس على
/// خلفية مربّع الأيقونة.
class YoungMuslimPillButton extends StatelessWidget {
  const YoungMuslimPillButton({
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

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.gold : skin.iconChip,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected
                  ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                  : skin.ink,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

/// الفعل الرئيسي في الشاشة: شريط ذهبي بعرض الصفحة.
class YoungMuslimPrimaryButton extends StatelessWidget {
  const YoungMuslimPrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.busy = false,
    super.key,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null && !busy;
    final onGold = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(13.r),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                SizedBox(
                  width: 14.sp,
                  height: 14.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: onGold,
                  ),
                )
              else
                AppIcon(icon, color: onGold, size: 15.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onGold,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// صفّ قائمة عام: مربّع أيقونة، عنوان ووصف، ثم سهم.
class YoungMuslimActionRow extends StatelessWidget {
  const YoungMuslimActionRow({
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
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            YoungMuslimIconChip(icon: icon, size: 30.w),
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
                    style: youngMuslimRowTitle(skin),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: youngMuslimRowSubtitle(skin),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: 8.w),
            ],
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
  }
}

/// صفّ «عنوان: قيمة» داخل كتلة المعلومات.
class YoungMuslimInfoRow extends StatelessWidget {
  const YoungMuslimInfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          Text(
            label,
            style: youngMuslimRowSubtitle(skin, size: 10.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: youngMuslimRowTitle(skin),
            ),
          ),
        ],
      ),
    );
  }
}

/// خانة إحصاء واحدة داخل شريط الإحصاءات.
class YoungMuslimStatCell extends StatelessWidget {
  const YoungMuslimStatCell({
    required this.value,
    required this.label,
    required this.icon,
    super.key,
  });

  final String value;
  final String label;
  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, color: skin.accent, size: 15.sp),
        SizedBox(height: 5.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: youngMuslimNumber(
            skin,
            size: 13.sp,
            color: skin.ink,
            weight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: youngMuslimRowSubtitle(skin, size: 9.sp),
        ),
      ],
    );
  }
}

/// شريط إحصاءات: خانات متساوية تفصلها شعرة رأسية.
class YoungMuslimStatStrip extends StatelessWidget {
  const YoungMuslimStatStrip({
    required this.cells,
    super.key,
  });

  final List<YoungMuslimStatCell> cells;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i != 0) Container(width: 1, height: 26.h, color: skin.hairline),
            Expanded(child: cells[i]),
          ],
        ],
      ),
    );
  }
}

/// حالة فارغة: مربّع أيقونة وسطران، بلا إطار ولا ظلّ.
class YoungMuslimEmptyState extends StatelessWidget {
  const YoungMuslimEmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Column(
        children: [
          YoungMuslimIconChip(icon: icon, size: 38.w),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: youngMuslimRowTitle(skin, size: 13.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: youngMuslimRowSubtitle(skin, size: 10.sp),
          ),
        ],
      ),
    );
  }
}

/// انتظار التحميل: دائرة واحدة على أرضية الصفحة، بلا لوحة رمادية.
class YoungMuslimLoadingPanel extends StatelessWidget {
  const YoungMuslimLoadingPanel({
    this.heightFactor = 0.32,
    super.key,
  });

  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: Center(
        child: SizedBox(
          width: 22.sp,
          height: 22.sp,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: skin.accent,
          ),
        ),
      ),
    );
  }
}
