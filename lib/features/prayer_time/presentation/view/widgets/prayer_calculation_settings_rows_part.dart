part of 'prayer_calculation_settings_card.dart';

/// صفّ يفتح ورقة اختيار: العنوان ووصفه، والقيمة المختارة عند الحافة.
class PrayerSettingsPickerRow extends StatelessWidget {
  const PrayerSettingsPickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String value;
  final String hint;
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
            PrayerSettingsIconChip(icon: icon),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
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
                    hint,
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
            SizedBox(width: 8.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 108.w),
              child: Text(
                value,
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            AppIcon(
              AppIcons.forwardFor(context),
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// صفّ خيارين: العنوان ووصفه، ثم زرّان يمتلئان ذهبًا عند الاختيار.
class PrayerSettingsSegmentedRow<T> extends StatelessWidget {
  const PrayerSettingsSegmentedRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final bool enabled;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PrayerSettingsIconChip(icon: icon),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
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
                      hint,
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
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i != 0) SizedBox(width: 6.w),
                Expanded(
                  child: _SegmentButton(
                    label: labelOf(options[i]),
                    isSelected: options[i] == value,
                    enabled: enabled,
                    onTap: () => onChanged(options[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// صفّ مفتاح: العنوان ووصفه ومفتاح النظام.
class PrayerSettingsSwitchRow extends StatelessWidget {
  const PrayerSettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      child: Row(
        children: [
          PrayerSettingsIconChip(icon: icon),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
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
                  hint,
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
          Transform.scale(
            scale: 0.82,
            child: Switch.adaptive(
              value: value,
              onChanged: enabled
                  ? (next) {
                      HapticFeedback.selectionClick();
                      onChanged(next);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// صفّ قيمة برقم يتغيّر بزرّي نقصان وزيادة.
class PrayerSettingsStepperRow extends StatelessWidget {
  const PrayerSettingsStepperRow({
    required this.label,
    required this.display,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
    this.isNeutral = false,
    super.key,
  });

  final String label;
  final String display;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  /// القيمة صفر: تُعرض بلون ثانوي حتى يبرز المعدَّل فعلًا.
  final bool isNeutral;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      verticalPadding: 7.h,
      child: Row(
        children: [
          SizedBox(width: 38.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 54.w,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                display,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isNeutral
                      ? skin.inkSoft.withValues(alpha: 0.7)
                      : skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

/// عنوان مجموعة صغير يليه خطّ شعرة إلى آخر السطر.
class PrayerSettingsGroupTitle extends StatelessWidget {
  const PrayerSettingsGroupTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 7.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.8),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Divider(height: 1, thickness: 1, color: skin.hairline),
          ),
        ],
      ),
    );
  }
}

/// رابط نصّي بأيقونة صغيرة — بديل الزرّ المحدَّد بإطار.
class PrayerSettingsTextLink extends StatelessWidget {
  const PrayerSettingsTextLink({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final HugeIconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color =
        onTap == null ? skin.inkSoft.withValues(alpha: 0.45) : skin.accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, color: color, size: 14.sp),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: color,
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

/// مربّع الأيقونة الصغير — بديل البطاقة حول الصفّ.
class PrayerSettingsIconChip extends StatelessWidget {
  const PrayerSettingsIconChip({required this.icon, super.key});

  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
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
