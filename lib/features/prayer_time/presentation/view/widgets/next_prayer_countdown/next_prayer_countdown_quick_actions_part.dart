part of 'next_prayer_countdown_widget.dart';

/// أربعة مداخل سريعة: أيقونة واسم، بلا بطاقة حولها.
///
/// كانت أربع بطاقات بحدود وظلال، فقرأتها العين ككتلة ثقيلة تنافس قائمة
/// المواقيت. الآن هي شريط خفيف يفصله خط شعرة عمّا فوقه.
class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel();

  List<_QuickActionItem> _actions(BuildContext context) {
    return [
      _QuickActionItem(
        label: 'المصحف',
        icon: AppIcons.quran,
        onTap: () => context.push(const ReadQuranScreen()),
      ),
      _QuickActionItem(
        label: 'مواقيت الصلاة',
        icon: AppIcons.clock,
        onTap: () => context.push(const PrayerTimeScreen()),
      ),
      _QuickActionItem(
        label: 'القبلة',
        icon: AppIcons.compass,
        onTap: () => context.push(const QiblahMainScreen()),
      ),
      _QuickActionItem(
        label: 'مكتبة الأذكار',
        icon: AppIcons.tasbih,
        onTap: () => context.push(const MainThikrScreen()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final actions = _actions(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Divider(height: 1, thickness: 1, color: skin.hairline),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
          child: Row(
            children: [
              for (final item in actions)
                Expanded(child: _QuickActionButton(item: item)),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.item});

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 2.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: AppIcon(item.icon, color: skin.accent, size: 16.sp),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.ink.withValues(alpha: 0.86),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback onTap;
}
