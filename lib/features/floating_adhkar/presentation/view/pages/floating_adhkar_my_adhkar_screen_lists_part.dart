part of 'floating_adhkar_my_adhkar_screen.dart';

class _BuiltInList extends StatelessWidget {
  const _BuiltInList({required this.items, required this.onToggleItem});

  final List<FloatingAdhkarItem> items;
  final void Function(String itemId, bool enabled) onToggleItem;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const LibraryEmptyState(
          title: 'لا توجد أذكار افتراضية متاحة',
          message: 'لم يتم العثور على مكتبة الأذكار الافتراضية داخل التطبيق.',
          icon: AppIcons.tasbih,
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          _AdhkarManageRow(
            title: items[i].title,
            body: items[i].text,
            note: items[i].sourceLabel,
            enabled: !items[i].isDeleted,
            isLast: i == items.length - 1,
            onChanged: (value) => onToggleItem(items[i].id, value),
          ),
      ],
    );
  }
}

class _CustomList extends StatelessWidget {
  const _CustomList({
    required this.items,
    required this.selectionMap,
    required this.onAddItem,
    required this.onToggleItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  final List<SubihModel> items;
  final Map<int, bool> selectionMap;
  final VoidCallback onAddItem;
  final void Function(int itemId, bool enabled) onToggleItem;
  final void Function(SubihModel item) onEditItem;
  final void Function(SubihModel item) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: LibraryEmptyState(
          title: 'لا توجد أذكار خاصة بعد',
          message: 'أضف ذكرك أو دعاءك ليدخل ضمن الدوران العشوائي العائم.',
          icon: AppIcons.noteEdit,
          actionLabel: 'إضافة ذكر جديد',
          onAction: onAddItem,
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Builder(
            builder: (context) {
              final item = items[i];
              final itemId = item.id;
              final enabled = itemId != null && (selectionMap[itemId] ?? true);

              return _AdhkarManageRow(
                title: item.title,
                body: item.content,
                enabled: enabled,
                isLast: i == items.length - 1,
                onChanged: itemId == null
                    ? null
                    : (value) => onToggleItem(itemId, value),
                onEdit: () => onEditItem(item),
                onDelete: itemId == null ? null : () => onDeleteItem(item),
              );
            },
          ),
      ],
    );
  }
}
