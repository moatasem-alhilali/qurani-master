import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// إدارة الأذكار العائمة: ما يظهر من الافتراضي، وما أضافه المستخدم.
///
/// كانت كل قائمة بطاقات بحدود وشارات؛ صارت صفوفًا نحيلة بمفتاح واحد في
/// طرف كل صفّ، والتبويب شريطًا بخطّ ذهبي تحت الاسم بدل صندوق مظلّل.
class FloatingAdhkarMyAdhkarScreen extends StatelessWidget {
  const FloatingAdhkarMyAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SabihBloc>(
      create: (_) => SabihBloc(
        repository: SabihRepositoryImpl(
          sabihService: DatabaseSabihService(),
        ),
      )..add(LoadAllSubihEvent()),
      child: const _FloatingAdhkarMyAdhkarView(),
    );
  }
}

class _FloatingAdhkarMyAdhkarView extends StatefulWidget {
  const _FloatingAdhkarMyAdhkarView();

  @override
  State<_FloatingAdhkarMyAdhkarView> createState() =>
      _FloatingAdhkarMyAdhkarViewState();
}

class _FloatingAdhkarMyAdhkarViewState
    extends State<_FloatingAdhkarMyAdhkarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool get _showBuiltInTab => _tabController.index == 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {});
    }
  }

  void _selectTab(int index) {
    if (_tabController.index == index) return;
    unawaited(HapticFeedback.selectionClick());
    _tabController.animateTo(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final floatingBloc = context.read<FloatingAdhkarBloc>();
    final skin = AppSkin.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SabihBloc, SabihState>(
          listenWhen: (previous, current) =>
              previous.actionState != current.actionState,
          listener: (context, state) {
            if (state.actionState == RequestState.success ||
                state.actionState == RequestState.error) {
              floatingBloc.add(const FloatingAdhkarLoadEvent());
            }
          },
        ),
        BlocListener<FloatingAdhkarBloc, FloatingAdhkarState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            final message = state.errorMessage;
            if (message == null || message.trim().isEmpty) {
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
        ),
      ],
      child: GroundScaffoldTheme(
        child: AppScaffoldWidget(
          title: 'إدارة الأذكار',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context.read<SabihBloc>().add(RefreshAllSubihEvent());
            floatingBloc.add(const FloatingAdhkarLoadEvent());
          },
          floatingActionButton: _showBuiltInTab
              ? null
              : FloatingActionButton(
                  onPressed: () => _showAddDialog(context),
                  tooltip: 'إضافة ذكر خاص',
                  backgroundColor: AppColors.gold,
                  child: AppIcon(
                    AppIcons.add,
                    color: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    size: 18.sp,
                  ),
                ),
          body: ColoredBox(
            color: skin.ground,
            child: BlocBuilder<SabihBloc, SabihState>(
              builder: (context, sabihState) {
                return BlocBuilder<FloatingAdhkarBloc, FloatingAdhkarState>(
                  builder: (context, floatingState) {
                    final customItems = sabihState.subihList
                        .where((item) => item.isCustom)
                        .toList();
                    final builtInItems =
                        List<FloatingAdhkarItem>.of(floatingState.builtInItems)
                          ..sort((first, second) {
                            if (first.isDeleted == second.isDeleted) {
                              return first.title.compareTo(second.title);
                            }
                            return first.isDeleted ? 1 : -1;
                          });
                    final activeBuiltInCount =
                        builtInItems.where((item) => !item.isDeleted).length;

                    final isLoadingBuiltIn =
                        floatingState.loadState == RequestState.loading &&
                            builtInItems.isEmpty;
                    final isLoadingCustom =
                        sabihState.loadState == RequestState.loading &&
                            customItems.isEmpty;

                    if (isLoadingBuiltIn || isLoadingCustom) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.gold),
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TabStrip(
                          activeIndex: _tabController.index,
                          builtInLabel:
                              '$activeBuiltInCount من ${builtInItems.length}',
                          customLabel: '${customItems.length}',
                          onSelect: _selectTab,
                        ),
                        if (_showBuiltInTab)
                          _BuiltInList(
                            items: builtInItems,
                            onToggleItem: (itemId, enabled) {
                              _setBuiltInItemEnabled(context, itemId, enabled);
                            },
                          )
                        else
                          _CustomList(
                            items: customItems,
                            selectionMap: floatingState.customSelectionMap,
                            onAddItem: () => _showAddDialog(context),
                            onToggleItem: (itemId, enabled) {
                              _setCustomItemEnabled(context, itemId, enabled);
                            },
                            onEditItem: (item) =>
                                _showEditDialog(context, item),
                            onDeleteItem: (item) =>
                                _showDeleteDialog(context, item),
                          ),
                        SizedBox(height: 26.h),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة ذكر مخصص',
      subtitle: 'سيصبح متاحًا ضمن الأذكار العائمة عند تفعيله.',
    );
  }

  void _showEditDialog(BuildContext context, SubihModel item) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: item),
      ),
      title: 'تعديل الذكر',
      subtitle: 'حدّث النص ثم احفظ التغييرات مباشرة.',
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, SubihModel item) async {
    final result = await showDeleteConfirmationDialog<bool>(context);
    if (result != true || item.id == null || !context.mounted) {
      return;
    }

    context.read<SabihBloc>().add(
          DeleteSubihEvent(
            request: SubihRequest.fromModel(item),
          ),
        );
  }

  void _setBuiltInItemEnabled(
    BuildContext context,
    String itemId,
    bool enabled,
  ) {
    unawaited(HapticFeedback.selectionClick());
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarSetBuiltInItemEnabledEvent(
            itemId: itemId,
            enabled: enabled,
          ),
        );
  }

  void _setCustomItemEnabled(
    BuildContext context,
    int itemId,
    bool enabled,
  ) {
    unawaited(HapticFeedback.selectionClick());
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarSetCustomItemEnabledEvent(
            subihId: itemId,
            enabled: enabled,
          ),
        );
  }
}

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
              tooltip: 'خيارات الذكر',
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
                  const PopupMenuItem<_ManageAction>(
                    value: _ManageAction.edit,
                    child: _ManageMenuLabel(
                      icon: AppIcons.edit,
                      label: 'تعديل',
                    ),
                  ),
                if (onDelete != null)
                  const PopupMenuItem<_ManageAction>(
                    value: _ManageAction.delete,
                    child: _ManageMenuLabel(
                      icon: AppIcons.delete,
                      label: 'حذف',
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
