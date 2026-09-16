part of 'daily_wird_screen.dart';

/// صفّ عمل واحد من الزاد.
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.index,
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final int index;
  final DailyWirdItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final preview = item.contentEntries.isNotEmpty
        ? item.contentEntries.first.text
        : item.contentText;

    return InkWell(
      onTap: () => _openItem(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DailyWirdIconChip(icon: dailyWirdItemIcon(item)),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        '${dailyWirdTimeLabel(item.timeCategory)} · '
                        '${dailyWirdTypeLabel(item)}',
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
                SizedBox(
                  width: 78.w,
                  child: DailyWirdActionButton(item: item),
                ),
                _ItemMenu(item: item, isFirst: isFirst, isLast: isLast),
              ],
            ),
            if (preview.trim().isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
            SizedBox(height: 7.h),
            DailyWirdProgressLine(value: item.progress),
          ],
        ),
      ),
    );
  }

  Future<void> _openItem(BuildContext context) async {
    final destination = DailyWirdDestinationResolver.resolve(item);
    if (destination != null) {
      context.push(destination);
      return;
    }

    final bloc = context.read<DailyWirdBloc>();

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: 'DailyWirdFocusScreen'),
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlocProvider.value(
            value: bloc,
            child: DailyWirdFocusScreen(itemId: item.id),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// قائمة خيارات العمل: ترتيب، وإعادة، وتعديل العدد، وإخفاء.
class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final DailyWirdItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return PopupMenuButton<_ItemAction>(
      tooltip: 'خيارات العمل',
      color: skin.raised,
      surfaceTintColor: skin.raised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: skin.hairline),
      ),
      padding: EdgeInsets.zero,
      icon: AppIcon(AppIcons.more, color: skin.accent, size: 15.sp),
      onSelected: (value) async {
        final bloc = context.read<DailyWirdBloc>();
        switch (value) {
          case _ItemAction.reset:
            bloc.add(DailyWirdResetItemEvent(item.id));
          case _ItemAction.editCount:
            final count = await showDailyWirdCountSheet(
              context,
              currentValue: item.countRequired ?? 1,
            );
            if (count != null) {
              bloc.add(DailyWirdUpdateItemCountEvent(item.id, count));
            }
          case _ItemAction.hide:
            bloc.add(DailyWirdHideItemEvent(item.id));
          case _ItemAction.moveUp:
            bloc.add(
              DailyWirdMoveItemEvent(itemId: item.id, direction: -1),
            );
          case _ItemAction.moveDown:
            bloc.add(
              DailyWirdMoveItemEvent(itemId: item.id, direction: 1),
            );
        }
      },
      itemBuilder: (context) => [
        if (item.hasCounter)
          _menuItem(context, _ItemAction.editCount, 'تعديل العدد المقصود'),
        _menuItem(context, _ItemAction.reset, 'البدء من جديد'),
        if (!isFirst)
          _menuItem(context, _ItemAction.moveUp, 'تقديم في الترتيب'),
        if (!isLast)
          _menuItem(context, _ItemAction.moveDown, 'تأخير في الترتيب'),
        _menuItem(context, _ItemAction.hide, 'إخفاء من الزاد'),
      ],
    );
  }

  PopupMenuItem<_ItemAction> _menuItem(
    BuildContext context,
    _ItemAction value,
    String label,
  ) {
    final skin = AppSkin.of(context);
    return PopupMenuItem<_ItemAction>(
      value: value,
      height: 36.h,
      child: Text(
        label,
        style: TextStyle(
          color: skin.ink,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
