import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

enum _CardMenuAction { edit, reset, delete }

class MyDhikrCardWidget extends StatelessWidget {
  const MyDhikrCardWidget({
    required this.subih,
    required this.count,
    required this.onTap,
    required this.onReset,
    super.key,
    this.onEdit,
    this.onDelete,
  });

  final SubihModel subih;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _handleMenuAction(_CardMenuAction action) {
    switch (action) {
      case _CardMenuAction.edit:
        onEdit?.call();
      case _CardMenuAction.reset:
        onReset();
      case _CardMenuAction.delete:
        onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = onEdit != null;
    final canDelete = onDelete != null;

    return CardWidget(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subih.title,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subih.content.trim().isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        subih.content,
                        style: context.bodyMedium?.copyWith(
                          color: context.onSurfaceColor.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<_CardMenuAction>(
                tooltip: 'خيارات الدعاء',
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  if (canEdit)
                    const PopupMenuItem<_CardMenuAction>(
                      value: _CardMenuAction.edit,
                      child: _MenuItemLabel(
                        icon: Icons.edit_outlined,
                        label: 'تعديل',
                      ),
                    ),
                  const PopupMenuItem<_CardMenuAction>(
                    value: _CardMenuAction.reset,
                    child: _MenuItemLabel(
                      icon: Icons.refresh_rounded,
                      label: 'تصفير عداد اليوم',
                    ),
                  ),
                  if (canDelete)
                    const PopupMenuItem<_CardMenuAction>(
                      value: _CardMenuAction.delete,
                      child: _MenuItemLabel(
                        icon: Icons.delete_outline_rounded,
                        label: 'حذف',
                        isDestructive: true,
                      ),
                    ),
                ],
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: context.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    'ترديد اليوم: $count',
                    style: context.labelLarge?.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.touch_app_rounded),
                label: const Text('تسبيح'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItemLabel extends StatelessWidget {
  const _MenuItemLabel({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : context.onSurfaceColor;

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
