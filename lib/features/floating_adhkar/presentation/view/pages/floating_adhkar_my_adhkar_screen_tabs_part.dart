part of 'floating_adhkar_my_adhkar_screen.dart';

/// تبويب بخطّ ذهبي تحت الاسم — لا صندوق مظلّل حول التبويبين.
class _TabStrip extends StatelessWidget {
  const _TabStrip({
    required this.activeIndex,
    required this.builtInLabel,
    required this.customLabel,
    required this.onSelect,
  });

  final int activeIndex;
  final String builtInLabel;
  final String customLabel;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              title: 'الأذكار الافتراضية',
              badge: builtInLabel,
              active: activeIndex == 0,
              onTap: () => onSelect(0),
            ),
          ),
          Expanded(
            child: _TabItem(
              title: 'الأذكار الخاصة',
              badge: customLabel,
              active: activeIndex == 1,
              onTap: () => onSelect(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String badge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 6.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.gold.withValues(alpha: active ? 1 : 0),
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active ? skin.ink : skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 11.5.sp,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            Text(
              badge,
              style: TextStyle(
                color: skin.accent,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
