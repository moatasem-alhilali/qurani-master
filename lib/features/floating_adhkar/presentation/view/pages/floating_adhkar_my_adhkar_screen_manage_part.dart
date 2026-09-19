part of 'floating_adhkar_my_adhkar_screen.dart';

enum _ManageAction { edit, delete }

/// صفّ ذكر في الإدارة: نصّه بخطّ المصحف، ومفتاحه في الطرف.
class _AdhkarManageRow extends StatelessWidget {
  const _AdhkarManageRow({
    required this.title,
    required this.body,
    required this.enabled,
    required this.isLast,
    this.note,
    this.onChanged,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String body;
  final String? note;
  final bool enabled;
  final bool isLast;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasMenu = onEdit != null || onDelete != null;
    final titleColor =
        enabled ? skin.ink : skin.inkSoft.withValues(alpha: 0.55);
    final bodyText = body.trim();
    final sourceNote = note?.trim() ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 10.w, 8.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (sourceNote.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Text(
                        sourceNote,
                        style: TextStyle(
                          color: skin.accent.withValues(alpha: 0.85),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                if (bodyText.isNotEmpty)
                  Text(
                    bodyText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: FontFamily.scheherazade,
                      color: enabled
                          ? skin.inkSoft
                          : skin.inkSoft.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                      height: 1.85,
                    ),
                  ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeTrackColor: AppColors.gold,
            onChanged: onChanged,
          ),
          if (hasMenu)
            PopupMenuButton<_ManageAction>(
              tooltip: context.l10n.floatingAdhkarItemOptions,
              color: skin.raised,
              onSelected: (action) {
                switch (action) {
                  case _ManageAction.edit:
                    onEdit?.call();
                  case _ManageAction.delete:
                    onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem<_ManageAction>(
                    value: _ManageAction.edit,
                    child: _ManageMenuLabel(
                      icon: AppIcons.edit,
                      label: context.l10n.commonEdit,
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem<_ManageAction>(
                    value: _ManageAction.delete,
                    child: _ManageMenuLabel(
                      icon: AppIcons.delete,
                      label: context.l10n.commonDelete,
                    ),
                  ),
              ],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                child: AppIcon(
                  AppIcons.more,
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  size: 15.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ManageMenuLabel extends StatelessWidget {
  const _ManageMenuLabel({required this.icon, required this.label});

  final HugeIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      children: [
        AppIcon(icon, color: skin.accent, size: 14.sp),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: skin.ink,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
