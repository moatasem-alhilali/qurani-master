part of 'next_prayer_countdown_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final actions = _actions(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _kPanelSurface,
              AppColors.brandCream,
            ],
          ),
          border: Border.all(
            color: _kPanelBorder.withValues(alpha: 0.95),
          ),
          boxShadow: [
            BoxShadow(
              color: _kHeroDeep.withValues(alpha: 0.18),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Positioned(
                top: -24.h,
                left: -10.w,
                child: Container(
                  width: 92.w,
                  height: 92.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brandIvory.withValues(alpha: 0.65),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 18.w,
                left: 18.w,
                child: Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _kAccentGold.withValues(alpha: 0),
                        _kAccentGold.withValues(alpha: 0.85),
                        _kAccentGold.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 8.h,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: List.generate(actions.length, (index) {
                      final item = actions[index];
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _QuickActionButton(item: item),
                            ),
                            if (index != actions.length - 1)
                              Container(
                                width: 1,
                                margin: EdgeInsets.symmetric(vertical: 10.h),
                                color: _kHeroDeep.withValues(alpha: 0.14),
                              ),
                          ],
                        ),
                      );
                    }),
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

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.item});

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.brandIvory,
                    AppColors.brandGoldLight.withValues(alpha: 0.82),
                  ],
                ),
                border: Border.all(
                  color: AppColors.brandGoldLight.withValues(alpha: 0.95),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _kHeroDeep.withValues(alpha: 0.10),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: AppIcon(
                item.icon,
                color: _kHeroDeep,
                size: 16.sp,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kPanelText,
                fontSize: 9.7.sp,
                fontWeight: FontWeight.w700,
                height: 1.22,
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
