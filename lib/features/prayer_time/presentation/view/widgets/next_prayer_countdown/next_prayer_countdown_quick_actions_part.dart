part of 'next_prayer_countdown_widget.dart';

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel();

  List<_QuickActionItem> _actions(BuildContext context) {
    return [
      _QuickActionItem(
        label: 'المصحف',
        icon: Icons.menu_book_outlined,
        onTap: () => context.push(const ReadQuranScreen()),
      ),
      _QuickActionItem(
        label: 'مواقيت الصلاة',
        icon: Icons.schedule_outlined,
        onTap: () => context.push(const PrayerTimeScreen()),
      ),
      _QuickActionItem(
        label: 'القبلة',
        icon: Icons.explore_outlined,
        onTap: () => context.push(const QiblahMainScreen()),
      ),
      _QuickActionItem(
        label: 'مكتبة الأذكار',
        icon: Icons.volunteer_activism_outlined,
        onTap: () => context.push(const MainThikrScreen()),
      ),
      // _QuickActionItem(
      //   label: 'المسبحة',
      //   icon: Icons.repeat_rounded,
      //   onTap: () => context.push(const TasbeehProvider()),
      // ),
      // _QuickActionItem(
      //   label: 'خطط الختمة',
      //   icon: Icons.inventory_2_outlined,
      //   onTap: () => context.push(const QuranPlanListScreen()),
      // ),
      // _QuickActionItem(
      //   label: 'حصن المسلم',
      //   icon: Icons.security_outlined,
      //   onTap: () => context.push(const HisnMuslimScreen()),
      // ),
      // _QuickActionItem(
      //   label: 'كل المميزات',
      //   icon: Icons.grid_view_rounded,
      //   onTap: () => _openAppsSheet(context),
      // ),
    ];
  }

  Future<void> _openAppsSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: FractionallySizedBox(
            heightFactor: 0.76,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: _kHeroDeep.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                    child: Text(
                      'كل المميزات',
                      style: TextStyle(
                        color: _kPanelText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
                      child: const AnotherFeatures(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = _actions(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: ColoredBox(
            color: Colors.white,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.22,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 8.h,
              ),
              itemBuilder: (context, index) {
                final item = actions[index];
                return InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: 2.h),
                      Icon(
                        item.icon,
                        color: _kAccentGold,
                        size: 21.sp,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _kPanelText,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
  final IconData icon;
  final VoidCallback onTap;
}
