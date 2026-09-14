part of 'daily_wird_screen.dart';

/// صفّ تذكير: مفتاح، ثم اسم التذكير ووقته.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.label,
    required this.value,
    required this.time,
    required this.onChanged,
    required this.onPickTime,
    this.isLast = false,
  });

  final String label;
  final bool value;
  final String time;
  final ValueChanged<bool> onChanged;
  final Future<void> Function() onPickTime;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          AdaptiveSwitch(
            value: value,
            onChanged: (next) {
              HapticFeedback.selectionClick();
              onChanged(next);
            },
          ),
          SizedBox(width: 10.w),
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
          InkWell(
            onTap: onPickTime,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(AppIcons.clock, color: skin.accent, size: 13.sp),
                  SizedBox(width: 5.w),
                  Text(
                    time,
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
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

/// شارة اختيار البرنامج داخل ورقة الإعدادات.
class DailyWirdChoiceChip extends StatelessWidget {
  const DailyWirdChoiceChip({
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : skin.raised,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: selected ? AppColors.gold : skin.hairline),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.brandIvory : skin.ink,
            fontSize: 10.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum _ItemAction {
  reset,
  editCount,
  hide,
  moveUp,
  moveDown,
}
