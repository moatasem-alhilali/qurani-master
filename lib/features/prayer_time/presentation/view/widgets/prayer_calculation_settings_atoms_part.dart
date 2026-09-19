part of 'prayer_calculation_settings_card.dart';

/// إطار الصفّ: حشو موحّد وفاصل شعرة أسفله.
class _RowFrame extends StatelessWidget {
  const _RowFrame({required this.child, this.verticalPadding});

  final Widget child;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: verticalPadding ?? 10.h,
      ),
      child: child,
    );
  }
}

class _AdjustmentsToggleRow extends StatelessWidget {
  const _AdjustmentsToggleRow({
    required this.isOpen,
    required this.activeCount,
    required this.enabled,
    required this.onTap,
  });

  final bool isOpen;
  final int activeCount;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      child: _RowFrame(
        child: Row(
          children: [
            const PrayerSettingsIconChip(icon: AppIcons.clock),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.prayerTimeCalcManualAdjust,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    activeCount == 0
                        ? context.l10n.prayerTimeCalcManualAdjustHint
                        : context.l10n.prayerTimeCalcManualAdjustCount(
                            activeCount,
                          ),
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
            AppIcon(
              isOpen ? AppIcons.up : AppIcons.down,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// زرّ ضمن مجموعة خيارين: يمتلئ ذهبًا عند الاختيار مع نبضة خفيفة.
class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      borderRadius: radius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 32.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: isSelected ? AppColors.gold : skin.hairline,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected
                ? AppColors.brandIvory
                : skin.ink.withValues(alpha: enabled ? 0.88 : 0.45),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      borderRadius: BorderRadius.circular(9.r),
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: enabled ? skin.iconChip : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          border: enabled ? null : Border.all(color: skin.hairline),
        ),
        child: Icon(
          icon,
          size: 15.sp,
          color: enabled ? skin.accent : skin.inkSoft.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? skin.accent : skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
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
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              AppIcon(AppIcons.check, color: skin.accent, size: 16.sp),
            ],
          ],
        ),
      ),
    );
  }
}
